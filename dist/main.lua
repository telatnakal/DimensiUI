--[[
    DimensiUI v1.2.0 (Bundled Single-File Build)
    Standalone DimensiUI | Default Theme: Dark Purple | Author: telatnakal
]]

local __DimensiModules = {}
local __DimensiCache = {}

local function __MakeNode(path, name, parent, isModule)
	local node = {
		Name = name,
		Parent = parent,
		_path = path,
		_isModule = isModule,
		_children = {},
		_childMap = {},
	}
	function node:GetChildren()
		return self._children
	end
	function node:FindFirstChild(childName)
		return self._childMap[childName]
	end
	function node:WaitForChild(childName)
		return self._childMap[childName]
	end
	function node:IsA(className)
		if className == "ModuleScript" then
			return self._isModule
		end
		return className == "Folder" or className == "Instance"
	end
	function node:Clone()
		assert(self._path == "", "Only the DimensiUI root can be cloned")
		local function cloneTree(source, parent)
			local copy = __MakeNode(source._path, source.Name, parent, source._isModule)
			for _, child in ipairs(source._children) do
				cloneTree(child, copy)
			end
			return copy
		end
		return cloneTree(self, nil)
	end
	setmetatable(node, {
		__index = function(self, key)
			local child = rawget(self, "_childMap")[key]
			if child ~= nil then
				return child
			end
			return nil
		end,
	})
	if parent then
		table.insert(parent._children, node)
		parent._childMap[name] = node
	end
	return node
end

local __RootNode = __MakeNode("", "DimensiUI", nil, true)
local __Node_Acrylic = __MakeNode('Acrylic', 'Acrylic', __RootNode, true)
local __Node_Components = __MakeNode('Components', 'Components', __RootNode, false)
local __Node_Creator = __MakeNode('Creator', 'Creator', __RootNode, true)
local __Node_Elements = __MakeNode('Elements', 'Elements', __RootNode, true)
local __Node_Icons = __MakeNode('Icons', 'Icons', __RootNode, true)
local __Node_Packages = __MakeNode('Packages', 'Packages', __RootNode, false)
local __Node_Themes = __MakeNode('Themes', 'Themes', __RootNode, true)
local __Node_Typography = __MakeNode('Typography', 'Typography', __RootNode, true)
local __Node_Acrylic_AcrylicBlur = __MakeNode('Acrylic/AcrylicBlur', 'AcrylicBlur', __Node_Acrylic, true)
local __Node_Acrylic_AcrylicPaint = __MakeNode('Acrylic/AcrylicPaint', 'AcrylicPaint', __Node_Acrylic, true)
local __Node_Acrylic_CreateAcrylic = __MakeNode('Acrylic/CreateAcrylic', 'CreateAcrylic', __Node_Acrylic, true)
local __Node_Acrylic_Utils = __MakeNode('Acrylic/Utils', 'Utils', __Node_Acrylic, true)
local __Node_Components_Assets = __MakeNode('Components/Assets', 'Assets', __Node_Components, true)
local __Node_Components_Button = __MakeNode('Components/Button', 'Button', __Node_Components, true)
local __Node_Components_Dialog = __MakeNode('Components/Dialog', 'Dialog', __Node_Components, true)
local __Node_Components_Element = __MakeNode('Components/Element', 'Element', __Node_Components, true)
local __Node_Components_Notification = __MakeNode('Components/Notification', 'Notification', __Node_Components, true)
local __Node_Components_Section = __MakeNode('Components/Section', 'Section', __Node_Components, true)
local __Node_Components_Tab = __MakeNode('Components/Tab', 'Tab', __Node_Components, true)
local __Node_Components_Textbox = __MakeNode('Components/Textbox', 'Textbox', __Node_Components, true)
local __Node_Components_TitleBar = __MakeNode('Components/TitleBar', 'TitleBar', __Node_Components, true)
local __Node_Components_Window = __MakeNode('Components/Window', 'Window', __Node_Components, true)
local __Node_Elements_Button = __MakeNode('Elements/Button', 'Button', __Node_Elements, true)
local __Node_Elements_Colorpicker = __MakeNode('Elements/Colorpicker', 'Colorpicker', __Node_Elements, true)
local __Node_Elements_Dropdown = __MakeNode('Elements/Dropdown', 'Dropdown', __Node_Elements, true)
local __Node_Elements_Input = __MakeNode('Elements/Input', 'Input', __Node_Elements, true)
local __Node_Elements_Keybind = __MakeNode('Elements/Keybind', 'Keybind', __Node_Elements, true)
local __Node_Elements_Paragraph = __MakeNode('Elements/Paragraph', 'Paragraph', __Node_Elements, true)
local __Node_Elements_Slider = __MakeNode('Elements/Slider', 'Slider', __Node_Elements, true)
local __Node_Elements_Toggle = __MakeNode('Elements/Toggle', 'Toggle', __Node_Elements, true)
local __Node_Packages_DimensiMotion = __MakeNode('Packages/DimensiMotion', 'DimensiMotion', __Node_Packages, true)
local __Node_Themes_Dimensi = __MakeNode('Themes/Dimensi', 'Dimensi', __Node_Themes, true)
local __Node_Packages_DimensiMotion_BaseMotor = __MakeNode('Packages/DimensiMotion/BaseMotor', 'BaseMotor', __Node_Packages_DimensiMotion, true)
local __Node_Packages_DimensiMotion_GroupMotor = __MakeNode('Packages/DimensiMotion/GroupMotor', 'GroupMotor', __Node_Packages_DimensiMotion, true)
local __Node_Packages_DimensiMotion_Instant = __MakeNode('Packages/DimensiMotion/Instant', 'Instant', __Node_Packages_DimensiMotion, true)
local __Node_Packages_DimensiMotion_Signal = __MakeNode('Packages/DimensiMotion/Signal', 'Signal', __Node_Packages_DimensiMotion, true)
local __Node_Packages_DimensiMotion_SingleMotor = __MakeNode('Packages/DimensiMotion/SingleMotor', 'SingleMotor', __Node_Packages_DimensiMotion, true)
local __Node_Packages_DimensiMotion_Spring = __MakeNode('Packages/DimensiMotion/Spring', 'Spring', __Node_Packages_DimensiMotion, true)



local __RealRequire = require
local __DimensiCaches = setmetatable({}, { __mode = "k" })
local function __DimensiRequire(target)
	if type(target) == "table" and target._path ~= nil then
		local root = target
		while root.Parent do
			root = root.Parent
		end
		local cache = __DimensiCaches[root]
		if not cache then
			cache = {}
			__DimensiCaches[root] = cache
		end
		if cache[target._path] ~= nil then
			return cache[target._path]
		end
		local loader = __DimensiModules[target._path]
		assert(loader, "DimensiUI module not found: " .. tostring(target._path))
		local result = loader(target, __DimensiRequire)
		cache[target._path] = result
		return result
	end
	return __RealRequire(target)
end

__DimensiModules[''] = function(script, require)
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
	Version = "1.2.1",

	OpenFrames = {},
	Options = {},
	_CleanupCallbacks = {},
	Themes = { "Dimensi" },

	Window = nil,
	WindowFrame = nil,
	Unloaded = false,

	Theme = "Dimensi",
	DialogOpen = false,
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
end

__DimensiModules['Acrylic'] = function(script, require)
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Acrylic = {
	AcrylicBlur = require(script.AcrylicBlur),
	CreateAcrylic = require(script.CreateAcrylic),
	AcrylicPaint = require(script.AcrylicPaint),
}

local BaseEffect
local DepthOfFieldDefaults = {}
local Initialized = false
local Destroyed = false

local function CaptureDefaults()
	table.clear(DepthOfFieldDefaults)
	local function Capture(Parent)
		if not Parent then return end
		for _, Object in ipairs(Parent:GetChildren()) do
			if Object:IsA("DepthOfFieldEffect") and Object ~= BaseEffect then
				DepthOfFieldDefaults[Object] = Object.Enabled
			end
		end
	end
	Capture(Lighting)
	Capture(Workspace.CurrentCamera)
end

function Acrylic.init()
	if Destroyed then return false end
	if Initialized then
		Acrylic.Enable()
		return true
	end

	BaseEffect = Instance.new("DepthOfFieldEffect")
	BaseEffect.Name = "DimensiUI_AcrylicBlur"
	BaseEffect.FarIntensity = 0
	BaseEffect.InFocusRadius = 0.1
	BaseEffect.NearIntensity = 1
	CaptureDefaults()
	for Effect in pairs(DepthOfFieldDefaults) do
		pcall(function() Effect.Enabled = false end)
	end
	BaseEffect.Parent = Lighting
	Initialized = true
	return true
end

function Acrylic.Enable()
	if Destroyed or not BaseEffect then return false end
	for Effect in pairs(DepthOfFieldDefaults) do
		if Effect and Effect.Parent then
			pcall(function() Effect.Enabled = false end)
		end
	end
	BaseEffect.Parent = Lighting
	return true
end

function Acrylic.Disable()
	if Destroyed or not BaseEffect then return false end
	BaseEffect.Parent = nil
	for Effect, WasEnabled in pairs(DepthOfFieldDefaults) do
		if Effect and Effect.Parent then
			pcall(function() Effect.Enabled = WasEnabled end)
		end
	end
	return true
end

function Acrylic.Destroy()
	if Destroyed then return end
	Destroyed = true
	if BaseEffect then
		pcall(function() BaseEffect:Destroy() end)
		BaseEffect = nil
	end
	for Effect, WasEnabled in pairs(DepthOfFieldDefaults) do
		if Effect and Effect.Parent then
			pcall(function() Effect.Enabled = WasEnabled end)
		end
	end
	table.clear(DepthOfFieldDefaults)
	Initialized = false
end

return Acrylic
end

__DimensiModules['Creator'] = function(script, require)
local Root = script.Parent
local Themes = require(Root.Themes)
local Motion = require(Root.Packages.DimensiMotion)
local Typography = require(Root.Typography)

local Creator = {
	Registry = {},
	Signals = {},
	TransparencyMotors = {},
	AccentOverride = nil,
	Motors = {},
	Models = {},
	NextThemeIndex = 0,
	DefaultProperties = {
		ScreenGui = {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		},
		Frame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ScrollingFrame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ScrollBarImageColor3 = Color3.new(0, 0, 0),
		},
		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			FontFace = Typography.Regular,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			TextSize = 14,
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
			Font = Enum.Font.SourceSans,
			FontFace = Typography.Regular,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.SourceSans,
			FontFace = Typography.Regular,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		ImageLabel = {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ImageButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
		},
		CanvasGroup = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
	},
}

local function ApplyCustomProps(Object, Props)
	if Props.ThemeTag then
		Creator.AddThemeObject(Object, Props.ThemeTag)
	end
end

function Creator.TrackConnection(Connection)
	if Connection and typeof(Connection) == "RBXScriptConnection" then
		table.insert(Creator.Signals, Connection)
		return Connection
	end
	return nil
end

function Creator.AddSignal(Signal, Function, Owner)
	assert(Signal and type(Function) == "function", "Creator.AddSignal expects a signal and callback")
	local Connection = Creator.TrackConnection(Signal:Connect(Function))
	if Owner and typeof(Owner) == "Instance" then
		local Cleanup
		Cleanup = Owner.Destroying:Connect(function()
			Creator.DisconnectSignal(Connection)
			Creator.DisconnectSignal(Cleanup)
		end)
		Creator.TrackConnection(Cleanup)
	end
	return Connection
end

function Creator.TrackMotor(Motor, Owner)
	if not Motor or type(Motor.destroy) ~= "function" then return nil end
	table.insert(Creator.Motors, Motor)
	if Owner and typeof(Owner) == "Instance" then
		local connection
		connection = Creator.TrackConnection(Owner.Destroying:Connect(function()
			Creator.DisconnectSignal(connection)
			Creator.ReleaseMotor(Motor)
		end))
	end
	return Motor
end

function Creator.ReleaseMotor(Motor)
	if not Motor then return end
	for i = #Creator.Motors, 1, -1 do
		if Creator.Motors[i] == Motor then table.remove(Creator.Motors, i) end
	end
	for i = #Creator.TransparencyMotors, 1, -1 do
		if Creator.TransparencyMotors[i] == Motor then table.remove(Creator.TransparencyMotors, i) end
	end
	pcall(function() Motor:destroy() end)
end


function Creator.TrackModel(Model)
	if not Model or typeof(Model) ~= "Instance" then return nil end
	table.insert(Creator.Models, Model)
	local connection
	connection = Model.Destroying:Connect(function()
		if connection then pcall(function() connection:Disconnect() end) end
		for i = #Creator.Models, 1, -1 do
			if Creator.Models[i] == Model then table.remove(Creator.Models, i) end
		end
	end)
	return Model
end

function Creator.DisconnectSignal(Connection)
	if not Connection then return end
	for Index = #Creator.Signals, 1, -1 do
		if Creator.Signals[Index] == Connection then
			table.remove(Creator.Signals, Index)
			break
		end
	end
	pcall(function() Connection:Disconnect() end)
end

function Creator.Disconnect()
	for Idx = #Creator.Signals, 1, -1 do
		local Connection = table.remove(Creator.Signals, Idx)
		pcall(function() Connection:Disconnect() end)
	end
	for Idx = #Creator.Motors, 1, -1 do
		local Motor = table.remove(Creator.Motors, Idx)
		pcall(function() Motor:destroy() end)
	end
	for Idx = #Creator.Models, 1, -1 do
		local Model = table.remove(Creator.Models, Idx)
		pcall(function() Model:Destroy() end)
	end
	Creator.Registry = {}
	Creator.TransparencyMotors = {}
	Creator.AccentOverride = nil
	Creator.NextThemeIndex = 0
end

function Creator.GetThemeProperty(Property)
	if Property == "Accent" and Creator.AccentOverride then
		return Creator.AccentOverride
	end
	local Library = require(Root)
	local Theme = Themes.Dimensi
	local Value = Theme and Theme[Property]
	if Value ~= nil then
		return Value
	end
	return nil
end

function Creator.UpdateTheme()
	for Instance, Object in next, Creator.Registry do
		for Property, ColorIdx in next, Object.Properties do
			local ok, err = pcall(function()
				Instance[Property] = Creator.GetThemeProperty(ColorIdx)
			end)
			if not ok then
				warn("DimensiUI theme property update failed:", err)
			Creator.Registry[Instance] = nil
			break
			end
		end
	end

	for _, Motor in next, Creator.TransparencyMotors do
		if Motor and not Motor._destroyed then
			Motor:setGoal(Motion.Instant.new(Creator.GetThemeProperty("ElementTransparency")))
		end
	end
end

function Creator.AddThemeObject(Object, Properties)
	assert(typeof(Object) == "Instance", "Creator.AddThemeObject expects an Instance")
	assert(type(Properties) == "table", "Creator.AddThemeObject expects a property map")
	Creator.NextThemeIndex += 1
	local Idx = Creator.NextThemeIndex
	local Data = {
		Object = Object,
		Properties = Properties,
		Idx = Idx,
	}

	Creator.Registry[Object] = Data
	local DestroyConnection
	DestroyConnection = Creator.TrackConnection(Object.Destroying:Connect(function()
		Creator.Registry[Object] = nil
		Creator.DisconnectSignal(DestroyConnection)
	end))
	Creator.UpdateTheme()
	return Object
end

function Creator.OverrideTag(Object, Properties)
	local Entry = Creator.Registry[Object]
	if not Entry or type(Properties) ~= "table" then
		return false
	end
	Entry.Properties = Properties
	Creator.UpdateTheme()
	return true
end

function Creator.New(Name, Properties, Children)
	assert(type(Name) == "string" and Name ~= "", "Creator.New expects an Instance class name")
	assert(Properties == nil or type(Properties) == "table", "Creator.New Properties must be a table")
	assert(Children == nil or type(Children) == "table", "Creator.New Children must be a table")
	local Object = Instance.new(Name)

	-- Default properties
	for Name, Value in next, Creator.DefaultProperties[Name] or {} do
		Object[Name] = Value
	end

	-- Properties
	for Name, Value in next, Properties or {} do
		if Name ~= "ThemeTag" then
			Object[Name] = Value
		end
	end

	-- Children
	for _, Child in next, Children or {} do
		Child.Parent = Object
	end

	ApplyCustomProps(Object, Properties)
	return Object
end

function Creator.SpringMotor(Initial, Instance, Prop, IgnoreDialogCheck, ResetOnThemeChange)
	IgnoreDialogCheck = IgnoreDialogCheck or false
	ResetOnThemeChange = ResetOnThemeChange or false
	local Motor = Creator.TrackMotor(Motion.SingleMotor.new(Initial), Instance)
	Motor:onStep(function(value)
		Instance[Prop] = value
	end)

	if ResetOnThemeChange then
		table.insert(Creator.TransparencyMotors, Motor)
	end

	local function SetValue(Value, Ignore)
		Ignore = Ignore or false
		if not IgnoreDialogCheck then
			if not Ignore then
				if Prop == "BackgroundTransparency" and require(Root).DialogOpen then
					return
				end
			end
		end
		Motor:setGoal(Motion.Spring.new(Value, { frequency = 8 }))
	end

	return Motor, SetValue
end

return Creator
end

__DimensiModules['Elements'] = function(script, require)
local Elements = {}

for _, Theme in next, script:GetChildren() do
	table.insert(Elements, require(Theme))
end

return Elements
end

__DimensiModules['Icons'] = function(script, require)
-- This file was @generated by Tarmac. It is not intended for manual editing.
return {
	assets = {
		["lucide-accessibility"] = "rbxassetid://10709751939",
		["lucide-activity"] = "rbxassetid://10709752035",
		["lucide-air-vent"] = "rbxassetid://10709752131",
		["lucide-airplay"] = "rbxassetid://10709752254",
		["lucide-alarm-check"] = "rbxassetid://10709752405",
		["lucide-alarm-clock"] = "rbxassetid://10709752630",
		["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
		["lucide-alarm-minus"] = "rbxassetid://10709752732",
		["lucide-alarm-plus"] = "rbxassetid://10709752825",
		["lucide-album"] = "rbxassetid://10709752906",
		["lucide-alert-circle"] = "rbxassetid://10709752996",
		["lucide-alert-octagon"] = "rbxassetid://10709753064",
		["lucide-alert-triangle"] = "rbxassetid://10709753149",
		["lucide-align-center"] = "rbxassetid://10709753570",
		["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
		["lucide-align-center-vertical"] = "rbxassetid://10709753421",
		["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
		["lucide-align-end-vertical"] = "rbxassetid://10709753808",
		["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
		["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
		["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
		["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
		["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
		["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
		["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
		["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
		["lucide-align-justify"] = "rbxassetid://10709759610",
		["lucide-align-left"] = "rbxassetid://10709759764",
		["lucide-align-right"] = "rbxassetid://10709759895",
		["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
		["lucide-align-start-vertical"] = "rbxassetid://10709760244",
		["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
		["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
		["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
		["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
		["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
		["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
		["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
		["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
		["lucide-anchor"] = "rbxassetid://10709761530",
		["lucide-angry"] = "rbxassetid://10709761629",
		["lucide-annoyed"] = "rbxassetid://10709761722",
		["lucide-aperture"] = "rbxassetid://10709761813",
		["lucide-apple"] = "rbxassetid://10709761889",
		["lucide-archive"] = "rbxassetid://10709762233",
		["lucide-archive-restore"] = "rbxassetid://10709762058",
		["lucide-armchair"] = "rbxassetid://10709762327",
		["lucide-arrow-big-down"] = "rbxassetid://10747796644",
		["lucide-arrow-big-left"] = "rbxassetid://10709762574",
		["lucide-arrow-big-right"] = "rbxassetid://10709762727",
		["lucide-arrow-big-up"] = "rbxassetid://10709762879",
		["lucide-arrow-down"] = "rbxassetid://10709767827",
		["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
		["lucide-arrow-down-left"] = "rbxassetid://10709767656",
		["lucide-arrow-down-right"] = "rbxassetid://10709767750",
		["lucide-arrow-left"] = "rbxassetid://10709768114",
		["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
		["lucide-arrow-left-right"] = "rbxassetid://10709768019",
		["lucide-arrow-right"] = "rbxassetid://10709768347",
		["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
		["lucide-arrow-up"] = "rbxassetid://10709768939",
		["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
		["lucide-arrow-up-down"] = "rbxassetid://10709768538",
		["lucide-arrow-up-left"] = "rbxassetid://10709768661",
		["lucide-arrow-up-right"] = "rbxassetid://10709768787",
		["lucide-asterisk"] = "rbxassetid://10709769095",
		["lucide-at-sign"] = "rbxassetid://10709769286",
		["lucide-award"] = "rbxassetid://10709769406",
		["lucide-axe"] = "rbxassetid://10709769508",
		["lucide-axis-3d"] = "rbxassetid://10709769598",
		["lucide-baby"] = "rbxassetid://10709769732",
		["lucide-backpack"] = "rbxassetid://10709769841",
		["lucide-baggage-claim"] = "rbxassetid://10709769935",
		["lucide-banana"] = "rbxassetid://10709770005",
		["lucide-banknote"] = "rbxassetid://10709770178",
		["lucide-bar-chart"] = "rbxassetid://10709773755",
		["lucide-bar-chart-2"] = "rbxassetid://10709770317",
		["lucide-bar-chart-3"] = "rbxassetid://10709770431",
		["lucide-bar-chart-4"] = "rbxassetid://10709770560",
		["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
		["lucide-barcode"] = "rbxassetid://10747360675",
		["lucide-baseline"] = "rbxassetid://10709773863",
		["lucide-bath"] = "rbxassetid://10709773963",
		["lucide-battery"] = "rbxassetid://10709774640",
		["lucide-battery-charging"] = "rbxassetid://10709774068",
		["lucide-battery-full"] = "rbxassetid://10709774206",
		["lucide-battery-low"] = "rbxassetid://10709774370",
		["lucide-battery-medium"] = "rbxassetid://10709774513",
		["lucide-beaker"] = "rbxassetid://10709774756",
		["lucide-bed"] = "rbxassetid://10709775036",
		["lucide-bed-double"] = "rbxassetid://10709774864",
		["lucide-bed-single"] = "rbxassetid://10709774968",
		["lucide-beer"] = "rbxassetid://10709775167",
		["lucide-bell"] = "rbxassetid://10709775704",
		["lucide-bell-minus"] = "rbxassetid://10709775241",
		["lucide-bell-off"] = "rbxassetid://10709775320",
		["lucide-bell-plus"] = "rbxassetid://10709775448",
		["lucide-bell-ring"] = "rbxassetid://10709775560",
		["lucide-bike"] = "rbxassetid://10709775894",
		["lucide-binary"] = "rbxassetid://10709776050",
		["lucide-bitcoin"] = "rbxassetid://10709776126",
		["lucide-bluetooth"] = "rbxassetid://10709776655",
		["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
		["lucide-bluetooth-off"] = "rbxassetid://10709776344",
		["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
		["lucide-bold"] = "rbxassetid://10747813908",
		["lucide-bomb"] = "rbxassetid://10709781460",
		["lucide-bone"] = "rbxassetid://10709781605",
		["lucide-book"] = "rbxassetid://10709781824",
		["lucide-book-open"] = "rbxassetid://10709781717",
		["lucide-bookmark"] = "rbxassetid://10709782154",
		["lucide-bookmark-minus"] = "rbxassetid://10709781919",
		["lucide-bookmark-plus"] = "rbxassetid://10709782044",
		["lucide-bot"] = "rbxassetid://10709782230",
		["lucide-box"] = "rbxassetid://10709782497",
		["lucide-box-select"] = "rbxassetid://10709782342",
		["lucide-boxes"] = "rbxassetid://10709782582",
		["lucide-briefcase"] = "rbxassetid://10709782662",
		["lucide-brush"] = "rbxassetid://10709782758",
		["lucide-bug"] = "rbxassetid://10709782845",
		["lucide-building"] = "rbxassetid://10709783051",
		["lucide-building-2"] = "rbxassetid://10709782939",
		["lucide-bus"] = "rbxassetid://10709783137",
		["lucide-cake"] = "rbxassetid://10709783217",
		["lucide-calculator"] = "rbxassetid://10709783311",
		["lucide-calendar"] = "rbxassetid://10709789505",
		["lucide-calendar-check"] = "rbxassetid://10709783474",
		["lucide-calendar-check-2"] = "rbxassetid://10709783392",
		["lucide-calendar-clock"] = "rbxassetid://10709783577",
		["lucide-calendar-days"] = "rbxassetid://10709783673",
		["lucide-calendar-heart"] = "rbxassetid://10709783835",
		["lucide-calendar-minus"] = "rbxassetid://10709783959",
		["lucide-calendar-off"] = "rbxassetid://10709788784",
		["lucide-calendar-plus"] = "rbxassetid://10709788937",
		["lucide-calendar-range"] = "rbxassetid://10709789053",
		["lucide-calendar-search"] = "rbxassetid://10709789200",
		["lucide-calendar-x"] = "rbxassetid://10709789407",
		["lucide-calendar-x-2"] = "rbxassetid://10709789329",
		["lucide-camera"] = "rbxassetid://10709789686",
		["lucide-camera-off"] = "rbxassetid://10747822677",
		["lucide-car"] = "rbxassetid://10709789810",
		["lucide-carrot"] = "rbxassetid://10709789960",
		["lucide-cast"] = "rbxassetid://10709790097",
		["lucide-charge"] = "rbxassetid://10709790202",
		["lucide-check"] = "rbxassetid://10709790644",
		["lucide-check-circle"] = "rbxassetid://10709790387",
		["lucide-check-circle-2"] = "rbxassetid://10709790298",
		["lucide-check-square"] = "rbxassetid://10709790537",
		["lucide-chef-hat"] = "rbxassetid://10709790757",
		["lucide-cherry"] = "rbxassetid://10709790875",
		["lucide-chevron-down"] = "rbxassetid://10709790948",
		["lucide-chevron-first"] = "rbxassetid://10709791015",
		["lucide-chevron-last"] = "rbxassetid://10709791130",
		["lucide-chevron-left"] = "rbxassetid://10709791281",
		["lucide-chevron-right"] = "rbxassetid://10709791437",
		["lucide-chevron-up"] = "rbxassetid://10709791523",
		["lucide-chevrons-down"] = "rbxassetid://10709796864",
		["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
		["lucide-chevrons-left"] = "rbxassetid://10709797151",
		["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
		["lucide-chevrons-right"] = "rbxassetid://10709797382",
		["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
		["lucide-chevrons-up"] = "rbxassetid://10709797622",
		["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
		["lucide-chrome"] = "rbxassetid://10709797725",
		["lucide-circle"] = "rbxassetid://10709798174",
		["lucide-circle-dot"] = "rbxassetid://10709797837",
		["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
		["lucide-circle-slashed"] = "rbxassetid://10709798100",
		["lucide-citrus"] = "rbxassetid://10709798276",
		["lucide-clapperboard"] = "rbxassetid://10709798350",
		["lucide-clipboard"] = "rbxassetid://10709799288",
		["lucide-clipboard-check"] = "rbxassetid://10709798443",
		["lucide-clipboard-copy"] = "rbxassetid://10709798574",
		["lucide-clipboard-edit"] = "rbxassetid://10709798682",
		["lucide-clipboard-list"] = "rbxassetid://10709798792",
		["lucide-clipboard-signature"] = "rbxassetid://10709798890",
		["lucide-clipboard-type"] = "rbxassetid://10709798999",
		["lucide-clipboard-x"] = "rbxassetid://10709799124",
		["lucide-clock"] = "rbxassetid://10709805144",
		["lucide-clock-1"] = "rbxassetid://10709799535",
		["lucide-clock-10"] = "rbxassetid://10709799718",
		["lucide-clock-11"] = "rbxassetid://10709799818",
		["lucide-clock-12"] = "rbxassetid://10709799962",
		["lucide-clock-2"] = "rbxassetid://10709803876",
		["lucide-clock-3"] = "rbxassetid://10709803989",
		["lucide-clock-4"] = "rbxassetid://10709804164",
		["lucide-clock-5"] = "rbxassetid://10709804291",
		["lucide-clock-6"] = "rbxassetid://10709804435",
		["lucide-clock-7"] = "rbxassetid://10709804599",
		["lucide-clock-8"] = "rbxassetid://10709804784",
		["lucide-clock-9"] = "rbxassetid://10709804996",
		["lucide-cloud"] = "rbxassetid://10709806740",
		["lucide-cloud-cog"] = "rbxassetid://10709805262",
		["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
		["lucide-cloud-fog"] = "rbxassetid://10709805477",
		["lucide-cloud-hail"] = "rbxassetid://10709805596",
		["lucide-cloud-lightning"] = "rbxassetid://10709805727",
		["lucide-cloud-moon"] = "rbxassetid://10709805942",
		["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
		["lucide-cloud-off"] = "rbxassetid://10709806060",
		["lucide-cloud-rain"] = "rbxassetid://10709806277",
		["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
		["lucide-cloud-snow"] = "rbxassetid://10709806374",
		["lucide-cloud-sun"] = "rbxassetid://10709806631",
		["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
		["lucide-cloudy"] = "rbxassetid://10709806859",
		["lucide-clover"] = "rbxassetid://10709806995",
		["lucide-code"] = "rbxassetid://10709810463",
		["lucide-code-2"] = "rbxassetid://10709807111",
		["lucide-codepen"] = "rbxassetid://10709810534",
		["lucide-codesandbox"] = "rbxassetid://10709810676",
		["lucide-coffee"] = "rbxassetid://10709810814",
		["lucide-cog"] = "rbxassetid://10709810948",
		["lucide-coins"] = "rbxassetid://10709811110",
		["lucide-columns"] = "rbxassetid://10709811261",
		["lucide-command"] = "rbxassetid://10709811365",
		["lucide-compass"] = "rbxassetid://10709811445",
		["lucide-component"] = "rbxassetid://10709811595",
		["lucide-concierge-bell"] = "rbxassetid://10709811706",
		["lucide-connection"] = "rbxassetid://10747361219",
		["lucide-contact"] = "rbxassetid://10709811834",
		["lucide-contrast"] = "rbxassetid://10709811939",
		["lucide-cookie"] = "rbxassetid://10709812067",
		["lucide-copy"] = "rbxassetid://10709812159",
		["lucide-copyleft"] = "rbxassetid://10709812251",
		["lucide-copyright"] = "rbxassetid://10709812311",
		["lucide-corner-down-left"] = "rbxassetid://10709812396",
		["lucide-corner-down-right"] = "rbxassetid://10709812485",
		["lucide-corner-left-down"] = "rbxassetid://10709812632",
		["lucide-corner-left-up"] = "rbxassetid://10709812784",
		["lucide-corner-right-down"] = "rbxassetid://10709812939",
		["lucide-corner-right-up"] = "rbxassetid://10709813094",
		["lucide-corner-up-left"] = "rbxassetid://10709813185",
		["lucide-corner-up-right"] = "rbxassetid://10709813281",
		["lucide-cpu"] = "rbxassetid://10709813383",
		["lucide-croissant"] = "rbxassetid://10709818125",
		["lucide-crop"] = "rbxassetid://10709818245",
		["lucide-cross"] = "rbxassetid://10709818399",
		["lucide-crosshair"] = "rbxassetid://10709818534",
		["lucide-crown"] = "rbxassetid://10709818626",
		["lucide-cup-soda"] = "rbxassetid://10709818763",
		["lucide-curly-braces"] = "rbxassetid://10709818847",
		["lucide-currency"] = "rbxassetid://10709818931",
		["lucide-database"] = "rbxassetid://10709818996",
		["lucide-delete"] = "rbxassetid://10709819059",
		["lucide-diamond"] = "rbxassetid://10709819149",
		["lucide-dice-1"] = "rbxassetid://10709819266",
		["lucide-dice-2"] = "rbxassetid://10709819361",
		["lucide-dice-3"] = "rbxassetid://10709819508",
		["lucide-dice-4"] = "rbxassetid://10709819670",
		["lucide-dice-5"] = "rbxassetid://10709819801",
		["lucide-dice-6"] = "rbxassetid://10709819896",
		["lucide-dices"] = "rbxassetid://10723343321",
		["lucide-diff"] = "rbxassetid://10723343416",
		["lucide-disc"] = "rbxassetid://10723343537",
		["lucide-divide"] = "rbxassetid://10723343805",
		["lucide-divide-circle"] = "rbxassetid://10723343636",
		["lucide-divide-square"] = "rbxassetid://10723343737",
		["lucide-dollar-sign"] = "rbxassetid://10723343958",
		["lucide-download"] = "rbxassetid://10723344270",
		["lucide-download-cloud"] = "rbxassetid://10723344088",
		["lucide-droplet"] = "rbxassetid://10723344432",
		["lucide-droplets"] = "rbxassetid://10734883356",
		["lucide-drumstick"] = "rbxassetid://10723344737",
		["lucide-edit"] = "rbxassetid://10734883598",
		["lucide-edit-2"] = "rbxassetid://10723344885",
		["lucide-edit-3"] = "rbxassetid://10723345088",
		["lucide-egg"] = "rbxassetid://10723345518",
		["lucide-egg-fried"] = "rbxassetid://10723345347",
		["lucide-electricity"] = "rbxassetid://10723345749",
		["lucide-electricity-off"] = "rbxassetid://10723345643",
		["lucide-equal"] = "rbxassetid://10723345990",
		["lucide-equal-not"] = "rbxassetid://10723345866",
		["lucide-eraser"] = "rbxassetid://10723346158",
		["lucide-euro"] = "rbxassetid://10723346372",
		["lucide-expand"] = "rbxassetid://10723346553",
		["lucide-external-link"] = "rbxassetid://10723346684",
		["lucide-eye"] = "rbxassetid://10723346959",
		["lucide-eye-off"] = "rbxassetid://10723346871",
		["lucide-factory"] = "rbxassetid://10723347051",
		["lucide-fan"] = "rbxassetid://10723354359",
		["lucide-fast-forward"] = "rbxassetid://10723354521",
		["lucide-feather"] = "rbxassetid://10723354671",
		["lucide-figma"] = "rbxassetid://10723354801",
		["lucide-file"] = "rbxassetid://10723374641",
		["lucide-file-archive"] = "rbxassetid://10723354921",
		["lucide-file-audio"] = "rbxassetid://10723355148",
		["lucide-file-audio-2"] = "rbxassetid://10723355026",
		["lucide-file-axis-3d"] = "rbxassetid://10723355272",
		["lucide-file-badge"] = "rbxassetid://10723355622",
		["lucide-file-badge-2"] = "rbxassetid://10723355451",
		["lucide-file-bar-chart"] = "rbxassetid://10723355887",
		["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
		["lucide-file-box"] = "rbxassetid://10723355989",
		["lucide-file-check"] = "rbxassetid://10723356210",
		["lucide-file-check-2"] = "rbxassetid://10723356100",
		["lucide-file-clock"] = "rbxassetid://10723356329",
		["lucide-file-code"] = "rbxassetid://10723356507",
		["lucide-file-cog"] = "rbxassetid://10723356830",
		["lucide-file-cog-2"] = "rbxassetid://10723356676",
		["lucide-file-diff"] = "rbxassetid://10723357039",
		["lucide-file-digit"] = "rbxassetid://10723357151",
		["lucide-file-down"] = "rbxassetid://10723357322",
		["lucide-file-edit"] = "rbxassetid://10723357495",
		["lucide-file-heart"] = "rbxassetid://10723357637",
		["lucide-file-image"] = "rbxassetid://10723357790",
		["lucide-file-input"] = "rbxassetid://10723357933",
		["lucide-file-json"] = "rbxassetid://10723364435",
		["lucide-file-json-2"] = "rbxassetid://10723364361",
		["lucide-file-key"] = "rbxassetid://10723364605",
		["lucide-file-key-2"] = "rbxassetid://10723364515",
		["lucide-file-line-chart"] = "rbxassetid://10723364725",
		["lucide-file-lock"] = "rbxassetid://10723364957",
		["lucide-file-lock-2"] = "rbxassetid://10723364861",
		["lucide-file-minus"] = "rbxassetid://10723365254",
		["lucide-file-minus-2"] = "rbxassetid://10723365086",
		["lucide-file-output"] = "rbxassetid://10723365457",
		["lucide-file-pie-chart"] = "rbxassetid://10723365598",
		["lucide-file-plus"] = "rbxassetid://10723365877",
		["lucide-file-plus-2"] = "rbxassetid://10723365766",
		["lucide-file-question"] = "rbxassetid://10723365987",
		["lucide-file-scan"] = "rbxassetid://10723366167",
		["lucide-file-search"] = "rbxassetid://10723366550",
		["lucide-file-search-2"] = "rbxassetid://10723366340",
		["lucide-file-signature"] = "rbxassetid://10723366741",
		["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
		["lucide-file-symlink"] = "rbxassetid://10723367098",
		["lucide-file-terminal"] = "rbxassetid://10723367244",
		["lucide-file-text"] = "rbxassetid://10723367380",
		["lucide-file-type"] = "rbxassetid://10723367606",
		["lucide-file-type-2"] = "rbxassetid://10723367509",
		["lucide-file-up"] = "rbxassetid://10723367734",
		["lucide-file-video"] = "rbxassetid://10723373884",
		["lucide-file-video-2"] = "rbxassetid://10723367834",
		["lucide-file-volume"] = "rbxassetid://10723374172",
		["lucide-file-volume-2"] = "rbxassetid://10723374030",
		["lucide-file-warning"] = "rbxassetid://10723374276",
		["lucide-file-x"] = "rbxassetid://10723374544",
		["lucide-file-x-2"] = "rbxassetid://10723374378",
		["lucide-files"] = "rbxassetid://10723374759",
		["lucide-film"] = "rbxassetid://10723374981",
		["lucide-filter"] = "rbxassetid://10723375128",
		["lucide-fingerprint"] = "rbxassetid://10723375250",
		["lucide-flag"] = "rbxassetid://10723375890",
		["lucide-flag-off"] = "rbxassetid://10723375443",
		["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
		["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
		["lucide-flame"] = "rbxassetid://10723376114",
		["lucide-flashlight"] = "rbxassetid://10723376471",
		["lucide-flashlight-off"] = "rbxassetid://10723376365",
		["lucide-flask-conical"] = "rbxassetid://10734883986",
		["lucide-flask-round"] = "rbxassetid://10723376614",
		["lucide-flip-horizontal"] = "rbxassetid://10723376884",
		["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
		["lucide-flip-vertical"] = "rbxassetid://10723377138",
		["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
		["lucide-flower"] = "rbxassetid://10747830374",
		["lucide-flower-2"] = "rbxassetid://10723377305",
		["lucide-focus"] = "rbxassetid://10723377537",
		["lucide-folder"] = "rbxassetid://10723387563",
		["lucide-folder-archive"] = "rbxassetid://10723384478",
		["lucide-folder-check"] = "rbxassetid://10723384605",
		["lucide-folder-clock"] = "rbxassetid://10723384731",
		["lucide-folder-closed"] = "rbxassetid://10723384893",
		["lucide-folder-cog"] = "rbxassetid://10723385213",
		["lucide-folder-cog-2"] = "rbxassetid://10723385036",
		["lucide-folder-down"] = "rbxassetid://10723385338",
		["lucide-folder-edit"] = "rbxassetid://10723385445",
		["lucide-folder-heart"] = "rbxassetid://10723385545",
		["lucide-folder-input"] = "rbxassetid://10723385721",
		["lucide-folder-key"] = "rbxassetid://10723385848",
		["lucide-folder-lock"] = "rbxassetid://10723386005",
		["lucide-folder-minus"] = "rbxassetid://10723386127",
		["lucide-folder-open"] = "rbxassetid://10723386277",
		["lucide-folder-output"] = "rbxassetid://10723386386",
		["lucide-folder-plus"] = "rbxassetid://10723386531",
		["lucide-folder-search"] = "rbxassetid://10723386787",
		["lucide-folder-search-2"] = "rbxassetid://10723386674",
		["lucide-folder-symlink"] = "rbxassetid://10723386930",
		["lucide-folder-tree"] = "rbxassetid://10723387085",
		["lucide-folder-up"] = "rbxassetid://10723387265",
		["lucide-folder-x"] = "rbxassetid://10723387448",
		["lucide-folders"] = "rbxassetid://10723387721",
		["lucide-form-input"] = "rbxassetid://10723387841",
		["lucide-forward"] = "rbxassetid://10723388016",
		["lucide-frame"] = "rbxassetid://10723394389",
		["lucide-framer"] = "rbxassetid://10723394565",
		["lucide-frown"] = "rbxassetid://10723394681",
		["lucide-fuel"] = "rbxassetid://10723394846",
		["lucide-function-square"] = "rbxassetid://10723395041",
		["lucide-gamepad"] = "rbxassetid://10723395457",
		["lucide-gamepad-2"] = "rbxassetid://10723395215",
		["lucide-gauge"] = "rbxassetid://10723395708",
		["lucide-gavel"] = "rbxassetid://10723395896",
		["lucide-gem"] = "rbxassetid://10723396000",
		["lucide-ghost"] = "rbxassetid://10723396107",
		["lucide-gift"] = "rbxassetid://10723396402",
		["lucide-gift-card"] = "rbxassetid://10723396225",
		["lucide-git-branch"] = "rbxassetid://10723396676",
		["lucide-git-branch-plus"] = "rbxassetid://10723396542",
		["lucide-git-commit"] = "rbxassetid://10723396812",
		["lucide-git-compare"] = "rbxassetid://10723396954",
		["lucide-git-fork"] = "rbxassetid://10723397049",
		["lucide-git-merge"] = "rbxassetid://10723397165",
		["lucide-git-pull-request"] = "rbxassetid://10723397431",
		["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
		["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
		["lucide-glass"] = "rbxassetid://10723397788",
		["lucide-glass-2"] = "rbxassetid://10723397529",
		["lucide-glass-water"] = "rbxassetid://10723397678",
		["lucide-glasses"] = "rbxassetid://10723397895",
		["lucide-globe"] = "rbxassetid://10723404337",
		["lucide-globe-2"] = "rbxassetid://10723398002",
		["lucide-grab"] = "rbxassetid://10723404472",
		["lucide-graduation-cap"] = "rbxassetid://10723404691",
		["lucide-grape"] = "rbxassetid://10723404822",
		["lucide-grid"] = "rbxassetid://10723404936",
		["lucide-grip-horizontal"] = "rbxassetid://10723405089",
		["lucide-grip-vertical"] = "rbxassetid://10723405236",
		["lucide-hammer"] = "rbxassetid://10723405360",
		["lucide-hand"] = "rbxassetid://10723405649",
		["lucide-hand-metal"] = "rbxassetid://10723405508",
		["lucide-hard-drive"] = "rbxassetid://10723405749",
		["lucide-hard-hat"] = "rbxassetid://10723405859",
		["lucide-hash"] = "rbxassetid://10723405975",
		["lucide-haze"] = "rbxassetid://10723406078",
		["lucide-headphones"] = "rbxassetid://10723406165",
		["lucide-heart"] = "rbxassetid://10723406885",
		["lucide-heart-crack"] = "rbxassetid://10723406299",
		["lucide-heart-handshake"] = "rbxassetid://10723406480",
		["lucide-heart-off"] = "rbxassetid://10723406662",
		["lucide-heart-pulse"] = "rbxassetid://10723406795",
		["lucide-help-circle"] = "rbxassetid://10723406988",
		["lucide-hexagon"] = "rbxassetid://10723407092",
		["lucide-highlighter"] = "rbxassetid://10723407192",
		["lucide-history"] = "rbxassetid://10723407335",
		["lucide-home"] = "rbxassetid://10723407389",
		["lucide-hourglass"] = "rbxassetid://10723407498",
		["lucide-ice-cream"] = "rbxassetid://10723414308",
		["lucide-image"] = "rbxassetid://10723415040",
		["lucide-image-minus"] = "rbxassetid://10723414487",
		["lucide-image-off"] = "rbxassetid://10723414677",
		["lucide-image-plus"] = "rbxassetid://10723414827",
		["lucide-import"] = "rbxassetid://10723415205",
		["lucide-inbox"] = "rbxassetid://10723415335",
		["lucide-indent"] = "rbxassetid://10723415494",
		["lucide-indian-rupee"] = "rbxassetid://10723415642",
		["lucide-infinity"] = "rbxassetid://10723415766",
		["lucide-info"] = "rbxassetid://10723415903",
		["lucide-inspect"] = "rbxassetid://10723416057",
		["lucide-italic"] = "rbxassetid://10723416195",
		["lucide-japanese-yen"] = "rbxassetid://10723416363",
		["lucide-joystick"] = "rbxassetid://10723416527",
		["lucide-key"] = "rbxassetid://10723416652",
		["lucide-keyboard"] = "rbxassetid://10723416765",
		["lucide-lamp"] = "rbxassetid://10723417513",
		["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
		["lucide-lamp-desk"] = "rbxassetid://10723417016",
		["lucide-lamp-floor"] = "rbxassetid://10723417131",
		["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
		["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
		["lucide-landmark"] = "rbxassetid://10723417608",
		["lucide-languages"] = "rbxassetid://10723417703",
		["lucide-laptop"] = "rbxassetid://10723423881",
		["lucide-laptop-2"] = "rbxassetid://10723417797",
		["lucide-lasso"] = "rbxassetid://10723424235",
		["lucide-lasso-select"] = "rbxassetid://10723424058",
		["lucide-laugh"] = "rbxassetid://10723424372",
		["lucide-layers"] = "rbxassetid://10723424505",
		["lucide-layout"] = "rbxassetid://10723425376",
		["lucide-layout-dashboard"] = "rbxassetid://10723424646",
		["lucide-layout-grid"] = "rbxassetid://10723424838",
		["lucide-layout-list"] = "rbxassetid://10723424963",
		["lucide-layout-template"] = "rbxassetid://10723425187",
		["lucide-leaf"] = "rbxassetid://10723425539",
		["lucide-library"] = "rbxassetid://10723425615",
		["lucide-life-buoy"] = "rbxassetid://10723425685",
		["lucide-lightbulb"] = "rbxassetid://10723425852",
		["lucide-lightbulb-off"] = "rbxassetid://10723425762",
		["lucide-line-chart"] = "rbxassetid://10723426393",
		["lucide-link"] = "rbxassetid://10723426722",
		["lucide-link-2"] = "rbxassetid://10723426595",
		["lucide-link-2-off"] = "rbxassetid://10723426513",
		["lucide-list"] = "rbxassetid://10723433811",
		["lucide-list-checks"] = "rbxassetid://10734884548",
		["lucide-list-end"] = "rbxassetid://10723426886",
		["lucide-list-minus"] = "rbxassetid://10723426986",
		["lucide-list-music"] = "rbxassetid://10723427081",
		["lucide-list-ordered"] = "rbxassetid://10723427199",
		["lucide-list-plus"] = "rbxassetid://10723427334",
		["lucide-list-start"] = "rbxassetid://10723427494",
		["lucide-list-video"] = "rbxassetid://10723427619",
		["lucide-list-x"] = "rbxassetid://10723433655",
		["lucide-loader"] = "rbxassetid://10723434070",
		["lucide-loader-2"] = "rbxassetid://10723433935",
		["lucide-locate"] = "rbxassetid://10723434557",
		["lucide-locate-fixed"] = "rbxassetid://10723434236",
		["lucide-locate-off"] = "rbxassetid://10723434379",
		["lucide-lock"] = "rbxassetid://10723434711",
		["lucide-log-in"] = "rbxassetid://10723434830",
		["lucide-log-out"] = "rbxassetid://10723434906",
		["lucide-luggage"] = "rbxassetid://10723434993",
		["lucide-magnet"] = "rbxassetid://10723435069",
		["lucide-mail"] = "rbxassetid://10734885430",
		["lucide-mail-check"] = "rbxassetid://10723435182",
		["lucide-mail-minus"] = "rbxassetid://10723435261",
		["lucide-mail-open"] = "rbxassetid://10723435342",
		["lucide-mail-plus"] = "rbxassetid://10723435443",
		["lucide-mail-question"] = "rbxassetid://10723435515",
		["lucide-mail-search"] = "rbxassetid://10734884739",
		["lucide-mail-warning"] = "rbxassetid://10734885015",
		["lucide-mail-x"] = "rbxassetid://10734885247",
		["lucide-mails"] = "rbxassetid://10734885614",
		["lucide-map"] = "rbxassetid://10734886202",
		["lucide-map-pin"] = "rbxassetid://10734886004",
		["lucide-map-pin-off"] = "rbxassetid://10734885803",
		["lucide-maximize"] = "rbxassetid://10734886735",
		["lucide-maximize-2"] = "rbxassetid://10734886496",
		["lucide-medal"] = "rbxassetid://10734887072",
		["lucide-megaphone"] = "rbxassetid://10734887454",
		["lucide-megaphone-off"] = "rbxassetid://10734887311",
		["lucide-meh"] = "rbxassetid://10734887603",
		["lucide-menu"] = "rbxassetid://10734887784",
		["lucide-message-circle"] = "rbxassetid://10734888000",
		["lucide-message-square"] = "rbxassetid://10734888228",
		["lucide-mic"] = "rbxassetid://10734888864",
		["lucide-mic-2"] = "rbxassetid://10734888430",
		["lucide-mic-off"] = "rbxassetid://10734888646",
		["lucide-microscope"] = "rbxassetid://10734889106",
		["lucide-microwave"] = "rbxassetid://10734895076",
		["lucide-milestone"] = "rbxassetid://10734895310",
		["lucide-minimize"] = "rbxassetid://10734895698",
		["lucide-minimize-2"] = "rbxassetid://10734895530",
		["lucide-minus"] = "rbxassetid://10734896206",
		["lucide-minus-circle"] = "rbxassetid://10734895856",
		["lucide-minus-square"] = "rbxassetid://10734896029",
		["lucide-monitor"] = "rbxassetid://10734896881",
		["lucide-monitor-off"] = "rbxassetid://10734896360",
		["lucide-monitor-speaker"] = "rbxassetid://10734896512",
		["lucide-moon"] = "rbxassetid://10734897102",
		["lucide-more-horizontal"] = "rbxassetid://10734897250",
		["lucide-more-vertical"] = "rbxassetid://10734897387",
		["lucide-mountain"] = "rbxassetid://10734897956",
		["lucide-mountain-snow"] = "rbxassetid://10734897665",
		["lucide-mouse"] = "rbxassetid://10734898592",
		["lucide-mouse-pointer"] = "rbxassetid://10734898476",
		["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
		["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
		["lucide-move"] = "rbxassetid://10734900011",
		["lucide-move-3d"] = "rbxassetid://10734898756",
		["lucide-move-diagonal"] = "rbxassetid://10734899164",
		["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
		["lucide-move-horizontal"] = "rbxassetid://10734899414",
		["lucide-move-vertical"] = "rbxassetid://10734899821",
		["lucide-music"] = "rbxassetid://10734905958",
		["lucide-music-2"] = "rbxassetid://10734900215",
		["lucide-music-3"] = "rbxassetid://10734905665",
		["lucide-music-4"] = "rbxassetid://10734905823",
		["lucide-navigation"] = "rbxassetid://10734906744",
		["lucide-navigation-2"] = "rbxassetid://10734906332",
		["lucide-navigation-2-off"] = "rbxassetid://10734906144",
		["lucide-navigation-off"] = "rbxassetid://10734906580",
		["lucide-network"] = "rbxassetid://10734906975",
		["lucide-newspaper"] = "rbxassetid://10734907168",
		["lucide-octagon"] = "rbxassetid://10734907361",
		["lucide-option"] = "rbxassetid://10734907649",
		["lucide-outdent"] = "rbxassetid://10734907933",
		["lucide-package"] = "rbxassetid://10734909540",
		["lucide-package-2"] = "rbxassetid://10734908151",
		["lucide-package-check"] = "rbxassetid://10734908384",
		["lucide-package-minus"] = "rbxassetid://10734908626",
		["lucide-package-open"] = "rbxassetid://10734908793",
		["lucide-package-plus"] = "rbxassetid://10734909016",
		["lucide-package-search"] = "rbxassetid://10734909196",
		["lucide-package-x"] = "rbxassetid://10734909375",
		["lucide-paint-bucket"] = "rbxassetid://10734909847",
		["lucide-paintbrush"] = "rbxassetid://10734910187",
		["lucide-paintbrush-2"] = "rbxassetid://10734910030",
		["lucide-palette"] = "rbxassetid://10734910430",
		["lucide-palmtree"] = "rbxassetid://10734910680",
		["lucide-paperclip"] = "rbxassetid://10734910927",
		["lucide-party-popper"] = "rbxassetid://10734918735",
		["lucide-pause"] = "rbxassetid://10734919336",
		["lucide-pause-circle"] = "rbxassetid://10735024209",
		["lucide-pause-octagon"] = "rbxassetid://10734919143",
		["lucide-pen-tool"] = "rbxassetid://10734919503",
		["lucide-pencil"] = "rbxassetid://10734919691",
		["lucide-percent"] = "rbxassetid://10734919919",
		["lucide-person-standing"] = "rbxassetid://10734920149",
		["lucide-phone"] = "rbxassetid://10734921524",
		["lucide-phone-call"] = "rbxassetid://10734920305",
		["lucide-phone-forwarded"] = "rbxassetid://10734920508",
		["lucide-phone-incoming"] = "rbxassetid://10734920694",
		["lucide-phone-missed"] = "rbxassetid://10734920845",
		["lucide-phone-off"] = "rbxassetid://10734921077",
		["lucide-phone-outgoing"] = "rbxassetid://10734921288",
		["lucide-pie-chart"] = "rbxassetid://10734921727",
		["lucide-piggy-bank"] = "rbxassetid://10734921935",
		["lucide-pin"] = "rbxassetid://10734922324",
		["lucide-pin-off"] = "rbxassetid://10734922180",
		["lucide-pipette"] = "rbxassetid://10734922497",
		["lucide-pizza"] = "rbxassetid://10734922774",
		["lucide-plane"] = "rbxassetid://10734922971",
		["lucide-play"] = "rbxassetid://10734923549",
		["lucide-play-circle"] = "rbxassetid://10734923214",
		["lucide-plus"] = "rbxassetid://10734924532",
		["lucide-plus-circle"] = "rbxassetid://10734923868",
		["lucide-plus-square"] = "rbxassetid://10734924219",
		["lucide-podcast"] = "rbxassetid://10734929553",
		["lucide-pointer"] = "rbxassetid://10734929723",
		["lucide-pound-sterling"] = "rbxassetid://10734929981",
		["lucide-power"] = "rbxassetid://10734930466",
		["lucide-power-off"] = "rbxassetid://10734930257",
		["lucide-printer"] = "rbxassetid://10734930632",
		["lucide-puzzle"] = "rbxassetid://10734930886",
		["lucide-quote"] = "rbxassetid://10734931234",
		["lucide-radio"] = "rbxassetid://10734931596",
		["lucide-radio-receiver"] = "rbxassetid://10734931402",
		["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
		["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
		["lucide-recycle"] = "rbxassetid://10734932295",
		["lucide-redo"] = "rbxassetid://10734932822",
		["lucide-redo-2"] = "rbxassetid://10734932586",
		["lucide-refresh-ccw"] = "rbxassetid://10734933056",
		["lucide-refresh-cw"] = "rbxassetid://10734933222",
		["lucide-refrigerator"] = "rbxassetid://10734933465",
		["lucide-regex"] = "rbxassetid://10734933655",
		["lucide-repeat"] = "rbxassetid://10734933966",
		["lucide-repeat-1"] = "rbxassetid://10734933826",
		["lucide-reply"] = "rbxassetid://10734934252",
		["lucide-reply-all"] = "rbxassetid://10734934132",
		["lucide-rewind"] = "rbxassetid://10734934347",
		["lucide-rocket"] = "rbxassetid://10734934585",
		["lucide-rocking-chair"] = "rbxassetid://10734939942",
		["lucide-rotate-3d"] = "rbxassetid://10734940107",
		["lucide-rotate-ccw"] = "rbxassetid://10734940376",
		["lucide-rotate-cw"] = "rbxassetid://10734940654",
		["lucide-rss"] = "rbxassetid://10734940825",
		["lucide-ruler"] = "rbxassetid://10734941018",
		["lucide-russian-ruble"] = "rbxassetid://10734941199",
		["lucide-sailboat"] = "rbxassetid://10734941354",
		["lucide-save"] = "rbxassetid://10734941499",
		["lucide-scale"] = "rbxassetid://10734941912",
		["lucide-scale-3d"] = "rbxassetid://10734941739",
		["lucide-scaling"] = "rbxassetid://10734942072",
		["lucide-scan"] = "rbxassetid://10734942565",
		["lucide-scan-face"] = "rbxassetid://10734942198",
		["lucide-scan-line"] = "rbxassetid://10734942351",
		["lucide-scissors"] = "rbxassetid://10734942778",
		["lucide-screen-share"] = "rbxassetid://10734943193",
		["lucide-screen-share-off"] = "rbxassetid://10734942967",
		["lucide-scroll"] = "rbxassetid://10734943448",
		["lucide-search"] = "rbxassetid://10734943674",
		["lucide-send"] = "rbxassetid://10734943902",
		["lucide-separator-horizontal"] = "rbxassetid://10734944115",
		["lucide-separator-vertical"] = "rbxassetid://10734944326",
		["lucide-server"] = "rbxassetid://10734949856",
		["lucide-server-cog"] = "rbxassetid://10734944444",
		["lucide-server-crash"] = "rbxassetid://10734944554",
		["lucide-server-off"] = "rbxassetid://10734944668",
		["lucide-settings"] = "rbxassetid://10734950309",
		["lucide-settings-2"] = "rbxassetid://10734950020",
		["lucide-share"] = "rbxassetid://10734950813",
		["lucide-share-2"] = "rbxassetid://10734950553",
		["lucide-sheet"] = "rbxassetid://10734951038",
		["lucide-shield"] = "rbxassetid://10734951847",
		["lucide-shield-alert"] = "rbxassetid://10734951173",
		["lucide-shield-check"] = "rbxassetid://10734951367",
		["lucide-shield-close"] = "rbxassetid://10734951535",
		["lucide-shield-off"] = "rbxassetid://10734951684",
		["lucide-shirt"] = "rbxassetid://10734952036",
		["lucide-shopping-bag"] = "rbxassetid://10734952273",
		["lucide-shopping-cart"] = "rbxassetid://10734952479",
		["lucide-shovel"] = "rbxassetid://10734952773",
		["lucide-shower-head"] = "rbxassetid://10734952942",
		["lucide-shrink"] = "rbxassetid://10734953073",
		["lucide-shrub"] = "rbxassetid://10734953241",
		["lucide-shuffle"] = "rbxassetid://10734953451",
		["lucide-sidebar"] = "rbxassetid://10734954301",
		["lucide-sidebar-close"] = "rbxassetid://10734953715",
		["lucide-sidebar-open"] = "rbxassetid://10734954000",
		["lucide-sigma"] = "rbxassetid://10734954538",
		["lucide-signal"] = "rbxassetid://10734961133",
		["lucide-signal-high"] = "rbxassetid://10734954807",
		["lucide-signal-low"] = "rbxassetid://10734955080",
		["lucide-signal-medium"] = "rbxassetid://10734955336",
		["lucide-signal-zero"] = "rbxassetid://10734960878",
		["lucide-siren"] = "rbxassetid://10734961284",
		["lucide-skip-back"] = "rbxassetid://10734961526",
		["lucide-skip-forward"] = "rbxassetid://10734961809",
		["lucide-skull"] = "rbxassetid://10734962068",
		["lucide-slack"] = "rbxassetid://10734962339",
		["lucide-slash"] = "rbxassetid://10734962600",
		["lucide-slice"] = "rbxassetid://10734963024",
		["lucide-sliders"] = "rbxassetid://10734963400",
		["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
		["lucide-smartphone"] = "rbxassetid://10734963940",
		["lucide-smartphone-charging"] = "rbxassetid://10734963671",
		["lucide-smile"] = "rbxassetid://10734964441",
		["lucide-smile-plus"] = "rbxassetid://10734964188",
		["lucide-snowflake"] = "rbxassetid://10734964600",
		["lucide-sofa"] = "rbxassetid://10734964852",
		["lucide-sort-asc"] = "rbxassetid://10734965115",
		["lucide-sort-desc"] = "rbxassetid://10734965287",
		["lucide-speaker"] = "rbxassetid://10734965419",
		["lucide-sprout"] = "rbxassetid://10734965572",
		["lucide-square"] = "rbxassetid://10734965702",
		["lucide-star"] = "rbxassetid://10734966248",
		["lucide-star-half"] = "rbxassetid://10734965897",
		["lucide-star-off"] = "rbxassetid://10734966097",
		["lucide-stethoscope"] = "rbxassetid://10734966384",
		["lucide-sticker"] = "rbxassetid://10734972234",
		["lucide-sticky-note"] = "rbxassetid://10734972463",
		["lucide-stop-circle"] = "rbxassetid://10734972621",
		["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
		["lucide-stretch-vertical"] = "rbxassetid://10734973130",
		["lucide-strikethrough"] = "rbxassetid://10734973290",
		["lucide-subscript"] = "rbxassetid://10734973457",
		["lucide-sun"] = "rbxassetid://10734974297",
		["lucide-sun-dim"] = "rbxassetid://10734973645",
		["lucide-sun-medium"] = "rbxassetid://10734973778",
		["lucide-sun-moon"] = "rbxassetid://10734973999",
		["lucide-sun-snow"] = "rbxassetid://10734974130",
		["lucide-sunrise"] = "rbxassetid://10734974522",
		["lucide-sunset"] = "rbxassetid://10734974689",
		["lucide-superscript"] = "rbxassetid://10734974850",
		["lucide-swiss-franc"] = "rbxassetid://10734975024",
		["lucide-switch-camera"] = "rbxassetid://10734975214",
		["lucide-sword"] = "rbxassetid://10734975486",
		["lucide-swords"] = "rbxassetid://10734975692",
		["lucide-syringe"] = "rbxassetid://10734975932",
		["lucide-table"] = "rbxassetid://10734976230",
		["lucide-table-2"] = "rbxassetid://10734976097",
		["lucide-tablet"] = "rbxassetid://10734976394",
		["lucide-tag"] = "rbxassetid://10734976528",
		["lucide-tags"] = "rbxassetid://10734976739",
		["lucide-target"] = "rbxassetid://10734977012",
		["lucide-tent"] = "rbxassetid://10734981750",
		["lucide-terminal"] = "rbxassetid://10734982144",
		["lucide-terminal-square"] = "rbxassetid://10734981995",
		["lucide-text-cursor"] = "rbxassetid://10734982395",
		["lucide-text-cursor-input"] = "rbxassetid://10734982297",
		["lucide-thermometer"] = "rbxassetid://10734983134",
		["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
		["lucide-thermometer-sun"] = "rbxassetid://10734982771",
		["lucide-thumbs-down"] = "rbxassetid://10734983359",
		["lucide-thumbs-up"] = "rbxassetid://10734983629",
		["lucide-ticket"] = "rbxassetid://10734983868",
		["lucide-timer"] = "rbxassetid://10734984606",
		["lucide-timer-off"] = "rbxassetid://10734984138",
		["lucide-timer-reset"] = "rbxassetid://10734984355",
		["lucide-toggle-left"] = "rbxassetid://10734984834",
		["lucide-toggle-right"] = "rbxassetid://10734985040",
		["lucide-tornado"] = "rbxassetid://10734985247",
		["lucide-toy-brick"] = "rbxassetid://10747361919",
		["lucide-train"] = "rbxassetid://10747362105",
		["lucide-trash"] = "rbxassetid://10747362393",
		["lucide-trash-2"] = "rbxassetid://10747362241",
		["lucide-tree-deciduous"] = "rbxassetid://10747362534",
		["lucide-tree-pine"] = "rbxassetid://10747362748",
		["lucide-trees"] = "rbxassetid://10747363016",
		["lucide-trending-down"] = "rbxassetid://10747363205",
		["lucide-trending-up"] = "rbxassetid://10747363465",
		["lucide-triangle"] = "rbxassetid://10747363621",
		["lucide-trophy"] = "rbxassetid://10747363809",
		["lucide-truck"] = "rbxassetid://10747364031",
		["lucide-tv"] = "rbxassetid://10747364593",
		["lucide-tv-2"] = "rbxassetid://10747364302",
		["lucide-type"] = "rbxassetid://10747364761",
		["lucide-umbrella"] = "rbxassetid://10747364971",
		["lucide-underline"] = "rbxassetid://10747365191",
		["lucide-undo"] = "rbxassetid://10747365484",
		["lucide-undo-2"] = "rbxassetid://10747365359",
		["lucide-unlink"] = "rbxassetid://10747365771",
		["lucide-unlink-2"] = "rbxassetid://10747397871",
		["lucide-unlock"] = "rbxassetid://10747366027",
		["lucide-upload"] = "rbxassetid://10747366434",
		["lucide-upload-cloud"] = "rbxassetid://10747366266",
		["lucide-usb"] = "rbxassetid://10747366606",
		["lucide-user"] = "rbxassetid://10747373176",
		["lucide-user-check"] = "rbxassetid://10747371901",
		["lucide-user-cog"] = "rbxassetid://10747372167",
		["lucide-user-minus"] = "rbxassetid://10747372346",
		["lucide-user-plus"] = "rbxassetid://10747372702",
		["lucide-user-x"] = "rbxassetid://10747372992",
		["lucide-users"] = "rbxassetid://10747373426",
		["lucide-utensils"] = "rbxassetid://10747373821",
		["lucide-utensils-crossed"] = "rbxassetid://10747373629",
		["lucide-venetian-mask"] = "rbxassetid://10747374003",
		["lucide-verified"] = "rbxassetid://10747374131",
		["lucide-vibrate"] = "rbxassetid://10747374489",
		["lucide-vibrate-off"] = "rbxassetid://10747374269",
		["lucide-video"] = "rbxassetid://10747374938",
		["lucide-video-off"] = "rbxassetid://10747374721",
		["lucide-view"] = "rbxassetid://10747375132",
		["lucide-voicemail"] = "rbxassetid://10747375281",
		["lucide-volume"] = "rbxassetid://10747376008",
		["lucide-volume-1"] = "rbxassetid://10747375450",
		["lucide-volume-2"] = "rbxassetid://10747375679",
		["lucide-volume-x"] = "rbxassetid://10747375880",
		["lucide-wallet"] = "rbxassetid://10747376205",
		["lucide-wand"] = "rbxassetid://10747376565",
		["lucide-wand-2"] = "rbxassetid://10747376349",
		["lucide-watch"] = "rbxassetid://10747376722",
		["lucide-waves"] = "rbxassetid://10747376931",
		["lucide-webcam"] = "rbxassetid://10747381992",
		["lucide-wifi"] = "rbxassetid://10747382504",
		["lucide-wifi-off"] = "rbxassetid://10747382268",
		["lucide-wind"] = "rbxassetid://10747382750",
		["lucide-wrap-text"] = "rbxassetid://10747383065",
		["lucide-wrench"] = "rbxassetid://10747383470",
		["lucide-x"] = "rbxassetid://10747384394",
		["lucide-x-circle"] = "rbxassetid://10747383819",
		["lucide-x-octagon"] = "rbxassetid://10747384037",
		["lucide-x-square"] = "rbxassetid://10747384217",
		["lucide-zoom-in"] = "rbxassetid://10747384552",
		["lucide-zoom-out"] = "rbxassetid://10747384679",
	},
}
end

__DimensiModules['Themes'] = function(script, require)
local Dimensi = require(script.Dimensi)

return {
	Names = { "Dimensi" },
	Dimensi = Dimensi,
}
end

__DimensiModules['Typography'] = function(script, require)
local function createFont(weight)
	local candidates = {
		"rbxasset://fonts/families/BuilderSans.json",
		"rbxasset://fonts/families/GothamSSm.json",
		"rbxasset://fonts/families/SourceSansPro.json",
	}

	for _, family in ipairs(candidates) do
		local ok, font = pcall(function()
			return Font.new(family, weight, Enum.FontStyle.Normal)
		end)
		if ok and font then
			return font
		end
	end

	return Font.fromEnum(Enum.Font.SourceSans)
end

return {
	Regular = createFont(Enum.FontWeight.Regular),
	Medium = createFont(Enum.FontWeight.Medium),
	SemiBold = createFont(Enum.FontWeight.SemiBold),
	Bold = createFont(Enum.FontWeight.Bold),
}
end

__DimensiModules['Acrylic/AcrylicBlur'] = function(script, require)
local Creator = require(script.Parent.Parent.Creator)
local createAcrylic = require(script.Parent.CreateAcrylic)
local viewportPointToWorld, getOffset = unpack(require(script.Parent.Utils))

local function createAcrylicBlur(distance)
	local cleanups = {}

	distance = distance or 0.001
	local positions = {
		topLeft = Vector2.new(),
		topRight = Vector2.new(),
		bottomRight = Vector2.new(),
	}
	local model = Creator.TrackModel(createAcrylic())
	model.Parent = workspace

	local function updatePositions(size, position)
		positions.topLeft = position
		positions.topRight = position + Vector2.new(size.X, 0)
		positions.bottomRight = position + size
	end

	local function render()
		if not model or not model.Parent then return end
		local currentCamera = game:GetService("Workspace").CurrentCamera
		if not currentCamera then return end
		local ok, err = pcall(function()
			local camera = currentCamera.CFrame
			local topLeft = positions.topLeft
			local topRight = positions.topRight
			local bottomRight = positions.bottomRight
			local topLeft3D = viewportPointToWorld(topLeft, distance)
			local topRight3D = viewportPointToWorld(topRight, distance)
			local bottomRight3D = viewportPointToWorld(bottomRight, distance)
			local width = (topRight3D - topLeft3D).Magnitude
			local height = (topRight3D - bottomRight3D).Magnitude
			model.CFrame = CFrame.fromMatrix((topLeft3D + bottomRight3D) / 2, camera.XVector, camera.YVector, camera.ZVector)
			model.Mesh.Scale = Vector3.new(width, height, 0)
		end)
		if not ok then warn("DimensiUI acrylic render failed:", err) end
	end

	local function onChange(rbx)
		local offset = getOffset()
		local size = rbx.AbsoluteSize - Vector2.new(offset, offset)
		local position = rbx.AbsolutePosition + Vector2.new(offset / 2, offset / 2)

		updatePositions(size, position)
		task.spawn(render)
	end

	local boundCamera
	local cameraConnections = {}
	local function disconnectCamera()
		for _, connection in ipairs(cameraConnections) do
			Creator.DisconnectSignal(connection)
		end
		table.clear(cameraConnections)
		boundCamera = nil
	end
	local function bindCamera(camera)
		if camera == boundCamera then return end
		disconnectCamera()
		boundCamera = camera
		if not camera then return end
		table.insert(cameraConnections, Creator.TrackConnection(camera:GetPropertyChangedSignal("CFrame"):Connect(render)))
		table.insert(cameraConnections, Creator.TrackConnection(camera:GetPropertyChangedSignal("ViewportSize"):Connect(render)))
		table.insert(cameraConnections, Creator.TrackConnection(camera:GetPropertyChangedSignal("FieldOfView"):Connect(render)))
		task.spawn(render)
	end
	local workspaceService = game:GetService("Workspace")
	local currentCameraConnection = Creator.TrackConnection(workspaceService:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		bindCamera(workspaceService.CurrentCamera)
	end))
	bindCamera(workspaceService.CurrentCamera)

	model.Destroying:Connect(function()
		disconnectCamera()
		Creator.DisconnectSignal(currentCameraConnection)
		for _, item in cleanups do
			pcall(function()
				item:Disconnect()
			end)
		end
	end)


	return onChange, model
end

return function(distance)
	local Blur = {}
	local onChange, model = createAcrylicBlur(distance)

	local comp = Creator.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	})

	Creator.AddSignal(comp:GetPropertyChangedSignal("AbsolutePosition"), function()
		onChange(comp)
	end)

	Creator.AddSignal(comp:GetPropertyChangedSignal("AbsoluteSize"), function()
		onChange(comp)
	end)

	Blur.AddParent = function(Parent)
		Creator.AddSignal(Parent:GetPropertyChangedSignal("Visible"), function()
			Blur.SetVisibility(Parent.Visible)
		end)
	end

	Blur.SetVisibility = function(Value)
		model.Transparency = Value and 0.98 or 1
	end

	Blur.Frame = comp
	Blur.Model = model

	return Blur
end
end

__DimensiModules['Acrylic/AcrylicPaint'] = function(script, require)

local Creator = require(script.Parent.Parent.Creator)
local AcrylicBlur = require(script.Parent.AcrylicBlur)

local New = Creator.New

return function(props)
    local AcrylicPaint = {}

    AcrylicPaint.Frame = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(13, 10, 20),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
    }, {
        New("ImageLabel", {
            Image = "rbxassetid://8992230677",
            ScaleType = "Slice",
            SliceCenter = Rect.new(
                Vector2.new(99, 99),
                Vector2.new(99, 99)
            ),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 120, 1, 116),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundTransparency = 1,
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.7,
        }),

        New("UICorner", {
            CornerRadius = UDim.new(0, 8),
        }),

        -- Solid main background
        New("Frame", {
            Name = "Background",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ThemeTag = {
                BackgroundColor3 = "AcrylicMain",
            },
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }),
        }),

        -- Solid gradient overlay
        New("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }),

            New("UIGradient", {
                Rotation = 90,
                ThemeTag = {
                    Color = "AcrylicGradient",
                },
            }),
        }),

        -- Decorative texture
        New("ImageLabel", {
            Image = "rbxassetid://9968344105",
            ImageTransparency = 0.98,
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.fromOffset(128, 128),
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }),
        }),

        New("ImageLabel", {
            Image = "rbxassetid://9968344227",
            ImageTransparency = 0.94,
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.fromOffset(128, 128),
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ThemeTag = {
                ImageTransparency = "AcrylicNoise",
            },
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }),
        }),

        -- Border
        New("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ZIndex = 2,
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 8),
            }),

            New("UIStroke", {
                Transparency = 0.5,
                Thickness = 1,
                ThemeTag = {
                    Color = "AcrylicBorder",
                },
            }),
        }),
    })

    local Blur

    if require(script.Parent.Parent).UseAcrylic then
        Blur = AcrylicBlur()
        Blur.Frame.Parent = AcrylicPaint.Frame

        AcrylicPaint.Model = Blur.Model
        AcrylicPaint.AddParent = Blur.AddParent
        AcrylicPaint.SetVisibility = Blur.SetVisibility
    end

    return AcrylicPaint
end
end

__DimensiModules['Acrylic/CreateAcrylic'] = function(script, require)
local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local function createAcrylic()
	local Part = Creator.New("Part", {
		Name = "Body",
		Color = Color3.new(0, 0, 0),
		Material = Enum.Material.Glass,
		Size = Vector3.new(1, 1, 0),
		Anchored = true,
		CanCollide = false,
		Locked = true,
		CastShadow = false,
		Transparency = 0.98,
	}, {
		Creator.New("SpecialMesh", {
			MeshType = Enum.MeshType.Brick,
			Offset = Vector3.new(0, 0, -0.000001),
		}),
	})

	return Part
end

return createAcrylic
end

__DimensiModules['Acrylic/Utils'] = function(script, require)
local function map(value, inMin, inMax, outMin, outMax)
	return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

local function viewportPointToWorld(location, distance)
	local camera = game:GetService("Workspace").CurrentCamera
	if not camera then return Vector3.zero end
	local unitRay = camera:ScreenPointToRay(location.X, location.Y)
	return unitRay.Origin + unitRay.Direction * distance
end

local function getOffset()
	local camera = game:GetService("Workspace").CurrentCamera
	if not camera then return 0 end
	local viewportSizeY = camera.ViewportSize.Y
	return map(viewportSizeY, 0, 2560, 8, 56)
end

return { viewportPointToWorld, getOffset }
end

__DimensiModules['Components/Assets'] = function(script, require)
return {
	Close = "rbxassetid://9886659671",
	Min = "rbxassetid://9886659276",
	Max = "rbxassetid://9886659406",
	Restore = "rbxassetid://9886659001",
}
end

__DimensiModules['Components/Button'] = function(script, require)
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local New = Creator.New

local Spring = Motion.Spring.new

return function(Theme, Parent, DialogCheck)
	DialogCheck = DialogCheck or false
	local Button = {}

	Button.Title = New("TextLabel", {
		FontFace = Typography.Regular,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Button.HoverFrame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ThemeTag = {
			BackgroundColor3 = "Hover",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
	})

	Button.Frame = New("TextButton", {
		Size = UDim2.new(0, 0, 0, 32),
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = "DialogButton",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = 0.65,
			ThemeTag = {
				Color = "DialogButtonBorder",
			},
		}),
		Button.HoverFrame,
		Button.Title,
	})

	local Motor, SetTransparency = Creator.SpringMotor(1, Button.HoverFrame, "BackgroundTransparency", DialogCheck)
	Creator.AddSignal(Button.Frame.MouseEnter, function()
		SetTransparency(0.97)
	end)
	Creator.AddSignal(Button.Frame.MouseLeave, function()
		SetTransparency(1)
	end)
	Creator.AddSignal(Button.Frame.MouseButton1Down, function()
		SetTransparency(1)
	end)
	Creator.AddSignal(Button.Frame.MouseButton1Up, function()
		SetTransparency(0.97)
	end)

	return Button
end
end

__DimensiModules['Components/Dialog'] = function(script, require)
local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera

local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)

local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local New = Creator.New

local Dialog = {
	Window = nil,
}

function Dialog:Init(Window)
	Dialog.Window = Window
	return Dialog
end

function Dialog:Create()
	local NewDialog = {
		Buttons = 0,
		Closed = false,
	}

	NewDialog.TintFrame = New("TextButton", {
		Text = "",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Parent = Dialog.Window.Root,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
	})

	local TintMotor, TintTransparency = Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true)

	NewDialog.ButtonHolder = New("Frame", {
		Size = UDim2.new(1, -40, 1, -40),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})

	NewDialog.ButtonHolderFrame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 70),
		Position = UDim2.new(0, 0, 1, -70),
		ThemeTag = {
			BackgroundColor3 = "DialogHolder",
		},
	}, {
		New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			ThemeTag = {
				BackgroundColor3 = "DialogHolderLine",
			},
		}),
		NewDialog.ButtonHolder,
	})

	NewDialog.Title = New("TextLabel", {
		FontFace = Typography.SemiBold,
		Text = "Dialog",
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 22),
		Position = UDim2.fromOffset(20, 25),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	NewDialog.Scale = New("UIScale", {
		Scale = 1,
	})

	local ScaleMotor, Scale = Creator.SpringMotor(1.1, NewDialog.Scale, "Scale")

	NewDialog.Root = New("CanvasGroup", {
		Size = UDim2.fromOffset(math.clamp(Dialog.Window.Size.X.Offset - 24, 220, 300), 165),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		GroupTransparency = 1,
		Parent = NewDialog.TintFrame,
		ThemeTag = {
			BackgroundColor3 = "Dialog",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
		New("UIStroke", {
			Transparency = 0.5,
			ThemeTag = {
				Color = "DialogBorder",
			},
		}),
		NewDialog.Scale,
		NewDialog.Title,
		NewDialog.ButtonHolderFrame,
	})

	local RootMotor, RootTransparency = Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency")

	function NewDialog:Open()
		if NewDialog.Closed or require(Root).Unloaded then return false end
		require(Root).DialogOpen = true
		NewDialog.Scale.Scale = 1.1
		TintTransparency(0.75)
		RootTransparency(0)
		Scale(1)
	end

	function NewDialog:Close()
		if NewDialog.Closed then return end
		NewDialog.Closed = true
		require(Root).DialogOpen = false
		TintTransparency(1)
		RootTransparency(1)
		Scale(1.1)
		if NewDialog.Root and NewDialog.Root:FindFirstChild("UIStroke") then
			NewDialog.Root.UIStroke:Destroy()
		end
		task.wait(0.15)
		if NewDialog.TintFrame and NewDialog.TintFrame.Parent then
			NewDialog.TintFrame:Destroy()
		end
	end

	function NewDialog:Button(Title, Callback)
		assert(Title == nil or type(Title) == "string", "Dialog:Button Title must be a string")
		assert(Callback == nil or type(Callback) == "function", "Dialog:Button Callback must be a function")
		if NewDialog.Closed then return nil end
		NewDialog.Buttons = NewDialog.Buttons + 1
		Title = Title or "Button"
		Callback = Callback or function() end

		local Button = require(Root.Components.Button)("", NewDialog.ButtonHolder, true)
		Button.Title.Text = Title

		for _, Btn in next, NewDialog.ButtonHolder:GetChildren() do
			if Btn:IsA("TextButton") then
				Btn.Size =
					UDim2.new(1 / NewDialog.Buttons, -(((NewDialog.Buttons - 1) * 10) / NewDialog.Buttons), 0, 32)
			end
		end

		Creator.AddSignal(Button.Frame.MouseButton1Click, function()
			require(Root):SafeCallback(Callback)
			pcall(function()
				NewDialog:Close()
			end)
		end)

		return Button
	end

	return NewDialog
end

return Dialog
end

__DimensiModules['Components/Element'] = function(script, require)
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local New = Creator.New

local Spring = Motion.Spring.new

return function(Title, Desc, Parent, Hover)
	local Element = {}

	Element.TitleLabel = New("TextLabel", {
		FontFace = Typography.Medium,
		Text = Title,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 13,
		TextWrapped = true,
		LineHeight = 1.12,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Element.DescLabel = New("TextLabel", {
		FontFace = Typography.Regular,
		Text = Desc,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextSize = 12,
		TextWrapped = true,
		LineHeight = 1.12,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		ThemeTag = {
			TextColor3 = "SubText",
		},
	})

	Element.LabelHolder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -24, 0, 0),
	}, {
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
		}),
		Element.TitleLabel,
		Element.DescLabel,
	})

	Element.Border = New("UIStroke", {
		Transparency = 0.5,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(0, 0, 0),
		ThemeTag = {
			Color = "ElementBorder",
		},
	})

	Element.Frame = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 0.89,
		BackgroundColor3 = Color3.fromRGB(130, 130, 130),
		Parent = Parent,
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = "",
		LayoutOrder = 7,
		ThemeTag = {
			BackgroundColor3 = "Element",
			BackgroundTransparency = "ElementTransparency",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		Element.Border,
		Element.LabelHolder,
	})

	function Element:SetTitle(Set)
		assert(type(Set) == "string", "Element:SetTitle expects a string")
		Element.TitleLabel.Text = Set
	end

	function Element:SetDesc(Set)
		assert(Set == nil or type(Set) == "string", "Element:SetDesc expects a string or nil")
		if Set == nil then
			Set = ""
		end
		if Set == "" then
			Element.DescLabel.Visible = false
		else
			Element.DescLabel.Visible = true
		end
		Element.DescLabel.Text = Set
	end

	function Element:Destroy()
		Element.Frame:Destroy()
	end

	Element:SetTitle(Title)
	Element:SetDesc(Desc)

	if Hover then
		local Themes = Root.Themes
		local Motor, SetTransparency = Creator.SpringMotor(
			Creator.GetThemeProperty("ElementTransparency"),
			Element.Frame,
			"BackgroundTransparency",
			false,
			true
		)

		Creator.AddSignal(Element.Frame.MouseEnter, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
		end)
		Creator.AddSignal(Element.Frame.MouseLeave, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency"))
		end)
		Creator.AddSignal(Element.Frame.MouseButton1Down, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") + Creator.GetThemeProperty("HoverChange"))
		end)
		Creator.AddSignal(Element.Frame.MouseButton1Up, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
		end)
	end

	return Element
end
end

__DimensiModules['Components/Notification'] = function(script, require)
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local Acrylic = require(Root.Acrylic)

local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local New = Creator.New

local Notification = {}

function Notification:Init(GUI)
	Notification.Holder = New("Frame", {
		Position = UDim2.new(1, -12, 1, -12),
		Size = UDim2.new(0, math.max(220, math.min(310, workspace.CurrentCamera.ViewportSize.X - 24)), 1, -24),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Parent = GUI,
	}, {
		New("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 10),
		}),
	})
	local Camera = workspace.CurrentCamera
	if Camera then
		Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), function()
			if Notification.Holder and Notification.Holder.Parent then
				Notification.Holder.Size = UDim2.new(0, math.max(220, math.min(310, Camera.ViewportSize.X - 24)), 1, -24)
			end
		end, GUI)
	end
end

function Notification:New(Config)
	assert(type(Config) == "table", "Notification config must be a table")
	assert(Config.Duration == nil or (type(Config.Duration) == "number" and Config.Duration == Config.Duration and Config.Duration >= 0 and math.abs(Config.Duration) < math.huge), "Notification duration must be a finite non-negative number")
	Config.Title = Config.Title or "Title"
	Config.Content = Config.Content or "Content"
	Config.SubContent = Config.SubContent or ""
	Config.Duration = Config.Duration or nil
	Config.Buttons = Config.Buttons or {}
	assert(type(Config.Title) == "string" and type(Config.Content) == "string" and type(Config.SubContent) == "string", "Notification text must be strings")
	local NewNotification = {
		Closed = false,
	}

	NewNotification.AcrylicPaint = Acrylic.AcrylicPaint()

	NewNotification.Title = New("TextLabel", {
		Position = UDim2.new(0, 14, 0, 17),
		Text = Config.Title,
		RichText = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextTransparency = 0,
		FontFace = Typography.Regular,
		TextSize = 13,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		Size = UDim2.new(1, -12, 0, 12),
		TextWrapped = true,
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	NewNotification.ContentLabel = New("TextLabel", {
		FontFace = Typography.Regular,
		Text = Config.Content,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		TextWrapped = true,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	NewNotification.SubContentLabel = New("TextLabel", {
		FontFace = Typography.Regular,
		Text = Config.SubContent,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		TextWrapped = true,
		ThemeTag = {
			TextColor3 = "SubText",
		},
	})

	NewNotification.LabelHolder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 40),
		Size = UDim2.new(1, -28, 0, 0),
	}, {
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 3),
		}),
		NewNotification.ContentLabel,
		NewNotification.SubContentLabel,
	})

	NewNotification.CloseButton = New("TextButton", {
		Text = "",
		Position = UDim2.new(1, -14, 0, 13),
		Size = UDim2.fromOffset(20, 20),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
	}, {
		New("ImageLabel", {
			Image = require(script.Parent.Assets).Close,
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ThemeTag = {
				ImageColor3 = "Text",
			},
		}),
	})

	NewNotification.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(1, 0),
	}, {
		NewNotification.AcrylicPaint.Frame,
		NewNotification.Title,
		NewNotification.CloseButton,
		NewNotification.LabelHolder,
	})

	if Config.Content == "" then
		NewNotification.ContentLabel.Visible = false
	end

	if Config.SubContent == "" then
		NewNotification.SubContentLabel.Visible = false
	end

	NewNotification.Holder = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 200),
		Parent = Notification.Holder,
	}, {
		NewNotification.Root,
	})

	local RootMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		Scale = 1,
		Offset = 60,
	}), NewNotification.Holder)

	RootMotor:onStep(function(Values)
		NewNotification.Root.Position = UDim2.new(Values.Scale, Values.Offset, 0, 0)
	end)

	Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function()
		NewNotification:Close()
	end)

	function NewNotification:Open()
		local ContentSize = NewNotification.LabelHolder.AbsoluteSize.Y
		NewNotification.Holder.Size = UDim2.new(1, 0, 0, 58 + ContentSize)

		RootMotor:setGoal({
			Scale = Spring(0, { frequency = 5 }),
			Offset = Spring(0, { frequency = 5 }),
		})
	end

	function NewNotification:Close()
		if NewNotification.Closed then return end
		NewNotification.Closed = true
		task.spawn(function()
			RootMotor:setGoal({
				Scale = Spring(1, { frequency = 5 }),
				Offset = Spring(60, { frequency = 5 }),
			})
			task.wait(0.4)
			if require(Root).UseAcrylic then
				local Paint = NewNotification.AcrylicPaint
				if Paint and Paint.Model then pcall(function() Paint.Model:Destroy() end) end
			end
			if NewNotification.Holder and NewNotification.Holder.Parent then
				NewNotification.Holder:Destroy()
			end
		end)
	end

	NewNotification:Open()
	if Config.Duration then
		task.delay(Config.Duration, function()
			NewNotification:Close()
		end)
	end
	return NewNotification
end

return Notification
end

__DimensiModules['Components/Section'] = function(script, require)
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Creator = require(Root.Creator)

local New = Creator.New

return function(Title, Parent)
	local Section = {}

	Section.Layout = New("UIListLayout", {
		Padding = UDim.new(0, 7),
	})

	Section.Container = New("Frame", {
		Size = UDim2.new(1, 0, 0, 26),
		Position = UDim2.fromOffset(0, 24),
		BackgroundTransparency = 1,
	}, {
		Section.Layout,
	})

	Section.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 26),
		LayoutOrder = 7,
		Parent = Parent,
	}, {
		New("TextLabel", {
			RichText = true,
			Text = Title,
			TextTransparency = 0,
			FontFace = Typography.SemiBold,
			TextSize = 14,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 18),
			Position = UDim2.fromOffset(0, 2),
			ThemeTag = {
				TextColor3 = "Text",
			},
		}),
		Section.Container,
	})

	Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Section.Container.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y)
		Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 25)
	end)
	return Section
end
end

__DimensiModules['Components/Tab'] = function(script, require)
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)

local New = Creator.New
local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local Components = Root.Components

local TabModule = {
	Window = nil,
	Tabs = {},
	Containers = {},
	SelectedTab = 0,
	TabCount = 0,
	SelectionGeneration = 0,
}

function TabModule:Init(Window)
	TabModule.Window = Window
	return TabModule
end

function TabModule:GetCurrentTabPos()
	local Window = TabModule.Window
	local Selected = TabModule.Tabs[TabModule.SelectedTab]
	if not Window or not Window.TabHolder or not Selected or not Selected.Frame then return 0 end
	return Selected.Frame.AbsolutePosition.Y - Window.TabHolder.AbsolutePosition.Y
end

function TabModule:New(Title, Icon, Parent)
	assert(type(Title) == "string" and Title ~= "", "Tab requires a non-empty title")
	local Library = require(Root)
	local Window = TabModule.Window
	assert(Window and Window.TabHolder and not Library.Unloaded, "Cannot create a tab after the library is destroyed")
	local Elements = Library.Elements

	TabModule.TabCount = TabModule.TabCount + 1
	local TabIndex = TabModule.TabCount

	local Tab = {
		Selected = false,
		Index = TabIndex,
		Name = Title,
		Type = "Tab",
	}

	if Library:GetIcon(Icon) then
		Icon = Library:GetIcon(Icon)
	end

	if Icon == "" or nil then
		Icon = nil
	end

	Tab.Frame = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = "Tab",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		New("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = Icon and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
			Text = Title,
			RichText = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextTransparency = 0,
			FontFace = Typography.Regular,
			TextSize = 12,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -12, 1, 0),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		}),
		New("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.new(0, 8, 0.5, 0),
			BackgroundTransparency = 1,
			Image = Icon and Icon or nil,
			ThemeTag = {
				ImageColor3 = "Text",
			},
		}),
	})

	local ContainerLayout = New("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	Tab.ContainerFrame = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent = Window.ContainerHolder,
		Visible = false,
		BottomImage = "rbxassetid://6889812791",
		MidImage = "rbxassetid://6889812721",
		TopImage = "rbxassetid://6276641225",
		ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
		ScrollBarImageTransparency = 0.95,
		ScrollBarThickness = 3,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		ContainerLayout,
		New("UIPadding", {
			PaddingRight = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 1),
			PaddingTop = UDim.new(0, 1),
			PaddingBottom = UDim.new(0, 1),
		}),
	})

	Creator.AddSignal(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 2)
	end)

	Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")

	Creator.AddSignal(Tab.Frame.MouseEnter, function()
		Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
	end)
	Creator.AddSignal(Tab.Frame.MouseLeave, function()
		Tab.SetTransparency(Tab.Selected and 0.89 or 1)
	end)
	Creator.AddSignal(Tab.Frame.MouseButton1Down, function()
		Tab.SetTransparency(0.92)
	end)
	Creator.AddSignal(Tab.Frame.MouseButton1Up, function()
		Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
	end)
	Creator.AddSignal(Tab.Frame.MouseButton1Click, function()
		TabModule:SelectTab(TabIndex)
	end)

	TabModule.Containers[TabIndex] = Tab.ContainerFrame
	TabModule.Tabs[TabIndex] = Tab

	Tab.Container = Tab.ContainerFrame
	Tab.ScrollFrame = Tab.Container

	function Tab:AddSection(SectionTitle)
		assert(type(SectionTitle) == "string" and SectionTitle ~= "", "Section title must be a non-empty string")
		local Section = { Type = "Section" }

		local SectionFrame = require(Components.Section)(SectionTitle, Tab.Container)
		Section.Container = SectionFrame.Container
		Section.ScrollFrame = Tab.Container

		setmetatable(Section, Elements)
		return Section
	end

	setmetatable(Tab, Elements)
	if TabIndex == 1 then TabModule:SelectTab(TabIndex) end
	return Tab
end

function TabModule:SelectTab(Tab)
	local Window = TabModule.Window
	local TabObject = TabModule.Tabs[Tab]
	if not Window or not TabObject or require(Root).Unloaded then return false end
	TabModule.SelectionGeneration += 1
	local Generation = TabModule.SelectionGeneration
	TabModule.SelectedTab = Tab
	for _, Item in next, TabModule.Tabs do
		Item.SetTransparency(1)
		Item.Selected = false
	end
	TabObject.SetTransparency(0.89)
	TabObject.Selected = true
	Window.TabDisplay.Text = TabObject.Name
	Window.SelectorPosMotor:setGoal(Spring(TabModule:GetCurrentTabPos(), { frequency = 6 }))
	task.spawn(function()
		if Generation ~= TabModule.SelectionGeneration or require(Root).Unloaded then return end
		Window.ContainerPosMotor:setGoal(Spring(110, { frequency = 10 }))
		Window.ContainerBackMotor:setGoal(Spring(1, { frequency = 10 }))
		task.wait(0.15)
		if Generation ~= TabModule.SelectionGeneration or require(Root).Unloaded then return end
		for _, Container in next, TabModule.Containers do
			if Container and Container.Parent then Container.Visible = false end
		end
		local SelectedContainer = TabModule.Containers[Tab]
		if SelectedContainer and SelectedContainer.Parent then SelectedContainer.Visible = true end
		Window.ContainerPosMotor:setGoal(Spring(94, { frequency = 5 }))
		Window.ContainerBackMotor:setGoal(Spring(0, { frequency = 8 }))
	end)
	return true
end

return TabModule
end

__DimensiModules['Components/Textbox'] = function(script, require)
local TextService = game:GetService("TextService")
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local New = Creator.New

return function(Parent, Acrylic)
	Acrylic = Acrylic or false
	local Textbox = {}

	Textbox.Input = New("TextBox", {
		FontFace = Typography.Regular,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromOffset(10, 0),
		ThemeTag = {
			TextColor3 = "Text",
			PlaceholderColor3 = "SubText",
		},
	})

	Textbox.Container = New("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.new(0, 6, 0, 0),
		Size = UDim2.new(1, -12, 1, 0),
	}, {
		Textbox.Input,
	})

	Textbox.Indicator = New("Frame", {
		Size = UDim2.new(1, -4, 0, 1),
		Position = UDim2.new(0, 2, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = Acrylic and 0.5 or 0,
		ThemeTag = {
			BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine",
		},
	})

	Textbox.Frame = New("Frame", {
		Size = UDim2.new(0, 0, 0, 30),
		BackgroundTransparency = Acrylic and 0.9 or 0,
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = Acrylic and "Input" or "DialogInput",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = Acrylic and 0.5 or 0.65,
			ThemeTag = {
				Color = Acrylic and "InElementBorder" or "DialogButtonBorder",
			},
		}),
		Textbox.Indicator,
		Textbox.Container,
	})

	local function Update()
		local PADDING = 2
		local Reveal = Textbox.Container.AbsoluteSize.X

		if not Textbox.Input:IsFocused() or Textbox.Input.TextBounds.X <= Reveal - 2 * PADDING then
			Textbox.Input.Position = UDim2.new(0, PADDING, 0, 0)
		else
			local Cursor = Textbox.Input.CursorPosition
			if Cursor ~= -1 then
				local subtext = string.sub(Textbox.Input.Text, 1, Cursor - 1)
				local width = TextService:GetTextSize(
					subtext,
					Textbox.Input.TextSize,
					Textbox.Input.Font,
					Vector2.new(math.huge, math.huge)
				).X

				local CurrentCursorPos = Textbox.Input.Position.X.Offset + width
				if CurrentCursorPos < PADDING then
					Textbox.Input.Position = UDim2.fromOffset(PADDING - width, 0)
				elseif CurrentCursorPos > Reveal - PADDING - 1 then
					Textbox.Input.Position = UDim2.fromOffset(Reveal - width - PADDING - 1, 0)
				end
			end
		end
	end

	task.spawn(Update)

	Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), Update)
	Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("CursorPosition"), Update)

	Creator.AddSignal(Textbox.Input.Focused, function()
		Update()
		Textbox.Indicator.Size = UDim2.new(1, -2, 0, 2)
		Textbox.Indicator.Position = UDim2.new(0, 1, 1, 0)
		Textbox.Indicator.BackgroundTransparency = 0
		Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "InputFocused" or "DialogHolder" })
		Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = "Accent" })
	end)

	Creator.AddSignal(Textbox.Input.FocusLost, function()
		Update()
		Textbox.Indicator.Size = UDim2.new(1, -4, 0, 1)
		Textbox.Indicator.Position = UDim2.new(0, 2, 1, 0)
		Textbox.Indicator.BackgroundTransparency = 0.5
		Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "Input" or "DialogInput" })
		Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine" })
	end)

	return Textbox
end
end

__DimensiModules['Components/TitleBar'] = function(script, require)
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Assets = require(script.Parent.Assets)
local Creator = require(Root.Creator)
local Motion = require(Root.Packages.DimensiMotion)

local New = Creator.New
local AddSignal = Creator.AddSignal

return function(Config)
	local TitleBar = {}

	local Library = require(Root)

	local function BarButton(Icon, Pos, Parent, Callback)
		local Button = {
			Callback = Callback or function() end,
		}

		Button.Frame = New("TextButton", {
			Size = UDim2.new(0, 34, 1, -8),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Parent = Parent,
			Position = Pos,
			Text = "",
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 7),
			}),
			New("ImageLabel", {
				Image = Icon,
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Name = "Icon",
				ThemeTag = {
					ImageColor3 = "Text",
				},
			}),
		})

		local Motor, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")

		AddSignal(Button.Frame.MouseEnter, function()
			SetTransparency(0.94)
		end)
		AddSignal(Button.Frame.MouseLeave, function()
			SetTransparency(1, true)
		end)
		AddSignal(Button.Frame.MouseButton1Down, function()
			SetTransparency(0.96)
		end)
		AddSignal(Button.Frame.MouseButton1Up, function()
			SetTransparency(0.94)
		end)
		AddSignal(Button.Frame.MouseButton1Click, Button.Callback)

		Button.SetCallback = function(Func)
			Button.Callback = Func
		end

		return Button
	end

	TitleBar.Frame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		Parent = Config.Parent,
	}, {
		New("Frame", {
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.new(0, 16, 0, 0),
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 5),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			New("TextLabel", {
				RichText = true,
				Text = Config.Title,
				FontFace = Typography.SemiBold,
				TextSize = 13,
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				Size = UDim2.fromScale(0, 1),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
			New("TextLabel", {
				RichText = true,
				Text = Config.SubTitle,
				TextTransparency = 0.4,
				FontFace = Typography.Regular,
				TextSize = 12,
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				Size = UDim2.fromScale(0, 1),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				ThemeTag = {
					TextColor3 = "Text",
				},
			}),
		}),
		New("Frame", {
			BackgroundTransparency = 0.5,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			ThemeTag = {
				BackgroundColor3 = "TitleBarLine",
			},
		}),
	})

	TitleBar.CloseButton = BarButton(Assets.Close, UDim2.new(1, -4, 0, 4), TitleBar.Frame, function()
		Library.Window:Dialog({
			Title = "Close",
			Content = "Are you sure you want to unload the interface?",
			Buttons = {
				{
					Title = "Yes",
					Callback = function()
						Library:Destroy()
					end,
				},
				{
					Title = "No",
				},
			},
		})
	end)
	TitleBar.MinButton = BarButton(Assets.Min, UDim2.new(1, -40, 0, 4), TitleBar.Frame, function()
		Library.Window:Minimize()
	end)

	return TitleBar
end
end

__DimensiModules['Components/Window'] = function(script, require)
-- i will rewrite this someday
local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local Acrylic = require(Root.Acrylic)
local Assets = require(script.Parent.Assets)
local Components = script.Parent

local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local New = Creator.New

return function(Config)
	local Library = require(Root)

	local function getBounds()
		Camera = Workspace.CurrentCamera or Camera
		local viewport = Camera and Camera.ViewportSize or Vector2.new(800, 600)
		local mobile = viewport.X < 600
		local minWidth = math.min(mobile and 300 or 420, math.max(260, viewport.X - 24))
		local minHeight = math.min(mobile and 280 or 340, math.max(240, viewport.Y - 24))
		return viewport, minWidth, minHeight, math.max(minWidth, viewport.X - 24), math.max(minHeight, viewport.Y - 24), mobile
	end

	local viewport, minWidth, minHeight, maxWidth, maxHeight, mobile = getBounds()
	local initialWidth = math.clamp(Config.Size.X.Offset, minWidth, maxWidth)
	local initialHeight = math.clamp(Config.Size.Y.Offset, minHeight, maxHeight)
	local initialTabWidth = mobile and math.clamp(Config.TabWidth, 92, 108) or math.clamp(Config.TabWidth, 120, 220)

	local Window = {
		Minimized = false,
		Size = UDim2.fromOffset(initialWidth, initialHeight),
		TabWidth = initialTabWidth,
		CurrentPos = 0,
		Position = UDim2.fromOffset(
			math.max(12, viewport.X / 2 - initialWidth / 2),
			math.max(12, viewport.Y / 2 - initialHeight / 2)
		),
	}

	local Dragging, DragInput, MousePos, StartPos = false
	local Resizing, ResizePos = false
	local DragEndConnection
	local MinimizeNotif = false

	Window.AcrylicPaint = Acrylic.AcrylicPaint()

	local Selector = New("Frame", {
		Size = UDim2.fromOffset(4, 0),
		BackgroundColor3 = Color3.fromRGB(76, 194, 255),
		Position = UDim2.fromOffset(0, 17),
		AnchorPoint = Vector2.new(0, 0.5),
		ThemeTag = {
			BackgroundColor3 = "Accent",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 2),
		}),
	})

	local ResizeStartFrame = New("Frame", {
		Size = UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -28, 1, -28),
	})

	Window.TabHolder = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ScrollBarImageTransparency = 1,
		ScrollBarThickness = 0,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 4),
		}),
	})

	local TabFrame = New("Frame", {
		Size = UDim2.new(0, Window.TabWidth, 1, -66),
		Position = UDim2.new(0, 12, 0, 54),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	}, {
		Window.TabHolder,
		Selector,
	})

	Window.TabDisplay = New("TextLabel", {
		RichText = true,
		Text = "Tab",
		TextTransparency = 0,
		FontFace = Typography.SemiBold,
		TextSize = 20,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		Size = UDim2.new(1, -16, 0, 28),
		Position = UDim2.fromOffset(Window.TabWidth + 26, 56),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Window.ContainerHolder = New("CanvasGroup", {
		Size = UDim2.new(1, -Window.TabWidth - 32, 1, -102),
		Position = UDim2.fromOffset(Window.TabWidth + 26, 90),
		BackgroundTransparency = 1,
	})

	Window.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = Window.Size,
		Position = Window.Position,
		Parent = Config.Parent,
		Active = true,
	}, {
		Window.AcrylicPaint.Frame,
		Window.TabDisplay,
		Window.ContainerHolder,
		TabFrame,
		ResizeStartFrame,
	})

	Window.TitleBar = require(script.Parent.TitleBar)({
		Title = Config.Title,
		SubTitle = Config.SubTitle,
		Parent = Window.Root,
		Window = Window,
	})

	if Library.UseAcrylic then
		Window.AcrylicPaint.AddParent(Window.Root)
	end

	local SizeMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		X = Window.Size.X.Offset,
		Y = Window.Size.Y.Offset,
	}), Window.Root)

	local PosMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		X = Window.Position.X.Offset,
		Y = Window.Position.Y.Offset,
	}), Window.Root)

	Window.SelectorPosMotor = Creator.TrackMotor(Motion.SingleMotor.new(17), Window.Root)
	Window.SelectorSizeMotor = Creator.TrackMotor(Motion.SingleMotor.new(0), Window.Root)
	Window.ContainerBackMotor = Creator.TrackMotor(Motion.SingleMotor.new(0), Window.Root)
	Window.ContainerPosMotor = Creator.TrackMotor(Motion.SingleMotor.new(94), Window.Root)

	SizeMotor:onStep(function(values)
		Window.Root.Size = UDim2.new(0, values.X, 0, values.Y)
	end)

	PosMotor:onStep(function(values)
		Window.Root.Position = UDim2.new(0, values.X, 0, values.Y)
	end)

	local LastValue = 0
	local LastTime = 0
	Window.SelectorPosMotor:onStep(function(Value)
		Selector.Position = UDim2.new(0, 0, 0, Value + 17)
		local Now = tick()
		local DeltaTime = Now - LastTime

		if LastValue ~= nil then
			Window.SelectorSizeMotor:setGoal(Spring((math.abs(Value - LastValue) / (DeltaTime * 60)) + 16))
			LastValue = Value
		end
		LastTime = Now
	end)

	Window.SelectorSizeMotor:onStep(function(Value)
		Selector.Size = UDim2.new(0, 4, 0, Value)
	end)

	Window.ContainerBackMotor:onStep(function(Value)
		Window.ContainerHolder.GroupTransparency = Value
	end)

	Window.ContainerPosMotor:onStep(function(Value)
		Window.ContainerHolder.Position = UDim2.fromOffset(Window.TabWidth + 26, Value)
	end)

	Creator.AddSignal(Window.TitleBar.Frame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = true
			MousePos = Input.Position
			StartPos = Window.Root.Position

			if DragEndConnection then
				Creator.DisconnectSignal(DragEndConnection)
			end
			DragEndConnection = Creator.TrackConnection(Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
					if DragEndConnection then
						Creator.DisconnectSignal(DragEndConnection)
						DragEndConnection = nil
					end
				end
			end))
		end
	end)

	Creator.AddSignal(Window.TitleBar.Frame.InputChanged, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			DragInput = Input
		end
	end)

	Creator.AddSignal(ResizeStartFrame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Resizing = true
			ResizePos = Input.Position
		end
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - MousePos
			local view = Camera.ViewportSize
			local x = math.clamp(StartPos.X.Offset + Delta.X, 0, math.max(0, view.X - Window.Size.X.Offset))
			local y = math.clamp(StartPos.Y.Offset + Delta.Y, 0, math.max(0, view.Y - Window.Size.Y.Offset))
			Window.Position = UDim2.fromOffset(x, y)
			PosMotor:setGoal({
				X = Instant(Window.Position.X.Offset),
				Y = Instant(Window.Position.Y.Offset),
			})

		end

		if
			(Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
			and Resizing
		then
			local Delta = Input.Position - ResizePos
			local StartSize = Window.Size

			local TargetSize = Vector3.new(StartSize.X.Offset, StartSize.Y.Offset, 0) + Vector3.new(1, 1, 0) * Delta
			local _, minW, minH, maxW, maxH = getBounds()
			local viewport = Camera.ViewportSize
			maxW = math.max(minW, math.min(maxW, viewport.X - Window.Position.X.Offset - 12))
			maxH = math.max(minH, math.min(maxH, viewport.Y - Window.Position.Y.Offset - 12))
			local TargetSizeClamped = Vector2.new(
				math.clamp(TargetSize.X, minW, maxW),
				math.clamp(TargetSize.Y, minH, maxH)
			)

			SizeMotor:setGoal({
				X = Motion.Instant.new(TargetSizeClamped.X),
				Y = Motion.Instant.new(TargetSizeClamped.Y),
			})
		end
	end)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if Resizing == true or Input.UserInputType == Enum.UserInputType.Touch then
			Resizing = false
			Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
		end
	end)

	local function FitToViewport()
		if not Window.Root or not Window.Root.Parent then return end
		local view, minW, minH, maxW, maxH, isMobile = getBounds()
		local width = math.clamp(Window.Size.X.Offset, minW, maxW)
		local height = math.clamp(Window.Size.Y.Offset, minH, maxH)
		local x = math.clamp(Window.Position.X.Offset, 0, math.max(0, view.X - width))
		local y = math.clamp(Window.Position.Y.Offset, 0, math.max(0, view.Y - height))
		Window.Size = UDim2.fromOffset(width, height)
		Window.Position = UDim2.fromOffset(x, y)
		Window.TabWidth = isMobile and math.clamp(Window.TabWidth, 92, 108) or math.clamp(Window.TabWidth, 120, 220)
		SizeMotor:setGoal({ X = Instant(width), Y = Instant(height) })
		PosMotor:setGoal({ X = Instant(x), Y = Instant(y) })
		TabFrame.Size = UDim2.new(0, Window.TabWidth, 1, -66)
		Window.TabDisplay.Position = UDim2.fromOffset(Window.TabWidth + 26, 56)
		Window.ContainerHolder.Size = UDim2.new(1, -Window.TabWidth - 32, 1, -102)
		Window.ContainerHolder.Position = UDim2.fromOffset(Window.TabWidth + 26, 90)
	end

	local ViewportConnection
	local function BindCamera()
		if ViewportConnection then
			Creator.DisconnectSignal(ViewportConnection)
			ViewportConnection = nil
		end
		Camera = Workspace.CurrentCamera
		if Camera then
			ViewportConnection = Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), FitToViewport)
			FitToViewport()
		end
	end
	Creator.AddSignal(Workspace:GetPropertyChangedSignal("CurrentCamera"), BindCamera, Window.Root)
	BindCamera()

	Creator.AddSignal(Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, Window.TabHolder.UIListLayout.AbsoluteContentSize.Y)
	end)

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if
			type(Library.MinimizeKeybind) == "table"
			and Library.MinimizeKeybind.Type == "Keybind"
			and not UserInputService:GetFocusedTextBox()
		then
			if Input.KeyCode.Name == Library.MinimizeKeybind.Value then
				Window:Minimize()
			end
		elseif Input.KeyCode == Library.MinimizeKey and not UserInputService:GetFocusedTextBox() then
			Window:Minimize()
		end
	end)

	function Window:Minimize()
		Window.Minimized = not Window.Minimized
		Window.Root.Visible = not Window.Minimized
		if not MinimizeNotif then
			MinimizeNotif = true
			local Key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey.Name
			Library:Notify({
				Title = "Interface",
				Content = "Press " .. Key .. " to toggle the inteface.",
				Duration = 6
			})
		end
	end

	function Window:Destroy()
		for index = #Library.OpenFrames, 1, -1 do
			local frame = Library.OpenFrames[index]
			if frame and frame.Parent then pcall(function() frame:Destroy() end) end
			table.remove(Library.OpenFrames, index)
		end
		if Library.UseAcrylic and Window.AcrylicPaint and Window.AcrylicPaint.Model then
			pcall(function() Window.AcrylicPaint.Model:Destroy() end)
		end
		if Window.Root then Window.Root:Destroy() end
	end

	local DialogModule = require(Components.Dialog):Init(Window)
	function Window:Dialog(Config)
		assert(type(Config) == "table" and type(Config.Title) == "string" and type(Config.Content) == "string", "Window:Dialog requires Title and Content strings")
		if require(Root).Unloaded then return nil end
		local Dialog = DialogModule:Create()
		Dialog.Title.Text = Config.Title

		local Content = New("TextLabel", {
			FontFace = Typography.Regular,
			Text = Config.Content,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 12,
			TextWrapped = true,
			LineHeight = 1.12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, -40, 1, 0),
			Position = UDim2.fromOffset(20, 60),
			BackgroundTransparency = 1,
			Parent = Dialog.Root,
			ClipsDescendants = false,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		New("UISizeConstraint", {
			MinSize = Vector2.new(220, 150),
			MaxSize = Vector2.new(620, math.huge),
			Parent = Dialog.Root,
		})

		Dialog.Root.Size = UDim2.fromOffset(Content.TextBounds.X + 40, 165)
		if Content.TextBounds.X + 40 > Window.Size.X.Offset - 120 then
			Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, 165)
			Content.TextWrapped = true
			Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, Content.TextBounds.Y + 150)
		end

		for _, Button in next, Config.Buttons do
			Dialog:Button(Button.Title, Button.Callback)
		end

		Dialog:Open()
	end

	local TabModule = require(Components.Tab):Init(Window)
	function Window:AddTab(TabConfig)
		assert(type(TabConfig) == "table", "Window:AddTab expects a table")
		assert(type(TabConfig.Title) == "string" and TabConfig.Title ~= "", "Window:AddTab requires Title")
		return TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder)
	end

	function Window:SelectTab(Tab)
		local Index = type(Tab) == "table" and Tab.Index or Tab
		return TabModule:SelectTab(Index)
	end

	Creator.AddSignal(Window.TabHolder:GetPropertyChangedSignal("CanvasPosition"), function()
		LastValue = TabModule:GetCurrentTabPos() + 16
		LastTime = 0
		Window.SelectorPosMotor:setGoal(Instant(TabModule:GetCurrentTabPos()))
	end)

	return Window
end
end

__DimensiModules['Elements/Button'] = function(script, require)
local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Button"

function Element:New(Idx, Config)
	-- The public element dispatcher always calls New(Idx, Config).
	-- Also accept the one-argument config form for backwards compatibility.
	if Config == nil and type(Idx) == "table" then
		Config = Idx
	end
	assert(type(Config) == "table", "Button - Config must be a table")
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Button - Missing Title")
	assert(Config.Callback == nil or type(Config.Callback) == "function", "Button - Callback must be a function")
	Config.Callback = Config.Callback or function() end

	local ButtonFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)

	local ButtonIco = New("ImageLabel", {
		Image = "rbxassetid://10709791437",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		BackgroundTransparency = 1,
		Parent = ButtonFrame.Frame,
		ThemeTag = {
			ImageColor3 = "Text",
		},
	})

	Creator.AddSignal(ButtonFrame.Frame.MouseButton1Click, function()
		self.Library:SafeCallback(Config.Callback)
	end)

	return ButtonFrame
end

return Element
end

__DimensiModules['Elements/Colorpicker'] = function(script, require)
local UserInputService = game:GetService("UserInputService")
local TouchInputService = game:GetService("TouchInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local RenderStepped = RunService.RenderStepped
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Colorpicker"

function Element:New(Idx, Config)
	assert(type(Config) == "table", "Colorpicker - Config must be a table")
	local Library = self.Library
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Colorpicker - Missing Title")
	assert(typeof(Config.Default) == "Color3", "Colorpicker - Default must be a Color3")
	assert(Config.Transparency == nil or (type(Config.Transparency) == "number" and Config.Transparency == Config.Transparency and Config.Transparency >= 0 and Config.Transparency <= 1), "Colorpicker - Transparency must be between 0 and 1")
	assert(Config.Callback == nil or type(Config.Callback) == "function", "Colorpicker - Callback must be a function")

	local Colorpicker = {
		Value = Config.Default,
		Transparency = Config.Transparency or 0,
		Type = "Colorpicker",
		Title = type(Config.Title) == "string" and Config.Title or "Colorpicker",
		Callback = Config.Callback or function(Color) end,
	}

	function Colorpicker:SetHSVFromRGB(Color)
		local H, S, V = Color3.toHSV(Color)
		Colorpicker.Hue = H
		Colorpicker.Sat = S
		Colorpicker.Vib = V
	end

	Colorpicker:SetHSVFromRGB(Colorpicker.Value)

	local ColorpickerFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)

	ColorpickerFrame.LabelHolder.Size = UDim2.new(1, -54, 0, 0)
	Colorpicker.SetTitle = ColorpickerFrame.SetTitle
	Colorpicker.SetDesc = ColorpickerFrame.SetDesc

	local DisplayFrameColor = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Colorpicker.Value,
		Parent = ColorpickerFrame.Frame,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
	})

	local DisplayFrame = New("ImageLabel", {
		Size = UDim2.fromOffset(26, 26),
		Position = UDim2.new(1, -10, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Parent = ColorpickerFrame.Frame,
		Image = "https://www.roblox.com/asset/?id=14204231522",
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(40, 40),
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		DisplayFrameColor,
	})

	local function CreateColorDialog()
		local Dialog = require(Components.Dialog):Create()
		Dialog.Title.Text = Colorpicker.Title
		Dialog.Root.Size = UDim2.fromOffset(430, 330)

		local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
		local Transparency = Colorpicker.Transparency

		local function CreateInput()
			local Box = require(Components.Textbox)()
			Box.Frame.Parent = Dialog.Root
			Box.Frame.Size = UDim2.new(0, 90, 0, 32)

			return Box
		end

		local function CreateInputLabel(Text, Pos)
			return New("TextLabel", {
				FontFace = Typography.Medium,
				Text = Text,
				TextColor3 = Color3.fromRGB(240, 240, 240),
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, 32),
				Position = Pos,
				BackgroundTransparency = 1,
				Parent = Dialog.Root,
				ThemeTag = {
					TextColor3 = "Text",
				},
			})
		end

		local function GetRGB()
			local Value = Color3.fromHSV(Hue, Sat, Vib)
			return { R = math.floor(Value.r * 255), G = math.floor(Value.g * 255), B = math.floor(Value.b * 255) }
		end

		local SatCursor = New("ImageLabel", {
			Size = UDim2.new(0, 18, 0, 18),
			ScaleType = Enum.ScaleType.Fit,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "https://www.roblox.com/asset/?id=4805639000",
		})

		local SatVibMap = New("ImageLabel", {
			Size = UDim2.fromOffset(180, 160),
			Position = UDim2.fromOffset(20, 55),
			Image = "rbxassetid://4155801252",
			BackgroundColor3 = Colorpicker.Value,
			BackgroundTransparency = 0,
			Parent = Dialog.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			SatCursor,
		})

		local OldColorFrame = New("Frame", {
			BackgroundColor3 = Colorpicker.Value,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = Colorpicker.Transparency,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
		})

		local OldColorFrameChecker = New("ImageLabel", {
			Image = "https://www.roblox.com/asset/?id=14204231522",
			ImageTransparency = 0.45,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.fromOffset(40, 40),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(112, 220),
			Size = UDim2.fromOffset(88, 24),
			Parent = Dialog.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			New("UIStroke", {
				Thickness = 2,
				Transparency = 0.75,
			}),
			OldColorFrame,
		})

		local DialogDisplayFrame = New("Frame", {
			BackgroundColor3 = Colorpicker.Value,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
		})

		local DialogDisplayFrameChecker = New("ImageLabel", {
			Image = "https://www.roblox.com/asset/?id=14204231522",
			ImageTransparency = 0.45,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.fromOffset(40, 40),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(20, 220),
			Size = UDim2.fromOffset(88, 24),
			Parent = Dialog.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			New("UIStroke", {
				Thickness = 2,
				Transparency = 0.75,
			}),
			DialogDisplayFrame,
		})

		local SequenceTable = {}

		for Color = 0, 1, 0.1 do
			table.insert(SequenceTable, ColorSequenceKeypoint.new(Color, Color3.fromHSV(Color, 1, 1)))
		end

		local HueSliderGradient = New("UIGradient", {
			Color = ColorSequence.new(SequenceTable),
			Rotation = 90,
		})

		local HueDragHolder = New("Frame", {
			Size = UDim2.new(1, 0, 1, -10),
			Position = UDim2.fromOffset(0, 5),
			BackgroundTransparency = 1,
		})

		local HueDrag = New("ImageLabel", {
			Size = UDim2.fromOffset(14, 14),
			Image = "https://www.roblox.com/asset/?id=12266946128",
			Parent = HueDragHolder,
			ThemeTag = {
				ImageColor3 = "DialogInput",
			},
		})

		local HueSlider = New("Frame", {
			Size = UDim2.fromOffset(12, 190),
			Position = UDim2.fromOffset(210, 55),
			Parent = Dialog.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
			HueSliderGradient,
			HueDragHolder,
		})

		local HexInput = CreateInput()
		HexInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 55)
		CreateInputLabel("Hex", UDim2.fromOffset(Config.Transparency and 360 or 340, 55))

		local RedInput = CreateInput()
		RedInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 95)
		CreateInputLabel("Red", UDim2.fromOffset(Config.Transparency and 360 or 340, 95))

		local GreenInput = CreateInput()
		GreenInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 135)
		CreateInputLabel("Green", UDim2.fromOffset(Config.Transparency and 360 or 340, 135))

		local BlueInput = CreateInput()
		BlueInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 175)
		CreateInputLabel("Blue", UDim2.fromOffset(Config.Transparency and 360 or 340, 175))

		local AlphaInput
		if Config.Transparency then
			AlphaInput = CreateInput()
			AlphaInput.Frame.Position = UDim2.fromOffset(260, 215)
			CreateInputLabel("Alpha", UDim2.fromOffset(360, 215))
		end

		local TransparencySlider, TransparencyDrag, TransparencyColor
		if Config.Transparency then
			local TransparencyDragHolder = New("Frame", {
				Size = UDim2.new(1, 0, 1, -10),
				Position = UDim2.fromOffset(0, 5),
				BackgroundTransparency = 1,
			})

			TransparencyDrag = New("ImageLabel", {
				Size = UDim2.fromOffset(14, 14),
				Image = "https://www.roblox.com/asset/?id=12266946128",
				Parent = TransparencyDragHolder,
				ThemeTag = {
					ImageColor3 = "DialogInput",
				},
			})

			TransparencyColor = New("Frame", {
				Size = UDim2.fromScale(1, 1),
			}, {
				New("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Rotation = 270,
				}),
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			})

			TransparencySlider = New("Frame", {
				Size = UDim2.fromOffset(12, 190),
				Position = UDim2.fromOffset(230, 55),
				Parent = Dialog.Root,
				BackgroundTransparency = 1,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
				New("ImageLabel", {
					Image = "https://www.roblox.com/asset/?id=14204231522",
					ImageTransparency = 0.45,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.fromOffset(40, 40),
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Parent = Dialog.Root,
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),
				TransparencyColor,
				TransparencyDragHolder,
			})
		end

		local function Display()
			SatVibMap.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
			HueDrag.Position = UDim2.new(0, -1, Hue, -6)
			SatCursor.Position = UDim2.new(Sat, 0, 1 - Vib, 0)
			DialogDisplayFrame.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)

			HexInput.Input.Text = "#" .. Color3.fromHSV(Hue, Sat, Vib):ToHex()
			RedInput.Input.Text = GetRGB()["R"]
			GreenInput.Input.Text = GetRGB()["G"]
			BlueInput.Input.Text = GetRGB()["B"]

			if Config.Transparency then
				TransparencyColor.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
				DialogDisplayFrame.BackgroundTransparency = Transparency
				TransparencyDrag.Position = UDim2.new(0, -1, 1 - Transparency, -6)
				AlphaInput.Input.Text = require(Root):Round((1 - Transparency) * 100, 0) .. "%"
			end
		end

		Creator.AddSignal(HexInput.Input.FocusLost, function(Enter)
			if Enter then
				local Success, Result = pcall(Color3.fromHex, HexInput.Input.Text)
				if Success and typeof(Result) == "Color3" then
					Hue, Sat, Vib = Color3.toHSV(Result)
				end
			end
			Display()
		end)

		Creator.AddSignal(RedInput.Input.FocusLost, function(Enter)
			if Enter then
				local CurrentColor = GetRGB()
				local Success, Result = pcall(Color3.fromRGB, RedInput.Input.Text, CurrentColor["G"], CurrentColor["B"])
				if Success and typeof(Result) == "Color3" then
					if tonumber(RedInput.Input.Text) <= 255 then
						Hue, Sat, Vib = Color3.toHSV(Result)
					end
				end
			end
			Display()
		end)

		Creator.AddSignal(GreenInput.Input.FocusLost, function(Enter)
			if Enter then
				local CurrentColor = GetRGB()
				local Success, Result =
					pcall(Color3.fromRGB, CurrentColor["R"], GreenInput.Input.Text, CurrentColor["B"])
				if Success and typeof(Result) == "Color3" then
					if tonumber(GreenInput.Input.Text) <= 255 then
						Hue, Sat, Vib = Color3.toHSV(Result)
					end
				end
			end
			Display()
		end)

		Creator.AddSignal(BlueInput.Input.FocusLost, function(Enter)
			if Enter then
				local CurrentColor = GetRGB()
				local Success, Result =
					pcall(Color3.fromRGB, CurrentColor["R"], CurrentColor["G"], BlueInput.Input.Text)
				if Success and typeof(Result) == "Color3" then
					if tonumber(BlueInput.Input.Text) <= 255 then
						Hue, Sat, Vib = Color3.toHSV(Result)
					end
				end
			end
			Display()
		end)

		if Config.Transparency then
			Creator.AddSignal(AlphaInput.Input.FocusLost, function(Enter)
				if Enter then
					pcall(function()
						local Value = tonumber(AlphaInput.Input.Text)
						if Value >= 0 and Value <= 100 then
							Transparency = 1 - Value * 0.01
						end
					end)
				end
				Display()
			end)
		end

		Creator.AddSignal(SatVibMap.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					local MinX = SatVibMap.AbsolutePosition.X
					local MaxX = MinX + SatVibMap.AbsoluteSize.X
					local MouseX = math.clamp(Mouse.X, MinX, MaxX)

					local MinY = SatVibMap.AbsolutePosition.Y
					local MaxY = MinY + SatVibMap.AbsoluteSize.Y
					local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

					Sat = (MouseX - MinX) / (MaxX - MinX)
					Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
					Display()

					RenderStepped:Wait()
				end
			end
		end)

		Creator.AddSignal(HueSlider.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					local MinY = HueSlider.AbsolutePosition.Y
					local MaxY = MinY + HueSlider.AbsoluteSize.Y
					local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

					Hue = ((MouseY - MinY) / (MaxY - MinY))
					Display()

					RenderStepped:Wait()
				end
			end
		end)

		if Config.Transparency then
			Creator.AddSignal(TransparencySlider.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinY = TransparencySlider.AbsolutePosition.Y
						local MaxY = MinY + TransparencySlider.AbsoluteSize.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

						Transparency = 1 - ((MouseY - MinY) / (MaxY - MinY))
						Display()

						RenderStepped:Wait()
					end
				end
			end)
		end

		Display()

		Dialog:Button("Done", function()
			Colorpicker:SetValue({ Hue, Sat, Vib }, Transparency)
		end)
		Dialog:Button("Cancel")
		Dialog:Open()
	end

	function Colorpicker:Display()
		Colorpicker.Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)

		DisplayFrameColor.BackgroundColor3 = Colorpicker.Value
		DisplayFrameColor.BackgroundTransparency = Colorpicker.Transparency

		Element.Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
		Element.Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
	end

	function Colorpicker:SetValue(HSV, Transparency)
		assert(type(HSV) == "table" and type(HSV[1]) == "number" and type(HSV[2]) == "number" and type(HSV[3]) == "number", "Colorpicker:SetValue expects HSV numeric values")
		for i = 1, 3 do assert(HSV[i] == HSV[i] and math.abs(HSV[i]) < math.huge and HSV[i] >= 0 and HSV[i] <= 1, "Colorpicker HSV values must be within 0 and 1") end
		assert(Transparency == nil or (type(Transparency) == "number" and Transparency == Transparency and math.abs(Transparency) < math.huge), "Colorpicker transparency must be finite")
		local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

		Colorpicker.Transparency = math.clamp(Transparency or 0, 0, 1)
		Colorpicker:SetHSVFromRGB(Color)
		Colorpicker:Display()
	end

	function Colorpicker:SetValueRGB(Color, Transparency)
		assert(typeof(Color) == "Color3", "Colorpicker:SetValueRGB expects Color3")
		assert(Transparency == nil or (type(Transparency) == "number" and Transparency == Transparency and math.abs(Transparency) < math.huge), "Colorpicker transparency must be finite")
		Colorpicker.Transparency = math.clamp(Transparency or 0, 0, 1)
		Colorpicker:SetHSVFromRGB(Color)
		Colorpicker:Display()
	end

	function Colorpicker:OnChanged(Func)
		Colorpicker.Changed = Func
		Element.Library:SafeCallback(Func, Colorpicker.Value)
	end

	function Colorpicker:Destroy()
		ColorpickerFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Creator.AddSignal(ColorpickerFrame.Frame.MouseButton1Click, function()
		CreateColorDialog()
	end)

	Colorpicker:Display()

	Library.Options[Idx] = Colorpicker
	return Colorpicker
end

return Element
end

__DimensiModules['Elements/Dropdown'] = function(script, require)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera

local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Creator = require(Root.Creator)
local Motion = require(Root.Packages.DimensiMotion)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Dropdown"

function Element:New(Idx, Config)
	assert(type(Config) == "table", "Dropdown - Config must be a table")
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Dropdown - Missing Title")
	assert(type(Config.Values) == "table", "Dropdown - Values must be a table")
	local seenOptions = {}
	local optionCount, maxOptionIndex = 0, 0
	for key, option in pairs(Config.Values) do
		assert(type(key) == "number" and key >= 1 and key % 1 == 0, "Dropdown - Values must be a sequential array")
		assert(type(option) == "string", "Dropdown - Options must be strings")
		assert(not seenOptions[option], "Dropdown - Duplicate options are not allowed")
		seenOptions[option] = true
		optionCount += 1
		maxOptionIndex = math.max(maxOptionIndex, key)
	end
	assert(optionCount == maxOptionIndex, "Dropdown - Values must not contain holes")
	assert(Config.Default == nil or type(Config.Default) == "string" or type(Config.Default) == "number" or type(Config.Default) == "table", "Dropdown - Invalid Default type")
	assert(Config.Multi == nil or type(Config.Multi) == "boolean", "Dropdown - Multi must be boolean")
	assert(Config.Callback == nil or type(Config.Callback) == "function", "Dropdown - Callback must be a function")
	local Library = self.Library

	local Dropdown = {
		Values = Config.Values,
		Value = Config.Multi and {} or (type(Config.Default) == "number" and nil or Config.Default),
		Multi = Config.Multi,
		Buttons = {},
		Opened = false,
		Type = "Dropdown",
		Callback = Config.Callback or function() end,
	}

	local DropdownFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, false)
	DropdownFrame.LabelHolder.Size = UDim2.new(0.56, -24, 0, 0)
	DropdownFrame.DescLabel.Size = UDim2.new(1, 0, 0, 0)

	Dropdown.SetTitle = DropdownFrame.SetTitle
	Dropdown.SetDesc = DropdownFrame.SetDesc

	local DropdownDisplay = New("TextLabel", {
		FontFace = Typography.Regular,
		Text = "Value",
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -30, 0, 14),
		Position = UDim2.new(0, 8, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local DropdownIco = New("ImageLabel", {
		Image = "rbxassetid://10709790948",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		BackgroundTransparency = 1,
		ThemeTag = {
			ImageColor3 = "SubText",
		},
	})

	local DropdownInner = New("TextButton", {
		Size = UDim2.new(0.42, 0, 0, 32),
		Position = UDim2.new(1, -10, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 0.9,
		Parent = DropdownFrame.Frame,
		ThemeTag = {
			BackgroundColor3 = "DropdownFrame",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 5),
		}),
		New("UISizeConstraint", {
			MinSize = Vector2.new(84, 32),
			MaxSize = Vector2.new(160, 32),
		}),
		New("UIStroke", {
			Transparency = 0.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "InElementBorder",
			},
		}),
		DropdownIco,
		DropdownDisplay,
	})

	local DropdownListLayout = New("UIListLayout", {
		Padding = UDim.new(0, 3),
	})

	local DropdownScrollFrame = New("ScrollingFrame", {
		Size = UDim2.new(1, -5, 1, -10),
		Position = UDim2.fromOffset(5, 5),
		BackgroundTransparency = 1,
		BottomImage = "rbxassetid://6889812791",
		MidImage = "rbxassetid://6889812721",
		TopImage = "rbxassetid://6276641225",
		ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
		ScrollBarImageTransparency = 0.95,
		ScrollBarThickness = 4,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
	}, {
		DropdownListLayout,
	})

	local DropdownHolderFrame = New("Frame", {
		Size = UDim2.fromScale(1, 0.6),
		ThemeTag = {
			BackgroundColor3 = "DropdownHolder",
		},
	}, {
		DropdownScrollFrame,
		New("UICorner", {
			CornerRadius = UDim.new(0, 7),
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "DropdownBorder",
			},
		}),
		New("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "https://www.roblox.com/asset/?id=5554236805",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(23, 23, 277, 277),
			Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
			Position = UDim2.fromOffset(-15, -15),
			ImageColor3 = Color3.fromRGB(0, 0, 0),
			ImageTransparency = 0.1,
		}),
	})

	local DropdownHolderCanvas = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(170, 300),
		Parent = self.Library.GUI,
		Visible = false,
	}, {
		DropdownHolderFrame,
		New("UISizeConstraint", {
			MinSize = Vector2.new(140, 0),
			MaxSize = Vector2.new(math.max(140, Camera.ViewportSize.X - 24), math.huge),
		}),
	})
	table.insert(Library.OpenFrames, DropdownHolderCanvas)

	local function RecalculateListPosition()
		local Add = 0
		if Camera.ViewportSize.Y - DropdownInner.AbsolutePosition.Y < DropdownHolderCanvas.AbsoluteSize.Y - 5 then
			Add = DropdownHolderCanvas.AbsoluteSize.Y
				- 5
				- (Camera.ViewportSize.Y - DropdownInner.AbsolutePosition.Y)
				+ 40
		end
		local viewport = Camera.ViewportSize
		local x = math.clamp(DropdownInner.AbsolutePosition.X - 1, 12, math.max(12, viewport.X - DropdownHolderCanvas.AbsoluteSize.X - 12))
		local y = math.clamp(DropdownInner.AbsolutePosition.Y - 5 - Add, 12, math.max(12, viewport.Y - DropdownHolderCanvas.AbsoluteSize.Y - 12))
		DropdownHolderCanvas.Position = UDim2.fromOffset(x, y)
	end

	local ListSizeX = 0
	local function RecalculateListSize()
		if #Dropdown.Values > 10 then
			DropdownHolderCanvas.Size = UDim2.fromOffset(ListSizeX, 392)
		else
			DropdownHolderCanvas.Size = UDim2.fromOffset(ListSizeX, DropdownListLayout.AbsoluteContentSize.Y + 10)
		end
	end

	local function RecalculateCanvasSize()
		DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
	end

	RecalculateListPosition()
	RecalculateListSize()

	Creator.AddSignal(DropdownInner:GetPropertyChangedSignal("AbsolutePosition"), RecalculateListPosition)

	Creator.AddSignal(DropdownInner.MouseButton1Click, function()
		Dropdown:Open()
	end)

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			local AbsPos, AbsSize = DropdownHolderFrame.AbsolutePosition, DropdownHolderFrame.AbsoluteSize
			if
				Mouse.X < AbsPos.X
				or Mouse.X > AbsPos.X + AbsSize.X
				or Mouse.Y < (AbsPos.Y - 20 - 1)
				or Mouse.Y > AbsPos.Y + AbsSize.Y
			then
				Dropdown:Close()
			end
		end
	end, DropdownFrame.Frame)

	local ScrollFrame = self.ScrollFrame
	function Dropdown:Open()
		Dropdown.Opened = true
		ScrollFrame.ScrollingEnabled = false
		DropdownHolderCanvas.Visible = true
		TweenService:Create(
			DropdownHolderFrame,
			TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{ Size = UDim2.fromScale(1, 1) }
		):Play()
	end

	function Dropdown:Close()
		Dropdown.Opened = false
		ScrollFrame.ScrollingEnabled = true
		DropdownHolderFrame.Size = UDim2.fromScale(1, 0.6)
		DropdownHolderCanvas.Visible = false
	end

	function Dropdown:Display()
		local Values = Dropdown.Values
		local Str = ""

		if Config.Multi then
			for Idx, Value in next, Values do
				if Dropdown.Value[Value] then
					Str = Str .. Value .. ", "
				end
			end
			Str = Str:sub(1, #Str - 2)
		else
			Str = Dropdown.Value or ""
		end

		DropdownDisplay.Text = (Str == "" and "--" or Str)
	end

	function Dropdown:GetActiveValues()
		if Config.Multi then
			local T = {}

			for Value, Bool in next, Dropdown.Value do
				table.insert(T, Value)
			end

			return T
		else
			return Dropdown.Value and 1 or 0
		end
	end

	function Dropdown:BuildDropdownList()
		local Values = Dropdown.Values
		local Buttons = {}

		for _, Element in next, DropdownScrollFrame:GetChildren() do
			if not Element:IsA("UIListLayout") then
				Element:Destroy()
			end
		end

		local Count = 0

		for Idx, Value in next, Values do
			local Table = {}

			Count = Count + 1

			local ButtonSelector = New("Frame", {
				Size = UDim2.fromOffset(4, 14),
				BackgroundColor3 = Color3.fromRGB(76, 194, 255),
				Position = UDim2.fromOffset(-1, 16),
				AnchorPoint = Vector2.new(0, 0.5),
				ThemeTag = {
					BackgroundColor3 = "Accent",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 2),
				}),
			})

			local ButtonLabel = New("TextLabel", {
				FontFace = Typography.Regular,
				Text = Value,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromOffset(10, 0),
				Name = "ButtonLabel",
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local Button = New("TextButton", {
				Size = UDim2.new(1, -5, 0, 32),
				BackgroundTransparency = 1,
				ZIndex = 23,
				Text = "",
				Parent = DropdownScrollFrame,
				ThemeTag = {
					BackgroundColor3 = "DropdownOption",
				},
			}, {
				ButtonSelector,
				ButtonLabel,
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
			})

			local Selected

			if Config.Multi then
				Selected = Dropdown.Value[Value]
			else
				Selected = Dropdown.Value == Value
			end

			local BackMotor, SetBackTransparency = Creator.SpringMotor(1, Button, "BackgroundTransparency")
			local SelMotor, SetSelTransparency = Creator.SpringMotor(1, ButtonSelector, "BackgroundTransparency")
			local SelectorSizeMotor = Creator.TrackMotor(Motion.SingleMotor.new(6), Button)

			SelectorSizeMotor:onStep(function(value)
				ButtonSelector.Size = UDim2.new(0, 4, 0, value)
			end)

			Creator.AddSignal(Button.MouseEnter, function()
				SetBackTransparency(Selected and 0.85 or 0.89)
			end)
			Creator.AddSignal(Button.MouseLeave, function()
				SetBackTransparency(Selected and 0.89 or 1)
			end)
			Creator.AddSignal(Button.MouseButton1Down, function()
				SetBackTransparency(0.92)
			end)
			Creator.AddSignal(Button.MouseButton1Up, function()
				SetBackTransparency(Selected and 0.85 or 0.89)
			end)

			function Table:UpdateButton()
				if Config.Multi then
					Selected = Dropdown.Value[Value]
					if Selected then
						SetBackTransparency(0.89)
					end
				else
					Selected = Dropdown.Value == Value
					SetBackTransparency(Selected and 0.89 or 1)
				end

				SelectorSizeMotor:setGoal(Motion.Spring.new(Selected and 14 or 6, { frequency = 6 }))
				SetSelTransparency(Selected and 0 or 1)
			end

			Creator.AddSignal(ButtonLabel.InputBegan, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					local Try = not Selected

					if Dropdown:GetActiveValues() == 1 and not Try and not Config.AllowNull then
					else
						if Config.Multi then
							Selected = Try
							Dropdown.Value[Value] = Selected and true or nil
						else
							Selected = Try
							Dropdown.Value = Selected and Value or nil

							for _, OtherButton in next, Buttons do
								OtherButton:UpdateButton()
							end
						end

						Table:UpdateButton()
						Dropdown:Display()

						Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
						Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
					end
				end
			end)

			Table:UpdateButton()
			Dropdown:Display()

			Buttons[Button] = Table
		end

		ListSizeX = 0
		for Button, Table in next, Buttons do
			if Button.ButtonLabel then
				if Button.ButtonLabel.TextBounds.X > ListSizeX then
					ListSizeX = Button.ButtonLabel.TextBounds.X
				end
			end
		end
		ListSizeX = math.clamp(ListSizeX + 30, 140, math.max(140, Camera.ViewportSize.X - 24))

		RecalculateCanvasSize()
		RecalculateListSize()
	end

	function Dropdown:SetValues(NewValues)
		assert(type(NewValues) == "table", "Dropdown:SetValues expects a table")
		local seen = {}
		local count, maxIndex = 0, 0
		for key, option in pairs(NewValues) do
			assert(type(key) == "number" and key >= 1 and key % 1 == 0, "Dropdown:SetValues expects an array")
			assert(type(option) == "string", "Dropdown options must be strings")
			assert(not seen[option], "Dropdown options cannot contain duplicates")
			seen[option] = true
			count += 1
			maxIndex = math.max(maxIndex, key)
		end
		assert(count == maxIndex, "Dropdown:SetValues cannot contain holes")
		Dropdown.Values = NewValues
		if Dropdown.Multi then
			local cleaned = {}
			for value, enabled in pairs(Dropdown.Value or {}) do
				if enabled and table.find(NewValues, value) then cleaned[value] = true end
			end
			Dropdown.Value = cleaned
		elseif Dropdown.Value and not table.find(NewValues, Dropdown.Value) then
			Dropdown.Value = nil
		end
		Dropdown:BuildDropdownList()
	end

	function Dropdown:OnChanged(Func)
		Dropdown.Changed = Func
		Library:SafeCallback(Func, Dropdown.Value)
	end

	function Dropdown:SetValue(Val)
		if Dropdown.Multi then
			assert(type(Val) == "table", "Dropdown:SetValue expects a table in Multi mode")
			local nTable = {}

			for Value, Bool in next, Val do
				assert(type(Value) == "string" and type(Bool) == "boolean", "Dropdown multi-value must map string options to booleans")
				if Bool and table.find(Dropdown.Values, Value) then nTable[Value] = true end
			end

			Dropdown.Value = nTable
		else
			if not Val then
				Dropdown.Value = nil
			elseif table.find(Dropdown.Values, Val) then
				Dropdown.Value = Val
			end
		end

		Dropdown:BuildDropdownList()

		Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
		Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
	end

	function Dropdown:Destroy()
		Dropdown:Close()
		for index = #Library.OpenFrames, 1, -1 do
			if Library.OpenFrames[index] == DropdownHolderCanvas then
				table.remove(Library.OpenFrames, index)
			end
		end
		if DropdownHolderCanvas then DropdownHolderCanvas:Destroy() end
		DropdownFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Dropdown:BuildDropdownList()
	Dropdown:Display()

	local Defaults = {}

	if type(Config.Default) == "string" then
		local Idx = table.find(Dropdown.Values, Config.Default)
		if Idx then
			table.insert(Defaults, Idx)
		end
	elseif type(Config.Default) == "table" then
		for _, Value in next, Config.Default do
			local Idx = table.find(Dropdown.Values, Value)
			if Idx then
				table.insert(Defaults, Idx)
			end
		end
	elseif type(Config.Default) == "number" and Dropdown.Values[Config.Default] ~= nil then
		table.insert(Defaults, Config.Default)
	end

	if next(Defaults) then
		for i = 1, #Defaults do
			local Index = Defaults[i]
			if Config.Multi then
				Dropdown.Value[Dropdown.Values[Index]] = true
			else
				Dropdown.Value = Dropdown.Values[Index]
			end

			if not Config.Multi then
				break
			end
		end

		Dropdown:BuildDropdownList()
		Dropdown:Display()
	end

	Library.Options[Idx] = Dropdown
	return Dropdown
end

return Element
end

__DimensiModules['Elements/Input'] = function(script, require)
local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New
local AddSignal = Creator.AddSignal
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Input"

function Element:New(Idx, Config)
	assert(type(Config) == "table", "Input - Config must be a table")
	local Library = self.Library
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Input - Missing Title")
	assert(Config.Default == nil or type(Config.Default) == "string", "Input - Default must be a string")
	assert(Config.Numeric == nil or type(Config.Numeric) == "boolean", "Input - Numeric must be boolean")
	assert(Config.Finished == nil or type(Config.Finished) == "boolean", "Input - Finished must be boolean")
	assert(Config.MaxLength == nil or (type(Config.MaxLength) == "number" and Config.MaxLength >= 0 and Config.MaxLength % 1 == 0 and Config.MaxLength <= 4096), "Input - MaxLength must be an integer from 0 to 4096")
	assert(Config.Callback == nil or type(Config.Callback) == "function", "Input - Callback must be a function")
	assert(Config.Placeholder == nil or type(Config.Placeholder) == "string", "Input - Placeholder must be a string")
	assert(Config.MaxLength == nil or #((Config.Default) or "") <= Config.MaxLength, "Input - Default exceeds MaxLength")
	assert(not Config.Numeric or Config.Default == nil or Config.Default == "" or tonumber(Config.Default) ~= nil, "Input - Numeric Default must be numeric")
	Config.Callback = Config.Callback or function() end

	local Input = {
		Value = Config.Default or "",
		Numeric = Config.Numeric or false,
		Finished = Config.Finished or false,
		Callback = Config.Callback or function(Value) end,
		Type = "Input",
	}

	local InputFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, false)

	Input.SetTitle = InputFrame.SetTitle
	Input.SetDesc = InputFrame.SetDesc

	local Textbox = require(Components.Textbox)(InputFrame.Frame, true)
	Textbox.Frame.Position = UDim2.new(1, -10, 0.5, 0)
	Textbox.Frame.AnchorPoint = Vector2.new(1, 0.5)
	Textbox.Frame.Size = UDim2.new(0.42, 0, 0, 32)
	InputFrame.LabelHolder.Size = UDim2.new(0.56, -24, 0, 0)
	Creator.New("UISizeConstraint", { MinSize = Vector2.new(88, 32), MaxSize = Vector2.new(160, 32), Parent = Textbox.Frame })
	Textbox.Input.Text = Config.Default or ""
	Textbox.Input.PlaceholderText = Config.Placeholder or ""

	local Box = Textbox.Input

	function Input:SetValue(Text)
		assert(type(Text) == "string", "Input:SetValue expects a string")
		if Config.MaxLength and #Text > Config.MaxLength then
			Text = Text:sub(1, Config.MaxLength)
		end

		if Input.Numeric then
			if (not tonumber(Text)) and Text:len() > 0 then
				Text = Input.Value
			end
		end

		Input.Value = Text
		Box.Text = Text

		Library:SafeCallback(Input.Callback, Input.Value)
		Library:SafeCallback(Input.Changed, Input.Value)
	end

	if Input.Finished then
		AddSignal(Box.FocusLost, function(enter)
			if not enter then
				return
			end
			Input:SetValue(Box.Text)
		end)
	else
		AddSignal(Box:GetPropertyChangedSignal("Text"), function()
			Input:SetValue(Box.Text)
		end)
	end

	function Input:OnChanged(Func)
		Input.Changed = Func
		Library:SafeCallback(Func, Input.Value)
	end

	function Input:Destroy()
		InputFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Library.Options[Idx] = Input
	return Input
end

return Element
end

__DimensiModules['Elements/Keybind'] = function(script, require)
local UserInputService = game:GetService("UserInputService")

local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Keybind"

function Element:New(Idx, Config)
	assert(type(Config) == "table", "Keybind - Config must be a table")
	local Library = self.Library
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Keybind - Missing Title")
	assert(type(Config.Default) == "string" and Config.Default ~= "", "Keybind - Missing default value.")
	assert(Config.Default == "MouseLeft" or Config.Default == "MouseRight" or Enum.KeyCode[Config.Default] ~= nil, "Keybind - Default must be a valid KeyCode name or MouseLeft/MouseRight")
	assert(Config.Mode == nil or Config.Mode == "Toggle" or Config.Mode == "Hold" or Config.Mode == "Always", "Keybind - Invalid mode")
	assert(Config.Callback == nil or type(Config.Callback) == "function", "Keybind - Callback must be a function")
	assert(Config.ChangedCallback == nil or type(Config.ChangedCallback) == "function", "Keybind - ChangedCallback must be a function")

	local Keybind = {
		Value = Config.Default,
		Toggled = false,
		Mode = Config.Mode or "Toggle",
		Type = "Keybind",
		Callback = Config.Callback or function(Value) end,
		ChangedCallback = Config.ChangedCallback or function(New) end,
	}

	local Picking = false
	local CaptureConnection, CaptureEndConnection
	local CaptureToken = 0

	local KeybindFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)

	KeybindFrame.LabelHolder.Size = UDim2.new(1, -112, 0, 0)
	Keybind.SetTitle = KeybindFrame.SetTitle
	Keybind.SetDesc = KeybindFrame.SetDesc

	local KeybindDisplayLabel = New("TextLabel", {
		FontFace = Typography.Regular,
		Text = Config.Default,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(0, 0, 0, 14),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local KeybindDisplayFrame = New("TextButton", {
		Size = UDim2.fromOffset(0, 30),
		Position = UDim2.new(1, -10, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 0.9,
		Parent = KeybindFrame.Frame,
		AutomaticSize = Enum.AutomaticSize.X,
		ThemeTag = {
			BackgroundColor3 = "Keybind",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 5),
		}),
		New("UISizeConstraint", {
			MaxSize = Vector2.new(104, 32),
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
		}),
		New("UIStroke", {
			Transparency = 0.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "InElementBorder",
			},
		}),
		KeybindDisplayLabel,
	})

	function Keybind:GetState()
		if UserInputService:GetFocusedTextBox() and Keybind.Mode ~= "Always" then
			return false
		end

		if Keybind.Mode == "Always" then
			return true
		elseif Keybind.Mode == "Hold" then
			if Keybind.Value == "None" then
				return false
			end

			local Key = Keybind.Value

			if Key == "MouseLeft" or Key == "MouseRight" then
				return Key == "MouseLeft" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
					or Key == "MouseRight"
						and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
			else
				return UserInputService:IsKeyDown(Enum.KeyCode[Keybind.Value])
			end
		else
			return Keybind.Toggled
		end
	end

	function Keybind:SetValue(Key, Mode)
		Key = Key or Keybind.Value
		Mode = Mode or Keybind.Mode
		assert(type(Key) == "string" and Key ~= "", "Keybind:SetValue expects a key name")
		assert(Key == "MouseLeft" or Key == "MouseRight" or Enum.KeyCode[Key] ~= nil, "Keybind:SetValue received an invalid key name")
		assert(Mode == "Toggle" or Mode == "Hold" or Mode == "Always", "Keybind:SetValue expects Toggle, Hold, or Always mode")

		KeybindDisplayLabel.Text = Key
		Keybind.Value = Key
		Keybind.Mode = Mode
	end

	function Keybind:OnClick(Callback)
		Keybind.Clicked = Callback
	end

	function Keybind:OnChanged(Callback)
		Keybind.Changed = Callback
		Library:SafeCallback(Callback, Keybind.Value)
	end

	function Keybind:DoClick()
		Library:SafeCallback(Keybind.Callback, Keybind.Toggled)
		Library:SafeCallback(Keybind.Clicked, Keybind.Toggled)
	end

	function Keybind:Destroy()
		CaptureToken += 1
		if CaptureConnection then Creator.DisconnectSignal(CaptureConnection); CaptureConnection = nil end
		if CaptureEndConnection then CaptureEndConnection:Disconnect(); CaptureEndConnection = nil end
		Picking = false
		KeybindFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Creator.AddSignal(KeybindDisplayFrame.InputBegan, function(Input)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1
			and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if Picking then return end
		Picking = true
		KeybindDisplayLabel.Text = "..."
		CaptureToken += 1
		local Token = CaptureToken
		task.delay(0.2, function()
			if not Picking or Token ~= CaptureToken then return end
			CaptureConnection = Creator.TrackConnection(UserInputService.InputBegan:Connect(function(CapturedInput)
				if not Picking or Token ~= CaptureToken then return end
				local CapturedKey
				local CallbackValue
				if CapturedInput.UserInputType == Enum.UserInputType.Keyboard then
					if CapturedInput.KeyCode == Enum.KeyCode.Unknown then return end
					CapturedKey = CapturedInput.KeyCode.Name
					CallbackValue = CapturedInput.KeyCode
				elseif CapturedInput.UserInputType == Enum.UserInputType.MouseButton1 then
					CapturedKey = "MouseLeft"
					CallbackValue = CapturedInput.UserInputType
				elseif CapturedInput.UserInputType == Enum.UserInputType.MouseButton2 then
					CapturedKey = "MouseRight"
					CallbackValue = CapturedInput.UserInputType
				else
					return
				end
				Picking = false
				Keybind.Value = CapturedKey
				KeybindDisplayLabel.Text = CapturedKey
				Library:SafeCallback(Keybind.ChangedCallback, CallbackValue)
				Library:SafeCallback(Keybind.Changed, CallbackValue)
				if CaptureConnection then Creator.DisconnectSignal(CaptureConnection); CaptureConnection = nil end
			end))
		end)
	end)

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if not Picking and not UserInputService:GetFocusedTextBox() then
			if Keybind.Mode == "Toggle" then
				local Key = Keybind.Value

				if Key == "MouseLeft" or Key == "MouseRight" then
					if
						Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1
						or Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2
					then
						Keybind.Toggled = not Keybind.Toggled
						Keybind:DoClick()
					end
				elseif Input.UserInputType == Enum.UserInputType.Keyboard then
					if Input.KeyCode.Name == Key then
						Keybind.Toggled = not Keybind.Toggled
						Keybind:DoClick()
					end
				end
			end
		end
	end)

	Library.Options[Idx] = Keybind
	return Keybind
end

return Element
end

__DimensiModules['Elements/Paragraph'] = function(script, require)
local Root = script.Parent.Parent
local Components = Root.Components
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)

local Paragraph = {}
Paragraph.__index = Paragraph
Paragraph.__type = "Paragraph"

function Paragraph:New(Idx, Config)
	-- The public element dispatcher always calls New(Idx, Config).
	-- Also accept the one-argument config form for backwards compatibility.
	if Config == nil and type(Idx) == "table" then
		Config = Idx
	end
	assert(type(Config) == "table", "Paragraph - Config must be a table")
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Paragraph - Missing Title")
	assert(Config.Content == nil or type(Config.Content) == "string", "Paragraph - Content must be a string")
	Config.Content = Config.Content or ""

	local Paragraph = require(Components.Element)(Config.Title, Config.Content, Paragraph.Container, false)
	Paragraph.Frame.BackgroundTransparency = 0.82
	Paragraph.Border.Transparency = 0.6

	return Paragraph
end

return Paragraph
end

__DimensiModules['Elements/Slider'] = function(script, require)
local UserInputService = game:GetService("UserInputService")
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Slider"

function Element:New(Idx, Config)
	assert(type(Config) == "table", "Slider - Config must be a table")
	local Library = self.Library
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Slider - Missing Title.")
	assert(type(Config.Default) == "number" and Config.Default == Config.Default and math.abs(Config.Default) < math.huge, "Slider - Default must be a finite number.")
	assert(type(Config.Min) == "number" and Config.Min == Config.Min and math.abs(Config.Min) < math.huge, "Slider - Min must be a finite number.")
	assert(type(Config.Max) == "number" and Config.Max == Config.Max and math.abs(Config.Max) < math.huge, "Slider - Max must be a finite number.")
	assert(Config.Max > Config.Min, "Slider - Max must be greater than Min.")
	assert(Config.Default >= Config.Min and Config.Default <= Config.Max, "Slider - Default must be within Min and Max")
	assert(Config.Callback == nil or type(Config.Callback) == "function", "Slider - Callback must be a function")
	assert(Config.Rounding == nil or (type(Config.Rounding) == "number" and Config.Rounding >= 0 and Config.Rounding <= 8 and Config.Rounding % 1 == 0), "Slider - Rounding must be an integer between 0 and 8.")

	local Slider = {
		Value = nil,
		Min = Config.Min,
		Max = Config.Max,
		Rounding = Config.Rounding or 0,
		Callback = Config.Callback or function(Value) end,
		Type = "Slider",
	}

	local Dragging = false

	local SliderFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, false)
	SliderFrame.LabelHolder.Size = UDim2.new(0.56, -24, 0, 0)
	SliderFrame.DescLabel.Size = UDim2.new(1, 0, 0, 0)

	Slider.SetTitle = SliderFrame.SetTitle
	Slider.SetDesc = SliderFrame.SetDesc

	local SliderDot = New("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, -7, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		Image = "https://www.roblox.com/asset/?id=12266946128",
		ThemeTag = {
			ImageColor3 = "Accent",
		},
	})

	local SliderRail = New("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(7, 0),
		Size = UDim2.new(1, -14, 1, 0),
	}, {
		SliderDot,
	})

	local SliderFill = New("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		ThemeTag = {
			BackgroundColor3 = "Accent",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
	})

	local SliderDisplay = New("TextLabel", {
		FontFace = Typography.Regular,
		Text = "Value",
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 14),
		Position = UDim2.new(0, -4, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		ThemeTag = {
			TextColor3 = "SubText",
		},
	})

	local SliderInner = New("Frame", {
		Size = UDim2.new(0.42, 0, 0, 4),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		BackgroundTransparency = 0.4,
		Parent = SliderFrame.Frame,
		ThemeTag = {
			BackgroundColor3 = "SliderRail",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
		New("UISizeConstraint", {
			MinSize = Vector2.new(84, 4),
			MaxSize = Vector2.new(150, math.huge),
		}),
		SliderDisplay,
		SliderFill,
		SliderRail,
	})

	Creator.AddSignal(SliderDot.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = true
		end
	end)

	Creator.AddSignal(SliderDot.InputEnded, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = false
		end
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if
			Dragging
			and (
				Input.UserInputType == Enum.UserInputType.MouseMovement
				or Input.UserInputType == Enum.UserInputType.Touch
			)
		then
			if SliderRail.AbsoluteSize.X <= 0 then return end
			local SizeScale =
				math.clamp((Input.Position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
			Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
		end
	end)

	function Slider:OnChanged(Func)
		Slider.Changed = Func
		Library:SafeCallback(Func, Slider.Value)
	end

	function Slider:SetValue(Value)
		assert(type(Value) == "number" and Value == Value and math.abs(Value) < math.huge, "Slider:SetValue expects a finite number")
		local Clamped = math.clamp(Value, Slider.Min, Slider.Max)
		local Rounded = Library:Round(Clamped, Slider.Rounding)
		self.Value = math.clamp(Rounded, Slider.Min, Slider.Max)
		local Ratio = math.clamp((self.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1)
		SliderDot.Position = UDim2.new(Ratio, -7, 0.5, 0)
		SliderFill.Size = UDim2.fromScale(Ratio, 1)
		SliderDisplay.Text = tostring(self.Value)

		Library:SafeCallback(Slider.Callback, self.Value)
		Library:SafeCallback(Slider.Changed, self.Value)
	end

	function Slider:Destroy()
		SliderFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Slider:SetValue(Config.Default)

	Library.Options[Idx] = Slider
	return Slider
end

return Element
end

__DimensiModules['Elements/Toggle'] = function(script, require)
local TweenService = game:GetService("TweenService")
local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Toggle"

function Element:New(Idx, Config)
	assert(type(Config) == "table", "Toggle - Config must be a table")
	local Library = self.Library
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Toggle - Missing Title")
	assert(Config.Default == nil or type(Config.Default) == "boolean", "Toggle - Default must be boolean")
	assert(Config.Callback == nil or type(Config.Callback) == "function", "Toggle - Callback must be a function")

	local Toggle = {
		Value = Config.Default or false,
		Callback = Config.Callback or function(Value) end,
		Type = "Toggle",
	}

	local ToggleFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)
	ToggleFrame.LabelHolder.Size = UDim2.new(1, -58, 0, 0)
	ToggleFrame.DescLabel.Size = UDim2.new(1, 0, 0, 0)

	Toggle.SetTitle = ToggleFrame.SetTitle
	Toggle.SetDesc = ToggleFrame.SetDesc

	local ToggleCircle = New("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(0, 2, 0.5, 0),
		Image = "https://www.roblox.com/asset/?id=12266946128",
		ImageTransparency = 0.5,
		ThemeTag = {
			ImageColor3 = "ToggleSlider",
		},
	})

	local ToggleBorder = New("UIStroke", {
		Transparency = 0.5,
		ThemeTag = {
			Color = "ToggleSlider",
		},
	})

	local ToggleSlider = New("Frame", {
		Size = UDim2.fromOffset(40, 22),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Parent = ToggleFrame.Frame,
		BackgroundTransparency = 1,
		ThemeTag = {
			BackgroundColor3 = "Accent",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 9),
		}),
		ToggleBorder,
		ToggleCircle,
	})

	function Toggle:OnChanged(Func)
		Toggle.Changed = Func
		Library:SafeCallback(Func, Toggle.Value)
	end

	function Toggle:SetValue(Value)
		Value = not not Value
		Toggle.Value = Value

		Creator.OverrideTag(ToggleBorder, { Color = Toggle.Value and "Accent" or "ToggleSlider" })
		Creator.OverrideTag(ToggleCircle, { ImageColor3 = Toggle.Value and "ToggleToggled" or "ToggleSlider" })
		TweenService:Create(
			ToggleCircle,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Position = UDim2.new(0, Toggle.Value and 23 or 2, 0.5, 0) }
		):Play()
		TweenService:Create(
			ToggleSlider,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ BackgroundTransparency = Toggle.Value and 0 or 1 }
		):Play()
		ToggleCircle.ImageTransparency = Toggle.Value and 0 or 0.5

		Library:SafeCallback(Toggle.Callback, Toggle.Value)
		Library:SafeCallback(Toggle.Changed, Toggle.Value)
	end

	function Toggle:Destroy()
		ToggleFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Creator.AddSignal(ToggleFrame.Frame.MouseButton1Click, function()
		Toggle:SetValue(not Toggle.Value)
	end)

	Toggle:SetValue(Toggle.Value)

	Library.Options[Idx] = Toggle
	return Toggle
end

return Element
end

__DimensiModules['Packages/DimensiMotion'] = function(script, require)
-- DimensiUI's native animation primitives.
return {
	SingleMotor = require(script.SingleMotor),
	GroupMotor = require(script.GroupMotor),
	Instant = require(script.Instant),
	Spring = require(script.Spring),
}
end

__DimensiModules['Themes/Dimensi'] = function(script, require)
return {
    Name = "Dimensi",

    Accent = Color3.fromRGB(168, 85, 247),

    AcrylicMain = Color3.fromRGB(17, 19, 24),
    AcrylicBorder = Color3.fromRGB(52, 60, 73),
    AcrylicGradient = ColorSequence.new(
        Color3.fromRGB(34, 40, 51),
        Color3.fromRGB(17, 19, 24)
    ),
    AcrylicNoise = 0.97,

    TitleBarLine = Color3.fromRGB(52, 60, 73),
    Tab = Color3.fromRGB(161, 168, 181),

    Element = Color3.fromRGB(25, 29, 36),
    ElementBorder = Color3.fromRGB(52, 60, 73),
    InElementBorder = Color3.fromRGB(64, 73, 88),
    ElementTransparency = 0,

    ToggleSlider = Color3.fromRGB(192, 132, 252),
    ToggleToggled = Color3.fromRGB(34, 40, 51),
    SliderRail = Color3.fromRGB(168, 85, 247),

    DropdownFrame = Color3.fromRGB(34, 40, 51),
    DropdownHolder = Color3.fromRGB(25, 29, 36),
    DropdownBorder = Color3.fromRGB(52, 60, 73),
    DropdownOption = Color3.fromRGB(74, 48, 99),
    Keybind = Color3.fromRGB(34, 40, 51),

    Input = Color3.fromRGB(34, 40, 51),
    InputFocused = Color3.fromRGB(25, 29, 36),
    InputIndicator = Color3.fromRGB(168, 85, 247),

    Dialog = Color3.fromRGB(34, 40, 51),
    DialogHolder = Color3.fromRGB(25, 29, 36),
    DialogHolderLine = Color3.fromRGB(52, 60, 73),
    DialogButton = Color3.fromRGB(34, 40, 51),
    DialogButtonBorder = Color3.fromRGB(64, 73, 88),
    DialogBorder = Color3.fromRGB(52, 60, 73),
    DialogInput = Color3.fromRGB(25, 29, 36),
    DialogInputLine = Color3.fromRGB(168, 85, 247),

    Text = Color3.fromRGB(241, 243, 247),
    SubText = Color3.fromRGB(161, 168, 181),

    Hover = Color3.fromRGB(192, 132, 252),
    HoverChange = 0,
}
end

__DimensiModules['Packages/DimensiMotion/BaseMotor'] = function(script, require)
local RunService = game:GetService("RunService")
local Signal = require(script.Parent.Signal)

local BaseMotor = {}
BaseMotor.__index = BaseMotor
function BaseMotor.new()
	return setmetatable({
		_onStep = Signal.new(), _onStart = Signal.new(), _onComplete = Signal.new(),
			_connection = nil, _destroyed = false,
		}, BaseMotor)
end
function BaseMotor:onStep(callback) return self._onStep:Connect(callback) end
function BaseMotor:onStart(callback) return self._onStart:Connect(callback) end
function BaseMotor:onComplete(callback) return self._onComplete:Connect(callback) end
function BaseMotor:start()
	if self._destroyed or self._connection then return end
	self._connection = RunService.RenderStepped:Connect(function(dt)
		if self._destroyed then return end
		local ok, done = pcall(self.step, self, dt)
		if not ok then
			warn("DimensiMotion motor step failed:", done)
			self:stop()
			return
		end
		if done and self._connection then
			self._connection:Disconnect()
			self._connection = nil
		end
	end)
end
function BaseMotor:stop()
	if self._connection then self._connection:Disconnect(); self._connection = nil end
end
function BaseMotor:destroy()
	if self._destroyed then return end
	self._destroyed = true
	self:stop()
	self._onStep:Destroy(); self._onStart:Destroy(); self._onComplete:Destroy()
end
BaseMotor.Destroy = BaseMotor.destroy
BaseMotor.step = function() return true end
BaseMotor.getValue = function() return nil end
BaseMotor.setGoal = function() end
function BaseMotor:__tostring() return "DimensiMotionMotor" end
return BaseMotor
end

__DimensiModules['Packages/DimensiMotion/GroupMotor'] = function(script, require)
local BaseMotor = require(script.Parent.BaseMotor)
local SingleMotor = require(script.Parent.SingleMotor)
local GroupMotor = setmetatable({}, BaseMotor)
GroupMotor.__index = GroupMotor
local function createMotor(value)
	if type(value) == "number" then return SingleMotor.new(value, false) end
	if type(value) == "table" then return GroupMotor.new(value, false) end
	error("DimensiMotion group values must be numbers or nested tables", 3)
end
function GroupMotor.new(initialValues, useImplicitConnections)
	assert(type(initialValues) == "table", "GroupMotor expects an initial values table")
	local self = setmetatable(BaseMotor.new(), GroupMotor)
	self._useImplicitConnections = useImplicitConnections ~= false
	self._complete = true
	self._motors = {}
	for key, value in pairs(initialValues) do self._motors[key] = createMotor(value) end
	return self
end
function GroupMotor:step(dt)
	if self._destroyed or self._complete then return true end
	local done = true
	for _, motor in pairs(self._motors) do if not motor:step(dt) then done = false end end
	self._onStep:Fire(self:getValue())
	if done then
		self._complete = true
		if self._useImplicitConnections then self:stop() end
		self._onComplete:Fire()
	end
	return done
end
function GroupMotor:setGoal(goals)
	if self._destroyed then return false end
	assert(type(goals) == "table", "GroupMotor goal must be a table")
	for key, goal in pairs(goals) do
		local motor = assert(self._motors[key], "Unknown GroupMotor key: " .. tostring(key))
		assert(type(goal) == "table" and type(goal.step) == "function", "GroupMotor child goal must implement step")
	end
	self._complete = false
	self._onStart:Fire()
	for key, goal in pairs(goals) do self._motors[key]:setGoal(goal) end
	if self._useImplicitConnections then self:start() end
	return true
end
function GroupMotor:getValue()
	local values = {}
	for key, motor in pairs(self._motors) do values[key] = motor:getValue() end
	return values
end
function GroupMotor:destroy()
	if self._destroyed then return end
	for _, motor in pairs(self._motors) do motor:destroy() end
	self._motors = {}
	BaseMotor.destroy(self)
end
function GroupMotor:__tostring() return "DimensiMotionMotor(Group)" end
return GroupMotor
end

__DimensiModules['Packages/DimensiMotion/Instant'] = function(script, require)
local Instant = {}
Instant.__index = Instant

function Instant.new(targetValue)
	assert(type(targetValue) == "number" and targetValue == targetValue and math.abs(targetValue) < math.huge,
		"DimensiMotion.Instant target must be a finite number")
	return setmetatable({ Target = targetValue }, Instant)
end

function Instant:step()
	return { complete = true, value = self.Target, velocity = 0 }
end
return Instant
end

__DimensiModules['Packages/DimensiMotion/Signal'] = function(script, require)
local Signal = {}
Signal.__index = Signal

local Connection = {}
Connection.__index = Connection

function Connection:Disconnect()
	if not self.Connected then return end
	self.Connected = false
	local signal = self.Signal
	if signal then
		for i = #signal._connections, 1, -1 do
			if signal._connections[i] == self then
				table.remove(signal._connections, i)
				break
			end
		end
	end
	self.Signal = nil
end
Connection.disconnect = Connection.Disconnect


function Signal.new()
	return setmetatable({ _connections = {}, _destroyed = false }, Signal)
end


function Signal:Connect(callback)
	assert(type(callback) == "function", "Signal:Connect expects a callback")
	assert(not self._destroyed, "Cannot connect to a destroyed signal")
	local connection = setmetatable({ Signal = self, Connected = true, Callback = callback }, Connection)
	table.insert(self._connections, connection)
	return connection
end
Signal.connect = Signal.Connect


function Signal:Fire(...)
	if self._destroyed then return end
	local args = table.pack(...)
	local snapshot = table.clone(self._connections)
	for _, connection in ipairs(snapshot) do
		if connection.Connected then
			local ok, err = pcall(connection.Callback, table.unpack(args, 1, args.n))
			if not ok then warn("DimensiMotion signal callback failed:", err) end
		end
	end
end
Signal.fire = Signal.Fire

function Signal:Wait()
	assert(not self._destroyed, "Cannot wait on a destroyed signal")
	local thread = coroutine.running()
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		if coroutine.status(thread) == "suspended" then
			local ok, err = coroutine.resume(thread, ...)
			if not ok then warn("DimensiMotion signal waiter failed:", err) end
		end
	end)
	return coroutine.yield()
end
Signal.wait = Signal.Wait


function Signal:Destroy()
	if self._destroyed then return end
	self._destroyed = true
	for i = #self._connections, 1, -1 do
		self._connections[i]:Disconnect()
	end
	table.clear(self._connections)
end


return Signal
end

__DimensiModules['Packages/DimensiMotion/SingleMotor'] = function(script, require)
local BaseMotor = require(script.Parent.BaseMotor)
local SingleMotor = setmetatable({}, BaseMotor)
SingleMotor.__index = SingleMotor
function SingleMotor.new(initialValue, useImplicitConnections)
	assert(type(initialValue) == "number" and initialValue == initialValue and math.abs(initialValue) < math.huge,
		"SingleMotor initial value must be finite")
	local self = setmetatable(BaseMotor.new(), SingleMotor)
	self._useImplicitConnections = useImplicitConnections ~= false
	self._goal = nil
	self._state = { complete = true, value = initialValue, velocity = 0 }
	return self
end
function SingleMotor:step(dt)
	if self._destroyed or self._state.complete or not self._goal then return true end
	local result = self._goal:step(self._state, dt)
	if type(result) ~= "table" or type(result.value) ~= "number" then
		self._state.complete = true
		self:stop()
		warn("DimensiMotion motor received invalid goal output")
		return true
	end
	self._state = result
	self._onStep:Fire(result.value)
	if result.complete then
		if self._useImplicitConnections then self:stop() end
		self._onComplete:Fire()
	end
	return result.complete
end
function SingleMotor:getValue() return self._state.value end
function SingleMotor:setGoal(goal)
	if self._destroyed then return false end
	assert(type(goal) == "table" and type(goal.step) == "function", "Motor goal must implement step")
	self._state.complete = false
	self._goal = goal
	self._onStart:Fire()
	if self._useImplicitConnections then self:start() end
	return true
end
function SingleMotor:__tostring() return "DimensiMotionMotor(Single)" end
return SingleMotor
end

__DimensiModules['Packages/DimensiMotion/Spring'] = function(script, require)
local Spring = {}
Spring.__index = Spring


function Spring.new(targetValue, options)
	assert(type(targetValue) == "number" and targetValue == targetValue and math.abs(targetValue) < math.huge,
		"DimensiMotion.Spring target must be a finite number")
	options = options or {}
	local frequency = tonumber(options.frequency) or 8
	local damping = tonumber(options.dampingRatio) or 1
	assert(frequency > 0 and frequency <= 100, "Spring frequency must be between 0 and 100")
	assert(damping >= 0 and damping <= 10, "Spring dampingRatio must be between 0 and 10")
	return setmetatable({ Target = targetValue, Frequency = frequency, Damping = damping }, Spring)
end


function Spring:step(state, dt)
	local target = self.Target
	local position = state.value
	local velocity = state.velocity or 0
	dt = math.clamp(tonumber(dt) or 0, 0, 0.05)
	-- Semi-implicit integration in short steps to remain stable across frame drops.
	local omega = 2 * math.pi * self.Frequency
	local damping = self.Damping
	local remaining = dt
	while remaining > 0 do
		local h = math.min(remaining, 1 / 120)
		local acceleration = (target - position) * omega * omega - 2 * damping * omega * velocity
		velocity += acceleration * h
		position += velocity * h
		remaining -= h
	end
	local complete = math.abs(velocity) < 0.001 and math.abs(position - target) < 0.001
	return { complete = complete, value = complete and target or position, velocity = complete and 0 or velocity }
end
return Spring
end

return __DimensiRequire(__RootNode)
