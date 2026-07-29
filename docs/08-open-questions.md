# 08 — Open Questions and Research Agenda

The RFC intentionally leaves several questions unresolved.

## Composition and granularity

- What is the correct operation boundary for different task classes?
- When should tightly coupled operations share one context window?
- Can workflow compilation remain understandable without becoming a new god object?
- Which workflow templates generalize across repositories, teams, and domains?
- At what point does a useful capability bundle become an agent again?

## Validation

- How should evidence quality and freshness be represented?
- Which semantic obligations can be made executable without excessive maintenance?
- How should uncertainty propagate between artifacts?
- When does independent model review add signal rather than correlated noise?
- How should human judgment be versioned and audited without pretending it is deterministic?

## State and recovery

- How are compensations tested against continuously changing external systems?
- How should the system choose between compensation, forward repair, and containment?
- How should shared-artifact blast radius be computed efficiently?
- Which irreversible actions require two-person approval?

## Model lifecycle

- How large must a capability-specific evaluation corpus be?
- How can drift be detected under low traffic?
- What constitutes equivalent behavior across providers with different tool APIs?
- How should a system operate when all validated model profiles are unavailable?

## Security and privacy

- How can taint labels remain useful without becoming unmanageable?
- What declassification operations are safe enough to automate?
- How can encoded or multi-stage exfiltration be detected with low false-positive rates?
- How should third-party tools and MCP servers be attested and sandboxed?
- How should privacy-preserving traces support incident investigation without retaining raw PII?

## Governance

- Who owns a capability contract?
- Who may change validation thresholds?
- What evidence is required to promote a new model profile?
- How should deviations and emergency overrides be recorded?
- Can a public conformance suite make implementations comparable?

## Terminology

“Disciplined capability composition” is intentionally descriptive rather than promotional. Better terminology is welcome if it preserves the key distinctions:

- contract over persona,
- evidence over assertion,
- compensation over fictional rollback,
- causality over raw logs,
- containment over adaptation,
- authority outside the model.
