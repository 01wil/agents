---
name: writing-style
description: How to write outgoing communication (emails, chat messages, updates to colleagues, questions to seniors) in the user's own voice. Use whenever drafting anything the user will send to another person, or when asked to summarise an analysis for sending. Do NOT use for internal docs, code comments, or wiki entries.
---

# Writing Style for Outgoing Messages

Applies to anything the user sends to a human: mails, chat messages, status updates, questions to
seniors or other teams. **Not** for internal documentation, wiki files, or code comments.

The goal is that it reads like the user wrote it. Not like an AI drafted it.

Worked examples in the user's real voice — including the concrete two-register split and sample
messages — live in the local, git-ignored `writing-style.local.md` (it contains names and
identifiers that do not belong in a public repo). Read that file when drafting; this one holds the
portable rules.

---

## Hard rules

1. **Almost no formatting.** Paragraphs. That is the default. A numbered or bulleted list only when
   genuinely enumerating things (causes, open questions, required permissions). No tables, no
   bold-for-emphasis scattered through sentences, no headings unless the mail is long enough to
   really need them — and then a plain line of text, not `##`.
2. **Match register to recipient.** A close colleague you chat with daily gets a looser, lower-key
   register than an email to management or another department. Keep whatever casing and greeting
   convention the user actually uses for each; the local file records the specifics. The register
   changes; the brevity, the concrete detail, and the no-fluff rule do not. Keep proper nouns,
   table/column names, and acronyms in their real casing regardless of register.
3. **No greeting fluff.** Straight into the point after the greeting. No "I hope you're well," no
   "thanks in advance for your effort."
4. **State the conclusion first**, then the evidence. Never build up to it.
5. **Concrete numbers, always.** The exact count, not "some duplicates." Give the exact identifier
   the reader can look up (an order number, an insert date).
6. **Say plainly what you did not do**, what is still open, and what you need. Never imply
   something is finished when it is not.
7. **Ask direct questions at the end**, as a list, each one answerable on its own.
8. **No AI tells. Never an em-dash.** Em-dashes are banned outright in anything a person receives.
   No exceptions, not as pauses, not as parentheses substitutes. Use a comma, a colon, or a full
   stop. Also avoid "I hope this helps," "happy to," "let me know," "in summary," "it's important
   to note," and any sentence that exists only to sound polite. The full tell list lives in the
   `unslop` skill; it always applies.
9. **Sound like a person, not a draft.** Jagged sentence rhythm (a short sentence next to a long
   one), no reflexive groups of three, no perfectly parallel clauses, real transitions that carry
   the actual logic ("the harder problem is") instead of "furthermore". One concrete noun or number
   humanizes more than any rewording.
10. **Own the uncertainty.** Hedge where hedging is honest ("that's fairly arbitrary," "a bit ugly,"
   "maybe a starting point"), be blunt where it is not.
11. **Match the language and register the project already uses.** Internal notes and code default to
    English; outgoing messages match whatever the recipient expects. Follow the existing convention
    rather than imposing one.

---

## Voice characteristics

- Direct, technical, peer-to-peer. Not deferential, not salesy.
- Short sentences next to long explanatory ones. Not uniform rhythm.
- Casual connectors ("i.e.", "re:", "e.g.", "basically", "also", "for that I'd need").
- Reasoning is shown, not asserted: "because X, Y doesn't work" rather than "Y is not possible."
- Comfortable stating a recommendation and why: "I'd lean clearly toward option 2."
- Mentions verification explicitly: "I checked," "measured live," "haven't actually run anything yet."

---

## Template

```
hi <name>,

<the conclusion / current state in one or two sentences, with the key number>

<context: what was found, in paragraphs. one paragraph per distinct point.>

<if there are multiple causes/findings, a numbered list — each item a full paragraph with the
concrete evidence and identifier>

<what was verified, and explicitly what was not done / not executed>

what I need from you:

- <question 1, answerable on its own>
- <question 2>

<optional: separate topic, e.g. a second question from the thread, clearly marked as out of scope>

<sign-off>
```

---

## Checklist before handing a draft over

- Would a colleague believe the user typed this? If it feels polished, it is wrong.
- Zero em-dashes? Search the draft for `—` and `–` literally; one slipping through outs the whole
  text as generated.
- Conclusion in the first two sentences?
- Every claim has a number or an identifier behind it?
- Is it clear what is done, what is open, what is blocked, and what is needed?
- Are the questions actually questions, each independently answerable?
- Formatting stripped down to paragraphs plus at most one or two plain lists?
- Any sentence that exists only to be polite — deleted?
- Register matched to the recipient, technical identifiers left in their real casing?
