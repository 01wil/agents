---
name: test-driven-development
description: Write the test before the code, for a feature or a bug fix, when the behaviour has a checkable outcome and the project already has a way to run tests. Use when asked to work test-first or TDD, or when a change is worth pinning down with a failing test first. Not for exploratory spikes or throwaway code.
---

# Test-driven development

Write the test first, watch it fail for the right reason, then write the least code that makes it
pass. The failing test is the proof that the test tests something; code written first and tested
after can pass against a test that never could have failed.

This is a way of working inside the loop (`wiki/loop-engineering.md`), not a replacement for it. The
acceptance criteria still come first; TDD is how you turn one criterion into code.

## The cycle

For each small piece of behaviour:

1. **Red.** Write one test that asserts the behaviour you are about to build. Run it. It must fail,
   and the failure message must be the one you expect, the assertion, not an import error or a typo.
   A test that fails for the wrong reason has told you nothing.
2. **Green.** Write the least code that makes it pass. Not the general solution, the one that passes.
   Resist building ahead of the test.
3. **Refactor.** Now that it is green, clean up what you just wrote, and run the test again. The test
   is what lets you refactor without fear.

Then the next piece. Small steps: a cycle is minutes, not an afternoon.

## For a bug fix

Reproduce the bug as a failing test before you touch the fix. Confirm it fails against the original
cause, then make it pass. That test is the regression guard; without seeing it fail first you cannot
know it guards anything (this is the rule in `verification-and-testing`, step 8, made the starting
point).

## Rules

- One behaviour per test. A test that asserts five things fails without telling you which.
- Test the observable outcome, not the internals, so the test survives a refactor.
- Follow the project's test conventions, runner, and fixtures (`verification-and-testing`). TDD
  changes the order you write things in, not the kind of tests you write.
- Keep each test deterministic from the start: control the clock, randomness, and anything over the
  network, or the red step lies.
- Report the commands you ran and the actual red-then-green transition. "Tests pass" after writing
  them first is a different and stronger claim than tests written to fit code that already ran.

## When not to

Exploratory work where you do not yet know the shape of the answer: spike first, throw it away, then
build it back test-first. And anything with no checkable outcome, where a test would assert nothing
real.
