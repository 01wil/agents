---
name: state-format
description: The state.md work log - the single memory of a project. Holds blockers, the prioritized todo list (with sub-todos and questions-to-people), and an append-only dated log that also tracks external correspondence ([IN]/[OUT] entries). Use when starting work on a project (read it first), when finishing any unit of work, when new material arrives in notes/, when a question needs a person, when asked to "update state.md", or when picking up a project with no context.
---

# state.md — The Work Log

Purpose: persist what was done and the state the project is in, so any agent or human can resume
without re-deriving anything.

state.md is the memory of a project. It carries three things, top to bottom:

1. Blockers and critical context — what you must know before touching anything.
2. The open todos — prioritized, with sub-todos and open questions to people.
3. The log — one dated entry per completed thing plus [IN]/[OUT] correspondence, append-only.

> Boundary: state.md records what happened in this project. The wiki records how the world works.
> Durable understanding of how the system works goes in src/docs (see src-docs.md). Task status
> never goes in the wiki; environment truths never go in state.md.

There is no separate plan.md, questions.md, or analysis.md — deliberately. Execution steps are
sub-todos here, questions to people are todos here, durable "how it works" understanding is a
deliverable (src-docs.md). Two files to resume from (with requirements.md), not five.

---

## The auto-write exception

Unlike every other persisted file, state.md is maintained automatically. At the end of a unit of
work, update it without asking — append the log entry, move done todos into the log, refresh the
blocker block. It is append-mostly and low-risk, and it is the file the user should never have to
think about. The user sees the diff in the session anyway.

Everything else — requirements.md, wiki edits, src/ docs, anything a person will read as a
deliverable — stays always-ask.

Two hard limits even under auto-write:
- Never delete or rewrite past log entries. The log is append-only; done todos move down, they do
  not vanish.
- Never fabricate a timestamp or a result, and never log something as done that was not verified.
  Fetch the real clock: `date '+%Y-%m-%d %H:%M'`.

---

## Starting work: read this first

Read state.md before planning anything. It tells you what was tried, what is blocked and why, and
which decisions are settled. Do not redo work recorded in the log, and do not relitigate a decision
without saying so explicitly. Then give the user a short situation brief (see AGENTS.md).

---

## Structure, top to bottom

1. Title — `# state.md — <project>`
2. Blockers / critical (conditional) — a short block at the very top, only if there is something
   the reader must know first: an active blocker, a missing permission, a "do not run X". A blocking
   question lives here too. Omit the whole block if nothing qualifies. Do not pad it.
3. TODO (open) — the prioritized checklist, before the log. Order is priority: top item is next.
   Order inherits from requirements.md priority. Todos may nest sub-todos. Questions to people are
   todos with a paste-ready message (below).
4. Summary / Log — the core. Dated entries, newest at the bottom of the run, each one completed
   thing. Below the entries, a few context bullets (what exists, how it works) if useful.
5. Key Decisions (optional) — durable choices plus rationale, so they are not relitigated. A
   decision made while working (by you or the user) is recorded here. An answer that came from an
   outside person is recorded in the log entry that resolves its question-todo.

---

## Todos: priority, sub-todos, and questions

Priority is the list order. The top todo is what happens next. When you pick up requirements, the
todos come out in the requirements' priority order. A blocker on a high-priority todo floats into
the blocker block at the top; a blocker on a low one does not.

Break a large todo into sub-todos by indenting under it. One in-progress todo at a time. If
executing reveals the plan is wrong, stop and revise the todos — do not improvise past them. If it
surfaces new scope, that goes back to requirements.md for confirmation first, not silently into the
todos.

```markdown
## TODO (open)

- [ ] <highest-priority task>
  - [ ] <sub-todo> — verify: <check>
  - [ ] <sub-todo> — verify: <check>
  - [ ] <sub-todo> — verify: <check>
- [ ] <lower-priority task>
```

A good sub-todo has the same shape a plan step used to: about 2–5 minutes of work, one concern
("add the field" and "validate the field" are two), checkable (it ends in a state you can
confirm — compiles, test passes, endpoint returns), and ordered by dependency so nothing
forward-references. If a sub-todo is bigger than a few minutes, split it; if ten are each ten
seconds, you are over-planning a trivial change — collapse them. Apply the `ponytail` ladder as you
write them, so the list already excludes what does not need to exist. Match the depth to the size:
a one-file fix needs a line of intent and its verification, not a ten-item breakdown.

### Questions to people

An open question that needs an answer from a named person is a todo with two parts: a normal todo
line, and an indented paragraph below it holding the exact message to send — written in the user's
voice (writing-style.md) so it can be pasted into a mail or chat with no editing. State your current
assumption inside the message so the person can confirm or correct rather than compose from scratch.

If the owner is unknown, say so in the todo and ask the user who it should go to; an unrouted
question never gets sent.

```markdown
- [ ] Ask <person> for <thing> (blocks: <what it blocks>)

      <paste-ready message in the user's voice, in whatever language the recipient expects,
      stating the current assumption so they can confirm or correct it>
```

The indented paragraph is what makes this cheap: the user copies it out, sends it, and when the
answer comes back pastes the reply in. You then file the answer — move the todo into the log with
the answer and its source, and record any build-changing consequence in Key Decisions or the
relevant deliverable. The question text is preserved in the log entry, never deleted, so the
reasoning survives compaction and nobody re-asks it.

If a question is blocking, also surface it once in the blocker block at the top.

---

## What a log entry contains

Each entry states what was done, the result, and how it was verified.

### External events: [IN] and [OUT]

The log is also the correspondence timeline. Two tagged entry kinds sit in the same chronological
stream as work entries (which stay untagged):

- **[IN]** — material arrived: an email, ticket, screenshot, data dump, or a pasted answer. Name
  the file in notes/, who it came from, and in one line what it changed (a new todo, a confirmed
  assumption, an answered question).
- **[OUT]** — something left toward a person: a question dispatched, a status update sent, a
  deliverable handed over.

```markdown
- **YYYY-MM-DD HH:MM** — [IN] mail from <person> (notes/mail/<date>-<topic>.eml) — <what it
  changed: a new todo, a confirmed assumption, an answered question>.
- **YYYY-MM-DD HH:MM** — [OUT] question to <person> re: <topic> (todo above).
```

Two tags only. Decisions go to Key Decisions, blockers to the blocker block — do not invent more
taxonomy.

**Intake rule:** whenever the agent processes a new file in notes/ (or the user pastes in new
material), an [IN] entry is part of the auto-write, including where the file was filed. This is
what makes the timeline complete without the user doing filing work.

**Reconstruction:** on first contact with an existing folder that has material but no (or an
incomplete) state.md, reconstruct the timeline from file dates and content as [IN] entries, marked
`(reconstructed)`. Then keep it current via the intake rule.

### Work entries

Good:
```markdown
- **YYYY-MM-DD HH:MM** — Root cause found: <the cause, stated plainly>. Verified: <the exact
  measured numbers, with units>. <What was done vs. not done, and why>.
```

Too vague:
```markdown
- **YYYY-MM-DD** — Looked into it, made some progress.
```

Include when relevant: measured numbers with units, exact error text for failures, what was not done
and why, and an explicit split of verified fact vs assumption.

---

## Rules

- One entry per thing done, not one per session. Three items completed is three entries.
- External events are logged too: [IN] for arriving material, [OUT] for outgoing questions and
  deliverables. Work entries stay untagged.
- Todos before the log, always. Priority is the list order.
- Timestamps are real, from the system clock.
- Append, never overwrite. Done todos move into the log; nothing is deleted.
- state.md auto-writes; deliverables and wiki edits stay always-ask.
- Match the project's language for anything a local reader sees; otherwise English.
- The blocker block is conditional — present only when there is a real blocker.

---

## Location

`notes/state.md` (see folder-structure.md). One per project. For an existing project, follow
whatever it already does rather than moving the file.

---

## Template

```markdown
# state.md — <project>

> BLOCKER: <only if there is one, else delete this line>

## TODO (open)

- [ ] <highest-priority actionable item>
  - [ ] <sub-todo> — verify: <check>
- [ ] <next item>
- [ ] Ask <person> for <thing> (blocks: <what>)

      <paste-ready message in the user's voice>

## Summary / Log

- **YYYY-MM-DD HH:MM** — [IN] <material arrived: from whom, filed where, what it changed>
- **YYYY-MM-DD HH:MM** — [OUT] <question/deliverable sent to whom>
- **YYYY-MM-DD HH:MM** — <work done, result, how verified>
- <context bullet: what exists / how it works>

## Key Decisions

- <decision + short rationale>
```
