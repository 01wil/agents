---
name: engineering-principles
description: Cross-cutting engineering principles not owned by another skill. Use when a task involves repetitive edits across many files, when verification needs to be repeatable rather than eyeballed, when a session is filling up with large tool output, or when designing types and a value can hold contradictory state.
---

# Engineering Principles

Three principles that no other skill owns. The loop owns phases, `senior-software-engineering` owns
design judgment, `verification-and-testing` owns test strategy. These sit across all of them.

---

## Build the lever

When work repeats, build the thing that does it or proves it instead of doing it by hand. The tool is
the artifact a reviewer can re-run.

- Do the first unit by hand to learn the recipe, then write the script. Prove the script by re-running
  it on that first unit and diffing against your hand-done version.
- Make the lever safe to re-run. Someone will run it twice. See idempotency in
  `senior-software-engineering`.
- A deterministic script beats a careful manual pass. Fifteen files edited by a script are
  consistently edited. Fifteen edited by hand are fifteen chances to differ.
- The strongest verification is a script that re-runs the comparison, not a one-time eyeball. A
  script diffing before-and-after row counts catches what a glance misses.
- Keep the script and its output. Phase 4 of the loop requires reporting actual results, and a
  re-runnable script *is* that evidence.

**The bar is triviality, not repetition.** A one-off still earns a lever when the lever is what makes
the work checkable. Build the smallest script that does or proves the job, never a framework.

Depending on the environment that might mean a shell script, a `SELECT` that counts what a `DELETE`
would touch, or a small script committed next to the change. See your local `knowledge/` folder for
the tooling specifics of this environment.

> A destructive lever is still destructive. A script that writes needs the full protocol in
> `destructive-operations.md`, including the backup, every time it runs.

---

## Guard the context window

Context is finite and cannot be reclaimed within a session. Every token that enters should earn its
place.

Overflow does not announce itself. It shows up as degraded reasoning, forgotten constraints, and a
plausible-sounding answer built on material that scrolled out of reach.

- **Route bulk elsewhere.** Large query results, long files, and verbose build output go to a
  subagent or a file. The main thread gets the summary, not the payload.
- **Don't read what you will not use.** Read the file the task needs. Skip the survey.
- **Keep what fires every time inline.** A template used on every invocation belongs in the skill
  file. A branch used occasionally belongs behind a pointer. See `writing-for-agents`.
- **Prefer a targeted query over a dump.** `SELECT COUNT(*)` and `TOP 20` answer most questions that
  a full table read also answers, at a fraction of the cost.
- **Hand off before you run out.** A handoff written with room to spare is accurate. One written at
  the limit is a guess. See the `handoff` skill.

---

## Make illegal states unrepresentable

If a type can hold a combination that means nothing, something eventually puts it there.

- **Model variants, not flag bags.** `bool Completed` plus `DateTime? CompletedAt` admits
  `Completed = true, CompletedAt = null`, which is meaningless. Derive the flag from
  `CompletedAt != null`, or model the states explicitly.
- **Brand semantic primitives.** `CustomerId` and `OrderId` are both `int` underneath and must not
  be interchangeable. A readonly record struct wrapping the value costs little and turns an
  argument transposition into a compile error. Validate once at creation, then trust the type.
- **External data is untyped until parsed.** JSON, config, environment variables, CLI arguments, and
  database rows are untrusted shapes. Parse into the typed model at the boundary, once. Do not pass a
  `DataRow` into business logic.
- **Do not lie to the compiler.** A cast that exists to silence an error is a runtime failure with a
  delay. If the compiler cannot prove the fact, prove it by validating, or acknowledge the cast as a
  hazard in a comment.
- **Make new variants fail the build.** A `switch` over a closed set should not compile when a case is
  added and unhandled. Use a `switch` expression with no default rather than one that silently falls
  through.
- **Derive from the authoritative schema.** When a table definition, OpenAPI spec, or migration owns a
  shape, generate or derive from it. A hand-maintained parallel type drifts, and the drift surfaces as
  a wrong value rather than an error.

**The tests:**

- Can you write a comment explaining when a combination of fields is valid? Then the type is too
  loose. Split it.
- Do two parameters share a primitive type and mean different things? Brand them.
- Where did this cast come from? Trace it to the boundary and validate there instead.
- If a variant is added next month, does the compiler point at every place that needs a case?
