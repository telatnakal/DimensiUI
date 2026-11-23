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
