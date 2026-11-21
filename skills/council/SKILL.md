---
name: council
description: A manual switch the user throws, never something to invoke on your own initiative. Use only when the user says "council". Runs a review across three strong models from three different providers in parallel and loops with fixes until they agree. Costly by design; for high-stakes changes.
---

# council

Three reviewers from three providers disagree in different places than one model does. Use that to
test a change before it ships. The user must ask for it: three flagship models at high effort is
not a default.

## Before you start

Finish the work first. Fix known issues and address open comments, then run the relevant checks.
Give the council the real implementation, not a draft whose flaws you already know. If the user
wants to discard the implementation and explore, skip fixes to code that will be replaced.

## Run it

1. Pick the members. If the user named them, use those. Otherwise take the latest flagship from each
   of three providers, at high reasoning effort. If you cannot reach three providers, or a named
   member is unavailable, say so and stop. Do not substitute another model.
2. Launch all three in parallel, read-only. Use the harness's way to run another provider's model
   (in T3 Code: `orchestrator_capabilities` to resolve models, then one `delegate_task` per model).
3. Brief each one the same way, self-contained, since they start blank: repo path, base to diff
   against, intent, what is out of scope, check results, and how to read the change. Ask for a
   verdict (APPROVE or CHANGES), a score out of 10, and findings labelled blocker, should, or nit,
   each with `file:line`, the claim, and a fix.
4. Do not wait idle. When a result arrives, check its findings against the code at once and decide
   what to fix while the others run. Do not edit files while any reviewer still reads that
   checkout.
5. Answer every finding yourself: fix it with the smallest change, disagree with evidence, or
   decline it as out of scope. A finding another path, a rare case, or a small cost produces is a
   nit whatever its label.
6. After fixes, start a fresh review. Each full pass is one round. Later rounds need only changed
   code and open findings. Repeat until all three approve.

## Budget

3 rounds. Extend to 5 only for security, permissions, auth, data loss, or concurrency, while a
blocker or should stays open with evidence. Stop early when a round returns only nits. Budget end is
not approval: if an item stays disputed after two replies, show both sides in two or three lines and
let the user decide.

It is your job to hold scope. Do not agree with a reviewer just to end the loop, and do not let
repeated reviews grow the diff. Cut before you add.

## Report

If the work ends in a pull request, put this section in the description, before the line naming the
model that did the work. Edit the description; do not post a comment.

```markdown
## Council review

Rounds: 2

| Delegate | Round 1 | Round 2 |
| --- | --- | --- |
| <model A> | 7/10 | 9/10 |
| <model B> | 8/10 | 10/10 |
| <model C> | 7/10 | 9/10 |
```

A delegate that gave no score is `no score`; never invent one. With no PR, put the same table in
the final reply.
