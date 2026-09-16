---
name: handoff
description: Compact the current session into a handoff document so a fresh agent can continue. Use when context is filling up, when work spans more than one session, when pausing mid-task, or when the user asks for a handoff or to hand work over.
---

# Handoff

Write a document that lets a fresh agent resume without re-deriving anything.

Save it to the project folder as `handoff.md` next to `state.md`, or to `/tmp` if the work has no
project folder. Ask which if it is not obvious.

## Relationship to state.md

`state.md` is the durable work log: where the project stands, what is decided, what is blocked. It
survives the project. A handoff is transient: the live thread of one session, deleted once picked up.

If a fact belongs in `state.md`, put it there instead and point at it. Do not write it twice. See
`state-format.md`.

## Contents

- **The goal**, and the acceptance criteria from phase 1 of the loop. A fresh agent that does not
  know the halting condition will either stop early or never stop.
- **Where the work stands** against those criteria. Which are met, which are not, which turned out
  wrong.
- **What was verified and how**, with the exact commands. Separate verified from assumed.
- **What is in flight.** Uncommitted edits, half-finished refactors, a script left in `/tmp`, a
  branch not pushed.
- **Blockers**, and what would unblock each. Name the person if it is waiting on someone.
- **Decisions made and rejected**, with the reason. This is what stops the next agent relitigating a
  settled question.
- **Traps found.** Anything that cost time and would cost it again.
- **Which skills and wiki files to load**, by path.

## Rules

- **Reference, do not duplicate.** Point at paths, commit SHAs, ticket keys, and existing docs
  instead of restating them. A handoff that copies a spec goes stale against it.
- **Exact identifiers.** Server, database, table, column, file path, line number, ticket key. A
  fresh agent cannot guess the real name from "the dev server".
- **Say what you did not do.** Unverified, unrun, and unfinished work stated plainly. Never imply
  completion.
- **No secrets.** No passwords, tokens, connection strings, or customer data. Name where a credential
  lives.
- **Flag anything destructive** that is pending or half-done, and point at
  `destructive-operations.md`.

## Check before handing over

Could an agent with no memory of this session pick it up, know when to stop, and not repeat work
already done? If any answer is no, the gap is what to write next.
