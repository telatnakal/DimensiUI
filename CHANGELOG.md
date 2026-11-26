# Changelog

All notable changes to DimensiUI are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.1] - 2026-11-26

Release-preparation pass focused on quality, consistency and stability. No features were removed.

### Changed
- **Minimize bubble:** the DimensiUI logo is now docked at the leftmost screen edge, with its center at 25% of
  the screen height (from the top), every time the window is minimized (previously it appeared wherever the
  window was). The position is a fraction of the screen, so it is consistent across resolutions.
- The bubble is drawn above all other interface elements (`ZIndex = 100`) and is re-clamped when the
  viewport size changes, so it always stays visible and reachable.
- The bubble position accounts for the ScreenGui top inset, so the 25% is measured on the full screen
  rather than on the inset-reduced GUI area.
- Version metadata is unified at `1.0.1` across `src/init.lua`, the bundle banner, both READMEs and this changelog.
  The version string previously read `1.1.2`; every reference now reads `1.0.1`.
- `README.md` rewritten (modern layout, option tables, component reference) and a Bahasa Indonesia
  edition added as `README.id.md`.
- `DimensiUI:ResetAccent()` now returns `true` on success, matching `SetAccent`.

### Added
- Smooth bubble animations: slide-and-pop entrance, hover grow, press feedback and a fade-out on restore.
  A token guards the animation so rapid minimize / restore / hide-key presses cannot leave the bubble in a
  wrong state.
- `scripts/build_icon.py` regenerates `src/BubbleIcon.lua` from `Assets/d-icon-bubble.png` (with `--check`).
- Static audit now verifies version consistency, the embedded logo and the minimize bubble contract.
- `CHANGELOG.md` and `.gitignore`.

### Fixed
- `src/BubbleIcon.lua` header referenced a non-existent `Assets/d-icon.png`; it now points to
  `Assets/d-icon-bubble.png`.
- `scripts/audit_static.py` now invokes the bundle builder with the current interpreter instead of a
  hard-coded `python`.

### Removed
- Unused locals and requires (`Mouse`, `Camera`, `Lighting`, `UserInputService`, `TweenService`, `Motion`,
  `Players`/`LocalPlayer`) in `init.lua`, `Window`, `Dialog`, `Textbox`, `TitleBar`, `Paragraph` and
  `Colorpicker`. These had no effect on behavior.
