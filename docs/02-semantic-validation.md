# 02 — Semantic Validation and External Oracles

JSON Schema proves shape, not truth. Semantic correctness must be expressed as proof obligations and evaluated through the strongest available external oracle.

## Semantic contract

```yaml
operation: implement_repository_method

preconditions:
  - target_repository_exists
  - referenced_entity_exists

postconditions:
  - project_compiles
  - method_symbol_exists
  - signature_matches_plan
  - relevant_tests_pass
  - no_existing_public_api_removed

invariants:
  - no_changes_outside_allowed_paths
  - no_new_runtime_dependency

required_evidence:
  - compiler_report
  - changed_file_manifest
  - test_report
  - api_diff
```

The model does not prove completion by claiming completion. The runtime collects evidence.

## Oracle hierarchy

Use the strongest applicable oracle:

1. Formal proof or type system
2. Compiler, parser, linker, or symbol resolver
3. Executable tests
4. Domain invariant or policy engine
5. Reference implementation or differential execution
6. Cross-artifact consistency checks
7. Property-based or metamorphic tests
8. Statistical or heuristic checks
9. Independent LLM critique
10. Human judgment

The order reflects mechanical repeatability, not human value.

## Cross-artifact validation

Many contradictions can be detected by comparing artifacts:

```text
Plan ↔ Patch
Patch ↔ Tests
Code ↔ OpenAPI
Entity ↔ Database schema
Decision ↔ Configuration
Claim ↔ Evidence
```

Example:

```text
Plan: “No database migration required.”
Patch: Adds a non-null database column.
Result: SEMANTIC_CONTRADICTION
```

## Property and metamorphic testing

When exact expected output is unknown, verify stable properties:

```text
sort(sort(x)) == sort(x)
encode(decode(x)) == x
priceWithDiscount(x, 0) == x
migration applied twice is idempotent or fails as declared
adding unrelated data does not change the query result
```

The model may propose properties or tests. The external runner determines the result.

## Claim–evidence model

For reports and architecture artifacts:

```json
{
  "claim": "The service uses PostgreSQL.",
  "evidence": [
    { "artifact": "application.yaml", "location": "datasource.jdbc.url" },
    { "artifact": "pom.xml", "location": "postgresql dependency" }
  ]
}
```

The validator checks existence, provenance, freshness, and the mechanically verifiable relation between claim and evidence.

## Non-Boolean validation

```typescript
type SemanticValidationResult =
  | { status: "verified"; evidence: EvidenceRef[] }
  | { status: "contradicted"; violations: Violation[]; evidence: EvidenceRef[] }
  | {
      status: "partially_verified";
      verifiedClaims: string[];
      unresolvedClaims: string[];
    }
  | {
      status: "indeterminate";
      reason: string;
      requiredEvidence: string[];
    };
```

`INDETERMINATE` is not failure and is not success. It prevents absence of evidence from being converted into an accidental green check.

## Bounded role of LLM evaluation

An independent model may:

- extract claims,
- propose invariants,
- generate tests,
- identify candidate contradictions,
- classify unstructured evidence.

It must not be the exclusive final oracle. A critique should be converted into a checkable obligation whenever possible.

```text
LLM critic: “Null handling may be broken.”
Runtime: selects or generates null-input tests.
Test runner: fails.
Decision: CONTRADICTED.
```

When no reliable oracle exists, the artifact remains explicitly judgment-based or unverified and may require human approval.
