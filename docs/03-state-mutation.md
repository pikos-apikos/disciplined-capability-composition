# 03 — State Mutation, Compensation, and Containment

Distributed systems do not generally provide true rollback. They provide new operations that attempt to restore acceptable invariants.

> Validation before mutation; compensation after mutation; explicit intervention when compensation is impossible.

## Side-effect classes

Every mutating operation declares one class:

```text
PURE
  No external state change.

REVERSIBLE
  Exact prior state can be restored.

COMPENSATABLE
  Exact reversal is impossible, but an approved business compensation exists.

IRREVERSIBLE
  No reliable restoration or compensation exists.
```

```yaml
operation: provision_customer_account
side_effect_class: COMPENSATABLE

mutations:
  - system: billing-api
    action: create_customer
    compensation: deactivate_customer

idempotency:
  key: workflow_id + operation_id

commit_policy:
  required_gates:
    - customer_data_verified
    - billing_configuration_verified
```

## Prepare and commit

```text
PLAN → PREPARE → VALIDATE → AUTHORIZE → COMMIT → VERIFY EFFECTS
```

The model operates primarily in `PREPARE`: drafts, patches, dry runs, candidate payloads, and proposed actions. `COMMIT` is controlled by deterministic policy and exact approved artifacts.

## Gate classes

- **Pre-commit gates:** must pass before mutation.
- **Post-commit gates:** verify that an external system applied the requested effect.
- **Continuous gates:** monitor delayed invariants and downstream consequences.

A high semantic failure after mutation should only occur for properties that could not honestly be verified earlier.

## Durable Saga journal

A Saga requires an append-only journal:

```json
{
  "workflowId": "wf-482",
  "sequence": 7,
  "operationId": "create-billing-account",
  "transition": "COMMITTED",
  "idempotencyKey": "wf-482:create-billing-account",
  "externalReference": "customer-9217",
  "compensationOperation": "deactivate-billing-account",
  "evidence": ["billing-response-7"]
}
```

It records attempted and observed effects, external references, compensation state, and evidence.

## Typed compensation

```typescript
type CompensationResult =
  | { status: "compensated"; restoredInvariants: string[]; evidence: EvidenceRef[] }
  | {
      status: "partially_compensated";
      remainingEffects: ExternalEffect[];
      requiredActions: string[];
    }
  | {
      status: "compensation_failed";
      reason: string;
      retryable: boolean;
      escalationRequired: boolean;
    };
```

Compensations must be versioned, idempotent, bounded, independently retryable, and validated. The model must not invent destructive compensations during an incident.

## Compensation graph

Reverse order is not always safe. Workflows may require a typed compensation graph because compensations have dependencies and some evidence must never be deleted.

```yaml
compensation_graph:
  deactivate_subscription:
    before: [refund_payment]
  refund_payment:
    before: [release_inventory]
  preserve_audit_record:
    compensatable: false
```

## Immutable shared artifacts

Avoid in-place mutation:

```text
architecture-v17
architecture-v18-candidate
current_architecture → architecture-v17
```

Commit is an atomic pointer switch. Recovery can restore the previous pointer while preserving the complete audit history.

## Databases and forward recovery

Prefer expand/contract migrations, compatibility windows, feature flags, shadow columns, dual reads/writes, and forward repair. A destructive down migration may lose information and should not be described as safe rollback.

## Irreversible actions

Sending email, publishing, transferring money, deleting unrecoverable resources, or changing permissions requires:

- all pre-commit gates verified,
- exact payload frozen and hashed,
- explicit authorization,
- human approval above a risk threshold.

Approval applies to a concrete artifact, not a vague intention.

## Containment state machine

```text
PLANNED → PREPARED → VALIDATED → COMMITTING → COMMITTED
                                             ↓
                                POST_COMMIT_VERIFICATION
```

Failure transitions:

```text
Before COMMITTED
  → ABORTED

After COMMITTED with compensation
  → COMPENSATING
  → COMPENSATED | PARTIALLY_COMPENSATED

After COMMITTED without safe recovery
  → CONTAINED
  → MANUAL_INTERVENTION_REQUIRED
```

Containment freezes downstream mutations, isolates affected resources, preserves evidence, and limits blast radius. Sometimes the correct recovery is not undo; it is preventing propagation.
