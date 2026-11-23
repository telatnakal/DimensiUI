# DimensiUI — Audit Ronde 2 / Hardening

**Project:** DimensiUI  
**Version:** 1.1.1  
**Author / displayed credit:** telatnakal  
**Theme:** Dimensi only (obsidian-violet)  
**Audit type:** Static source review and hardening; runtime validation is outstanding.

## Scope

Reviewed the modular source, bundled build, addon managers, component lifecycle, callback paths, configuration handling, theme registry, animation ownership, input capture, and repository metadata. The project has no Fluent UI or Flipper imports/packages in this revision. Roblox built-in services and Roblox asset IDs remain in use.

## Changes in this release candidate

### API constructor regression fix (1.1.1)
- Fixed `Paragraph:New` and `Button:New` to accept the same `(Idx, Config)` arguments used by the central element dispatcher.
- Both constructors normalize the one-argument `AddParagraph({ ... })` / `AddButton({ ... })` form, while retaining compatibility with the legacy two-argument `AddParagraph("id", { ... })` / `AddButton("id", { ... })` form.
- Added a static regression assertion that every element constructor accepts `(Idx, Config)` and that Paragraph/Button retain one-argument config normalization.

### Architecture / dependencies
- Removed the legacy `src/Packages/Flipper` tree and all source/bundle references.
- Added `src/Packages/DimensiMotion`: internal signal, spring target, instant target, single motor, and group motor.
- Motion step uses bounded frame delta and short integration substeps; invalid goal output is guarded.
- Motion signals isolate listener errors; motors expose cleanup and are tracked.
- Window, notification, dropdown, and element-owned motors are tracked; owner destruction releases motor and its signal connections.
- Acrylic models are tracked by the library and destroyed on library teardown.

### Core / theme / lifecycle
- Theme updates use guarded property assignments and drop registry entries that fail updates.
- Theme-tag registry entries disconnect when instances are destroyed.
- `Creator.New` validates class/config container types.
- Theme/accent operations reject calls after library destruction.
- `Notify` returns nil after destruction.
- Destroy is idempotent; tracked connections, motors, acrylic models, GUI, and tab module state are cleared.
- Tab selection has a generation guard against stale asynchronous transitions.
- First tab is selected on creation; `Window:SelectTab` accepts an index or tab object.
- Dialog close is guarded against repeated calls and delayed cleanup checks parents.
- Notification close is idempotent; acrylic model and holder cleanup are guarded.

### Input / component contracts
- Added/strengthened config validation for Window, Tab, Section, Button, Toggle, Input, Slider, Dropdown, Colorpicker, Keybind, Paragraph, Dialog, and Notification.
- Slider accepts only finite values, validates range/default/rounding, clamps after rounding, and guards zero-width rail.
- Input validates string defaults, numeric mode, callback, placeholder, and max length; setter requires string.
- Dropdown validates option array, string options, duplicate entries, multi mode, and callback; `SetValues` prunes invalid selections; multi `SetValue` checks key/value types.
- Multi Dropdown initializes its state as a dictionary instead of indexing a nil/string default.
- Colorpicker validates Color3 defaults, HSV ranges, and transparency; setter clamps transparency.
- Keybind validates default and setter key names against `Enum.KeyCode` and supported mouse keys.
- Callback paths remain isolated through `SafeCallback` where the component already uses it.

### Acrylic
- Rebinds camera listeners when `Workspace.CurrentCamera` changes.
- Camera/property render paths guard missing camera/model and isolate render errors.
- Acrylic model and camera connections are tracked and released on teardown.

### Addons
- SaveManager folder/config names are bounded and reject traversal/control characters.
- Save serialization and file writes are protected; config payload is limited to 1 MiB.
- Load checks file size, JSON/top-level structure, object count/array shape, option IDs/types, and value shapes; parser calls are protected.
- InterfaceManager settings are size-limited, read/write/JSON operations guarded, and the stored theme is normalized to `Dimensi`; the theme selector is removed.
- InterfaceManager folder paths reject traversal and create nested folders.

### Build and docs
- `dist/main.lua` rebuilt from source modules.
- Repository/raw references use `telatnakal/DimensiUI`.
- README, Example, version metadata, and audit notes updated.
- Added `scripts/audit_static.py` for repeatable module/path/parity/branding/deterministic-build checks.

## Static validation performed

- 36 source module paths detected.
- 36 bundled module paths detected.
- No duplicate bundle module markers.
- Source/bundle module sets match.
- Source/bundle text parity check passes.
- Literal `require(script...)` paths resolve.
- No `Fluent`, `Flipper`, or old `eko-sulistyawan` references in source/addons/README/example/bundle.
- Build is deterministic across repeated runs.
- Delimiter and block-balance heuristic: 45 Lua/Luau files scanned, no balance issues.
- ZIP integrity checked after packaging.

## Not verified / release blockers

- Luau compilation was **not** run: no Luau compiler/analyzer is available in this environment.
- Roblox Studio/client runtime tests were **not** run.
- Visual QA (desktop, touch, scaling, text clipping) was not run.
- Motion timing, spring convergence, and all input edge cases still require runtime testing.
- Acrylic rendering remains graphics/camera dependent; validate on target executor/client.
- Config loading can apply valid entries before returning a partial-load error if other entries are invalid.
- Notification `Buttons` config is accepted but not implemented as interactive notification buttons; use Dialog for buttons.
- InterfaceManager cannot activate Acrylic if the window was created with Acrylic disabled; Acrylic is opt-in at window creation in the current API.
- Source provenance/licensing of all pre-existing UI modules and asset IDs is not fully established from the supplied archive. This release does not invent a license file. Verify the source/license inventory before public distribution and retain required notices.

## Manual regression matrix (required before tagging a public release)

1. Create/destroy windows repeatedly; check no render/input connections or acrylic parts remain.
2. Create tabs, rapidly select tabs, remove/destroy UI, and test initial tab selection.
3. Test Window drag, resize, minimize/restore, touch, and viewport changes.
4. Test all elements with valid/invalid configs and callbacks that intentionally error.
5. Slider: min/max, fractional ranges, rounding, narrow ranges, and non-finite input.
6. Dropdown: empty values, duplicates, single/multi, changing values, pruning after `SetValues`.
7. Keybind: keyboard, mouse buttons, focus in textbox, capture, and destroying while capturing.
8. Colorpicker: RGB/HSV, alpha endpoints, dialog close/cancel, and destruction during dialog.
9. Notification spam, duration 0, repeated close, library destroy during animation.
10. Acrylic: enable/disable, camera replacement, FOV/viewport changes, and teardown.
11. SaveManager: valid config, corrupt JSON, >1 MiB file, path traversal, unknown IDs, invalid enum, partial load, read/write failure.
12. InterfaceManager: malformed settings, invalid theme/key, path traversal, settings write failure.
13. Test low graphics quality and mobile/touch; check layout and performance.

## Release status

**Static hardened release candidate (1.1.1) — not runtime verified.** Do not label it production/runtime-tested until the compiler and Roblox regression matrix above pass.

## Findings fixed during the final hardening pass

- **High — motor orphaning on element/window destruction:** animation motors were tracked globally but were not tied to the owner instance. `Creator.TrackMotor(motor, owner)` now releases/destroys the motor when the owner is destroyed; global cleanup also destroys all motors.
- **High — acrylic model orphaning:** acrylic models were parented to Workspace and not centrally owned. They are now tracked and destroyed on library teardown; camera bindings rebind to replacement cameras and disconnect when the model is destroyed.
- **Medium — tab-selection race:** rapidly switching tabs could allow older delayed tasks to hide/show stale containers. Selection-generation guards now cancel stale transitions.
- **Medium — first tab remained unselected until clicked:** the first created tab is selected automatically.
- **Medium — dropdown default state:** multi-select dropdowns could index a nil/string value during initial rendering. Initial multi-select state is now a dictionary; config arrays are checked for holes and duplicate options.
- **Medium — save/load hardening:** SaveManager now validates folder/file names, limits JSON payloads, validates array structure and option shapes, and applies parser calls synchronously under `pcall`. Slider loading converts stored numeric strings before setting values.
- **Medium — InterfaceManager settings:** reads/writes and JSON are protected; payload size and field types are checked; invalid themes and key names are ignored; folder traversal is rejected.
- **Medium — repeated dialog/notification close:** close paths are idempotent and cleanup checks parent/model existence.
- **Low — API misuse:** config type validation and invalid calls after library destruction are rejected or safely return false/nil.

These fixes were statically checked and bundled. They are not a substitute for Roblox runtime testing.


## Dimensi-only responsive redesign pass

- Deleted `Amethyst.lua`, `Aqua.lua`, `Dark.lua`, `Darker.lua`, `Light.lua`, and `Rose.lua`; only `Dimensi.lua` remains as a theme definition.
- `src/Themes/init.lua` exports only `Dimensi`; `Library.Themes` is a fixed `{ "Dimensi" }` list and `SetTheme` rejects all other names.
- `InterfaceManager` no longer creates a theme dropdown and normalizes persisted theme settings to `Dimensi`.
- Reworked the palette toward a restrained obsidian-violet surface, soft 1px border colors, clear primary/secondary text, and a controlled violet accent.
- Updated typography and spacing across title bar, tab header, section, element, paragraph, input, dropdown, keybind, notification, and dialog components.
- Added viewport-aware initial window sizing, viewport-change fitting, drag/resize clamping, mobile tab width, responsive input/slider/dropdown widths, and mobile popup/dialog/notification constraints.
- Added owner-bound signal cleanup for dropdown global input handling, removed dropdown popup references on element destruction, and clear open-frame references on window/library teardown.
- Rebuilt the bundle using the source tree as the module inventory; static audit now checks the single-theme contract, responsive layout markers, source parity, and deterministic output.

**Validation status:** static audit and deterministic bundle parity pass. No Luau compiler or Roblox runtime is available here, so desktop/tablet/mobile rendering, touch behavior, and all lifecycle edge cases remain to be tested in Roblox Studio/client.
- Window viewport listener now rebinds when `Workspace.CurrentCamera` is replaced, and the previous camera's viewport connection is disconnected before the new one is observed.
