local DimensiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/telatnakal/DimensiUI/main/dist/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/telatnakal/DimensiUI/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/telatnakal/DimensiUI/main/Addons/InterfaceManager.lua"))()

local Window = DimensiUI:CreateWindow({
	Title = "DimensiUI",
	SubTitle = "v" .. DimensiUI.Version,
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Theme = "Dimensi",
	MinimizeKey = Enum.KeyCode.RightControl, -- sembunyikan total (window + ikon D)
	Icon = "https://raw.githubusercontent.com/telatnakal/DimensiUI/main/Assets/d-icon.png", -- diunduh sekali ke workspace executor; boleh juga "rbxassetid://ID"
})

local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = "layers", Description = "Overview and quick actions" }),
	Automation = Window:AddTab({ Title = "Automation", Icon = "sliders", Description = "Configure automation behavior" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings", Description = "Manage interface and saved configs" }),
}

local Options = DimensiUI.Options

do
	DimensiUI:Notify({
		Title = "DimensiUI",
		Content = "Interface siap digunakan dengan ikon aktif.",
		SubContent = "Icon: " .. tostring(DimensiUI:GetIcon("layers")),
		Duration = 4,
	})

	Tabs.Main:AddParagraph({
		Title = "DimensiUI Rebuild",
		Content = "DimensiUI — clean dark-purple interface library. Author: telatnakal.",
	})

	Tabs.Main:AddButton({
		Title = "Test Dialog",
		Description = "Menampilkan dialog konfirmasi",
		Callback = function()
			Window:Dialog({
				Title = "Konfirmasi",
				Content = "Jalankan aksi pada DimensiUI?",
				Buttons = {
					{
						Title = "Ya",
						Callback = function()
							print("Aksi dikonfirmasi")
						end,
					},
					{
						Title = "Batal",
						Callback = function()
							print("Aksi dibatalkan")
						end,
					},
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

	local Slider = Tabs.Automation:AddSlider("SampleSlider", {
		Title = "Delay (detik)",
		Description = "Atur interval eksekusi",
		Default = 1,
		Min = 0,
		Max = 10,
		Rounding = 1,
		Callback = function(Value)
			print("SampleSlider:", Value)
		end,
	})

	local Dropdown = Tabs.Automation:AddDropdown("SampleDropdown", {
		Title = "Mode",
		Values = { "Mode A", "Mode B", "Mode C" },
		Multi = false,
		Default = 1,
	})

	Dropdown:OnChanged(function(Value)
		print("SampleDropdown:", Value)
	end)
end

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
