---
name: writing-for-agents
description: How to write documents an agent consumes. Use when creating or editing a skill, a wiki file, AGENTS.md, or any doc reached by a pointer. Also use when a skill fires at the wrong time, when a document is too long to stay reliable, or when deciding whether material should be inline or behind a reference.
---

# Writing for Agents

A skill, a wiki file, an `AGENTS.md`, a doc reached by a pointer: the packaging differs, the writing
does not. The same levers make each one predictable, because the agent takes the same *process*
every run rather than producing the same output.

The structure this applies to is in `wiki-guidelines.md` (what goes where). This is how to write it.

---

## Pointers

A **pointer** is a reference in the agent's context that names out-of-context material and encodes
the condition for reaching it. A skill's `description` is one. A line in `AGENTS.md` naming a wiki
file is the same object.

The pointer's *wording*, not its target, decides when the agent reaches the material and how
reliably. Good material behind a weak pointer is a variance bug: sharpen the wording first, inline
the material only if sharpening fails.

A pointer does two jobs: say what the material is, and list the **branches** that should trigger
reaching it. Every word of an always-loaded pointer costs on every turn, so it earns harder pruning
than the body:

- Front-load the leading word. The pointer is where it does its triggering work.
- One trigger per branch. Synonyms renaming one branch are one branch written twice.
- Cut identity the body already carries.

Write descriptions as trigger conditions, not summaries. "Use when a download fails with HTTP 403"
fires. "Covers proxy configuration" does not.

## The two loads

Every document and pointer spends one of two budgets:

- **Context load** is the cost of always-loaded material: an `AGENTS.md` line, a skill description,
  anything in context every turn, spending tokens whether or not it fires.
- **Cognitive load** is the cost on you: which documents exist and when to reach for each. You are
  the index. Not a cost to minimise, it is the price of your own agency. Spend it where your
  judgment matters, remove it where it does not.

Material reached only through a pointer escapes context load at the price of the pointer's line.
Material with no pointer rides entirely on cognitive load, which is how a wiki file nobody indexed
gets forgotten.

## Information hierarchy

A document is built from **steps** (ordered actions) and **reference** (definitions, rules, facts
consulted on demand). They mix freely: all steps, all reference, or both. The decision is where
each piece sits on a ladder ranked by how immediately the agent needs it:

1. **In-file step.** The primary tier: what the agent does, in order.
2. **In-file reference.** Consulted on demand. Often a legitimately flat set, every rule of a review
   on one rung. That is a fine arrangement, not a smell.
3. **Disclosed reference.** Pushed to a separate file behind a pointer, loaded only when the pointer
   fires.

Push too little down and the top bloats. Push too much and you hide what the agent needs. That
tension is the whole decision.

**Progressive disclosure** is the move down the ladder so the top stays legible. Branching is the
cleanest test: inline what every branch needs, disclose what only some branches reach. In a document
with steps, undisclosed reference buries them and turns attending to them into a coin flip.

**Co-location** is the within-file companion. Keep a concept's definition, rules and caveats under
one heading rather than scattered, so reading one part brings its neighbours. Scattering fragments
one meaning across many places, which is different from duplication repeating one meaning in two.

**Sprawl** is the failure mode: a document simply too long, even when every line is live. Attention
thins across the excess. The cure is the ladder.

## Completion criteria

Every step ends on a condition that tells the agent it is done. Two properties make it a lever:

- **Clarity.** Can the agent tell done from not-done? A vague bound invites **premature
  completion**, ending the step early because attention slipped to being done. Sharpen the bound
  first, it is cheap and local. Only split the sequence if the bound is irreducibly fuzzy and you
  actually observe the rush.
- **Demand.** How much it requires. "Every modified table accounted for" forces thorough work where
  "produce a change list" does not. Demand drives the digging the agent does inside the work.

The strongest criteria are checkable and exhaustive. This is the same property `loop-engineering.md`
demands of acceptance criteria, applied to a document's steps.

## Leading words

A **leading word** is a compact concept already in the model's pretraining that the agent thinks
with while running the document. Repeated as a token, never as a sentence, it anchors a whole region
of behaviour in the fewest tokens by recruiting priors the model already holds.

Coining your own works if you define it clearly, but a made-up word recruits no priors: you pay in
definition tokens what a pretrained word gives free. Reach for an existing word first.

Hunt for passages that collapse into one token. "Fast, deterministic, low-overhead" becomes *tight*.
"A loop you believe in" becomes *red*, turning a fuzzy gate into a binary observable state.

**Negation** is the failure mode beside this lever. Steering by prohibition drags the forbidden
behaviour into context and makes it *more* available. Don't think of an elephant, and the elephant is
all there is. Prompt the positive: state the target behaviour so the banned one is never spoken. A
prohibition earns its place only as a hard guardrail you cannot phrase positively, and even then
pair it with the positive target.

The exception is `destructive-operations.md`, where the prohibition *is* the content and the cost of
a miss is unrecoverable. Absolute rules there are deliberate.

## Pruning

- Keep each meaning in a **single source of truth**, so changing behaviour is a one-place edit.
  Duplication costs maintenance and tokens, and inflates a meaning's prominence past its real rank.
- The **environment** is a source of truth too: config files, directory layout, `--help` output. A
  document restating it is a cache, earning its load only when the lookup is expensive. Cache what
  the agent cannot find by looking: the unwritten convention, the reason behind a choice, the gotcha
  no config confesses.
- Check every line for **relevance**. A line loses it by never bearing on the task, or by going
  stale. Without pruning the default fate is sediment: stale layers that settle because adding feels
  safe and removing feels risky.
- Hunt **no-ops** sentence by sentence. An instruction the model already obeys by default pays load
  to say nothing. The test is model-relative: settle a disagreement by running the document, not by
  debating. When a sentence fails, delete the whole sentence rather than trimming words.

---

## Formatting: plain by default

Write to survive as plain text. These documents are read in terminals, diffs, and grep output as
often as in a renderer, and heavy markup adds noise without adding meaning.

- Prose and short lists are the default. Reach for a **table** only when the content is genuinely
  two-dimensional (a column mapped to a meaning across several rows); a table of two rows is a list
  wearing a costume.
- **Bold** marks a real signpost — a term being defined, a hard rule — not scattered emphasis inside
  sentences. If half the paragraph is bold, none of it is.
- Headings earn their place by making the document skimmable; do not `##` a two-line note.
- This applies to the wiki, `AGENTS.md`, and the `notes/` working files alike (`state.md`,
  `requirements.md`). The working files especially stay plain — they change every turn and are read
  under load.

---

## Skill mechanics

Two invocation choices, trading the two loads:

- **Model-invoked** keeps a `description`, so the agent fires it autonomously and other skills can
  reach it. You can still type its name. The description is a permanently loaded pointer: context
  load in exchange for discoverability. Omit `disable-model-invocation` and write the description as
  trigger branches.
- **User-invoked** strips the description from the agent's reach. Only you typing the name invokes
  it, and no other skill can. Zero context load, but you must remember it exists. Set
  `disable-model-invocation: true`.

Pick model-invocation only when the agent must reach the skill on its own, or another skill must.

> A user-invoked skill you forget is dead weight. Forty user-invoked skills are forty things you
> will not remember. Prefer a model-invoked skill with a sharp description, or fold the material
> into a skill that already fires.

Shared reference two user-invoked skills both need can live in neither, since neither can fire the
other. Push it to a plain file any skill can point at.

Frontmatter for this environment:

```yaml
---
name: skill-name
description: What it covers. Use when <trigger>, when <trigger>, or when <trigger>.
---
```

## Checklist

- Does the description name distinct triggers, not a summary?
- Is every always-loaded line earning its place on every turn?
- Are steps at the top, reference below, and only branch-specific material disclosed?
- Does each step have a criterion the agent can check?
- Any sentence the model would obey anyway? Delete it.
- Any meaning stated in two files? Pick the owner, point at it from the other.
- Any prohibition that could be phrased as a positive target?
