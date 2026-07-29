# Security Policy

This repository currently contains a public RFC and non-production examples.

Please report security issues that affect the examples or any future reference implementation through a private GitHub security advisory rather than a public issue.

The security model assumes:

- model outputs are untrusted,
- external content cannot grant authority,
- credentials remain in a deterministic execution plane,
- tool calls are proposals until policy-authorized,
- sensitive data crosses trust boundaries only through explicit minimization and egress controls.

A future implementation must not claim conformance until these properties are tested adversarially.
