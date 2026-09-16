---
name: high-signal-code-review
description: Review code or a change set for correctness, regressions, security, reliability, maintainability, and test gaps. Use when asked to review a PR, commit, diff, implementation, architecture change, or repository quality.
---

# High-Signal Code Review

Prioritize defects that can change behavior or materially increase operational risk.

## Review Process

1. Establish the intended behavior and change scope from the request, issue, tests, and surrounding code.
2. Inspect the complete diff and relevant callers, callees, schemas, configuration, and tests. Do not review changed lines in isolation.
3. Check correctness across happy paths, boundaries, null and empty values, errors, cancellation, concurrency, retries, and partial failure as applicable.
4. Check API, storage, serialization, deployment, and backward compatibility for real consumers.
5. Check authorization, validation, injection risks, secret handling, privacy, unsafe deserialization, and dependency trust boundaries.
6. Check resource lifecycle, unbounded operations, query behavior, algorithmic complexity, and hot-path allocations where relevant.
7. Evaluate whether tests would fail for the likely regressions. Identify missing tests with concrete scenarios.
8. Avoid subjective style findings already handled by formatters unless they obscure correctness or maintainability.

## Finding Format

Order findings by severity and provide:

- Severity: critical, high, medium, or low.
- Precise file and line reference.
- Concrete failing scenario or risk.
- Why existing code or tests do not prevent it.
- A concise remediation direction.

Do not inflate severity. Do not report a possibility as a bug without a plausible execution path. If there are no findings, say so and list residual testing or environmental gaps.
