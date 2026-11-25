# DimensiUI — Audit Ronde 2 / Hardening

**Project:** DimensiUI  
**Version:** 1.2.15  
**Author / displayed credit:** telatnakal  
**Theme:** Dimensi only (obsidian-violet)  
**Audit type:** Static source review and hardening; runtime validation is outstanding.

## Current package note — v1.2.15

The release metadata is synchronized across `src/init.lua`, `README.md`, this audit, and the `dist/main.lua` banner. The build script derives the bundle banner version from the modular source, and the static audit checks that parity. v1.2.15 hardens addon library binding and filesystem error handling. This is static validation, not Roblox runtime certification.

## Scope

Reviewed the modular source, bundled build, addon managers, component lifecycle, callback paths, configuration handling, theme registry, animation ownership, input capture, and repository metadata. The project has no Fluent UI or Flipper imports/packages in this revision. Roblox built-in services and Roblox asset IDs remain in use.

## Changes in v1.2.15

- SaveManager now protects file-existence checks for config and autoload files, validates ignore-index input and the assigned Library instance, reports autoload write failures, validates all config entries before applying any values, rejects duplicate option IDs, and rolls back already-applied values if a setter fails.
- InterfaceManager now validates the assigned Library instance and reports folder initialization failures to its caller.
- Notification button support is implemented and statically validated; the previous audit note that described it as unimplemented was stale.
- Rebuilt `dist/main.lua` from modular source and expanded static checks for the addon contracts. Runtime/device verification remains pending.

## Changes in prior releases

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

- 37 source module paths detected.
- 37 bundled module paths detected.
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
- SaveManager validates the complete config before applying values and attempts rollback if a setter fails; rollback itself is best-effort because Roblox callbacks and external side effects cannot be transactionally reversed.
- Notification buttons are implemented with validated titles/callbacks and owner-bound click connections; verify layout and callback behavior in Roblox runtime.
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

**Static hardened release candidate (1.2.15) — not runtime verified.** Do not label it production/runtime-tested until the compiler and Roblox regression matrix above pass.

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


## Audit Ronde 3 — 1.1.2 typography and palette pass

- Added `src/Typography.lua` as the shared font resolver. It attempts Builder Sans first, then Gotham SSm, then Source Sans Pro, with a final Roblox enum fallback.
- Replaced direct Gotham font construction in component modules with shared weighted typography tokens.
- Applied the shared regular font face to default TextLabel, TextButton, and TextBox creation.
- Updated the Dimensi theme to the obsidian palette (`#111318` background, `#191D24` surface, `#222833` elevated surface) with restrained violet accent (`#A855F7`) and higher-contrast text.
- Rebuilt the 37-module standalone bundle and added typography assertions to the static audit.

### Ronde 3 validation
- Static audit: PASS.
- Source/bundle module parity: 37/37.
- Deterministic build: PASS.
- ZIP integrity: to be checked after packaging.
- Luau compiler and Roblox Studio/client runtime: NOT RUN.

### Outstanding architectural blocker
The current code still exposes a singleton Library from `src/init.lua`; `Creator` registries/motors and `TabModule` state are module-level shared tables. `CreateWindow` also rejects a second window. Therefore the agreed independent Multi Instance architecture is NOT implemented in this archive. Converting this safely requires an instance-context refactor across Creator, Window, Tab, elements, Dialog, Notification, Acrylic, and addons while preserving public API compatibility. Do not represent 1.1.2 as completing all 41 planned refactor scopes.


## Multi Instance implementation update (1.2.0)

The library now exposes `Library:NewInstance()`. It clones the root ModuleScript and requires that clone, which gives each library instance its own ModuleScript require cache. This scopes the stateful Creator, Tab, Notification, Acrylic, Elements, and Motion modules to the cloned root tree while preserving the existing API on the original library instance. The standalone bundle implements equivalent root-tree cloning and per-root module caches.

This implementation is statically integrated but is not yet certified by Roblox Studio runtime tests. Verify that root ModuleScript cloning is permitted in the target deployment environment, that cloned roots can be required from their parent, and that destroying one instance leaves other instances fully functional.


## Component event ownership update — 1.2.7

- Element-level event listeners in Button, Toggle, Input, Slider, Dropdown, Keybind, and Colorpicker now pass an owning GUI instance to `Creator.AddSignal` where the listener lifetime is bounded by a component or dialog.
- Dropdown option hover, press, and selection listeners are tied to each generated option button; popup/global input listeners are tied to the Dropdown frame.
- Keybind's temporary capture listener is tied to the Keybind frame, so destroying the component also disconnects capture input.
- Slider drag state is reset on explicit destruction.
- Static checks can verify source/bundle parity and owner arguments; Roblox runtime behavior still requires Studio/client testing.

## Component and Window event ownership update — 1.2.8

- Bound TitleBar hover/press/click signals to each title-bar button frame.
- Bound reusable element hover, component button hover, section layout, tab interaction/layout, and textbox focus/measurement signals to their owning GUI instances.
- Bound Window drag, resize, minimize-key, tab-layout, camera viewport, and canvas-position signals to the Window root.
- The temporary drag InputObject connection is now registered through `Creator.AddSignal` with the Window root as owner, so destroying the Window during an active drag disconnects it immediately.
- Every `Creator.AddSignal` call in the modular source now supplies an explicit owner instance. Long-lived Acrylic camera bindings remain explicitly disconnected when their tracked model is destroyed.

**Validation:** static audit, 37-module source/bundle parity, require-path checks, and deterministic build pass. No Luau compiler or Roblox Studio/client runtime is available here; runtime behavior remains unverified.



## Addon instance isolation update — 1.2.9

- `SaveManager.New()` / `SaveManager.NewInstance()` create independent manager objects with independent folder, ignore-index, parser, and Library/Options state.
- `InterfaceManager.New()` / `InterfaceManager.NewInstance()` create independent manager objects with independent folder and settings state.
- Existing module-level singleton exports remain available for backward compatibility.
- This isolates addon in-memory state; filesystem folder names are still shared if callers configure identical paths.
- Static source checks do not replace runtime tests with two libraries and two addon instances.

## Addon instance isolation correction — 1.2.10

- SaveManager parser load callbacks now receive the owning manager and apply values through that manager's `Options` table.
- SaveManager save/load iteration and configuration controls use the active manager instance rather than singleton-captured option references.
- InterfaceManager settings load/save and generated control callbacks use the active manager instance.
- The legacy singleton exports remain available, while `New()` and `NewInstance()` now have isolated settings and option bindings throughout the addon methods.
- Static audit verifies that addon factory internals do not retain singleton `Options` or `Settings` references.
- Static source/bundle parity and deterministic build passed. Luau compiler and Roblox Studio runtime checks remain outstanding.


## Addon factory regression correction — 1.2.11

- SaveManager previously declared `BuildFolderTree` using an unresolved global `self` and invoked the same unresolved value during factory initialization. The factory now binds both operations to its local `SaveManager` instance.
- InterfaceManager previously assigned `Settings` through an unresolved global `self` and declared `SaveSettings` on an unresolved global `Manager`. Both now bind to the local `InterfaceManager` instance.
- Added static regression assertions for these factory-local references.
- This fixes concrete source-level initialization defects; Roblox executor filesystem APIs and addon UI flows still require runtime validation.


## Audit update — 1.2.13

- Fixed a release-blocking Multi Instance mismatch: `NewInstance()` previously required an actual Roblox `ModuleScript`, while the standalone bundle supplies a synthetic Lua table node. The factory now recognizes both root forms.
- Added teardown for synthetic cloned module trees, including child maps and parent links.
- Added static assertions covering both modular and bundled root handling.
- Roblox runtime validation remains outstanding; static checks do not prove executor or Studio behavior.
