# Changelog

All notable changes included in the public DimensiUI package are documented here.

## [1.0.1] — Stable Release

- Published the complete modular DimensiUI source tree and standalone bundle.
- Set synchronized package metadata and bundle banner to version `1.0.1`.
- Included the Dimensi theme, shared typography resolver, responsive layout work, and instance factory APIs present in this source snapshot.
- Hardened SaveManager validation and persistence error handling.
- Hardened InterfaceManager library binding and folder setup error reporting.
- Added validated, owner-bound Notification button callbacks.
- Rebuilt `dist/main.lua` from `src/` and verified source/bundle parity with the static audit.
- Added repository build instructions and retained prior engineering notes in `docs/DEVELOPMENT_HISTORY.md`.

### Verification note

Static checks pass for this package. Luau compilation and Roblox Studio/client runtime, device, and visual regression tests have not been performed in this build environment.
