---
name: loop-engineering
description: The mandatory working loop for any task that writes or changes code, SQL, scripts, configuration, or infrastructure. Use before writing the first line of an implementation, when a task has no stated acceptance criteria, when deciding whether a change is done, when scope starts growing mid-task, and before running anything against an environment. Read together with destructive-operations.md.
---

# Loop Engineering

How work gets done here. Applies to every task that produces or changes code, SQL, scripts,
configuration, or deployment state. Not a suggestion, and not only for large tasks. A one-line fix
runs the same loop, it just runs it in a minute.

This is a convention file, not measured knowledge. It encodes how the user wants agents to work.
When it conflicts with a repository-local instruction, the repository wins. When it conflicts with
`destructive-operations.md`, safety wins.

---

## TL;DR

1. Specify. Write the bounds and the acceptance criteria before any code exists. No criteria, no code.
2. Implement. The smallest thing that meets the criteria. Nothing else.
3. Adversary (optional). One hostile pass for real bugs, then one precise fix cycle. Not a rewrite.
4. Verify. Against a dev environment or tests that mirror production. Never against production.

Then stop. Meeting the acceptance criteria is the halt condition. Continuing past it is not
diligence, it is scope creep.

> Production is untouchable in every phase without explicit, task-specific approval. Reading
> production is not automatically safe either, an unbounded query on a live box is still an
> incident. Before anything that writes, read `destructive-operations.md` in full.

> Questions beat assumptions, always. One question costs a minute. A wrong assumption costs the
> whole loop, and sometimes costs data.

---

## 1. Specify

Nothing gets written until the problem has edges.

Produce these four things first, in the task notes or in the reply to the user:

- The problem, in one or two sentences, in terms of observable behavior.
- In scope. The files, tables, systems, and behaviors this change is allowed to touch.
- Out of scope. What will explicitly not be touched, especially the tempting adjacent cleanup.
- Acceptance criteria. Checkable statements that decide whether the work is finished.

An acceptance criterion has to be falsifiable by running something. "The bug is gone" is not a
criterion — nothing to run, nothing to check. A statement naming the exact command, the exact
expected result, and the environment it was checked in is.

If the criteria cannot be written, the problem is not understood yet. That is a signal to ask, not
a signal to start coding and find out. State assumptions explicitly and get them confirmed when
they change what gets built.

Halting criteria are the point of this phase. Without them there is no definition of done, so the
work expands until someone gets bored. With them, the loop terminates.

For a bug, run `systematic-debugging` first. You cannot specify a fix for a cause you have not
found.

## 2. Implement

The minimal implementation that satisfies the acceptance criteria. Then stop.

Minimal is a hard constraint, not a preference:

- No abstraction without at least two real call sites today.
- No configuration option nobody asked for.
- No compatibility shim without a named consumer.
- No error handling for conditions that cannot occur.
- No refactor of code that is next to the change but not in it.
- No new dependency when the repository already has a working pattern.
- No defensive logging or comments that restate the code.

The best change is the one that deletes code. Lines removed is a better measure of the work than
lines added. If the diff grew while the criteria stayed the same, something went in that does not
belong. Read the diff and take it out.

Follow the conventions already in the repository, even where a different approach would be nicer.
Consistency is worth more than local taste.

Deeper method: `senior-software-engineering` for design judgment inside this phase. Run `deslop` on
your own diff before moving on.

## 3. Adversary (optional)

One pass where the goal is to break your own work. Skip it for trivial changes. Run it for
anything touching money, trades, persistence, concurrency, auth, or a scheduled job.

Attack the change specifically:

- Boundaries. Empty input, one row, null, maximum length, first and last day of a period.
- Assumptions. What if the source has duplicates. What if the join fans out. What if the date is
  parsed under a different locale. What if the string is shorter than the substring index.
- Failure. What happens on a timeout, a partial write, a retry, a second concurrent run.
- Blast radius. What breaks downstream if this is wrong and nobody notices for a week.

Then one cycle: collect the real findings, fix them precisely, done. One cycle is the whole point.
An adversary pass that turns into a rewrite has failed, it has just replaced verified code with
unverified code. Findings that fall outside the agreed scope get written down and reported, not
fixed silently.

Deeper method: `high-signal-code-review`.

## 4. Verify against a dev environment

Evidence, or it is not done. Two acceptable forms:

- A dev environment that mirrors production closely enough that a pass there means something.
  Same schema, same compat level, representative data volume, same auth path.
- Tests at the lowest level that actually exercises the failure boundary. Unit for logic,
  integration for anything touching a database, serialization, the filesystem, or a framework.
  End-to-end for the wiring itself.

Rules for this phase:

- Run every acceptance criterion from phase 1 and report the actual result, per criterion.
- For a bug fix, confirm the test fails for the original cause before the fix. A regression test
  that never went red proves nothing.
- Report the exact commands and the exact output. Never a summary of a run that did not happen.
- Say plainly what was not verified and why. A skipped check reported honestly is fine. A skipped
  check implied to have passed is not.
- Clean up what you created. Temp scripts, test rows, scratch directories, and say what you removed.

If no dev mirror exists and no test can reach the real failure boundary, stop and ask. Falling
back to production is never the answer, and neither is declaring it verified because it compiled.

For which servers are dev and which are production, see the environment topology in your local
`knowledge/` folder (`knowledge/INDEX.md`). Never infer the environment from a server name — a box
that reads like a legacy test server can hold live production data.

Deeper method: `verification-and-testing`.

---

## Production

Explicit approval, for that specific task, before production is touched in any phase. Not implied
by the task existing. Not implied by yesterday's approval. Not implied by the change being small.

- Writes to production need approval and the full procedure in `destructive-operations.md`.
- Reads against production need approval too when they are unbounded, long-running, or lock-taking.
- Deployments, schedule changes, job enable/disable, and config changes count as production writes.
- No backup, no destructive operation.
- If the user said wait, wait. Investigating is not an exception.

## Ask instead of assuming

Ask when the answer changes what gets built, what gets touched, or whether the work is done.
Specifically: acceptance criteria cannot be made checkable, scope is ambiguous at a boundary,
two reasonable designs differ in consequence, an environment cannot be identified with certainty,
or a finding suggests the stated problem is not the real one.

Do not ask what the repository already answers. Read the code first.

Batch the questions, make each one independently answerable, and say what you will do with each
answer. When the user is drafting something to a colleague, `writing-style.md` applies.

---

## Where the deeper method lives

This file owns the loop, the halting criteria, and the production guardrail. Depth per phase lives
in the skills, so it is not restated here and cannot drift.

| Phase | Load |
|---|---|
| 1. Specify | `systematic-debugging` when the task is a bug. You cannot specify a fix for a cause you have not found |
| 2. Implement | `senior-software-engineering`, then `deslop` on your own diff |
| 3. Adversary | `high-signal-code-review` |
| 4. Verify | `verification-and-testing` |
| Any phase | `engineering-principles` for levers, context budget, and type discipline |
| Any phase, writes | `destructive-operations.md`, mandatory |
| Any phase, environments | your local `knowledge/` folder (`knowledge/INDEX.md`) |

---

## Failure modes

The recognizable ways this loop gets broken:

- Coding before the criteria exist, then discovering the requirement halfway and rebuilding.
- Criteria that cannot be checked by running anything, so "done" becomes a matter of opinion.
- Building the general version of a specific request. Configuration, hooks, and interfaces nobody
  asked for.
- Fixing the adjacent thing. It was right there, and now the diff is unreviewable.
- The adversary pass becoming a rewrite, replacing tested code with untested code.
- Declaring success on a compile, a syntax check, or a plan of what the tests would show.
- Verifying on a box because its name sounded like a test system.
- Assuming a requirement because asking felt like an interruption.
- Reporting completion while an acceptance criterion was silently dropped.

## Checklist before reporting done

- Were the acceptance criteria written before the code, and are they still the same ones?
- Does every criterion have an actual command and an actual result behind it?
- Is anything in the diff not required by a criterion? If yes, why is it still there?
- Was anything touched that phase 1 put out of scope?
- Was production touched, and if so, where is the explicit approval?
- Is it clear what was verified, what was not, and what is still open?
- Are the scratch artifacts cleaned up, and is the cleanup stated?
- Is there any claim in the report that was not actually observed?
