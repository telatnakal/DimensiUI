# Changelog

## [1.0.1]

### Changed
- `SetAccent` now also re-tints `Hover` and `DropdownOption`, so a custom accent no longer leaves violet leftovers.
- Scrollbars use the theme `SubText` colour; stray off-palette colour literals (grey, cyan, near-white) were aligned to the Midnight palette.
- Denser layout to reduce scrolling: row minimum height 44 → 38 px, row padding 7 → 5 px, gap between sections 16 → 12 px.

### Fixed
- Minimize bubble now docks at 75% of the screen height (from the top) with a 36 px left gap; the docking math was corrected so the value is a true screen fraction (previously it was pushed off-screen and clamped to the top edge).
- `SaveManager:Load` no longer rejects a whole config because of one bad entry: invalid, duplicate or unknown entries are skipped and reported; the config only fails when nothing valid remains.
- Dropdowns with an empty (`nil`) selection can now be saved and loaded.
- `SaveManager:Load` and `InterfaceManager:LoadSettings` no longer throw on unknown key names, and accept `MouseLeft` / `MouseRight`.
- Added the missing `CHANGELOG.md` referenced by the READMEs and `audit_static.py`.
