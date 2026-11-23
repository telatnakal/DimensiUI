#!/usr/bin/env python3
"""Static DimensiUI audit checks; no Roblox runtime is required."""
from pathlib import Path
import re
import hashlib
import subprocess

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
modules = {}
for file in SRC.rglob("*.lua"):
    rel = file.relative_to(SRC).as_posix()
    path = rel[:-4]
    if path.endswith("/init"):
        path = path[:-5]
    elif path == "init":
        path = ""
    modules[path] = file

missing = []
for file in SRC.rglob("*.lua"):
    rel = file.relative_to(SRC).as_posix()
    current = rel[:-4]
    if current.endswith("/init"):
        current = current[:-5]
    elif current == "init":
        current = ""
    for match in re.finditer(r"require\(script((?:\.Parent|\.[A-Za-z_][A-Za-z0-9_]*)*)\)", file.read_text()):
        chain = match.group(1).lstrip(".").split(".") if match.group(1) else []
        target = current.split("/") if current else []
        for segment in chain:
            if segment == "Parent":
                if target:
                    target.pop()
            else:
                target.append(segment)
        path = "/".join(target)
        if path not in modules and path not in {"Acrylic", "Components", "Elements", "Packages", "Themes"}:
            missing.append((rel, match.group(0), path))
assert not missing, f"Unresolved module references: {missing}"

bundle_file = ROOT / "dist/main.lua"
bundle = bundle_file.read_text()
markers = list(re.finditer(r"(?m)^__DimensiModules\['([^']*)'\] = function\(script, require\)\n", bundle))
paths = [marker.group(1) for marker in markers]
assert len(paths) == len(set(paths)), "Duplicate bundle module markers"
assert set(paths) == set(modules), f"Bundle/source path mismatch: source-only={set(modules)-set(paths)}, bundle-only={set(paths)-set(modules)}"
for index, marker in enumerate(markers):
    end = markers[index + 1].start() if index + 1 < len(markers) else len(bundle)
    chunk = bundle[marker.end():end]
    if "\nend\n" in chunk:
        chunk = chunk.rsplit("\nend\n", 1)[0]
    source = modules[marker.group(1)].read_text().rstrip()
    assert chunk.rstrip() == source.rstrip(), f"Source/bundle mismatch: {marker.group(1)}"

forbidden = ("Flipper", "Fluent", "eko-sulistyawan")
text_files = [*SRC.rglob("*.lua"), *ROOT.joinpath("Addons").rglob("*.lua"), ROOT / "README.md", ROOT / "Example.lua", bundle_file]
hits = [(str(file.relative_to(ROOT)), term) for file in text_files for term in forbidden if term.lower() in file.read_text(errors="ignore").lower()]
assert not hits, f"Legacy references found: {hits}"

# Single-theme contract.
theme_files = sorted(path.name for path in (SRC / "Themes").glob("*.lua"))
assert theme_files == ["Dimensi.lua", "init.lua"], f"Unexpected theme modules: {theme_files}"
theme_init = (SRC / "Themes/init.lua").read_text()
library_init = (SRC / "init.lua").read_text()
interface_manager = (ROOT / "Addons/InterfaceManager.lua").read_text()
assert 'Names = { "Dimensi" }' in theme_init, "Theme registry must contain only Dimensi"
assert 'Themes = { "Dimensi" }' in library_init, "Library.Themes must be locked to Dimensi"
assert 'if Value ~= "Dimensi" then' in library_init, "SetTheme must reject non-Dimensi themes"
assert 'Library:SetTheme("Dimensi")' in interface_manager, "InterfaceManager must lock Dimensi theme"
assert 'AddDropdown("InterfaceTheme"' not in interface_manager, "InterfaceManager must not expose a theme selector"
assert "Themes.Dark" not in (SRC / "Creator.lua").read_text(), "Legacy theme fallback remains"

assert (ROOT / "src/Packages/DimensiMotion/init.lua").exists(), "Native motion package missing"
assert not (ROOT / "src/Packages/Flipper").exists(), "Legacy motion package still exists"
assert 'Version = "1.1.1"' in (SRC / "init.lua").read_text(), "Version metadata mismatch"


# Responsive layout contracts.
window_source = (SRC / "Components/Window.lua").read_text()
assert 'GetPropertyChangedSignal("ViewportSize")' in window_source, "Window must react to viewport changes"
assert 'GetPropertyChangedSignal("CurrentCamera")' in window_source and "BindCamera()" in window_source, "Window must rebind when CurrentCamera changes"
assert "math.clamp" in window_source and "getBounds()" in window_source, "Window must clamp its size and position"
assert "viewport.X < 600" in window_source, "Mobile breakpoint is missing"
assert "math.clamp(ListSizeX + 30" in (SRC / "Elements/Dropdown.lua").read_text(), "Dropdown popup width must be viewport-aware"

# Every element is invoked through ElementComponent:New(Idx, Config).
# Guard against the historical one-argument Button/Paragraph signature bug.
for element_file in (SRC / "Elements").glob("*.lua"):
    if element_file.name == "init.lua":
        continue
    source = element_file.read_text()
    signature = re.search(r"function\s+\w+:New\(([^)]*)\)", source)
    assert signature, f"Missing New constructor: {element_file.name}"
    params = [part.strip() for part in signature.group(1).split(",") if part.strip()]
    assert params[:2] == ["Idx", "Config"], f"Constructor must accept (Idx, Config): {element_file.name}"
for element_file in (SRC / "Elements/Paragraph.lua", SRC / "Elements/Button.lua"):
    source = element_file.read_text()
    assert 'if Config == nil and type(Idx) == "table" then' in source, f"Missing legacy config normalization: {element_file.name}"

first = hashlib.sha256(bundle_file.read_bytes()).hexdigest()
subprocess.run(["python", str(ROOT / "scripts/build_bundle.py")], check=True, cwd=ROOT, capture_output=True)
second = hashlib.sha256(bundle_file.read_bytes()).hexdigest()
assert first == second, "Bundle build is not deterministic"
print(f"PASS: {len(modules)} source modules; {len(paths)} bundle modules; require paths resolved; source parity; no legacy refs; deterministic build")
print(f"Bundle SHA256: {second}")
