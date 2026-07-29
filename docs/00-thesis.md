# 00 — Thesis and Computational Model

## The question

Are LLM systems being designed at the wrong level of abstraction?

The common multi-agent design mirrors a human organization: an orchestrator delegates broad tasks to persistent agents with roles, memory, and autonomy. This metaphor is intuitive, but it hides the computational structure and encourages several failure modes:

- implicit decomposition,
- unbounded context,
- hidden state in conversations,
- self-validation,
- ambiguous completion,
- broad tool authority,
- difficult recovery.

The revised thesis is:

> Reliable LLM systems are not built by composing agents. They are built by composing typed, bounded, validated capabilities.

## The LLM as a probabilistic operation runtime

A model invocation is best treated as a non-deterministic transformation:

```text
input artifacts
+ operation contract
+ bounded context
+ permitted tools
        ↓
       LLM
        ↓
candidate output artifact
        ↓
external validation
```

The model can implement operations such as:

```text
observe → classify → retrieve → compare → clarify → plan
→ propose → implement → criticize → verify → revise → summarize
```

The same model may execute many operations. Multiple models may execute the same operation. The stable abstraction is the contract, not the persona.

## Agents as views over capability graphs

An “Architect Agent” may be a human-facing view over:

```text
inspect constraints
→ identify boundaries
→ compare alternatives
→ record trade-offs
→ propose decision
```

A “Review Agent” may be:

```text
read contract
→ inspect candidate artifact
→ execute checks
→ classify violations
→ produce review artifact
```

Agent identity can still be useful for UX, authorization bundles, or domain presentation. It should not be the primary execution primitive.

## Threads are bounded execution contexts

A thread should not own a large project. It should execute one operation or one tightly coupled state transition:

```yaml
state: PLAN_APPROVED
operation: implement_database_migration
input: migration-plan-v3
allowed_paths:
  - db/migrations/**
expected_output: patch
validation:
  - migration_parser
  - ephemeral_database_test
budget:
  attempts: 1
```

The durable result is the artifact and its provenance, not conversational memory.

```text
conversation memory ≠ authoritative system state
artifact graph       = authoritative system state
```

## The orchestrator

The orchestrator is not a simulated manager. It is a combination of:

- durable state machine,
- scheduler,
- context assembler,
- policy engine,
- validator router,
- compensation coordinator,
- optional workflow planner.

It advances the next legal transition rather than assigning ownership of the whole goal.

## Known workflows before dynamic compilation

The system should prefer versioned workflow templates. Dynamic plan synthesis is a high-risk capability, not a default.

```text
known intent
→ select approved workflow template
→ bind artifacts and policies
→ execute
```

Only novel cases should invoke a planner to propose a new graph. That graph must itself be validated, bounded, and approved before execution.

## The actual system intelligence

The important intelligence may live in the composition layer:

- operation selection,
- context selection,
- evidence requirements,
- validator authority,
- stopping conditions,
- state transitions,
- escalation boundaries.

The model contributes cognition. The system contributes reliability.
