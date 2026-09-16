---
name: senior-software-engineering
description: Design and implementation judgment for production code. Use for feature work, bug fixes, refactors, architecture changes, API or data-model changes, integrations, and performance work. Also use whenever a change starts growing beyond what was asked, or when choosing between two designs.
---

# Senior Software Engineering

The technical bar for phase 2 of the loop, plus the three behaviours that keep a change small.
`loop-engineering.md` owns the phases, the acceptance criteria, and the verification rules. This
skill owns the judgment applied inside them.

These exist because they are the failure modes that actually happen: overcomplication, scope creep,
and silent assumptions.

**Tradeoff:** this biases toward caution over speed. For trivial tasks, use judgment.

---

## 1. Think before coding

Don't assume. Don't hide confusion. Surface tradeoffs.

- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them. Don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what is confusing. Ask.
- Read the relevant code, tests, configuration and recent conventions first. The repository is the
  source of truth about its own patterns, not your priors.

## 2. Simplicity first

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No flexibility or configurability that was not requested.
- No error handling for impossible scenarios.
- No compatibility shims without a real consumer.
- If you write 200 lines and it could be 50, rewrite it.

Ask: would a senior engineer call this overcomplicated? If yes, simplify.

## 3. Surgical changes

Touch only what you must. Clean up only your own mess.

- Don't improve adjacent code, comments, or formatting.
- Don't refactor things that are not broken.
- Match existing style, even where you would do it differently.
- Preserve public contracts unless a breaking change is explicitly required. Identify affected
  consumers before changing an API or schema.
- If you notice unrelated dead code, mention it. Don't delete it.

When your changes create orphans:

- Remove imports, variables and functions that *your* changes made unused.
- Don't remove pre-existing dead code unless asked.
- Delete the scratch files, temp scripts and test directories *you* created, and say what you
  removed. Never delete anything you were given.

The test: every changed line traces directly to the request.

---

## Technical bar

Applies when the change touches these areas. Not a checklist to satisfy mechanically.

- **Correctness over cleverness.** Names express domain intent. Functions have one coherent
  responsibility.
- **Trust boundaries.** Validate inputs where they enter the system. Keep invariants close to the
  data they protect.
- **Failure handling.** No silent failures. Preserve useful context in errors. Distinguish failure
  classes the caller must act on differently: config, auth, transient, partial success.
- **Transient faults.** Retry only what is genuinely transient, with backoff and a bound. Never
  retry a deterministic failure.
- **Idempotency.** Anything that can be re-run after a crash, restart, or retry converges to the
  same end state. This covers scheduled jobs, ETL steps, and any lifecycle command. Design for the
  second run, not just the first.
- **Resource lifetime.** Be explicit about ownership, disposal, cancellation, and what happens on
  partial completion.
- **Concurrency and state.** State ownership, nullability and thread-safety are explicit, not
  incidental. Prefer eliminating shared state over serializing access to it.
- **Secrets.** Never log, commit, or echo them. Reference where a credential lives, never its value.
- **Configuration.** Validated at startup, not discovered as a runtime error. No
  environment-specific values hard-coded.
- **Data and distributed changes.** Consider compatibility, idempotency, transactions, timeouts,
  and partial failure.
- **Performance** against expected scale and measured bottlenecks. Avoid accidental quadratic work,
  unbounded reads, and chatty I/O. Not at the cost of clarity, and not before measuring.
- **Comments** explain non-obvious reasoning and tradeoffs. They do not restate the code.

---

**This skill is working if:** diffs contain fewer unnecessary changes, less is rewritten due to
overcomplication, and clarifying questions arrive before implementation rather than after mistakes.
