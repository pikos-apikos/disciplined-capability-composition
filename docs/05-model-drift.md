# 05 — Model Drift and Dependency Lifecycle

A model API is a dynamically changing third-party dependency. A model name is not sufficient execution identity, and a provider is not part of the trusted computing base.

## Deployable unit

The deployable dependency is:

```text
Capability contract
+ prompt version
+ model execution profile
+ tool schemas
+ validation policy
+ evaluation baseline
```

```yaml
capability: generate_repository_patch
capability_version: 3.4.0

model_profile:
  provider: provider-a
  model_family: model-x
  model_version: model-x-2026-06-18
  endpoint_type: responses
  region: eu
  reasoning_level: medium
  temperature: 0
  max_output_tokens: 12000

prompt_hash: sha256:...
tool_schema_hashes: [sha256:...]
semantic_contract_version: 4.0.0
evaluation_suite: repo-patch-evals-7
```

Mutable aliases may be used in development, not in production. Pinning reduces risk but cannot guarantee that serving behavior remains unchanged.

## Capability-specific evaluation corpus

A model is not approved in general. It is qualified for a specific capability and risk class.

```text
representative/
boundary-cases/
adversarial/
historical-failures/
context-pressure/
tool-use/
irreversible-action-scenarios/
```

Evaluate semantic obligations, not text similarity:

- schema compliance,
- verified/contradicted/indeterminate rates,
- fabricated references,
- tool selection,
- unsafe action attempts,
- retries,
- latency,
- token cost,
- compensation frequency.

## Behavioral baseline

Store expected distributions:

```yaml
structural_success_rate: 0.998
semantic_verified_rate: 0.914
indeterminate_rate: 0.021
contradicted_rate: 0.014
fabricated_symbol_rate: 0.007
p95_latency_ms: 8400
mean_output_tokens: 4200
```

Drift is a change in the distribution of contract-relevant outcomes, not merely different wording.

## Sentinel evaluations

Run fixed, versioned probes continuously:

- small hourly contract probes,
- daily boundary and historical-failure suites,
- full suite before promotion,
- emergency suite after a provider change signal.

## Shadow and canary execution

```text
Production request
  ├─ active profile → authoritative candidate
  └─ shadow profile → validation only, no mutation authority
```

Compare profiles through external oracles. Model agreement is not proof.

Promotion lifecycle:

```text
DISCOVERED → EVALUATING → SHADOW → CANARY
→ LIMITED_PRODUCTION → PRODUCTION
```

Rollout unit:

```text
Capability × Model Profile × Risk Class
```

A profile may be approved for summarization and forbidden for database migrations.

## Drift detection and quarantine

```yaml
warning:
  semantic_verified_rate_drop: 0.03
  token_cost_increase: 0.20

quarantine:
  unsafe_action_attempts: 1
  semantic_verified_rate_drop: 0.08
  mutation_contract_violations: 1
```

Critical drift transitions the profile:

```text
ACTIVE → SUSPECTED_DRIFT → QUARANTINED
```

The runtime stops new high-risk routing, uses only pre-qualified fallbacks, pauses unsafe workflows, and produces a drift incident packet.

## Validated fallback chain

```yaml
primary: provider-a/model-x/version-17
fallbacks:
  - profile: provider-b/model-y/version-8
    compatibility: fully_evaluated
  - profile: local/model-z/version-3
    compatibility: reduced
    restrictions:
      - no_external_mutations
      - human_review_required
terminal_behavior: MODEL_CAPABILITY_UNAVAILABLE
```

Fail closed when no approved profile satisfies the contract.

## Attribution

A regression may come from:

```text
MODEL_DRIFT
PROMPT_DRIFT
CONTEXT_DRIFT
TOOL_SCHEMA_DRIFT
VALIDATOR_DRIFT
DATA_DRIFT
RUNTIME_DRIFT
PROVIDER_POLICY_DRIFT
```

Use controlled replay to isolate the changed variable. Do not alter production prompts during an incident. The safe path is:

```text
Detect → Contain → Diagnose → Candidate adaptation
→ Evaluate → Shadow → Canary → Promote
```
