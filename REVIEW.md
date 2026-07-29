# Skeptical Review Request

Review this RFC as a principal engineer, systems architect, SRE, and security engineer. Be critical rather than agreeable.

Please examine:

1. Where the proposal is genuinely useful and where it merely renames workflows, actors, functional composition, durable execution, or zero-trust security.
2. Hidden assumptions about validation, context isolation, latency, cost, and human availability.
3. Whether operation granularity is practical.
4. Failure modes introduced by the orchestrator, policy engine, artifact graph, or reference monitor.
5. Whether artifacts can realistically replace conversational memory.
6. Whether the oracle hierarchy creates unacceptable test and policy maintenance cost.
7. Whether compensations are sufficiently safe for real external systems.
8. Whether the causal observability model is usable during a high-pressure incident.
9. Whether drift detection can distinguish provider changes from prompt, data, or validator changes.
10. Whether the security model actually prevents privilege escalation after successful prompt injection.
11. What minimum implementation can falsify the thesis without overengineering.
12. Which maxims are redundant, too absolute, or technically incorrect.

For each criticism, provide:

- the violated assumption,
- a concrete counterexample,
- severity,
- an experiment or implementation change that could resolve it.
