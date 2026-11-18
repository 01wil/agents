---
name: src-docs
description: The documentation that ships with the code in src/ - README (always), DEPLOYMENT (usually), ARCHITECTURE (when the design is non-obvious), and the optional docs/ folder - plus credential handling in deployed tools. Use when a project reaches a shareable state, when asked to write a README or document a project for others, when preparing code for handover or an upstream remote, when deciding how a deployed tool stores its secrets, or when durable "how it works" understanding needs to live where humans read it.
---

# src Docs — What Ships With the Code

Purpose: tell a competent stranger what this project is, how to run it, how to deploy it, and how it
is built — without reading the source or asking you.

These files ship. They are tracked with the code in src/ and travel to the upstream remote (see
folder-structure.md). Their audience is another professional — a colleague, a future maintainer,
your future self — not the agent working the task. Keep the work log (state.md) and anything in
notes/ out of them; those stay local and do not publish.

Three files plus one optional folder, each with its own trigger:

| File | When | Holds |
|---|---|---|
| README.md | always | what it is, how to run it, how to use it |
| DEPLOYMENT.md | usually | how it is built, released, and run in its real environment |
| ARCHITECTURE.md | when the design is non-obvious | how it is built and why, for a maintainer |
| docs/ | optional | deeper human-readable deliverables that outgrow one file |

A README that is present and honest can only help. So can a good DEPLOYMENT. Write them by default;
skip only when there is genuinely nothing to say (a throwaway scratch task with no code).

---

## Where durable "how it works" understanding goes

Understanding of how the system works — structure, data flow, moving parts, the gotchas you only
learn by reading it — is expensive to derive and dies at compaction if it has no home. It has one
here: ARCHITECTURE.md (or docs/ for anything larger). This is a deliverable a human reads, so it is
always-ask like all shipped docs.

The split against the other files:
- How the system works, for a human, durable → ARCHITECTURE.md / docs/.
- Throwaway working understanding the agent needs this session → the context bullets in state.md.
- Truths about the environment that outlive this one project (a shared DB schema, a server topology)
  → the wiki knowledge folder (folder-structure.md).

Rule of thumb: project-specific and worth keeping → ARCHITECTURE.md. Cross-project environment truth
→ wiki knowledge. Ephemeral → state.md.

---

## Agent instructions

### When to write them

Offer README and DEPLOYMENT once the project is shareable — runnable code someone else might use,
hand over, or push upstream. Offer ARCHITECTURE when the design is not obvious from reading the
entry point. Do not scaffold docs for a scratch analysis task with no code.

### What each must let the reader do

- README: a competent stranger can, from it alone, understand what the project is, decide if it fits
  their need, install and run it, and use it correctly. If any of those still needs you in the room,
  a section is missing.
- DEPLOYMENT: someone other than you can build a release and put it where it runs, including the
  prerequisites, the exact steps, and how to verify it came up.
- ARCHITECTURE: a maintainer can change the system without first reverse-engineering it — the
  components, how data moves, the integration points, and the non-obvious decisions and why.

### Keeping them honest

Every command in these files must actually run as written. A doc that describes an aspirational setup,
or a flag that was renamed, is worse than none — it is trusted and wrong. Verify commands before
publishing them, the same standard loop-engineering.md phase 4 applies to code. When the code changes
in a way that contradicts a doc, fix the doc; stale architecture is trusted and wrong.

### Never

- Never put secrets, tokens, or connection strings in a shipped doc (see folder-structure.md).
- Never document a command you have not run as written.
- Never leak internal notes — the work log and received material stay in notes/.

---

## Location and language

At the project root / in src/, tracked with the code (folder-structure.md). One of each per project;
docs/ holds the overflow. Match the project's language — the local language for deliverables meant
for local readers, otherwise English (writing-style.md).

---

## README sections a professional carries

Include what the project needs; a library and a scheduled job legitimately differ. The common core:

1. Title + one-line description — what it is, in a sentence.
2. What it is / why it exists — the problem it solves, a short paragraph.
3. Requirements / prerequisites — runtime, SDK, OS, accounts, access needed before it runs.
4. Installation / setup — the exact steps to a working install, commands included.
5. Configuration — settings and env vars, and where the real secret goes (never the secret itself).
6. Usage — how to run it, with a concrete example of input and expected output.
7. How it works (optional) — a short note; deep detail goes in ARCHITECTURE.md, linked not pasted.
8. Troubleshooting (optional) — the failure a new user hits first, and its fix.
9. Ownership / contact / licence — who owns it, who to ask.

## DEPLOYMENT sections

1. Target environment — where it runs (host, runtime, service, schedule).
2. Prerequisites — access, accounts, certificates, secrets that must exist first.
3. Build — the exact commands to produce a release artifact.
4. Deploy — the exact steps to put it where it runs.
5. Verify — how to confirm it came up and works (a health check, a log line, a test call).
6. Rollback — how to get back to the previous version.

## ARCHITECTURE sections

Only the ones the project needs; a small project may be a few paragraphs. Do not scaffold empty
headings. Distinguish verified (you read the code, traced the call) from assumed, and mark
assumptions.

1. Overview — what the system is and does.
2. Structure — the components and their responsibilities, key files/modules.
3. Data flow — how data moves: sources, transforms, sinks. The path that matters.
4. Integration points — external systems, DBs, APIs, schedules it depends on or feeds.
5. Gotchas — the non-obvious things learned by reading it: an encoding quirk, an implicit ordering,
   a footgun. Cache what the config does not confess.
6. Decisions — why it is built this way; the alternatives rejected and the reason.

---

## Credentials in a deployed tool

Git-ignoring a config file keeps a secret out of version control. It does nothing about the copy on
disk next to the exe, which is where it is actually exposed.

Order of preference:
1. Certificate / managed identity — no shared secret to leak or rotate. Ask for this for a
   long-lived tool.
2. Plaintext config with restricted permissions — acceptable for an internal tool when the
   alternative is blocked. Treat it as an accepted risk and write it down as such.

For (2), strip inherited permissions so the file is not readable by every user of the machine:

```
icacls config.json /inheritance:r /grant:r "DOMAIN\svc-account:(R)"
```

- `/inheritance:r` drops inherited entries so the folder ACL stops applying.
- `/grant:r "…:(R)"` grants read to exactly one account (`:r` replaces rather than adds).

This does not encrypt anything — an administrator and the account itself can still read it. It only
narrows who can. It matters on a shared/production host; on a single-user workstation it changes
little.

Also:
- Validate on startup that the config is filled in, and reject template placeholder values. An
  unfilled template otherwise fails later as an opaque authentication error.
- Record the expiry of any secret that expires, and set a reminder.
- A Clean/Rebuild deletes bin/, including a filled-in config placed there. Keep the real one outside
  the build output.
- Never attach a config with a secret to a ticket or email, and never copy it to a shared location
  "temporarily".

---

## Templates

```markdown
# <project>

<one-line description>

## What it is
<the problem it solves, the context a stranger lacks>

## Requirements
- <runtime / SDK / OS / access needed>

## Setup
<exact install commands>

## Configuration
- `<setting / env var>` — <what it does>. Secrets live <where>, never in this repo.

## Usage
<how to run it, with a concrete input -> expected output example>

## Ownership
<owner, who to contact, licence>
```

```markdown
# Deployment — <project>

## Target environment
<host / runtime / service / schedule>

## Prerequisites
- <access / account / certificate / secret that must exist first>

## Build
<exact build commands>

## Deploy
<exact deploy steps>

## Verify
<health check / log line / test call proving it is up>

## Rollback
<how to return to the previous version>
```

```markdown
# Architecture — <project>

## Overview
<what it is and does>

## Structure
- `<path>` — <responsibility>

## Data flow
<sources -> transforms -> sinks; the path that matters>

## Integration points
- <external system / DB / API / schedule> — <how it is used>

## Gotchas
- <non-obvious thing learned by reading the code — mark assumed vs verified>

## Decisions
- <why it is built this way; the alternative rejected and why>
```
