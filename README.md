# DimensiUI

**DimensiUI** is a modular UI library for Roblox experiences, with a standalone bundled build.

| Release metadata | Value |
|---|---|
| Project | DimensiUI |
| Version | `1.1.2` |
| Release type | Stable Release |
| Author | telatnakal |
| Theme | Midnight (navy-violet) |
| Runtime | Roblox Lua / Luau |

**Version:** 1.1.2

## Features

- Compact settings rows and tighter card spacing for denser, more readable layouts.

- Windows, tabs, sections, buttons, toggles, sliders, dropdowns, inputs, keybinds, color pickers, and paragraphs
- Notifications and dialogs, including notification action buttons
- Midnight visual system (navy surfaces, selective violet accent) with runtime accent customization
- Shared typography resolver with Builder Sans candidate and Roblox font fallbacks
- Responsive window sizing, collapsible sidebar, and viewport-aware controls
- Balanced hybrid layout: tonal sidebar, page title and description header, rounded cards with hairline row dividers, and adaptive control alignment
- Solid surfaces with optional window transparency (no blur effects)
- Instance factory APIs: `NewInstance()` and `CreateInstance()`
- Instance-owned cleanup callbacks through `AddCleanup()`
- SaveManager and InterfaceManager addons with per-instance factories
- Modular source plus generated standalone bundle

## Repository layout

```text
DimensiUI/
├── Addons/                 # SaveManager and InterfaceManager
├── dist/                   # Generated standalone distribution
│   └── main.lua
├── scripts/                # Bundle builder and static audit
├── src/                    # Authoritative modular source
├── Example.lua             # Usage example
├── LICENSE                 # MIT License
└── default.project.json    # Rojo project mapping
```

## Installation

### Standalone bundle

The generated single-file build is available at `dist/main.lua`. For example, in environments that permit `loadstring` and HTTP requests:

```lua
local DimensiUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/telatnakal/DimensiUI/main/dist/main.lua"
))()
```

### Modular source

Use `default.project.json` with Rojo or place the `src/` hierarchy into Roblox Studio as a ModuleScript tree. Require the root module (`src/init.lua`).

## Basic usage

```lua
local DimensiUI = loadstring(game:HttpGet("YOUR_RAW_SOURCE_URL"))()

local Window = DimensiUI:CreateWindow({
    Title = "DimensiUI",
    SubTitle = "Interface",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 420),
    Theme = "Dimensi", -- Midnight visual preset (backwards-compatible theme key)
})

local Tab = Window:AddTab({ Title = "Main", Icon = "home" })
local Section = Tab:AddSection("Controls")
Section:AddButton({
    Title = "Example",
    Callback = function() end,
})
```

## Minimize and icon bubble

The title-bar minimize button collapses the window into a small round "D" bubble. Click the bubble to restore the window; drag it to move it. Pressing `RightControl` (configurable with `MinimizeKey`, or the Hide Bind in InterfaceManager) hides everything, including the bubble, and pressing it again brings back whatever was showing.

```lua
local Window = Library:CreateWindow({
    Title = "DimensiUI",
    MinimizeKey = Enum.KeyCode.RightControl,
    Icon = "rbxassetid://123456789", -- optional
})
```

`Icon` accepts a Roblox asset id (`"rbxassetid://ID"` or a number), or an image URL. A URL is downloaded once into the executor workspace (`DimensiUI/`) and reused afterwards; this needs `writefile` and `getcustomasset`, and it is the only network request the library makes. Use a raw link such as `https://raw.githubusercontent.com/<user>/<repo>/main/Assets/d-icon-128.png` (a `github.com/.../blob/...` page link is converted automatically). If the icon cannot be loaded, the bubble shows a plain "D" and a warning is printed.

## Multiple library instances

Create a separate library instance when an independent UI lifecycle is needed:

```lua
local PrimaryUI = DimensiUI
local SecondaryUI = DimensiUI:NewInstance()

PrimaryUI:CreateWindow({ Title = "Primary" })
SecondaryUI:CreateWindow({ Title = "Secondary" })

SecondaryUI:Destroy() -- PrimaryUI remains alive
```

`CreateInstance()` is also available as an alias. Each library instance is intended to own its module tree/cache, GUI, theme registry, tab state, notifications, motion resources, and cleanup lifecycle. Runtime behavior should be verified in the target Roblox environment.

Register additional instance-owned teardown work with:

```lua
DimensiUI:AddCleanup(function()
    -- Release resources owned by this library instance.
end)
```

Cleanup callbacks run in reverse registration order when the instance is destroyed.

## Addons

The addon modules preserve their legacy singleton exports and also expose instance factories. Bind each addon instance to the matching library instance:

```lua
local SaveManagerModule = loadstring(game:HttpGet("YOUR_SAVEMANAGER_RAW_URL"))()
local SaveManager = SaveManagerModule:NewInstance()
SaveManager:SetLibrary(SecondaryUI)
SaveManager:SetFolder("DimensiUI/Secondary")
```

Use a distinct folder for each manager when configurations must be stored separately. Addon instance isolation does not automatically create separate filesystem namespaces.

## Theme and typography

The visual preset is **Midnight** (internally registered as `Dimensi` for backwards compatibility). It uses deep navy surfaces and a selective violet accent. The sidebar can be collapsed with the header menu control or `Window:ToggleSidebar()`. Tabs accept an optional `Description` field for the page header. Runtime accent customization is available through `SetAccent(Color3)` and `ResetAccent()`. The typography resolver attempts Builder Sans and falls back to supported Roblox font families when needed. Availability of a font family depends on the Roblox runtime.

## Build

Regenerate the standalone bundle after editing `src/`:

```bash
python3 scripts/build_bundle.py
python3 scripts/audit_static.py   # optional static checks
```

## License and provenance

The repository includes an MIT `LICENSE` file. The provenance of every pre-existing UI module and Roblox asset ID has not been independently established; review [PROVENANCE.md](PROVENANCE.md) and applicable upstream notices before redistributing third-party materials.

## Links

- Repository: https://github.com/telatnakal/DimensiUI
- Standalone bundle: https://raw.githubusercontent.com/telatnakal/DimensiUI/main/dist/main.lua
