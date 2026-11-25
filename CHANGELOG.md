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
