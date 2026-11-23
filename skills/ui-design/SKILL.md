---
name: ui-design
description: Make user interface look deliberate rather than generated. Use when building or restyling a screen, page, component, settings window or menu bar UI; when a UI looks generic, cluttered or "AI-made"; when asked for a named pass (quieter, distill, typeset, layout, harden, onboard, polish, critique, audit); or when creating or updating a DESIGN.md.
---

# UI Design

Generated UI fails the same way every time: it reaches for the category default instead of a
choice. This skill replaces defaults with decisions, writes the decisions down once, and checks the
rendered pixels against them. Lazy about decoration, never about states or accessibility.

Out of scope: diagrams and charts produced as files belong to the `diagram-design` skill; the page
contract for a claude.ai Artifact belongs to the harness's artifact skills. Prose inside the UI
follows the copy rules below; longer prose a person reads goes through `unslop`.

Platform detail lives in two references. Read the one that matches the stack before step 3:

- `references/web.md` — HTML/CSS: tokens as custom properties, semantic HTML, responsive, forms.
- `references/swiftui.md` — SwiftUI code rules and the macOS HIG: settings windows, menu bar
  extras, windows, permissions and onboarding.

## Local by default

Everything the UI loads comes from the machine or the repo: the platform's system font stack or a
font file already committed to the project, platform icons (SF Symbols) or inline SVG, images in
the repo. The UI makes no network request the project did not already make. A new font, script,
analytics call, CDN or remote image is a dependency decision for the user, so ask first. Tools for
rendering and checking are whatever the project or harness already has; this skill installs
nothing.

## Workflow

Run the steps in order. Each ends on a condition you can check; do not move on until it holds. For
a one-line tweak, steps 1–2 shrink to a sentence, but step 4 still happens.

1. **Understand.** Read the existing UI code, components, tokens and any DESIGN.md, PRODUCT.md or
   style guide before inventing anything. Establish who uses this surface, where and how often,
   the one job it does, and its mode: operate (a tool, settings, dashboard: precision and
   restraint win), read (docs: measure and structure win) or persuade (a landing page: one bold
   idea earns its place). The user's brief wins over this skill whenever they conflict.
   Done when you can state in three lines: the audience, the primary action of each view, and
   which existing system governs the work (or that none exists).

2. **Plan the tokens.** Update the project's DESIGN.md, or create one when there is none and the
   work spans more than one view. Use the template below. Then review the plan against the brief:
   any line you would have written for an unrelated product is a default, so change it and say
   why. In an existing system, extend it; do not start a parallel one.
   Done when every colour, size, space, radius and duration the build will use is named in the plan
   with a role, and the do/don't list names this product's own temptations.

3. **Build against the tokens.** Components reference tokens, never literal values. Reach for the
   native element or system control before building one (`ponytail`). Design every state in the
   States list as you go, not after.
   Done when a search for raw colours, pixel sizes and padding literals outside the token source
   finds none you cannot justify, and each view has every state that applies to it.

4. **Render and critique.** Look at real pixels: the browser or preview tooling the harness has,
   Xcode previews, the simulator, or a window screenshot. Capture each view at its representative
   sizes, in light and dark, plus one stress case (long text, empty data, largest text size). Run
   the squint test: blurred, can you still name the primary element, the secondary one and the
   groups, in order? Compare against the plan and the Defaults list.
   Done when every view has been seen in each theme and a written findings list exists, even if it
   is empty. If nothing can be rendered, say so plainly, critique the source instead, and mark the
   visual check as not done rather than passed.

5. **Fix.** Work in severity order: broken or inaccessible paths, then missing states, then
   hierarchy and layout, then visual consistency, then cleanup. Re-render after each batch. Then
   remove one thing: the least necessary element, border, colour or animation on each view.
   Done when every finding is fixed or waived with a stated reason, and the fixes have been seen
   rendered.

6. **Final audit.** Go through the Audit checklist and record pass or fail with the evidence for
   each line (a measured ratio, a screenshot, a key press, a search result).
   Done when every line has a verdict; a fail you are leaving is named in the report.

Report: what changed, the DESIGN.md decisions, the audit table, what you could not check and why.

## DESIGN.md template

Keep it to a page. It is the single source of truth for how the product looks; code tokens mirror
it, and a new value goes here first.

```markdown
# Design
Product: one line. Audience and setting: one line. Mode: operate | read | persuade.
Character: three words, and the one place boldness is spent.

## Colour (by role, light / dark)
canvas, surface, surface-raised, text, text-secondary, border, accent, accent-text,
focus, success, warning, danger — each a value per theme, with what it is for.

## Type
family (system stack or bundled file), scale by role: display, title, heading, body, label,
caption — size / line height / weight. Numerals: tabular where figures align.

## Space and shape
spacing scale (e.g. 4 8 12 16 24 32 48 64), content max width, radii (small, medium, large:
which elements get each), elevation levels and when each is used.

## Motion
durations (feedback, state change, overlay), easing, what animates and what never does,
reduced-motion behaviour.

## Do / Don't
5–10 lines specific to this product.
```

## Principles

Restraint. One element per view carries the emphasis: one primary action, one accent use that
matters. Spend boldness in one place and keep everything around it quiet. Every border, divider,
label, number and container must encode information; if it only decorates, remove it. On native
platforms restraint means staying system-native, with brand living in tint, content and a few
precise details.

Hierarchy. Importance is carried by size, weight, space and position before colour. Adjacent roles
must differ clearly; if two sizes are hard to tell apart, merge them. The reading order on screen
matches the order in the markup or view tree, and the keyboard follows the same path.

Spacing rhythm. One scale, used with intent: tight inside a group, generous between groups, more
space above a heading than below it. Proximity groups things before any container does. The same
gap everywhere is monotony, not consistency.

Typography. One family, normally the platform's system face. Three to five sizes, adjacent steps at
least 1.25× apart, two or three weights. Body text at the platform's comfortable size (web 16px,
macOS 13pt, iOS 17pt), line height around 1.4–1.6, measure 45–75 characters. Sentence case for
labels and headings. Tabular numerals wherever figures line up.

Colour by role. Neutrals do most of the work; one accent marks interactivity, selection and focus,
and nothing else. Semantic colours (success, warning, danger) appear only for status, always with
an icon or words beside them. One colour never carries two meanings. Text on a coloured surface is
a shade of that hue or near-white, never mid-grey. Dark mode is designed, not inverted, and both
themes are checked. Contrast targets are in the audit.

Motion with purpose. Motion acknowledges an action, explains a state change, or preserves
continuity; anything else is removed. Durations: about 100–150 ms for feedback, 150–300 ms for a
state change, 300–500 ms for an overlay or layout change; exits faster than entrances. Ease out
(decelerate) on arrival. Frequent actions get little or no animation. Animations are
interruptible, never the only signal, and under reduced motion become a fade or nothing.

All states designed. For each view decide what applies and build it:

- default, hover, focus, pressed, selected, disabled (visibly inert, and say why where useful);
- loading: show structure immediately, keep the layout stable, keep the rest usable;
- empty: first use (what goes here, why, one action to start), cleared by the user (light touch),
  no results (say so, offer a way out);
- error: what happened, how to fix it, input preserved, retry where it makes sense;
- success: brief confirmation using the action's own verb;
- first run and permission needed or denied;
- overflow: very long and very short text, huge numbers, hundreds of items, a translation 40%
  longer, the largest text size, the narrowest window.

Copy is design. Name things by the user's concept, not the system's. Buttons say what happens, as
a verb and an object ("Save changes", not "Submit"), and the name holds through the flow ("Publish"
leads to "Published"). Errors state the problem and the fix, without apology or vagueness.
Placeholder content is realistic but invents no facts: no fabricated reviews, customers, metrics or
claims.

## Defaults to replace

Each line is the target, with the generated default it replaces in brackets so you can spot it in
review. A brief that explicitly asks for one of these looks gets it.

Structure

- Structure from space and type; a card only for a genuinely separate, movable object, never a card
  inside a card. (Everything chopped into identical rounded cards with the same soft shadow.)
- Headings that carry their own weight. (A tiny tracked all-caps eyebrow or pill chip above every
  heading.)
- Numbers only on real sequences. (01 / 02 / 03 on sections that are not steps.)
- An icon beside its label, in flow, at text size. (A rounded icon tile stacked above every
  heading.)
- Figures in the sentence they prove, and only real ones. (The hero metric: big number, small
  label, a strip of three stats.)
- Sections shaped by what the reader needs to know. (Eyebrow, headline, lede, three cards, repeated
  every section.)
- Inline editing or a popover when the task does not need to block everything. (A modal by reflex.)
- Spacing that varies with relationship. (One gap value everywhere.)

Surfaces and colour

- Flat surfaces and neutral elevation with a real offset and soft blur, used only to show layering.
  (Glows, coloured halos, radial spotlight washes, decorative glass and blur.)
- A palette chosen for this product and its use setting, light or dark decided by where it is used.
  (Purple-to-blue gradients, cyan or acid green on near-black, the warm cream page with a
  terracotta accent.)
- Emphasis from weight or size, in solid colour. (Gradient text; one word in a headline in a
  different colour or italic.)
- A full border, a tint, or a leading icon to mark a state. (A coloured bar down one side of a
  rounded box.)
- One radius scale applied by element size and role. (The same radius on everything, or pill and
  sharp mixed at random.)
- Plain surfaces; texture only when it carries meaning. (Grid-line backgrounds, repeating stripes,
  hairline border plus wide shadow on every card.)

Type and icons

- The platform's system face set with a clear scale. (Whatever font was trending, or a display
  serif in italic as the hero.)
- Labels in sentence case at a readable size. (All-caps labels, wide-tracked body, monospace as a
  "technical" costume.)
- One icon family in one style and weight, from the platform or the project. (Emoji or Unicode
  glyphs standing in for icons; filled and outline mixed at one level.)
- Arrows only where something moves you somewhere. (A → appended to every link and button.)

Motion

- One authored moment at most, plus feedback on user action. (Fade-and-slide-up on every section,
  hover lift on every card, staggered scroll reveals.)
- Smooth deceleration. (Bounce and elastic easing.)
- Liveness indicators only on live data. (Pulsing dots, blinking cursors, marquees as decoration.)

Copy

- Plain, specific nouns and verbs. (Seamless, powerful, effortless, unlock, elevate, supercharge,
  next-generation, world-class.)
- Each sentence ends on information. (Aphoristic closers, "Not X. Just Y.", "X. Y." two-fragment
  headings, contrast frames.)
- Middle dots, em dashes and arrows at the density a careful human uses. (Meta strings joined
  with " · ", em dashes in every line.)
- The interface never talks about itself. ("Below you'll find", "This section shows".)

## Named passes

The user, or you, can ask for one of these by name. Each runs steps 4–6 of the workflow, scoped to
its concern, inside the existing visual world. None of them redesigns unless asked; if the concept
itself is wrong, say so instead.

- **quieter** — lower the intensity: fewer colours, lighter weights, flatter surfaces, less motion,
  more space. Keep one anchor; quiet is not grey and flat everywhere.
- **bolder** — the opposite, for a bland surface: strengthen the one focal element and the scale
  contrast, leave the rest alone.
- **distill** — remove what does not earn its place: redundant copy, duplicate actions, decorative
  containers, rarely used options (move them behind disclosure). One primary action per view.
- **layout** — fix reading order, grouping and rhythm: squint test, proximity before containers,
  spacing from the scale, alignment to one grid.
- **typeset** — fix the type system: roles, scale steps, weights, measure, line height, wrapping,
  numerals; cut extra families and one-off sizes.
- **colour** — assign colour by role: neutral base, one accent, semantic colours with non-colour
  cues, both themes and increased contrast checked.
- **animate** — add motion only where it explains a change or acknowledges an action; set
  durations from the tokens; verify reduced motion.
- **clarify** — rewrite labels, buttons, empty states and errors to the copy rules.
- **harden** — stress every view with the overflow, error, offline, permission and concurrency
  cases from the States list and fix what breaks.
- **onboard** — design first run and empty states: get to the first real success fast, teach by
  doing, skippable, never shown twice, findable later; ask for permissions in context.
- **adapt** — make the layout survive every supported size, input method and text size without
  losing a feature.
- **critique** — review only, no edits: what works, the top three to five problems ranked by impact
  on the user, the defaults spotted, and which pass fixes each.
- **audit** — review only: run the Audit checklist and report each line as pass or fail with
  evidence and severity (P0 blocks a task, P1 fails accessibility or a major flow, P2 annoys, P3
  polish).
- **polish** — the final pass before shipping: fix drift from DESIGN.md, finish every state on the
  whole path, align, tidy copy and code, then re-audit.

## Audit checklist

- Contrast: body text at least 4.5:1, large text (about 18pt, or 14pt bold) and meaningful icons,
  control borders and focus indicators at least 3:1, in every theme and state.
- Focus: every interactive element shows a visible focus indicator that nothing covers.
- Keyboard: every action works without a pointer, in an order that matches the visual one; escape
  closes overlays; no traps.
- Hit targets: web at least 24×24 CSS px (44 for touch-first UI); iOS 44×44pt; macOS controls at
  their system sizes (28pt default, 20pt minimum).
- Text scaling: usable at 200% browser zoom or the largest Dynamic Type size; nothing clipped or
  overlapping.
- Not colour alone: every status, error and selection also has a shape, icon or words.
- Names: every control and meaningful image has an accessible name; decorative images are hidden.
- Reduced motion: honoured, with state changes still visible.
- States: every applicable state from the list exists and was seen rendered.
- Tokens: no literal values outside the token source; DESIGN.md matches the code.
- Defaults: nothing from the Defaults list survived without the brief asking for it.
- Local: no new fonts, scripts, analytics or remote assets.
