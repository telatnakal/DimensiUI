#!/usr/bin/env python3
"""Static DimensiUI audit checks; no Roblox runtime is required."""
from pathlib import Path
import re
import hashlib
import subprocess
import sys

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
        if path not in modules and path not in {"Components", "Elements", "Packages", "Themes"}:
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
save_manager = (ROOT / "Addons/SaveManager.lua").read_text()
assert "local function CreateSaveManager()" in save_manager and "SaveManager.New = CreateSaveManager" in save_manager and "SaveManager.NewInstance = CreateSaveManager" in save_manager, "SaveManager instance factories are missing"
assert "local function CreateInterfaceManager()" in interface_manager and "InterfaceManager.New = CreateInterfaceManager" in interface_manager and "InterfaceManager.NewInstance = CreateInterfaceManager" in interface_manager, "InterfaceManager instance factories are missing"
assert "local InterfaceManager = CreateInterfaceManager()" in interface_manager, "InterfaceManager legacy singleton export is missing"
assert "local SaveManager = CreateSaveManager()" in save_manager, "SaveManager legacy singleton export is missing"
assert "manager.Options[idx]" in save_manager and "pcall(entry.Parser.Load, entry.Index, entry.Data, self)" in save_manager, "SaveManager parser must use the owning manager registry"
assert "next, self.Options" in save_manager and "self.Options.SaveManager_ConfigList" in save_manager, "SaveManager UI must use the owning manager registry"
assert "SaveManager.Options" not in save_manager, "SaveManager factory still captures singleton Options"
assert "local Settings = self.Settings" in interface_manager and "Manager:SaveSettings()" in interface_manager, "InterfaceManager callbacks must use the owning manager"
assert "InterfaceManager.Settings = {" in interface_manager, "InterfaceManager factory must initialize settings on its local table"
assert "Themes.Dark" not in (SRC / "Creator.lua").read_text(), "Legacy theme fallback remains"

assert (ROOT / "src/Packages/DimensiMotion/init.lua").exists(), "Native motion package missing"
assert not (ROOT / "src/Packages/Flipper").exists(), "Legacy motion package still exists"
version_source = (SRC / "init.lua").read_text()
version_match = re.search(r'(?m)^\s*Version = "([0-9]+\.[0-9]+\.[0-9]+)",\s*$', version_source)
assert version_match, "Library version metadata is missing"
version = version_match.group(1)
assert f"**Version:** {version}" in (ROOT / "README.md").read_text(), "README version metadata mismatch"
assert f"DimensiUI v{version} (Bundled Single-File Build)" in bundle, "Bundle banner version mismatch"
assert "Theme: Dimensi | Author: telatnakal" in bundle, "Bundle banner theme/author metadata mismatch"
assert 'function Library:RegisterOption(Idx, Option)' in library_init, "Option registration helper is missing"
assert 'function Library:UnregisterOption(Idx, Option)' in library_init, "Identity-safe option removal helper is missing"
assert 'end, ButtonFrame.Frame)' in (SRC / "Elements/Button.lua").read_text(), "Button listener must be owner-bound"
assert 'end, ToggleFrame.Frame)' in (SRC / "Elements/Toggle.lua").read_text(), "Toggle listener must be owner-bound"
input_source = (SRC / "Elements/Input.lua").read_text()
assert input_source.count('InputFrame.Frame)') >= 2, "Input listeners must be owner-bound"
slider_source = (SRC / "Elements/Slider.lua").read_text()
assert slider_source.count('SliderFrame.Frame)') >= 3, "Slider listeners must be owner-bound"
dropdown_source = (SRC / "Elements/Dropdown.lua").read_text()
assert 'RecalculateListPosition, DropdownFrame.Frame)' in dropdown_source and 'end, DropdownFrame.Frame)' in dropdown_source and 'end, Button)' in dropdown_source, "Dropdown listeners must be owner-bound"
keybind_source = (SRC / "Elements/Keybind.lua").read_text()
assert 'CaptureConnection = Creator.AddSignal(UserInputService.InputBegan' in keybind_source and 'end, KeybindFrame.Frame)' in keybind_source, "Keybind capture listener must be owner-bound"
colorpicker_source = (SRC / "Elements/Colorpicker.lua").read_text()
assert colorpicker_source.count('Dialog.Root)') >= 7 and 'end, ColorpickerFrame.Frame)' in colorpicker_source, "Colorpicker listeners must be owner-bound"
# Component and window listeners must be scoped to the GUI that owns their lifetime.
for rel, tokens in {
    "Components/TitleBar.lua": ["Button.Callback, Button.Frame)"],
    "Components/Element.lua": ["end, Element.Frame)"],
    "Components/Button.lua": ["end, Button.Frame)"],
    "Components/Section.lua": ["end, Section.Root)"],
    "Components/Tab.lua": ["end, Tab.Frame)", "end, Tab.ContainerFrame)"],
    "Components/Textbox.lua": ["Update, Textbox.Frame)", "end, Textbox.Frame)"],
    "Components/Window.lua": ["end, Window.Root)", "FitToViewport, Window.Root)", "Input.Changed, function()"],
}.items():
    source = (SRC / rel).read_text()
    for token in tokens:
        assert token in source, f"Missing owner-bound listener in {rel}: {token}"
window_source = (SRC / "Components/Window.lua").read_text()
assert window_source.count("end, Window.Root)") >= 8, "Window service and GUI listeners must be owned by Window.Root"

# Every AddSignal call must declare the Instance that owns its connection.
def signal_call_arguments(source: str):
    pattern = re.compile(r"(?:Creator\.)?AddSignal\(")
    for match in pattern.finditer(source):
        index = match.end()
        depth = 1
        quote = None
        escaped = False
        argument_start = index
        arguments = []
        while index < len(source) and depth:
            char = source[index]
            if quote:
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == quote:
                    quote = None
            else:
                if char in ('"', "\'"):
                    quote = char
                elif char in "([{":
                    depth += 1
                elif char in ")]}":
                    if char == ")" and depth == 1:
                        arguments.append(source[argument_start:index].strip())
                    depth -= 1
                elif char == "," and depth == 1:
                    arguments.append(source[argument_start:index].strip())
                    argument_start = index + 1
            index += 1
        yield arguments

for file in SRC.rglob("*.lua"):
    for arguments in signal_call_arguments(file.read_text()):
        assert len(arguments) >= 3 and arguments[2], f"AddSignal must declare an owner: {file.relative_to(SRC)}"

assert 'function Library:CreateInstance()' in (SRC / "init.lua").read_text(), "CreateInstance alias is missing"
assert 'function Library:AddCleanup(Callback)' in (SRC / "init.lua").read_text(), "Instance cleanup registration is missing"
assert not (SRC / "Acrylic").exists(), "Acrylic module must stay removed"
assert (SRC / "Surface.lua").exists(), "Solid surface module is missing"
notification_source = (SRC / "Components/Notification.lua").read_text()
assert 'GetPropertyChangedSignal("CurrentCamera")' in notification_source, "Notifications must rebind to replacement cameras"
assert 'Notification button callback must be a function' in notification_source, "Notification button validation is missing"
assert 'end, NewNotification.Holder)' in notification_source, "Notification close cleanup must be owner-bound"
for file in [*SRC.rglob("*.lua"), *ROOT.joinpath("Addons").rglob("*.lua")]:
    assert "acrylic" not in file.read_text().lower(), f"Acrylic reference remains: {file.relative_to(ROOT)}"
window_dialog_source = (SRC / "Components/Window.lua").read_text()
assert 'Config.Buttons = Config.Buttons or {}' in window_dialog_source, "Dialog Buttons must be optional"
assert 'function Library:NewInstance()' in (SRC / "init.lua").read_text(), "Multi Instance factory is missing"

# Multi-instance factory must work in both modular ModuleScript and synthetic bundled roots.
instance_factory = (SRC / "init.lua").read_text()
assert 'local IsModuleRoot = typeof(Root) == "Instance" and Root:IsA("ModuleScript")' in instance_factory, "ModuleScript root detection is missing"
assert 'local IsBundleRoot = type(Root) == "table" and Root._path == "" and type(Root.Clone) == "function"' in instance_factory, "Bundled root detection is missing"
assert 'local function ValidateCloneTree(InstanceRoot)' in instance_factory, "ModuleScript clone-tree validation is missing"
assert 'InstanceRoot:GetDescendants()' in instance_factory and 'Descendant.Archivable' in instance_factory, "Multi Instance must reject non-Archivable descendants before cloning"
assert 'type(RootClone.Destroy) == "function"' in instance_factory, "Bundled root clone cleanup is missing"
assert 'function node:Destroy()' in bundle, "Synthetic bundle nodes must support clone teardown"
assert 'function node:Clone()' in bundle, "Synthetic bundle root cloning is missing"
assert 'local __DimensiCaches = setmetatable({}, { __mode = "k" })' in bundle, "Bundle per-root module cache is missing"
assert 'function node:Clone()' in bundle, "Bundle root clone support is missing"


# Typography contract.
typography = (SRC / "Typography.lua").read_text()
assert "BuilderSans.json" in typography, "Builder Sans font candidate is missing"
assert "GothamSSm.json" in typography and "SourceSansPro.json" in typography, "Font fallbacks are missing"
assert 'local Typography = require(Root.Typography)' in (SRC / "Creator.lua").read_text(), "Creator typography defaults are missing"
for file in SRC.rglob("*.lua"):
    source = file.read_text()
    if file.name != "Typography.lua":
        assert 'Font.new("rbxasset://fonts/families/GothamSSm.json"' not in source, f"Direct legacy font reference: {file}"

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

assert 'Library:UnregisterOption(Idx, Toggle)' in (SRC / "Elements/Toggle.lua").read_text(), "Toggle destroy must unregister only its own option instance"
toggle_source = (SRC / "Elements/Toggle.lua").read_text()
assert "TRACK_WIDTH = 36" in toggle_source and "TRACK_HEIGHT = 20" in toggle_source, "Toggle track must use 36x20 sizing"
assert "KNOB_SIZE = 14" in toggle_source and "KNOB_PAD = 3" in toggle_source, "Toggle knob must use 14px sizing with 3px padding"
assert "TRACK_WIDTH - KNOB_SIZE - KNOB_PAD" in toggle_source, "Toggle knob position must match track geometry"

assert 'Library:UnregisterOption(Idx, Slider)' in (SRC / "Elements/Slider.lua").read_text(), "Slider destroy must unregister only its own option instance"

assert 'Library:UnregisterOption(Idx, Dropdown)' in (SRC / "Elements/Dropdown.lua").read_text(), "Dropdown destroy must unregister only its own option instance"

assert 'Library:UnregisterOption(Idx, Colorpicker)' in (SRC / "Elements/Colorpicker.lua").read_text(), "Colorpicker destroy must unregister only its own option instance"

assert 'Library:UnregisterOption(Idx, Input)' in (SRC / "Elements/Input.lua").read_text(), "Input destroy must unregister only its own option instance"

assert 'Library:UnregisterOption(Idx, Keybind)' in (SRC / "Elements/Keybind.lua").read_text(), "Keybind destroy must unregister only its own option instance"

first = hashlib.sha256(bundle_file.read_bytes()).hexdigest()
subprocess.run([sys.executable, str(ROOT / "scripts/build_bundle.py")], check=True, cwd=ROOT, capture_output=True)
second = hashlib.sha256(bundle_file.read_bytes()).hexdigest()
assert first == second, "Bundle build is not deterministic"
print(f"PASS: {len(modules)} source modules; {len(paths)} bundle modules; require paths resolved; source parity; no legacy refs; deterministic build")
print(f"Bundle SHA256: {second}")

# Dialog open-state ownership and concurrent dialog accounting.
dialog_source = (SRC / "Components/Dialog.lua").read_text()
assert "function NewDialog:SetOpenState(IsOpen)" in dialog_source, "Dialog open-state accounting is missing"
assert "Library._OpenDialogCount > 0" in dialog_source, "Concurrent dialog state is not reference-counted"
assert "NewDialog.TintFrame.Destroying" in dialog_source, "External dialog destruction must release open-state ownership"
assert "Library._OpenDialogCount = 0" in library_init, "Library teardown must reset dialog accounting"


# Addon factories must initialize methods/state on their local manager tables.
save_manager = (ROOT / "Addons/SaveManager.lua").read_text()
interface_manager = (ROOT / "Addons/InterfaceManager.lua").read_text()
assert "function SaveManager:BuildFolderTree()" in save_manager, "SaveManager factory method must belong to its local instance"
assert "\n\tSaveManager:BuildFolderTree()" in save_manager, "SaveManager factory must initialize its own folder tree"
assert "function self:BuildFolderTree()" not in save_manager and "\n\tself:BuildFolderTree()" not in save_manager, "SaveManager factory contains an unresolved self reference"
assert "InterfaceManager.Settings = {" in interface_manager, "InterfaceManager settings must belong to its local instance"
assert "function InterfaceManager:SaveSettings()" in interface_manager, "InterfaceManager SaveSettings must belong to its local instance"
assert "self.Settings = {" not in interface_manager and "function Manager:SaveSettings()" not in interface_manager, "InterfaceManager factory contains unresolved manager references"

# Addon filesystem boundaries and per-instance library binding.
assert 'pcall(isfile, path)' in save_manager, "SaveManager file existence checks must be protected"
assert 'pcall(isfile, path)' in save_manager[save_manager.find('function SaveManager:LoadAutoloadConfig()'):], "Autoload existence checks must be protected"
assert 'pcall(writefile, self.Folder .. "/settings/autoload.txt", name)' in save_manager, "Autoload writes must be protected"
assert 'ignore indexes must contain non-empty strings' in save_manager, "SaveManager ignore indexes must be validated"
assert 'invalid DimensiUI library instance' in save_manager, "SaveManager must validate its Library binding"
assert 'invalid DimensiUI library instance' in interface_manager, "InterfaceManager must validate its Library binding"
assert 'local ok, err = pcall(self.BuildFolderTree, self)' in interface_manager, "InterfaceManager must report folder initialization errors"
assert 'Notification button callback must be a function' in notification_source, "Notification button callbacks must be validated"
assert 'ButtonConfig.Callback' in notification_source and 'end, NewNotification.Holder)' in notification_source, "Notification buttons must use owner-bound callbacks"

assert 'config validation failed; %d invalid or duplicate entries; no options were changed' in save_manager, "SaveManager must validate the complete config before applying values"
assert 'config apply failed; previous option values were restored where possible' in save_manager, "SaveManager must attempt rollback after apply failure"
assert 'local pending, seen, skipped = {}, {}, 0' in save_manager, "SaveManager config load staging is missing"
assert 'pcall(entry.Parser.Load, entry.Index, entry.Previous, self)' in save_manager, "SaveManager must restore the currently failing option when possible"
assert 'table.insert(applied, entry)\n\t\tend\n\t\treturn true' in save_manager, "SaveManager successful loads must return true"


# Version consistency: every place that states a version must match src/init.lua.
for readme_name in ("README.md", "README.id.md"):
    readme_text = (ROOT / readme_name).read_text(encoding="utf-8")
    assert f"**Version:** {version}" in readme_text, f"{readme_name} version metadata mismatch"
    assert f"version-{version}-" in readme_text, f"{readme_name} version badge mismatch"
changelog = (ROOT / "CHANGELOG.md").read_text(encoding="utf-8")
first_release = re.search(r"(?m)^## \[([0-9]+\.[0-9]+\.[0-9]+)\]", changelog)
assert first_release and first_release.group(1) == version, "CHANGELOG latest entry must match the library version"
previous_label = "1.1.2"  # the pre-release label that 1.0.1 replaces; it must not survive outside the changelog
stale = [name for name in ("README.md", "README.id.md", "Example.lua")
         if previous_label in (ROOT / name).read_text(encoding="utf-8")]
assert version == previous_label or not stale, f"Stale version references: {stale}"

# The embedded bubble logo must match the PNG source asset.
icon_check = subprocess.run([sys.executable, str(ROOT / "scripts/build_icon.py"), "--check"], cwd=ROOT, capture_output=True, text=True)
assert icon_check.returncode == 0, icon_check.stdout + icon_check.stderr

# Minimize bubble contract: docked at the left edge, vertically centered, animated, restores the window.
window_source = (SRC / "Components/Window.lua").read_text()
assert "AnchorPoint = Vector2.new(0.5, 0.5)" in window_source, "Bubble must be anchored on its own centre"
assert "UDim2.new(0, BUBBLE_MARGIN + BUBBLE_SIZE / 2, 0.5, 0)" in window_source, "Bubble must dock at the left edge"
assert "UDim2.new(0, X + BUBBLE_SIZE / 2, 0.5, Y)" in window_source, "Bubble placement must be centre-anchored with scale-based vertical centring"
assert "BubbleDocked = true" in window_source and "-(height + inset) * BUBBLE_DOCK_Y - inset / 2" in window_source, "Every minimize must re-dock the bubble at the fixed screen fraction"
assert "BUBBLE_MARGIN = 48" in window_source and "BUBBLE_DOCK_Y = 0.25" in window_source, "Bubble must dock near the left edge (8px gap), 25% from the top"
assert 'New("UIScale"' in window_source and "SetBubbleShown" in window_source, "Bubble show/hide animation is missing"
assert "BubbleToken" in window_source, "Bubble animation must guard against stale hide callbacks"
assert "Window:SetCollapsed(false)" in window_source, "Clicking the bubble must restore the window"
assert "BubbleViewportHook" in window_source, "Bubble must re-clamp when the viewport changes"
assert "ZIndex = 100" in window_source, "Bubble must stay above other GUI elements"
print(f"PASS: version {version} is consistent across source, bundle, READMEs and changelog; bubble contract verified")
