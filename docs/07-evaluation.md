# 07 — Evaluation and Minimal Implementation

This proposal is falsifiable. Added orchestration is justified only if it produces better accepted outcomes than a simpler autonomous-worker approach.

## Minimal implementation

Do not begin with a custom “agent operating system.” Use boring infrastructure:

- durable workflow engine or explicit state machine,
- relational workflow state,
- immutable object storage for artifacts/evidence,
- model gateway,
- schema validation,
- compiler/test/policy oracles,
- append-only causal journal,
- narrow tool broker.

Initial workflow:

```text
Plan Generation (LLM)
  → Plan Validation
  → Candidate Change (LLM)
  → Compiler/Lint/Test
  → Accept | Targeted Revision | Block
```

No external mutation is required for the first experiment.

## Comparative experiment

### Path A — autonomous worker

```text
one thread
one broad role prompt
whole task
broad repository access
self-directed planning and validation
```

### Path B — capability composition

```text
explicit workflow
bounded operations
artifact handoffs
scoped access
independent validation gates
```

Use multiple tasks of different sizes and inject known failures.

## Primary metrics

- accepted output rate without rework,
- review defect rate,
- reviewer time,
- incomplete-task rate,
- unrelated diff size,
- test pass rate,
- retries per accepted artifact,
- total context tokens processed,
- cost per accepted artifact,
- wall-clock time,
- mean time to recovery from node failure,
- recovery cost after upstream failure,
- model interchangeability,
- provenance completeness.

## Safety metrics

- ambiguous success rate,
- fabricated evidence rate,
- unsafe tool proposal rate,
- unauthorized action execution rate,
- unresolved mutation rate,
- compensation success rate,
- containment time,
- cross-tenant data exposure,
- prompt-injection-to-impact conversion rate.

The last metric should be zero even when the model itself follows the malicious instruction.

## Acceptance hypothesis

Capability composition should produce:

- fewer incomplete and unrelated changes,
- lower review and recovery cost,
- better failure localization,
- higher reproducibility,
- stronger model portability,
- complete traceability,
- no increase in consequential security impact.

If it does not, the architecture should be simplified or rejected.

## Suggested implementation sequence

1. Typed operation/result contracts
2. Artifact and evidence store
3. Deterministic validators
4. Durable state transitions and retry budgets
5. Causal journal
6. Prepare/commit boundary for one safe external mutation
7. Compensation and containment
8. Model execution profiles and eval registry
9. Reference monitor and privacy gateway
10. Operator console projections

Each stage should produce measurable value before the next is introduced.
