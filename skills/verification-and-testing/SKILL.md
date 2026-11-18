---
name: verification-and-testing
description: Design, implement, or improve software tests and verification strategy. Use when asked to add tests, increase confidence, investigate coverage, validate a change, stabilize flaky tests, or create a test plan.
---

# Verification and Testing

Build confidence with the least costly test that can reliably detect the target failure.

## Strategy

1. Identify the behavior, invariant, or risk being verified.
2. Choose the lowest test level that exercises the real failure boundary: unit, component, integration, contract, end-to-end, or operational check.
3. Follow repository test conventions and reuse established fixtures and builders.
4. Test observable outcomes rather than private implementation details.
5. Cover the primary path, meaningful boundaries, and failure modes. Avoid exhaustive low-value permutations.
6. Keep tests deterministic. Control clocks, randomness, concurrency, network calls, and external services using repository-approved mechanisms.
7. Ensure tests are isolated, order-independent, and responsible for cleaning up resources they create.
8. For a bug fix, demonstrate that the regression test fails for the original cause before relying on it as evidence.
9. Use realistic integration tests for database mappings, serialization, filesystem behavior, dependency contracts, and framework configuration that mocks cannot validate.
10. Run focused tests and then the broadest practical relevant suite. Report exact commands and failures.

## Test Quality

- A failure explains which behavior regressed.
- Assertions are specific enough to reject incorrect outcomes without overspecifying incidental details.
- Fixtures make intent clear and do not conceal critical setup.
- Timeouts are bounded and asynchronous work is awaited.
- Flaky tests are diagnosed at the cause, not stabilized with arbitrary retries or sleeps.
- Coverage percentages are supporting signals, not goals by themselves.
