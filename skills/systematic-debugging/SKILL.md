---
name: systematic-debugging
description: Diagnose and fix software failures using evidence and reproducible experiments. Use for bug reports, exceptions, failing tests, build errors, flaky behavior, regressions, production incidents, performance regressions, or unclear incorrect behavior.
---

# Systematic Debugging

Find the root cause before committing to a fix.

## Workflow

1. Capture the exact symptom, expected behavior, environment, inputs, and failure boundary.
2. Reproduce the failure with the smallest reliable command or test. If reproduction is impossible, gather logs and code-path evidence and label conclusions by confidence.
3. Check recent and local changes without reverting work that is not yours.
4. Trace backward from the observed failure through callers, state transitions, external boundaries, and configuration.
5. Form a small number of falsifiable hypotheses. Test the highest-value hypothesis first rather than making several speculative edits.
6. Separate root cause from secondary exceptions, noisy logs, and downstream symptoms.
7. Add a focused regression test that fails for the demonstrated cause when practical.
8. Implement the smallest fix at the layer that owns the violated invariant.
9. Verify the original reproduction, relevant neighboring cases, and the broader suite appropriate to the change.
10. Remove temporary instrumentation unless it provides lasting operational value.

## Guardrails

- Do not hide failures by swallowing exceptions, weakening assertions, increasing arbitrary delays, or disabling checks.
- Do not add retries without classifying the failure as transient and bounding attempts with timeout, backoff, cancellation, and observability.
- Do not fix data races with unexplained sleeps.
- Do not attribute a failure to a dependency, environment, or user input without evidence.
- Preserve diagnostic context while avoiding secrets and personal data.

## Report

Summarize the reproduced symptom, root cause, evidence, fix, regression coverage, and verification commands. Clearly separate confirmed facts from remaining hypotheses.
