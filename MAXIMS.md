# The Maxims of Disciplined Capability Composition

These maxims are normative design constraints for systems that use non-deterministic models inside consequential workflows.

## Typed execution

1. **A typed LLM operation must fail explicitly before it is allowed to succeed ambiguously.**
2. **Semantic correctness must be demonstrated by the strongest available external oracle, never merely asserted by the model that produced it.**
3. **When no reliable oracle exists, the result must remain explicitly unverified.**

## State mutation

4. **Every external mutation must declare its reversibility, compensation, and evidence requirements before execution.**
5. **An orchestrator must never promise rollback where only compensation is technically possible.**

## Traceability

6. **Every consequential decision must be traceable from intent, through evidence and validation, to its resulting state mutation.**
7. **Observability must explain the causal state of the workflow, not merely expose the logs that produced it.**

## Model lifecycle

8. **A model version is a deployable dependency, not a transparent implementation detail.**
9. **No model change may enter production without capability-specific evidence that it still satisfies the contract.**
10. **Model drift must trigger containment before adaptation.**
11. **The capability contract belongs to the system; the model is only one replaceable implementation of it.**

## Security and privacy

12. **External content may provide information, but it can never confer authority.**
13. **An LLM may propose an action, but it may never authorize itself to execute it.**
14. **Every model output remains untrusted until independently validated, policy-checked, and explicitly authorized.**
15. **Sensitive data may cross a trust boundary only through purpose-bound minimization and explicit egress policy.**
16. **A successful prompt injection must still be unable to become a successful privilege escalation or data exfiltration.**

## Compact mental model

```text
LLM
  proposes, transforms, extracts, criticizes, and synthesizes.

Runtime
  constrains, versions, executes, validates, records, and rejects.

Orchestrator
  advances legal state transitions and coordinates compensation.

External oracles
  provide authoritative evidence.

Human
  judges what cannot honestly be mechanized and authorizes irreversible risk.
```
