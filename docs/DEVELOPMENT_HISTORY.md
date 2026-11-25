# DimensiUI Development History

> Internal engineering history retained for traceability. The public package version in this archive is **1.0.1**.

## Previous development entries

## 1.2.15

- Hardened SaveManager config/autoload file checks and autoload writes with protected filesystem calls.
- Validated SaveManager ignore-index input and per-instance Library binding; InterfaceManager now validates its Library binding and reports folder setup errors.
- Made SaveManager config loading validate all entries before applying any values, reject duplicate option IDs, and roll back already-applied values if a setter fails.
- Confirmed Notification button configuration is implemented, validated, and owner-bound; corrected the stale audit note that described it as unimplemented.
- Rebuilt `dist/main.lua` from the 37 modular source files and extended deterministic static checks. Roblox/Luau runtime verification remains pending.

## 1.2.14

- Synchronized the library, README, audit metadata, and standalone bundle version.
- Updated the standalone bundle banner to identify the Dimensi theme instead of the obsolete Dark Purple theme label.
- Updated the bundle builder to derive its banner version from `src/init.lua`, preventing future source/bundle header drift.
- Added static release checks for version and bundle-banner parity. Roblox runtime verification remains pending.

## 1.2.13

- Validate the complete modular ModuleScript clone tree before creating a new library instance.
- Reject non-Archivable descendants with the exact offending instance path instead of silently producing an incomplete cloned module tree.
- Preserve the existing standalone bundle cloning path.
- Added static regression checks for clone-tree validation and rebuilt the standalone bundle. Roblox runtime verification remains pending.

## 1.2.12

- Fixed `NewInstance()` for the standalone bundle: the synthetic module-tree root is now accepted alongside Roblox ModuleScript roots.
- Added synthetic node-tree destruction so destroying a bundled child instance releases its cloned module tree and cache key.
- Kept the modular ModuleScript cloning path and its Archivable validation unchanged.
- Added static regression checks for modular and bundled instance-root handling.
- Rebuilt `dist/main.lua` from modular source. Roblox runtime verification remains pending.

## 1.2.11

- Fixed SaveManager factory initialization to define and invoke `BuildFolderTree` on its own manager instance instead of an undefined global `self`.
- Fixed InterfaceManager factory initialization to create `Settings` on its own instance and define `SaveSettings` on the correct manager table.
- Added static regression checks for factory-local method ownership and initialization.
- Rebuilt `dist/main.lua` from modular source. Roblox runtime verification remains pending.

## 1.2.10

- Corrected SaveManager factory isolation: parser load callbacks and config-section controls now use the owning manager's Options registry instead of the legacy singleton.
- Corrected InterfaceManager factory isolation: settings persistence, folder setup, and UI callbacks now consistently use the owning manager instance.
- Preserved the legacy singleton export and `New()` / `NewInstance()` factory APIs.
- Rebuilt the standalone bundle from modular source; Roblox runtime verification remains pending.

## 1.2.9

- Added `New()` and `NewInstance()` factories to SaveManager and InterfaceManager while preserving the existing singleton exports.
- Each addon instance now owns its own folder, settings, ignored option indexes, parser state, and Library/Options references.
- Kept addon method behavior and existing setup calls backward-compatible.
- Rebuilt the standalone bundle from modular source; Roblox runtime verification remains pending.

## 1.2.8

- Bound TitleBar, element hover, component button, section layout, tab interaction, and textbox focus/measurement signals to their owning GUI instances.
- Bound Window drag, resize, minimize-key, tab-layout, camera viewport, and canvas-position listeners to the Window root.
- Bound the temporary drag InputObject connection to the Window root so destroying a window during a drag releases it immediately.
- Extended static audit checks for owner-scoped component and Window listeners.
- Rebuilt the standalone bundle from modular source; Roblox runtime verification remains pending.

## 1.2.7

- Bound Dropdown popup positioning, open/close input, and per-option hover/selection listeners to their owning GUI instances.
- Bound Button, Toggle, Input, and Colorpicker input listeners to their owning component/dialog frames.
- Bound Keybind capture listeners to the Keybind component so external GUI destruction also releases active capture.
- Bound Slider drag state to its owner and clear the dragging flag during explicit destruction.
- Rebuilt the standalone bundle from modular source; runtime verification remains pending.

## 1.2.6

- Scope Slider and Keybind global input listeners to their owning component.
- Replace Colorpicker yielding drag loops with event-driven, owner-scoped input handling.
- Ensure Colorpicker drag listeners are disconnected when its dialog is destroyed.

# Changelog

## 1.1.0 — Hardened Release Candidate
- Replaced legacy animation package with DimensiMotion.
- Added motor/model ownership and cleanup.
- Hardened theme, tab, dialog, notification, and acrylic lifecycle.
- Strengthened component configuration and value validation.
- Hardened SaveManager and InterfaceManager persistence.
- Updated repository branding and raw URLs to telatnakal/DimensiUI.
- Rebuilt the bundled distribution and added static audit script.
- Runtime/compiler/visual validation remains pending.


## Dimensi single-theme redesign
- Removed every alternate theme module; `Dimensi` is now the only registered and accepted theme.
- Locked `Library.Themes`, `Library.Theme`, and InterfaceManager settings to `Dimensi`; removed the theme selector.
- Refined the obsidian-violet palette, GothamSSm typography, card spacing, and responsive control widths.
- Added viewport-aware window fitting, clamped drag/resize behavior, mobile tab sizing, and touch-friendly targets.
- Improved dropdown popup sizing/positioning and cleanup of open-frame references and owner-bound input connections.
- Rebuilt `dist/main.lua` from `src/` and extended static checks for single-theme/build parity.
- Roblox runtime and device visual validation is still required.

## 1.2.0

- Added `Library:NewInstance()` to create an isolated library instance from a cloned root ModuleScript.
- Isolated Creator, Tab, Notification, Acrylic, and element module state through per-root ModuleScript caches.
- Added per-root module caching and root-tree cloning to the standalone bundle runtime.
- Each cloned library instance owns its GUI and module lifecycle; destroying one instance does not reset another instance's module state.
- Runtime behavior still requires verification in Roblox Studio/client.


## 1.2.1

- Added `CreateInstance()` as an alias for the isolated `NewInstance()` factory.
- Added `AddCleanup(callback)` for instance-owned teardown callbacks.
- Added explicit Acrylic lifecycle cleanup and restoration of captured DepthOfField states during library destruction.
- Library destruction now clears option and open-frame registries after releasing owned resources.
- Rebuilt the standalone bundle from the modular source.


## 1.2.3

- Bound Acrylic blur component signals to their owning GUI instances so destroying a window or acrylic component releases its property listeners.
- Tracked Acrylic model destruction cleanup and explicitly disconnect camera bindings when an Acrylic model is removed.
- Bound notification close-button and dialog-button input connections to their owning GUI instances.
- Added notification-holder teardown cleanup so its Acrylic model is destroyed even when the holder is removed externally.
- Rebuilt the standalone bundle from modular source and extended static assertions for owner-bound cleanup.
- Roblox runtime behavior remains unverified.


## 1.2.4

- Replaced the single DialogOpen boolean transition with per-instance open-dialog reference counting.
- Closing one dialog no longer clears the modal state while another dialog in the same library instance remains open.
- External dialog destruction now releases its modal ownership and marks the dialog closed.
- Library teardown resets the dialog counter.
- Rebuilt the standalone bundle from modular source.
- Roblox runtime behavior remains unverified.


## 1.2.5

- Added instance-owned option registration helpers.
- Option teardown now removes a registry entry only when it still points to the exact option being destroyed, preventing an older component from deleting a newer component registered under the same ID.
- Preserved the existing replacement behavior for duplicate option IDs while making cleanup identity-safe.
- Extended static audit checks for option registration and teardown behavior.
- Rebuilt the standalone bundle from modular source.
- Roblox runtime behavior remains unverified.
