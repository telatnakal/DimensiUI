# Building DimensiUI

This repository keeps `src/` as the source of truth. The single-file distribution at `dist/main.lua` is generated and must not be edited manually.

## Requirements

- Python 3.9 or newer
- No third-party Python packages are required for the bundle and static audit scripts
- Optional: [Rojo](https://rojo.space/) for building/synchronizing the Roblox project from `default.project.json`

## Rebuild the standalone bundle

Run these commands from the repository root:

```bash
python scripts/build_bundle.py
python scripts/audit_static.py
```

The build script reads every Lua module under `src/` and writes `dist/main.lua`. The audit checks module references, source/bundle parity, the single-theme contract, typography and responsive markers, selected lifecycle/API invariants, and deterministic output.

## Optional: build a Roblox model with Rojo

```bash
rojo build default.project.json -o DimensiUI.rbxm
```

Open the generated model in Roblox Studio and verify the resulting ModuleScript hierarchy before use.

## Release checklist

1. Make code changes in `src/` or `Addons/`, not in the generated bundle.
2. Run `python scripts/build_bundle.py`.
3. Run `python scripts/audit_static.py` and require a passing result.
4. Verify `src/init.lua`, `README.md`, `AUDIT.md`, and the bundle banner report the same public version.
5. Run Luau analysis and the manual Roblox Studio/client regression matrix documented in `AUDIT.md`.
6. Package the complete repository, including source, addons, scripts, docs, license, example, and `dist/`.

## Notes

The static audit is not a substitute for Luau compilation or Roblox runtime testing. Do not describe a release as runtime-certified unless those tests have actually passed.
