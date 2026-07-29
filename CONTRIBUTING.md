# Contributing

This repository is an RFC and engineering experiment. Contributions should make the claims more precise, falsifiable, implementable, or demonstrably wrong.

Useful contributions include:

- concrete counterexamples,
- failure-mode analyses,
- schema improvements,
- minimal prototypes,
- evaluation datasets,
- security attack scenarios,
- incident-response exercises,
- comparisons with durable workflow, actor, compiler, and policy systems.

## Pull requests

A pull request should state:

1. The claim or boundary being changed.
2. The failure mode or evidence motivating the change.
3. Whether the change is normative, explanatory, or experimental.
4. How the claim can be evaluated.
5. Any new operational or security cost introduced.

Avoid claims based solely on model authority or anecdotal success. Prefer external evidence, executable examples, or clearly labeled hypotheses.

## Design principle

Do not weaken a contract merely to accommodate a model regression. Change the contract only when the intended system behavior has consciously changed.
