local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Root = script
local Creator = require(Root.Creator)
local ElementsTable = require(Root.Elements)
local Acrylic = require(Root.Acrylic)
local Components = Root.Components
local NotificationModule = require(Components.Notification)

local New = Creator.New

local function GetGuiParent()
	if RunService:IsStudio() then
		return LocalPlayer:WaitForChild("PlayerGui")
	end
	if type(gethui) == "function" then
		local ok, hui = pcall(gethui)
		if ok and hui then
			return hui
		end
	end
	local ok, coreGui = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok and coreGui then
		return coreGui
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local ProtectGui = (type(protectgui) == "function" and protectgui)
	or (syn and type(syn.protect_gui) == "function" and syn.protect_gui)
	or function() end
local GUI = New("ScreenGui", {
	Parent = GetGuiParent(),
})
ProtectGui(GUI)
NotificationModule:Init(GUI)

local Library = {
	Name = "DimensiUI",
	Author = "telatnakal",
	Credit = "telatnakal",
	Version = "1.2.6",

	OpenFrames = {},
	Options = {},
	_CleanupCallbacks = {},
	Themes = { "Dimensi" },

	Window = nil,
	WindowFrame = nil,
	Unloaded = false,

	Theme = "Dimensi",
	DialogOpen = false,
	_OpenDialogCount = 0,
	UseAcrylic = true,
	Acrylic = true,
	Transparency = true,
	MinimizeKeybind = nil,
	MinimizeKey = Enum.KeyCode.LeftControl,

	GUI = GUI,
}

function Library:SafeCallback(Function, ...)
	if Library.Unloaded or type(Function) ~= "function" then
		return false
	end

	local Success, Event = pcall(Function, ...)
	if not Success then
		local ErrorText = tostring(Event)
		local _, ErrorStart = ErrorText:find(":%d+: ")
		if ErrorStart then
			ErrorText = ErrorText:sub(ErrorStart + 1)
		end
		Library:Notify({
			Title = "Interface",
			Content = "Callback error",
			SubContent = ErrorText,
			Duration = 5,
		})
		return false
	end
	return true
end

function Library:Round(Number, Factor)
	Factor = math.max(0, math.floor(tonumber(Factor) or 0))
	local Scale = 10 ^ Factor
	if Number >= 0 then
		return math.floor(Number * Scale + 0.5) / Scale
	end
	return math.ceil(Number * Scale - 0.5) / Scale
end

local Icons = require(Root.Icons).assets
function Library:GetIcon(Name)
	if Name ~= nil and Icons["lucide-" .. Name] then
		return Icons["lucide-" .. Name]
	end
	return nil
end

local Elements = {}
Elements.__index = Elements
Elements.__namecall = function(Table, Key, ...)
	return Elements[Key](...)
end

for _, ElementComponent in ipairs(ElementsTable) do
	Elements["Add" .. ElementComponent.__type] = function(self, Idx, Config)
		ElementComponent.Container = self.Container
		ElementComponent.Type = self.Type
		ElementComponent.ScrollFrame = self.ScrollFrame
		ElementComponent.Library = Library

		return ElementComponent:New(Idx, Config)
	end
end

Library.Elements = Elements

function Library:NewInstance()
	assert(not Library.Unloaded, "DimensiUI has been destroyed")
	assert(typeof(Root) == "Instance" and Root:IsA("ModuleScript"), "DimensiUI:NewInstance requires a ModuleScript root")
	assert(Root.Archivable, "DimensiUI:NewInstance requires the root ModuleScript to be Archivable")

	local Clone
	local Success, Result = pcall(function()
		Clone = Root:Clone()
		assert(Clone, "Root ModuleScript could not be cloned")
		Clone.Name = Root.Name .. "_Instance"
		Clone.Parent = Root.Parent
		local NewLibrary = require(Clone)
		assert(type(NewLibrary) == "table" and NewLibrary ~= Library, "Cloned ModuleScript did not create an isolated library")
		NewLibrary._RootClone = Clone
		NewLibrary._InstanceParent = Root.Parent
		return NewLibrary
	end)

	if not Success then
		if Clone and typeof(Clone) == "Instance" then
			pcall(function() Clone:Destroy() end)
		end
		error("DimensiUI:NewInstance failed: " .. tostring(Result), 2)
	end

	return Result
end

function Library:CreateInstance()
	return self:NewInstance()
end

function Library:AddCleanup(Callback)
	assert(type(Callback) == "function", "AddCleanup expects a function")
	if Library.Unloaded then
		pcall(Callback)
		return false
	end
	table.insert(Library._CleanupCallbacks, Callback)
	return true
end

function Library:RegisterOption(Idx, Option)
	if Idx == nil then return false end
	assert(type(Option) == "table", "RegisterOption expects an option table")
	if Library.Unloaded then return false end
	Library.Options[Idx] = Option
	return true
end

function Library:UnregisterOption(Idx, Option)
	if Idx == nil then return false end
	if Library.Options[Idx] ~= Option then return false end
	Library.Options[Idx] = nil
	return true
end

function Library:CreateWindow(Config)
	assert(not Library.Unloaded, "DimensiUI has been destroyed")
	assert(type(Config) == "table", "Window - Config must be a table")
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Window - Missing Title")
	assert(Config.Size == nil or typeof(Config.Size) == "UDim2", "Window - Size must be a UDim2")
	assert(Config.TabWidth == nil or (type(Config.TabWidth) == "number" and Config.TabWidth == Config.TabWidth and math.abs(Config.TabWidth) < math.huge and Config.TabWidth >= 100 and Config.TabWidth <= 400), "Window - TabWidth must be between 100 and 400")
	assert(Config.Acrylic == nil or type(Config.Acrylic) == "boolean", "Window - Acrylic must be boolean")
	assert(Config.Theme == nil or type(Config.Theme) == "string", "Window - Theme must be a string")
	assert(Config.MinimizeKey == nil or (typeof(Config.MinimizeKey) == "EnumItem" and Config.MinimizeKey.EnumType == Enum.KeyCode), "Window - MinimizeKey must be a KeyCode")
	assert(Config.SubTitle == nil or type(Config.SubTitle) == "string", "Window - SubTitle must be a string")

	Config.SubTitle = Config.SubTitle or ""
	Config.TabWidth = Config.TabWidth or 170
	Config.Size = Config.Size or UDim2.fromOffset(590, 470)
	if Config.Acrylic == nil then
		Config.Acrylic = false
	end
	Config.Theme = "Dimensi"
	Config.MinimizeKey = Config.MinimizeKey or Enum.KeyCode.LeftControl

	if Library.Window then
		print("You cannot create more than one window.")
		return
	end

	local Window = require(Components.Window)({
		Parent = GUI,
		Size = Config.Size,
		Title = Config.Title,
		SubTitle = Config.SubTitle,
		TabWidth = Config.TabWidth,
	})

	Library.MinimizeKey = Config.MinimizeKey

	Library.UseAcrylic = Config.Acrylic
	if Library.UseAcrylic then
		Acrylic.init()
	end

	Library.Window = Window
	Library:SetTheme(Config.Theme)

	return Window
end

function Library:SetTheme(Value)
	if Library.Unloaded then return false end
	if Value ~= "Dimensi" then
		return false
	end
	Library.Theme = "Dimensi"
	Creator.UpdateTheme()
	return true
end

function Library:SetAccent(Color)
	if Library.Unloaded then return false end
	assert(typeof(Color) == "Color3", "DimensiUI:SetAccent expects a Color3")
	Creator.AccentOverride = Color
	Creator.UpdateTheme()
	return true
end

function Library:ResetAccent()
	if Library.Unloaded then return false end
	Creator.AccentOverride = nil
	Creator.UpdateTheme()
end

function Library:Destroy()
	if Library.Unloaded then
		return
	end
	Library.Unloaded = true
	Library.DialogOpen = false
	Library._OpenDialogCount = 0
	if Library.Window and Library.UseAcrylic and Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Model then
		pcall(function()
			Library.Window.AcrylicPaint.Model:Destroy()
		end)
	end
	for Index = #Library._CleanupCallbacks, 1, -1 do
		local Callback = table.remove(Library._CleanupCallbacks, Index)
		pcall(Callback)
	end
	if Acrylic and type(Acrylic.Destroy) == "function" then
		pcall(Acrylic.Destroy)
	end
	Creator.Disconnect()
	if Library.GUI then
		Library.GUI:Destroy()
	end
	table.clear(Library.OpenFrames)
	local TabModule = require(Components.Tab)
	TabModule.Window = nil
	TabModule.Tabs = {}
	TabModule.Containers = {}
	TabModule.SelectedTab = 0
	TabModule.TabCount = 0
	TabModule.SelectionGeneration += 1
	Library.Window = nil
	table.clear(Library.Options)
	table.clear(Library.OpenFrames)
	local RootClone = Library._RootClone
	Library._RootClone = nil
	if RootClone and typeof(RootClone) == "Instance" then
		pcall(function() RootClone:Destroy() end)
	end
end

function Library:ToggleAcrylic(Value)
	if type(Value) ~= "boolean" then return false end
	if Library.Window then
		if Library.UseAcrylic and Library.Window.AcrylicPaint then
			Library.Acrylic = not not Value
			local Paint = Library.Window.AcrylicPaint
			if Paint.Model then
				Paint.Model.Transparency = Value and 0.98 or 1
			end
			if Value then
				Acrylic.Enable()
			else
				Acrylic.Disable()
			end
		end
		return true
	end
	return false
end

function Library:ToggleTransparency(Value)
	if type(Value) ~= "boolean" then return false end
	if Library.Window and Library.Window.AcrylicPaint and Library.Window.AcrylicPaint.Frame then
		local Background = Library.Window.AcrylicPaint.Frame:FindFirstChild("Background")
		if Background then
			Background.BackgroundTransparency = Value and 0.35 or 0
		end
		return true
	end
	return false
end

function Library:Notify(Config)
	if Library.Unloaded then return nil end
	return NotificationModule:New(Config)
end

if type(getgenv) == "function" then
	pcall(function()
		local Environment = getgenv()
		if Environment.DimensiUI == nil then
			Environment.DimensiUI = Library
		end
	end)
end

return Library
