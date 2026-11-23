# DimensiUI

Repository: https://github.com/telatnakal/DimensiUI
Raw source: https://raw.githubusercontent.com/telatnakal/DimensiUI/main/

A modular Roblox UI library with a self-contained bundled build, a responsive interface for desktop, tablet, and mobile, predictable APIs, and lightweight customization.

- **Author:** telatnakal
- **Credit:** telatnakal
- **Version:** 1.1.1
- **Theme:** Dimensi only (obsidian-violet)

## Features

- Window, tabs, sections, buttons, toggles, sliders, dropdowns, inputs, keybinds, color pickers, paragraphs
- Notifications and dialogs
- Single Dimensi theme with runtime accent override
- Optional acrylic and transparency effects
- SaveManager and InterfaceManager addons
- Modular source and a bundled single-file build

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
