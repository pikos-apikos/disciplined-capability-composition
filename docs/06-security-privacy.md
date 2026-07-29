# 06 — Security and Privacy

Prompt injection is not primarily a prompt-writing problem. It is an authority, information-flow, and confused-deputy problem.

The design must assume that a model can be manipulated. Safety comes from proving that manipulation cannot grant power.

## Trust boundary

The LLM is outside the Trusted Computing Base. It does not hold credentials, decide permissions, declassify data, or directly mutate external systems.

```text
Intent
  → identity and authorization
  → capability policy
  → privacy gateway
  → bounded model context
  → model proposal
  → security reference monitor
  → validation and authorization
  → execution plane
```

> Reasoning about authority is not authority.

## External content provides information, not authority

Email, webpages, PDFs, repositories, RAG documents, tool results, model outputs, and memory entries are potentially hostile data.

```yaml
context_segment:
  source: email/message-184
  trust_level: EXTERNAL_UNTRUSTED
  semantic_role: DATA
  may_define_goal: false
  may_grant_authority: false
  may_request_tool_use: false
```

Text that claims to be a system override remains untrusted data.

## Taint propagation

Artifacts carry provenance, trust, classification, purpose, egress, tenant, and retention labels.

```yaml
artifact:
  id: customer-report-v12
  tenant: tenant-17
  trust: MODEL_DERIVED_UNTRUSTED
  classification: [PII, CONFIDENTIAL]
  purpose: customer_support_case_441
  allowed_egress: [internal_case_system]
  forbidden_egress: [public_internet, general_model_provider]
```

Taint is monotonic by default:

```text
Untrusted input → model transformation → untrusted derived output
```

Only a dedicated, policy-controlled declassification operation may remove or narrow labels.

## Object capabilities and tool brokerage

The model never receives credentials. The orchestrator issues short-lived, purpose-bound grants:

```yaml
capability_grant:
  principal:
    workflow: wf-482
    operation: summarize_support_email
  resource:
    type: gmail_thread
    ids: [thread-882]
  permissions: [read]
  restrictions:
    attachments: false
    external_network: false
  expires_in: 90s
  single_use: true
```

The model sees an opaque handle. A deterministic broker executes the call, filters output, labels returned content as untrusted, and records evidence.

## Tool calls are proposals

A structured tool call is still only a proposed action. The reference monitor checks:

- original user intent,
- resource scope,
- recipient provenance,
- data classification,
- exact payload approval,
- workflow state,
- risk budget,
- egress policy.

The model cannot issue its own `ALLOW` decision.

## Split-context architecture

Never combine untrusted content, secrets, powerful tools, and broad goals in one context.

```text
Untrusted extraction
  → structured tainted facts
  → trusted planning
  → candidate action artifact
  → policy/human authorization
  → narrow execution capability
```

The operation exposed to hostile content should not also have secret access, production writes, or unrestricted network egress.

## Privacy gateway

Before every provider call:

```text
purpose check
→ classification
→ field-level minimization
→ redaction/pseudonymization/tokenization
→ provider/residency policy
→ outbound DLP
→ invocation
```

Mappings from tokens to identities remain inside a dedicated vault.

```yaml
privacy_contract:
  allowed: [INTERNAL, PSEUDONYMIZED_PII]
  forbidden: [RAW_PAN, ACCESS_TOKEN, MEDICAL_RECORD]
  purpose: dispute_summary
  approved_profiles: [eu-zdr-provider-a, local-model-profile]
  raw_payload_logging: forbidden
```

If the contract cannot be satisfied, the invocation is blocked. There is no silent fallback to weaker privacy guarantees.

## Egress control

Control every outbound channel:

- model provider payloads,
- HTTP,
- email and chat,
- file uploads,
- issue comments,
- telemetry,
- logs,
- generated URLs and redirects.

Policies restrict domains, classifications, volume, redirects, encodings, and recipients. Exfiltration attempts may use Base64, URLs, “checksums,” or staged tool calls; plain-text secret scanning is insufficient.

## RAG and memory supply chain

Ingestion requires authentication, tenant isolation, provenance, scanning, trust classification, quarantine, expiration, and approval. Retrieved documents never define system policy, grant permission, register tools, or change workflow goals.

## Tool supply chain

Every tool has a signed, versioned manifest with schemas, publisher, permissions, network/filesystem scope, output classification, and injection exposure. Model-proposed tools are never loaded dynamically.

## Security reference monitor

A small deterministic component authorizes every transition:

```typescript
authorize(
  principal,
  capability,
  resource,
  action,
  purpose,
  classification,
  provenance,
  workflowState
): AuthorizationDecision
```

It must be always invoked, non-bypassable, independently auditable, and free of an LLM in the final allow/deny path.

## Security containment

Suspicious activity transitions:

```text
RUNNING → SECURITY_SUSPECTED → SECURITY_CONTAINED
```

Containment revokes grants, blocks egress, freezes mutations, quarantines artifacts, preserves evidence, traces downstream consumers, and rotates credentials when exposure is plausible.

## Security evaluations

Test direct and indirect injection, tool-output injection, memory poisoning, cross-tenant exfiltration, secret discovery, encoded exfiltration, authorization laundering, malicious tools, and human-approval bypass.

The goal is not merely to make the model refuse. The legitimate task should still complete safely without excessive false positives.
