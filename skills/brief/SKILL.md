---
name: brief
description: A manual switch the user throws, never something to invoke on your own initiative. Turn on only when the user says "brief", "brief this", "brief that", or "brief <topic>". Produces a fixed 10-line situation brief - what the work is, where it stands, what is open, what happens next - readable at a glance in under a minute.
disable-model-invocation: true
---

# brief

A one-minute read that puts the user back on top of a topic. Not a summary of the conversation:
the **current state of the work**, in a shape that never changes, so the eye finds each field in
the same place every time.

Trigger: the user types `brief`, `brief this`, `brief that`, or `brief <topic>`. Nothing else.
Without a topic, brief the work folder of the current session.

## Where the content comes from

Read before writing, do not reconstruct from memory: `notes/state.md` (blockers, todos, log) and
`notes/requirements.md` (the contract). Everything in the brief must be traceable to those files or
to something verified this session. A fact you cannot source does not go in.

## The shape

Exactly these five blocks, in this order, blank line between each. Ten content lines at most.

```markdown
**<Topic>** · <the one-line what, including where time is booked if relevant>

**Now**
<one or two lines: the current state, in observable terms>

**Rules**
<one or two lines: the constraints that change what may be done — only if there are any>

**Open**
- <item> — <who/what it waits on>
- <item> — <who/what it waits on>

**Next** <the single next action>
```

## Rules for the content

- **Lead with the thing itself**, never with "this is a brief about".
- **Each block is independent.** The reader skips any of them and still understands the rest.
- **Open is a list, maximum three items, ranked.** More than three means the top three plus
  `+N more in state.md`. Each item names what it waits on — a person, a decision, a run.
- **Next is one action**, the thing to do now, small enough to start immediately.
- **No history.** What was done yesterday belongs in the log, not the brief. The exception is a
  result that still changes today's decisions.
- **Whole sentences, no shorthand, no abbreviations** the user has not used themselves. This is
  read under load.
- **Blockers come first.** If something is blocked, that goes in **Now**, not buried in **Open**.
- Name the state of a thing, not its history: "runs automatically at 09:00" beats "I set up a
  scheduled task yesterday".

## Length

Ten content lines is the ceiling, not the target. A quiet project is four lines, and padding it
back to ten makes it worse. If the topic genuinely needs more than ten, the brief names the one
thing that matters and points at `state.md` for the rest.

Formatting stays plain: bold labels, hyphen bullets, no tables, no nesting, no emoji
(`writing-for-agents.md`, "Formatting: plain by default").
