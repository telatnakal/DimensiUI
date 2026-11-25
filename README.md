# DimensiUI

Repository: https://github.com/telatnakal/DimensiUI
Raw source: https://raw.githubusercontent.com/telatnakal/DimensiUI/main/

A modular Roblox UI library with a self-contained bundled build, a responsive interface for desktop, tablet, and mobile, predictable APIs, and lightweight customization.

- **Author:** telatnakal
- **Credit:** telatnakal
- **Version:** 1.2.15
- **Theme:** Dimensi only (obsidian-violet / Builder Sans typography)

## Features

- Window, tabs, sections, buttons, toggles, sliders, dropdowns, inputs, keybinds, color pickers, paragraphs
- Notifications and dialogs
- Single Dimensi theme with runtime accent override
- Optional acrylic and transparency effects
- SaveManager and InterfaceManager addons with per-instance factories and guarded persistence
- Modular source and a bundled single-file build
- Isolated library instances through `Library:NewInstance()` and `Library:CreateInstance()`
- Per-instance SaveManager and InterfaceManager factories with validated library binding

## Installation

Use `src` as the modular source in Roblox Studio, or load the bundled single-file build from the project raw URL:

```lua
local DimensiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/telatnakal/DimensiUI/main/dist/main.lua"))()
```

Addon raw URLs:
- `https://raw.githubusercontent.com/telatnakal/DimensiUI/main/Addons/SaveManager.lua`
- `https://raw.githubusercontent.com/telatnakal/DimensiUI/main/Addons/InterfaceManager.lua`


## Basic usage

```lua
local DimensiUI = loadstring(game:HttpGet("YOUR_RAW_SOURCE_URL"))()


-- Create another independent library instance when a separate UI lifecycle is needed.
local SecondaryUI = DimensiUI:NewInstance()

local Window = DimensiUI:CreateWindow({
    Title = "DimensiUI",
    SubTitle = "Interface",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 420),
    Acrylic = false,
    Theme = "Dimensi",
})

local Tab = Window:AddTab({ Title = "Main", Icon = "home" })
local Section = Tab:AddSection("Controls")
Section:AddButton({ Title = "Example", Callback = function() end })
```


## Theme

`Dimensi` is the only supported theme. `CreateWindow({ Theme = ... })` always uses `Dimensi`, and `DimensiUI:SetTheme()` returns `false` for every other theme name. Runtime accent customization remains available through `DimensiUI:SetAccent(Color3)` and `DimensiUI:ResetAccent()`.


## Attribution and license

Author and project credit displayed by this library: **telatnakal**. License and source provenance must be reviewed before public distribution. This archive does not include a verified upstream license inventory.


## Multiple instances

Each library instance owns an independent root module tree and its own GUI, theme registry, tab state, notifications, motion resources, and cleanup lifecycle. Create additional instances with `local OtherUI = DimensiUI:NewInstance()`. Each instance can create one window using the existing `CreateWindow` API. Destroy instances independently with `OtherUI:Destroy()`; destroying one instance is not intended to unload another.


### Instance isolation and cleanup

Each library instance owns its own cloned module tree and module cache in both modular and bundled builds. Create an independent instance with either `Library:NewInstance()` or `Library:CreateInstance()`. Each instance can create one window and can be destroyed independently.

```lua
local UI = require(path.to.DimensiUI)
local UI2 = UI:CreateInstance()

UI:CreateWindow({ Title = "Primary" })
UI2:CreateWindow({ Title = "Secondary" })

UI2:Destroy() -- does not destroy UI
```

Register instance-owned cleanup work with `Library:AddCleanup(function() ... end)`. Callbacks are run in reverse registration order when that instance is destroyed. Acrylic's owned DepthOfField effect is also released during destruction and previously captured effect states are restored.

### Per-instance addons

The addon modules retain their existing singleton exports for compatibility. For multiple independent library instances, create a matching addon instance and assign the corresponding library:

```lua
local SaveManagerModule = loadstring(game:HttpGet("YOUR_SAVEMANAGER_RAW_URL"))()
local InterfaceManagerModule = loadstring(game:HttpGet("YOUR_INTERFACEMANAGER_RAW_URL"))()

local SaveManager = SaveManagerModule:NewInstance()
local InterfaceManager = InterfaceManagerModule:NewInstance()

SaveManager:SetLibrary(UI2)
InterfaceManager:SetLibrary(UI2)
```

Use a distinct `SetFolder()` path for each manager if their configuration files must also remain separate on disk. Independent manager objects do not automatically create separate filesystem namespaces.
