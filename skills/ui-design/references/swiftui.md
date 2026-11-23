# SwiftUI and macOS branch

SwiftUI code rules and Apple platform conventions for the `ui-design` workflow. Principles, states
and the audit live in `SKILL.md`. On Apple platforms the default target is "a fluent user would
trust it": system controls, system type, system colours, with the product's character in tint,
content and a few precise details. Check the deployment target before using newer APIs.

## Tokens in code

- One shared `enum Design` (or the project's existing equivalent) holds spacing, radii, icon sizes,
  animation durations and any custom colours or fonts. Views read from it; a search for numeric
  `padding(`, `spacing:` and `cornerRadius` literals in views finds nothing outside it.
- Prefer the system default over a token where one exists: default stack spacing and padding, form
  row insets, control sizes. Hard-coded padding is a choice to justify, not a habit.
- Colours: system semantic colours and hierarchical styles (`.primary`, `.secondary`, `.tertiary`,
  `.tint`) over manual opacity; custom colours as asset-catalog colours with light, dark and
  high-contrast variants. SwiftUI `Color`, not `UIColor`/`NSColor`, in views. App-wide accent set in
  the asset catalog's accent colour, applied with `tint()`.
- Type: system text styles (`.body`, `.headline`, `.title2`...) rather than fixed sizes; a custom
  size goes through `@ScaledMetric` or a scaled text style. `bold()` rather than
  `fontWeight(.bold)`; other weights only with a reason. Avoid `.caption2`, and use `.caption`
  sparingly.

## Views and controls

- `Button("Add Item", systemImage: "plus", action: add)`: every button has a text label even when
  shown icon-only (`.labelStyle(.iconOnly)`), so VoiceOver and Voice Control can name it. Same for
  `Menu("Options", systemImage: ...)`.
- `Button` for anything tappable; `onTapGesture` only when tap location or count matters, and then
  with `.accessibilityAddTraits(.isButton)`.
- `Label` for icon plus text, not an `HStack`. SF Symbols for icons, in one rendering style per
  level.
- `Form` (grouped style on macOS settings) with `LabeledContent` around controls such as sliders so
  title and control align; `LabeledContent` also for read-only title/value rows.
- `ContentUnavailableView` for empty and missing data; `ContentUnavailableView.search` for empty
  search results (it shows the query itself).
- `ProgressView` while loading, never a blank view. Determinate when the duration is known.
- `TextField(axis: .vertical)` over `TextEditor` unless full-screen editing is needed.
- Flexible frames; `ViewThatFits` to fall back from a horizontal arrangement to a vertical one;
  `containerRelativeFrame` before `GeometryReader`. Layout must survive longer translations, larger
  text and narrower windows without dropping a feature.
- System presentations: `sheet(item:)` for an optional value, `confirmationDialog` attached to its
  trigger, `alert` with no bare OK button, `inspector` for a side panel. A destructive button gets
  `role: .destructive`; button titles are verbs.
- `clipShape(.rect(cornerRadius:))`, `foregroundStyle()`, `.scrollIndicators(.hidden)`; build
  `Text` by interpolation, never by `+` concatenation, so it stays localisable.
- Images: `Image(decorative:)` or `accessibilityHidden()` when decorative, `accessibilityLabel` when
  meaningful.

## Motion and accessibility in code

- `.animation(.smooth, value: state)` always with a value; chain with `withAnimation { } completion:
  { }`, never delays. Durations from the `Design` enum. Prefer system transitions.
- When `@Environment(\.accessibilityReduceMotion)` is true, swap movement and scaling for opacity.
- When `accessibilityDifferentiateWithoutColor` is true, add a shape, icon or stroke to anything
  colour distinguishes.
- Respect system accessibility settings; never re-implement them as in-app options.
- Busy labels that change (a live price, a counter) get `accessibilityInputLabels` for Voice
  Control.

## Rendering for step 4

`#Preview` per state: default, empty, loading, error, long content, dark, largest text size. Render
them with Xcode previews (or the Xcode MCP's preview rendering when it is configured), run the app
and capture the window with the system `screencapture`, or use the harness's simulator tooling for
iOS. Check light, dark and Increase Contrast.

## macOS conventions

Designing for the Mac: large displays, a pointer and a keyboard, many apps side by side. Show more
with fewer nested levels and less modality, keep density comfortable, put every command in the menu
bar with a keyboard shortcut, make the whole app keyboard-operable, let windows resize, and restore
window size, position and selection on relaunch.

Type and size. The system face is SF Pro; body is 13pt, headline 13pt bold, title 3 15pt, title 1
22pt, large title 26pt, callout 12pt, subheadline 11pt, footnote and captions 10pt (the floor).
macOS has no Dynamic Type, so text styles keep the Mac's sizes; do not scale them up to iOS sizes.
Controls default to 28pt high, never below 20pt.

Windows. System window chrome only; custom chrome that almost matches feels broken. Windows look
right in key, main and inactive states (system components handle this; custom ones must too).
Nothing critical in a bottom bar, which often sits off-screen. Sidebars collapse when the window
narrows. Open a new window only to preserve context; offer "Open in New Window" rather than forcing
it. User-facing text says "window", never "scene".

Menu bar. Standard menus in standard order (App, File, Edit, Format, View, custom, Window, Help);
rename or drop File and Format when they do not apply. Items stay put and are disabled, never
hidden, when unavailable. Show/hide items name the action they will take ("Hide Sidebar").

Settings window. A SwiftUI `Settings` scene, opened from the App menu's Settings… item and
Command-Comma, never from a toolbar button.

- A toolbar of panes, always visible and not customisable, that marks the active pane. Few panes,
  with plain noun names; the window title is the pane name, or "AppName Settings" with one pane.
- Reopens on the last pane. Minimise and zoom disabled; each pane sizes to its content and fits
  without scrolling at its default size, or something belongs in an Advanced pane.
- One row, one setting: a title, an optional single line of secondary text, the control trailing.
  Group related rows in form sections; separate groups with space, not extra containers.
- Controls: a switch for an emphasised setting or one governing a group; a checkbox for a single
  on/off and for parent/child settings (show the mixed state); radio buttons for two to five
  exclusive choices; a pop-up button beyond five.
- Great defaults so most people never open it. Options that filter, order or show/hide something
  live next to that thing, not here. System-wide settings (accessibility, scrolling, appearance)
  are never duplicated; link to the System Settings pane instead. Rare destructive actions
  ("Restore Defaults…") sit at the edge of the flow.

Menu bar extras. A template image (SF Symbol or black-and-clear custom glyph) sized for the 24pt
menu bar so the system tints it. A click opens a menu, not a popover, unless the function genuinely
needs one. Keep the menu short: state, the main toggle, Settings…, Quit. The user decides whether
the extra is shown (a setting, offered during setup); the system can hide it at any time, so every
function is also reachable from the app itself (reopening the app, the Dock menu, the main window
or settings).

Permissions. Ask when the feature that needs access is first used. Only when the app cannot work at
all without it does the request belong in onboarding, with the reason explained. Purpose strings
are one specific sentence, active voice, sentence case, ending with a period ("The app listens for
your wake word to start dictation.", not "Microphone access is needed for a better experience.").
A pre-alert screen has exactly one button, "Continue" or "Next", never "Allow", and no way to skip
the system prompt. Accessibility, Input Monitoring and Screen Recording are granted in System
Settings rather than by an alert, so the same rules apply to the explanatory screen: one sentence of
why, one button that opens the right pane, and live granted/not-granted status that updates without
a relaunch.

Onboarding. After launch, short and optional. Teach by letting the person do the real task once,
about this app and never about macOS. Prefer a tip in context over an upfront tour. Defer
non-essential setup behind sensible defaults. Once dismissed it never returns on its own, but stays
findable in Help or Settings. No ratings or purchase prompts before the person has used the app.

Alerts. Reserve the caution symbol for real risk of loss. Title says what happened or what is
about to; buttons are verbs, with the destructive one marked; no alert for something an undo could
handle.

Colour and materials. Prefer system colours, which already have dark and increased-contrast
variants; respect the user's chosen accent colour. Custom tinted backgrounds stay neutral so
desktop tinting does not clash. Materials and vibrancy only where the system uses them (sidebars,
popovers, HUD panels), never as decoration.

Motion. System components animate themselves; custom motion is brief feedback that follows the
gesture's direction, cancellable, absent from frequent actions, and replaced by a fade under Reduce
Motion.

## iOS differences

Tap targets 44×44pt; Dynamic Type up to accessibility sizes (test with `dynamicTypeSize`); lay out
inside the safe area without guessed insets; a tab bar for two to five top-level sections and a
navigation stack for hierarchy; leave the edge-swipe back gesture alone; base layout on size
classes, never on device idiom; every feature survives every window size.
