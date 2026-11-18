---
name: requirements-format
description: The requirements.md file - the per-project contract of what is being built, in priority order, and how it will be judged done. Written and confirmed BEFORE any code. Use at the start of any new work item, when a task has no agreed acceptance criteria, when scope is unclear, when the user says "start"/"begin"/"build", or when asked to write or update requirements.
---

# requirements.md — The Contract, Before Any Work

Purpose: pin down what is being built, in priority order, and how it will be judged done — and get
it confirmed — before a single line is written. Without this file agreed, work does not start.

This is the persisted form of loop-engineering.md phase 1 (Specify). The loop owns the rule — no
code before checkable acceptance criteria. This file owns the artifact that survives the session.
It answers, in order:

1. What problem, in observable terms? (why this exists)
2. What is in scope, in priority order, and what is explicitly out?
3. When is it done? (acceptance criteria — falsifiable by running something)

> Pipeline: requirements.md (the contract) → the work → state.md (the record). The requirements'
> priority order becomes the todo order in state.md.

---

## Priority is the order

Requirements are written most-important first. The order is the priority — no labels, no buckets, no
scheme to misread. The top requirement is the one that, if only one thing ships, must ship.

This is the feature that makes priority do work: when time runs short, the agent drops from the
bottom without asking. state.md's todos inherit this order, so "what is next" is never a question.

Out of scope is not a footnote — it is the other half of priority. Naming what will explicitly not
be touched (especially tempting adjacent cleanup) is what stops scope creep.

---

## Agent instructions

### Before starting any work item

1. Check for an existing requirements.md. If it exists and is confirmed, read it and work to it in
   priority order.
2. If it does not exist, or the task is not covered by it: do not start. Run the brainstorming skill
   to draw the spec out of the user, then draft this file.
3. Present the draft in sections short enough to read, and get each confirmed. Acceptance criteria
   get explicit sign-off — they are the definition of done.
4. Only once the user confirms does implementation begin. Record the confirmation date.

### The gate

No confirmed acceptance criteria, no code. If the criteria cannot be written as checkable statements,
the problem is not understood yet — that is a signal to ask (see brainstorming), not to start coding
and discover the requirement halfway.

### When scope changes mid-work

If a new need appears, stop, add it to this file as a proposed change in its right priority position,
get it confirmed, then adjust the todos. A requirement discovered by building is a requirement that
should have been asked.

### Never

- Never start implementation against unconfirmed criteria.
- Never silently widen scope. A change to the contract is a change to this file, confirmed first.
- Never write an acceptance criterion that cannot be checked by running something.

---

## What makes an acceptance criterion valid

Falsifiable by running a command, a query, or a test. It names the observable, the exact expected
result, and how it is checked.

Valid:
```markdown
- `<query/command>` returns `<exact expected result>`, checked on `<environment>`.
```

Not valid (cannot be run):
```markdown
- The bug is gone and everything still works.
```

Include when relevant: measured numbers with units, the environment the check runs in (never infer
it from a server name — see loop-engineering.md), and what a passing vs failing result looks like.

---

## Provenance

When a requirement traces to one specific received item, cite it inline in a short trailing form:

```markdown
2. <requirement> *(from <person>'s mail, notes/mail/<date>-<topic>.eml)*
```

Cite only when the source is not obvious — requirements that came from direct conversation with the
user need no citation. Readability wins: if citations start getting in the way of reading the list,
they are being overused.

---

## Location

`notes/requirements.md` (see folder-structure.md). It is input to the work, not a code deliverable,
so it lives with the notes. One per project; separate confirmed work items become sections within it,
ordered by priority, not new files.

---

## Structure, in this order

1. Title — `# requirements.md — <project>`
2. Problem — one or two sentences, in observable behaviour. Why this work exists.
3. Requirements, in priority order — what is being built, most important first. Each may carry its
   own acceptance criteria, or they can be collected below.
4. Out of scope — what will explicitly not be touched, especially tempting adjacent cleanup.
5. Acceptance criteria — the checkable statements that decide done, each with its check.
6. Open assumptions — stated assumptions that, if wrong, change what gets built. Flag unconfirmed
   ones; unresolved ones that need a person become question-todos in state.md.
7. Confirmed — a one-line dated record of when the user signed off, and on what version.

---

## Template

```markdown
# requirements.md — <project>

## Problem

<one or two sentences, observable behaviour>

## Requirements (priority order, top = must ship)

1. <most important thing being built>
2. <next>
3. <nice to have if cheap>

## Out of scope

- <what will explicitly not be touched>

## Acceptance criteria

- [ ] <checkable statement + the exact command/query/test and expected result>
- [ ] <checkable statement + its check>

## Open assumptions

- <assumption that would change the build if wrong — mark unconfirmed ones>

## Confirmed

- **YYYY-MM-DD** — user confirmed scope, priority, and acceptance criteria above.
```
