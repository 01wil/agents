# Web branch

HTML and CSS specifics for the `ui-design` workflow. Principles, states and the audit live in
`SKILL.md`; this file is how they land in a browser.

## Tokens

Put every DESIGN.md value in one place as custom properties, and theme by swapping them. If the
project already has a token mechanism (Tailwind config, a theme file, CSS modules), extend that
instead of adding a second one.

```css
:root {
  color-scheme: light dark;
  --font-sans: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", sans-serif;
  --font-mono: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  --space-1: 4px; --space-2: 8px; --space-3: 12px; --space-4: 16px;
  --space-6: 24px; --space-8: 32px; --space-12: 48px; --space-16: 64px;
  --radius-sm: 4px; --radius-md: 8px; --radius-lg: 12px;
  --dur-feedback: 120ms; --dur-state: 200ms; --dur-overlay: 320ms;
  --ease-out: cubic-bezier(0.16, 1, 0.3, 1);
  --canvas: #fff; --surface: #f6f7f8; --text: #16181d; --text-2: #565b66;
  --border: #dfe1e6; --accent: #1f5fd6; --on-accent: #fff; --focus: #1f5fd6;
}
@media (prefers-color-scheme: dark) {
  :root { --canvas: #111317; --surface: #1a1d22; --text: #eceef2; --text-2: #a3a8b3;
          --border: #2c3038; --accent: #6f9cff; --on-accent: #0b1020; --focus: #8fb2ff; }
}
```

The values above are placeholders showing the shape, not a palette to reuse: choose this product's
own. Name tokens by role (`--text-2`, `--danger`), never by value (`--blue-500` in components).
Type sizes in `rem` so user font settings and zoom work; `clamp()` only for display type on
persuade pages, fixed steps on product UI.

Fonts stay local. The system stack is the default; a brand face is used only when its files are
already in the repo (`@font-face` with a relative `url()`, `font-display: swap`, a metric-matched
fallback). No `<link>` to a font service, no `@import` from a CDN.

## Semantic HTML

- Native elements first: `<button>` for actions, `<a href>` for navigation, `<label>` tied to every
  input, `<dialog>` for modals, `<details>` for disclosure, `<select>` before a custom listbox,
  correct `type` and `inputmode` and `autocomplete` on inputs.
- Landmarks (`header`, `nav`, `main`, `footer`) and one `h1`, with heading levels never skipped.
- Icon-only buttons carry an `aria-label`; decorative SVG gets `aria-hidden="true"`; meaningful
  images get real `alt`.
- Status changes that matter (saved, error count, items in a list) are announced with a polite live
  region; errors use `role="alert"` sparingly.
- A skip link to `main` on pages with a header.

## Focus and interaction

- `:focus-visible` ring from the `--focus` token, at least 2px, offset from the edge, 3:1 against
  its surroundings. Removing an outline always comes with its replacement.
- Sticky headers and toasts do not cover the focused element (`scroll-padding-top`).
- Hover is an enhancement: every hover reveal also works on focus and on touch. Hovered elements
  stay put; let a child carry any movement so the target does not slide out from under the pointer.
- Theme the surfaces the browser draws: `accent-color` for native controls, `::selection`,
  `caret-color`, `scrollbar-color`, `text-underline-offset`.

## Layout and responsive

- Mobile-first; breakpoints where the content breaks, not at device names. Check 320, 390, 768,
  1024 and 1440 wide. No horizontal page scroll at 320.
- `gap` for sibling rhythm; logical properties (`margin-inline`, `padding-block`) so RTL works.
- Text containers capped at 65–75ch. Long tokens wrap (`overflow-wrap: anywhere`); flex and grid
  children that hold text get `min-width: 0`.
- `text-wrap: balance` on headings, `text-wrap: pretty` on body copy.
- Reserve space for images and async content (width/height or `aspect-ratio`) so nothing jumps.
- Viewport meta `width=device-width, initial-scale=1`; never disable zoom. `dvh` instead of `vh`
  for full-height mobile layouts.
- Keep selector specificity flat (one class per rule where possible) so section and component rules
  do not silently cancel each other's spacing.

## Motion

- Animate `transform` and `opacity`; leave `width`, `height`, `top`, `left` and margins alone.
- Durations and easing from the tokens. Content is visible in its default state, so a failed script
  never hides the page.
- Reduced motion keeps state changes legible rather than killing everything:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 1ms; animation-iteration-count: 1;
    transition-property: opacity, color, background-color, border-color; scroll-behavior: auto; }
}
```

## Forms

Visible labels above or beside the field (never placeholder-only). Validate on blur, report empty
required fields on submit, clear the error as soon as it is fixed. Errors sit under their field,
linked with `aria-describedby`; a long form also gets a focused error summary. The submit button
stays enabled until a request is in flight, then shows progress. Input survives a failed submit.
Paste is never blocked. Ask before discarding unsaved changes.

## Rendering for step 4

Serve the page locally and use the browser or preview tooling the harness already provides, or a
headless browser the project already depends on. Capture each target width in both colour schemes,
emulate `prefers-reduced-motion`, zoom to 200%, and tab through once. Read the console: a script
error can leave content invisible while the screenshot still looks plausible.
