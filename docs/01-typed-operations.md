# 01 — Typed LLM Operations

## Operation contract

A typed LLM operation declares:

```yaml
operation: propose_repository_patch
version: 3.1.0
purpose: Produce a minimal candidate patch for an approved change plan

inputs:
  - approved_plan
  - repository_snapshot

outputs:
  success: patch_artifact
  blocked: missing_input_report
  failure: classified_failure

preconditions:
  - plan_is_approved
  - repository_snapshot_is_current

postconditions:
  - patch_is_parseable
  - changed_paths_are_allowed

allowed_tools:
  - repository.read
  - patch.propose

forbidden_actions:
  - network_egress
  - branch_push
  - production_mutation

budget:
  attempts: 1
  max_output_tokens: 12000
```

The runtime constructs protocol metadata. The model produces only the content payload.

> The LLM produces content. The runtime produces the protocol.

## First-class result states

A contract must provide a lawful escape hatch:

```typescript
type OperationResult<T> =
  | { status: "completed"; data: T; evidence: EvidenceRef[] }
  | { status: "blocked"; reason: string; missingInputs: string[] }
  | {
      status: "failed";
      failureType: FailureType;
      retryable: boolean;
      diagnostics: Diagnostic[];
    };
```

Without `blocked`, the model is pressured to invent missing values to satisfy a success-only schema.

## Failure taxonomy

```text
FORMAT_ERROR
  Output cannot be parsed.

SCHEMA_ERROR
  Output parses but violates structural types or fields.

SEMANTIC_INCOMPLETE
  Structure is valid but required meaning is absent.

SEMANTIC_CONTRADICTION
  Claims or fields are mutually inconsistent or conflict with evidence.

CONTEXT_FAILURE
  Required information was not available.

CAPABILITY_FAILURE
  The selected model/profile cannot execute the operation reliably.

POLICY_FAILURE
  The proposal exceeds its authority or data-use policy.
```

Different failures require different transitions. “Retry” is not a general recovery strategy.

## Recovery ladder

```text
Constrained output
  ↓
Deterministic parse and schema validation
  ↓
Safe normalization
  ↓
One targeted structural repair
  ↓
Typed extractor fallback
  ↓
Failure classification
  ↓
Replan / context enrichment / model fallback / human review
```

Safe normalization may remove Markdown fences or canonicalize an enum. It must never invent semantic content.

A targeted repair receives only the invalid object, validator errors, and violated schema fragment. Repeating the full prompt with the same model and inputs is probabilistic hoping, not recovery.

## Retry budgets

```yaml
FORMAT_ERROR:
  normalization: 1
  targeted_repair: 1
  extractor_fallback: 1

SCHEMA_ERROR:
  targeted_repair: 2

SEMANTIC_INCOMPLETE:
  retry: 0
  action: replan

CONTEXT_FAILURE:
  retry: 0
  action: request_upstream_artifact

CAPABILITY_FAILURE:
  retry: 0
  action: approved_model_fallback_or_human
```

A retry is justified only when something changes: prompt, context, model profile, decoding constraints, operation boundary, or validation feedback.

## Granularity

The correct unit is not the smallest imaginable prompt. It is the smallest **bounded execution context with a meaningful validation boundary**.

Too large:

- hidden decomposition,
- difficult failure localization,
- unrelated changes,
- expensive restart.

Too small:

- orchestration overhead,
- repeated context injection,
- latency,
- loss of useful local coherence.

Persistent schema failures are architectural telemetry. They may indicate a god-object contract, an invalid boundary, insufficient context, or an unsuitable model profile.
