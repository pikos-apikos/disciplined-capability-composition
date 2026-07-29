# 04 — Causal Observability and Human Operations

Logs are exhaust. They are not the operator interface.

The observability layer must answer quickly:

1. What was the workflow trying to do?
2. Where did reality diverge from the plan?
3. What external state has already changed?
4. What is verified, contradicted, or indeterminate?
5. Why was the workflow contained?
6. What safe actions remain?

## Causal execution graph

The primary unit is a typed event in a causal graph, not a log line.

Entities:

```text
workflow, operation, attempt, artifact, evidence, validation,
mutation, compensation, policy decision, approval, external reference
```

Relations:

```text
OPERATION consumed ARTIFACT
OPERATION produced ARTIFACT
ARTIFACT validated_by VALIDATION
VALIDATION supported_by EVIDENCE
OPERATION caused MUTATION
MUTATION compensated_by COMPENSATION
OPERATION blocked_by POLICY
DECISION approved_by HUMAN
ARTIFACT supersedes ARTIFACT
```

The runtime records causality. An LLM may summarize it but cannot invent it.

## Semantic spans

A semantic span records purpose and obligations in addition to technical timing:

```yaml
operation: apply_customer_policy
purpose: Apply the verified eligibility decision
inputs:
  - eligibility-decision-v8
expected_postconditions:
  - customer_policy_matches_decision
  - no_existing_entitlement_removed
actual_result: committed
validations:
  - policy-validation: verified
  - entitlement-regression: contradicted
transition:
  from: POST_COMMIT_VERIFICATION
  to: CONTAINED
```

## Operator console projections

### Incident overview

Show the current truth first: containment reason, first divergence, external mutations, compensation state, last verified checkpoint, disabled actions, and required intervention.

### Causal DAG

Display semantic nodes by default. Low-level calls and raw logs are drill-down details.

### Decision timeline

Show only state-changing and decision-relevant events.

### Mutation ledger

| Mutation | System | Expected | Actual | Compensation | State |
|---|---|---|---|---|---|
| mut-41 | PostgreSQL | Policy updated | Updated | Restore prior value | Compensated |
| mut-42 | Entitlement API | Add entitlement | Accepted | Remove entitlement | Unresolved |

### Validation and evidence matrix

| Requirement | Status | Evidence |
|---|---|---|
| Customer eligible | VERIFIED | decision-v8 |
| No entitlement removed | CONTRADICTED | diff-report-22 |
| External final state known | INDETERMINATE | status-query-81 |

### Recovery workbench

Expose only typed, policy-approved actions. Do not present a generic Retry button.

```text
Re-query external state
  Risk: Low
  Mutation: None

Execute approved compensation
  Risk: Medium
  Mutation: External API
  Approval: Required

Accept current state
  Risk: High
  Leaves invariant unresolved
  Business approval: Required
```

Unsafe actions should be unavailable, not merely decorated with a warning.

## Incident packet

On containment, create an immutable artifact containing:

- summary,
- first divergence,
- last verified checkpoint,
- blast radius,
- committed/compensated/unresolved mutations,
- unresolved invariants,
- safe next actions,
- evidence bundle.

## Deterministic explanation first

A template engine should be able to produce the factual incident explanation directly from the graph. An LLM may create a clearer narrative afterward, but every sentence must link to provenance.

> The LLM may compress the truth of the trace. It may not create the truth of the trace.

## Unsampled control-plane events

Never sample:

- state transitions,
- mutations,
- validations,
- approvals,
- policy decisions,
- compensation attempts,
- artifact creation,
- external references.

These events must be durable, append-only, ordered per workflow, and tamper-evident.

## Operator SLOs

A useful console should allow an operator to:

- identify the failed operation and containment reason within 30 seconds,
- identify all unresolved mutations within 2 minutes,
- select a policy-approved recovery path within 5 minutes,
- explain the causal chain without opening raw logs,
- open the evidence behind every important claim in one step.
