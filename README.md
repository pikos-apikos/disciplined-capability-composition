# Disciplined Capability Composition

> Building reliable systems around language models that may fail, drift, hallucinate, and be manipulated.

**Status:** Draft RFC  
**License:** MIT  
**Primary thesis:** Reliable LLM systems are built by composing typed, bounded, validated capabilities—not by composing autonomous agent personas.

## Why this repository exists

Most agent frameworks begin with a human metaphor:

```text
Task → Orchestrator → Architect Agent → Worker Agent → Review Agent
```

This repository starts from a systems-engineering model instead:

```text
Intent
  → typed capability graph
  → bounded probabilistic operations
  → external validation
  → immutable artifacts
  → policy-controlled state transitions
```

The LLM is not the system. It is one replaceable, untrusted implementation of a typed operation inside a durable control plane.

## The 16 maxims

1. **A typed LLM operation must fail explicitly before it is allowed to succeed ambiguously.**
2. **Semantic correctness must be demonstrated by the strongest available external oracle, never merely asserted by the model that produced it.**
3. **When no reliable oracle exists, the result must remain explicitly unverified.**
4. **Every external mutation must declare its reversibility, compensation, and evidence requirements before execution.**
5. **An orchestrator must never promise rollback where only compensation is technically possible.**
6. **Every consequential decision must be traceable from intent, through evidence and validation, to its resulting state mutation.**
7. **Observability must explain the causal state of the workflow, not merely expose the logs that produced it.**
8. **A model version is a deployable dependency, not a transparent implementation detail.**
9. **No model change may enter production without capability-specific evidence that it still satisfies the contract.**
10. **Model drift must trigger containment before adaptation.**
11. **The capability contract belongs to the system; the model is only one replaceable implementation of it.**
12. **External content may provide information, but it can never confer authority.**
13. **An LLM may propose an action, but it may never authorize itself to execute it.**
14. **Every model output remains untrusted until independently validated, policy-checked, and explicitly authorized.**
15. **Sensitive data may cross a trust boundary only through purpose-bound minimization and explicit egress policy.**
16. **A successful prompt injection must still be unable to become a successful privilege escalation or data exfiltration.**

## RFC map

| Chapter | Subject |
|---|---|
| [00 — Thesis and computational model](docs/00-thesis.md) | Why capabilities, artifacts, and state transitions are the primary abstraction |
| [01 — Typed LLM operations](docs/01-typed-operations.md) | Contracts, failure taxonomy, recovery ladder, and bounded execution contexts |
| [02 — Semantic validation](docs/02-semantic-validation.md) | Oracle hierarchy, proof obligations, evidence, and `INDETERMINATE` |
| [03 — State mutation and compensation](docs/03-state-mutation.md) | Prepare/commit, Sagas, containment, immutable artifacts, and irreversible actions |
| [04 — Causal observability](docs/04-observability.md) | Causal DAGs, mutation ledgers, incident packets, and operator workbenches |
| [05 — Model drift](docs/05-model-drift.md) | Execution profiles, sentinel evals, shadowing, canaries, quarantine, and fallback |
| [06 — Security and privacy](docs/06-security-privacy.md) | Confused deputy, taint propagation, reference monitor, privacy gateway, and egress controls |
| [07 — Evaluation and implementation](docs/07-evaluation.md) | Minimal architecture, experiment design, metrics, and falsifiability |
| [08 — Open questions](docs/08-open-questions.md) | Known risks, unresolved design choices, and research agenda |

## Minimal architecture

```text
                         ┌──────────────────────┐
User / System Intent ───▶│ Intent & Auth Plane  │
                         └──────────┬───────────┘
                                    ▼
                         ┌──────────────────────┐
                         │ Workflow State Machine│
                         └──────────┬───────────┘
                                    ▼
                         ┌──────────────────────┐
                         │ Capability Runtime    │
                         └──────┬────────┬──────┘
                                │        │
                       context  │        │ proposal
                                ▼        ▼
                         ┌──────────┐  ┌────────────────┐
                         │ Model    │  │ Reference      │
                         │ Gateway  │  │ Monitor/Policy │
                         └────┬─────┘  └───────┬────────┘
                              │                │
                              ▼                ▼
                       Model Provider     Tools / Systems
                              │                │
                              └──────┬─────────┘
                                     ▼
                         ┌──────────────────────┐
                         │ Validators & Oracles │
                         └──────────┬───────────┘
                                    ▼
                         ┌──────────────────────┐
                         │ Artifact/Evidence DAG│
                         └──────────────────────┘
```

## Scope

This RFC is about production systems in which model outputs can influence code, data, workflows, external APIs, or human decisions. It is not an argument against conversational assistants, creative generation, or agent-like user interfaces. Agents may remain useful as a presentation layer or policy bundle. They are not the trusted execution primitive.

## Review posture

This is an engineering hypothesis, not a declaration of victory. The proposal should be implemented, measured, attacked, broken, and revised. See [REVIEW.md](REVIEW.md) for a skeptical review prompt and [CONTRIBUTING.md](CONTRIBUTING.md) for contribution expectations.

## Provenance

The initial draft was developed through an iterative architecture conversation led by **Yiannis Miliaresis**, with critique and synthesis assisted by OpenAI and Google language models. The claims belong to the public discussion and should be challenged on engineering merit rather than model authority.
