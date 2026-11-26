# Changelog

## [1.0.1]

### Fixed
- Minimize bubble now docks at 75% of the screen height (from the top) with a 36 px left gap; the docking math was corrected so the value is a true screen fraction (previously it was pushed off-screen and clamped to the top edge).
- `SaveManager:Load` no longer rejects a whole config because of one bad entry: invalid, duplicate or unknown entries are skipped and reported; the config only fails when nothing valid remains.
- Dropdowns with an empty (`nil`) selection can now be saved and loaded.
- `SaveManager:Load` and `InterfaceManager:LoadSettings` no longer throw on unknown key names, and accept `MouseLeft` / `MouseRight`.
- Added the missing `CHANGELOG.md` referenced by the READMEs and `audit_static.py`.
