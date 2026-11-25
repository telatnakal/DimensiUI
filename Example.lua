-- =========================================================
-- DIMENSI-HUB | DIMENSI
-- Example configuration for the compact DimensiUI layout
-- Author / Credit: telatnakal
-- =========================================================

local DimensiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/telatnakal/DimensiUI/main/dist/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/telatnakal/DimensiUI/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/telatnakal/DimensiUI/main/Addons/InterfaceManager.lua"))()

local Window = DimensiUI:CreateWindow({
    Title = "DIMENSI-HUB | FOREST MARKET",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dimensi",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "layers" }),
    Automation = Window:AddTab({ Title = "Automation", Icon = "sliders" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = DimensiUI.Options

DimensiUI:Notify({
    Title = "Dimensi-Hub",
    Content = "Compact interface loaded.",
    Duration = 4,
})

Tabs.Main:AddParagraph({
    Title = "Welcome",
    Content = "DIMENSI-HUB compact layout. Theme colors remain unchanged.",
})

Tabs.Main:AddButton({
    Title = "Test Dialog",
    Description = "Show a confirmation dialog",
    Callback = function()
        Window:Dialog({
            Title = "Confirmation",
            Content = "Run a test action?",
            Buttons = {
                { Title = "Yes", Callback = function() print("Confirmed") end },
                { Title = "Cancel", Callback = function() print("Cancelled") end },
            },
        })
    end,
})

local Toggle = Tabs.Automation:AddToggle("SampleToggle", {
    Title = "Auto Feature",
    Default = false,
})
Toggle:OnChanged(function()
    print("SampleToggle:", Options.SampleToggle.Value)
end)

Tabs.Automation:AddSlider("SampleSlider", {
    Title = "Delay (seconds)",
    Description = "Set execution interval",
    Default = 1, Min = 0, Max = 10, Rounding = 1,
    Callback = function(Value) print("SampleSlider:", Value) end,
})

local Dropdown = Tabs.Automation:AddDropdown("SampleDropdown", {
    Title = "Mode",
    Values = { "Mode A", "Mode B", "Mode C" },
    Multi = false, Default = 1,
})
Dropdown:OnChanged(function(Value) print("SampleDropdown:", Value) end)

SaveManager:SetLibrary(DimensiUI)
InterfaceManager:SetLibrary(DimensiUI)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:SetFolder("DimensiUISettings/Example")
InterfaceManager:SetFolder("DimensiUISettings")
InterfaceManager:BuildFolderTree()

Tabs.Settings:AddSection("Config")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
