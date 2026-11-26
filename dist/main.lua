--[[
    DimensiUI v1.0.1 (Bundled Single-File Build)
    Standalone DimensiUI | Theme: Dimensi | Author: telatnakal
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
	function node:Destroy()
		for index = #self._children, 1, -1 do
			self._children[index]:Destroy()
		end
		table.clear(self._children)
		table.clear(self._childMap)
		if self.Parent and self.Parent._childMap then
			if self.Parent._childMap[self.Name] == self then
				self.Parent._childMap[self.Name] = nil
			end
			for index = #self.Parent._children, 1, -1 do
				if self.Parent._children[index] == self then
					table.remove(self.Parent._children, index)
					break
				end
			end
		end
		self.Parent = nil
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
local __Node_BubbleIcon = __MakeNode('BubbleIcon', 'BubbleIcon', __RootNode, true)
local __Node_Components = __MakeNode('Components', 'Components', __RootNode, false)
local __Node_Creator = __MakeNode('Creator', 'Creator', __RootNode, true)
local __Node_Elements = __MakeNode('Elements', 'Elements', __RootNode, true)
local __Node_Icons = __MakeNode('Icons', 'Icons', __RootNode, true)
local __Node_Packages = __MakeNode('Packages', 'Packages', __RootNode, false)
local __Node_Surface = __MakeNode('Surface', 'Surface', __RootNode, true)
local __Node_Themes = __MakeNode('Themes', 'Themes', __RootNode, true)
local __Node_Typography = __MakeNode('Typography', 'Typography', __RootNode, true)
local __Node_Components_Assets = __MakeNode('Components/Assets', 'Assets', __Node_Components, true)
local __Node_Components_Button = __MakeNode('Components/Button', 'Button', __Node_Components, true)
local __Node_Components_Card = __MakeNode('Components/Card', 'Card', __Node_Components, true)
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
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local Root = script
local Creator = require(Root.Creator)
local ElementsTable = require(Root.Elements)
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
	Version = "1.0.1",

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
	Transparency = true,
	MinimizeKeybind = nil,
	MinimizeKey = Enum.KeyCode.RightControl,

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

local function ValidateCloneTree(InstanceRoot)
	assert(InstanceRoot.Archivable, "DimensiUI:NewInstance cannot clone a non-Archivable instance: " .. InstanceRoot:GetFullName())
	for _, Descendant in ipairs(InstanceRoot:GetDescendants()) do
		assert(Descendant.Archivable, "DimensiUI:NewInstance cannot clone a non-Archivable descendant: " .. Descendant:GetFullName())
	end
end

function Library:NewInstance()
	assert(not Library.Unloaded, "DimensiUI has been destroyed")

	local IsModuleRoot = typeof(Root) == "Instance" and Root:IsA("ModuleScript")
	local IsBundleRoot = type(Root) == "table" and Root._path == "" and type(Root.Clone) == "function"
	assert(IsModuleRoot or IsBundleRoot, "DimensiUI:NewInstance requires a modular or bundled library root")	
	if IsModuleRoot then
		ValidateCloneTree(Root)
	end

	local Clone
	local Success, Result = pcall(function()
		Clone = Root:Clone()
		assert(Clone, "Library root could not be cloned")
		Clone.Name = Root.Name .. "_Instance"
		if IsModuleRoot then
			Clone.Parent = Root.Parent
		end
		local NewLibrary = require(Clone)
		assert(type(NewLibrary) == "table" and NewLibrary ~= Library, "Cloned root did not create an isolated library")
		NewLibrary._RootClone = Clone
		NewLibrary._InstanceParent = IsModuleRoot and Root.Parent or nil
		return NewLibrary
	end)

	if not Success then
		if Clone then
			pcall(function()
				if typeof(Clone) == "Instance" then
					Clone:Destroy()
				elseif type(Clone) == "table" and type(Clone.Destroy) == "function" then
					Clone:Destroy()
				end
			end)
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
	assert(Config.Theme == nil or type(Config.Theme) == "string", "Window - Theme must be a string")
	assert(Config.MinimizeKey == nil or (typeof(Config.MinimizeKey) == "EnumItem" and Config.MinimizeKey.EnumType == Enum.KeyCode), "Window - MinimizeKey must be a KeyCode")
	assert(Config.SubTitle == nil or type(Config.SubTitle) == "string", "Window - SubTitle must be a string")
	assert(Config.Icon == nil or Config.Icon == false or type(Config.Icon) == "string" or type(Config.Icon) == "number", "Window - Icon must be false, an asset id, an image URL, or a custom asset path")

	Config.SubTitle = Config.SubTitle or ""
	Config.TabWidth = Config.TabWidth or 170
	Config.Size = Config.Size or UDim2.fromOffset(590, 470)
	Config.Theme = "Dimensi"
	Config.MinimizeKey = Config.MinimizeKey or Enum.KeyCode.RightControl

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
		Icon = Config.Icon,
	})

	Library.MinimizeKey = Config.MinimizeKey

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
	return true
end

function Library:Destroy()
	if Library.Unloaded then
		return
	end
	Library.Unloaded = true
	Library.DialogOpen = false
	Library._OpenDialogCount = 0
	for Index = #Library._CleanupCallbacks, 1, -1 do
		local Callback = table.remove(Library._CleanupCallbacks, Index)
		pcall(Callback)
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
	if RootClone then
		pcall(function()
			if typeof(RootClone) == "Instance" then
				RootClone:Destroy()
			elseif type(RootClone) == "table" and type(RootClone.Destroy) == "function" then
				RootClone:Destroy()
			end
		end)
	end
end

function Library:ToggleTransparency(Value)
	if type(Value) ~= "boolean" then return false end
	if Library.Window and Library.Window.Surface and Library.Window.Surface.Frame then
		local Alpha = Value and 0.15 or 0
		local Background = Library.Window.Surface.Frame:FindFirstChild("Background")
		if Background then
			Background.BackgroundTransparency = Alpha
		end
		local Sidebar = Library.Window.Sidebar
		if Sidebar then
			Sidebar.BackgroundTransparency = Alpha
			local Patch = Sidebar:FindFirstChild("Patch")
			if Patch then
				Patch.BackgroundTransparency = Alpha
			end
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

__DimensiModules['BubbleIcon'] = function(script, require)
-- Logo "D" untuk bubble minimize (PNG 112x112, 7736 bytes), tertanam supaya tidak butuh jaringan.
-- Dibuat dari Assets/d-icon-bubble.png; PNG ini ditulis ke workspace executor lalu dimuat lewat getcustomasset.
-- File ini dihasilkan oleh scripts/build_icon.py; jangan diedit manual.
return table.concat({
	"\137\080\078\071\013\010\026\010\000\000\000\013\073\072\068\082\000\000\000\112\000\000\000\112\008\003\000\000\000\241\062\004\121\000\000\001\128\080\076\084\069\253\238\254\247\219\253\241\204\253\230\196\249\228\187\251\227\176\252\214\179\242\209\169",
	"\238\215\154\251\199\148\243\199\132\249\195\112\249\167\134\207\165\113\228\165\102\246\148\100\228\170\086\249\148\088\243\137\084\249\133\081\223\159\068\248\131\069\233\150\052\252\131\049\235\107\075\168\105\060\190\106\047\220\077\048\125\100\038\222",
	"\095\036\182\075\035\161\058\035\094\089\026\189\076\024\174\065\027\170\065\019\163\071\025\143\061\023\131\063\018\145\059\018\131\052\022\149\052\020\125\054\015\132\051\015\119\049\024\096\048\016\107\047\014\111\045\014\103\040\023\092\036\023\076\039",
	"\016\113\033\016\079\041\013\104\040\013\093\037\013\085\032\013\077\031\020\060\026\016\057\025\015\059\021\014\044\025\013\055\020\013\047\017\012\042\016\012\036\044\008\115\035\009\090\032\009\084\031\010\074\028\009\072\027\006\078\026\010\062\026\008",
	"\065\023\008\062\022\008\056\021\004\067\020\006\055\020\010\044\020\007\048\019\006\050\018\004\051\016\011\039\015\011\034\015\008\038\017\005\047\015\004\045\014\004\040\014\002\046\013\002\038\014\011\032\014\009\031\013\010\030\013\009\030\012\009\028",
	"\013\008\029\013\004\030\011\008\027\010\008\023\010\007\026\009\007\022\010\006\024\008\006\021\009\005\024\007\005\020\009\001\038\009\001\034\009\001\033\008\001\029\004\000\028\007\003\023\007\000\024\002\001\022\007\006\018\007\005\018\006\005\018\005",
	"\005\017\006\005\015\006\004\017\005\004\016\005\004\014\005\003\015\004\003\011\002\003\010\003\001\014\000\000\016\000\000\012\001\001\006\000\000\006\000\000\000\014\059\250\007\000\000\028\115\073\068\065\084\120\218\125\155\139\063\098\251\247\255\119",
	"\017\221\144\041\218\149\084\067\025\010\237\033\165\171\075\019\070\168\012\035\221\108\093\092\074\234\148\092\074\253\235\191\181\222\239\093\056\223\243\249\173\099\012\198\099\063\247\107\221\222\235\189\247\251\048\157\118\187\221\193\079\213\118\245",
	"\001\237\254\254\238\246\239\223\191\103\127\254\156\158\030\031\030\028\236\239\237\133\119\119\221\027\027\046\151\107\117\117\121\121\197\190\216\055\059\216\202\242\242\234\234\170\203\181\177\225\118\239\134\247\246\246\015\014\143\143\143\079\255\156",
	"\157\193\069\110\239\238\238\239\225\154\213\106\149\096\000\196\180\251\192\118\155\226\008\079\192\029\238\239\239\133\195\187\238\029\160\017\150\125\113\193\106\181\206\015\012\190\177\002\120\025\168\200\092\067\102\004\153\167\127\000\121\246\247\246",
	"\118\064\236\016\096\103\000\164\002\239\203\119\192\059\067\030\168\035\056\183\155\208\064\216\194\002\160\102\103\103\045\022\139\145\154\197\002\223\018\238\034\072\069\166\251\003\073\085\126\016\219\004\073\128\240\037\252\000\126\092\006\030\149\071",
	"\157\217\023\007\210\008\204\098\049\163\205\012\012\191\067\042\209\106\007\231\162\107\251\072\116\236\128\248\064\136\109\065\097\159\119\047\200\059\065\121\123\123\036\114\235\128\003\026\234\050\207\232\167\038\198\100\178\209\145\033\176\225\145\081",
	"\153\124\108\114\074\143\088\132\090\023\022\081\038\069\238\237\247\137\127\063\136\096\084\033\241\103\153\242\004\111\098\236\064\221\234\178\125\017\180\205\089\204\122\245\152\108\088\196\252\095\019\143\200\198\167\102\144\009\058\033\158\125\036\013",
	"\037\186\021\082\167\220\039\010\192\135\079\060\200\021\226\205\001\110\110\206\172\031\147\013\137\192\196\032\075\009\198\162\193\223\163\163\067\098\188\009\209\144\108\082\143\206\253\064\126\038\222\010\068\001\056\008\031\242\078\079\040\014\083\101",
	"\121\005\113\022\221\132\108\072\044\150\072\101\074\214\096\242\036\202\237\078\087\176\118\057\232\049\001\121\004\169\098\153\122\198\076\144\043\203\152\062\187\123\125\036\241\042\077\029\004\082\127\130\188\155\079\060\042\207\106\155\051\171\229\146",
	"\097\137\084\062\097\224\018\157\110\231\033\182\201\113\166\190\113\158\064\017\232\021\143\129\149\073\196\034\209\240\152\030\145\011\068\228\014\113\171\016\072\090\144\144\042\012\117\040\232\235\243\246\009\015\228\065\029\216\044\106\185\084\034\085",
	"\176\166\104\183\087\241\059\076\006\180\001\207\064\205\228\169\244\186\089\019\171\004\166\088\142\072\027\032\191\184\181\159\172\008\172\010\250\254\014\244\017\121\043\004\167\144\074\021\019\134\096\175\235\195\171\155\056\206\227\015\004\054\055\055",
	"\061\196\224\111\174\127\019\190\110\015\152\082\137\024\144\196\175\040\018\220\218\039\098\011\064\167\050\213\143\110\070\244\161\188\109\215\170\125\097\097\078\167\144\203\021\044\215\237\197\076\008\011\196\098\190\128\095\096\017\227\156\014\147\195",
	"\201\113\156\147\220\078\168\215\241\176\114\137\120\104\156\250\245\063\136\247\015\204\195\064\223\249\128\183\014\149\103\051\078\042\020\010\214\211\235\122\224\090\155\023\169\144\047\000\230\247\111\110\246\021\114\014\052\167\019\145\240\029\064\061",
	"\221\158\135\085\072\196\035\083\102\018\073\012\228\167\204\193\212\097\144\119\015\241\131\242\059\161\233\226\090\095\089\092\154\211\171\084\042\029\215\123\231\224\050\041\062\030\244\017\035\076\130\220\228\040\012\105\028\033\110\122\156\006\003\135",
	"\072\185\100\104\204\108\153\199\214\243\069\035\005\098\253\221\012\244\065\248\144\103\153\082\169\212\166\110\015\112\129\082\046\020\011\133\098\065\048\074\132\040\250\009\207\241\153\007\068\095\200\099\002\149\029\211\152\116\088\010\145\180\045\174",
	"\128\091\191\018\153\050\013\160\016\063\247\054\240\150\108\070\141\070\051\155\237\249\000\247\079\058\116\017\143\199\129\024\035\068\162\211\183\233\252\138\219\012\248\124\193\088\040\120\193\111\026\076\201\094\140\085\072\135\137\091\191\018\161\030",
	"\025\224\221\013\120\059\224\079\251\146\077\175\209\104\029\189\087\184\219\127\248\120\242\242\242\226\002\152\064\140\129\078\004\006\061\212\155\020\232\065\024\049\112\068\240\226\138\051\056\223\218\038\149\124\120\092\032\210\234\056\193\158\115\123",
	"\199\220\211\245\001\234\129\198\207\014\225\155\158\214\069\123\081\131\163\080\184\184\076\093\094\166\082\148\136\006\084\112\156\128\003\158\199\007\148\016\176\098\177\144\096\124\200\100\200\244\060\106\133\068\001\129\004\175\210\056\210\046\119\203",
	"\144\004\253\200\079\224\105\167\167\103\043\061\110\126\243\037\157\206\229\210\104\169\212\037\034\005\104\159\007\052\129\017\035\031\033\252\119\248\019\047\112\006\127\055\161\083\072\228\102\139\109\017\114\149\104\164\078\101\072\003\197\229\129\230",
	"\039\225\205\119\223\077\086\254\241\050\199\231\192\210\000\189\004\191\094\082\228\197\166\128\219\012\094\092\132\062\089\156\026\220\089\168\224\131\116\173\064\032\229\230\217\001\145\134\145\017\026\054\246\151\109\129\103\239\182\172\142\151\124\154",
	"\007\035\068\180\075\116\046\092\236\210\079\113\129\248\069\252\179\245\121\000\188\076\133\046\211\038\231\091\117\086\005\196\057\043\118\000\232\171\084\034\131\014\061\038\009\179\237\130\252\004\222\114\175\100\229\094\115\087\096\125\036\161\094\162",
	"\099\047\131\020\119\153\190\128\075\127\182\143\111\067\158\203\248\197\163\195\241\220\006\162\194\060\139\061\007\195\072\036\050\040\240\248\128\020\196\202\162\013\242\197\218\037\188\235\235\107\074\164\126\021\100\166\047\056\192\249\225\043\072\094",
	"\106\023\023\073\016\133\127\225\119\201\228\069\110\211\192\095\094\198\145\088\053\106\164\227\022\072\085\218\228\014\143\001\136\003\005\113\040\038\232\012\198\175\105\221\125\205\021\174\009\241\147\079\017\151\226\061\078\167\231\130\079\247\105\131",
	"\047\208\082\152\092\151\023\060\167\228\241\014\144\088\049\170\164\106\072\213\229\129\083\153\179\063\180\002\049\065\205\211\211\198\183\023\162\175\064\120\136\162\177\131\251\135\079\233\128\147\243\229\208\185\041\066\072\193\061\008\247\034\220\019",
	"\072\187\055\140\132\146\072\044\056\184\215\132\094\037\213\147\048\066\222\096\249\051\152\049\212\161\152\048\250\108\215\225\120\207\021\010\068\094\058\117\065\234\157\180\053\172\052\159\211\147\076\198\251\233\066\125\121\153\074\127\024\248\212\119",
	"\207\050\166\108\232\146\016\061\029\175\086\033\055\019\167\238\238\069\064\034\067\050\006\028\074\002\168\141\244\184\229\215\060\225\241\233\139\080\016\151\007\047\053\191\223\031\216\088\139\069\003\209\160\192\143\133\008\053\069\136\052\208\169\184",
	"\047\177\051\202\040\203\177\208\005\202\053\197\186\014\141\002\194\072\037\238\031\030\049\184\070\128\067\087\137\067\173\189\168\021\104\005\248\195\167\067\062\088\095\057\231\192\184\053\231\134\135\182\105\088\122\001\031\192\046\023\138\039\147\041",
	"\202\131\120\231\043\183\027\074\241\144\136\061\174\086\033\115\174\162\142\098\199\040\056\021\162\008\018\025\034\112\131\058\212\216\124\094\012\060\065\252\010\215\087\233\120\224\228\247\246\214\214\214\018\053\248\106\107\125\027\108\103\231\215\175",
	"\095\191\127\255\062\060\057\063\191\185\057\075\004\145\153\073\019\032\239\049\040\037\018\201\144\152\025\098\077\024\236\002\231\124\077\104\021\010\112\234\050\233\226\135\000\132\140\113\173\046\218\032\067\195\093\231\006\056\148\164\203\069\156\083",
	"\082\147\201\100\202\255\052\152\020\097\016\056\133\237\065\040\148\204\000\144\231\067\028\018\135\197\035\172\201\019\130\144\094\092\057\252\029\199\180\066\045\228\205\254\001\067\004\174\174\044\089\160\131\118\163\246\058\045\135\092\046\021\058\026",
	"\099\254\211\068\130\009\223\141\042\089\238\111\249\062\158\004\098\190\080\170\222\176\018\201\168\169\090\173\064\068\147\151\233\152\035\219\052\170\006\018\015\152\003\020\072\051\230\232\221\225\111\209\130\135\002\076\242\219\154\033\049\140\136\104",
	"\210\079\038\163\038\135\063\035\067\020\059\202\154\238\030\146\023\124\062\159\075\198\203\074\177\161\237\195\117\006\186\064\156\231\184\238\174\032\017\125\202\128\064\044\065\011\150\188\223\209\186\034\056\176\235\066\166\096\254\006\163\038\049\201",
	"\192\190\160\229\114\217\168\192\084\026\238\170\201\012\207\231\083\109\131\212\083\076\065\230\241\201\088\048\020\202\056\018\109\163\070\097\182\129\196\157\240\030\067\034\104\135\053\087\027\125\115\196\030\175\005\096\225\177\150\127\230\180\218\033",
	"\209\048\108\091\062\019\063\051\081\168\092\038\025\034\254\029\053\149\239\147\121\062\253\228\025\131\118\224\131\092\142\221\221\069\125\025\015\247\022\153\086\081\137\238\048\067\106\112\105\110\090\003\002\157\173\171\190\190\199\090\173\150\127\051",
	"\106\103\134\068\100\167\244\069\232\087\247\202\129\009\179\062\048\149\158\106\060\199\055\125\044\196\207\199\153\216\009\165\129\059\015\068\029\193\055\034\017\026\156\123\151\009\187\093\088\131\154\233\200\171\051\250\120\213\215\247\088\171\055\075",
	"\111\017\237\204\204\008\051\244\127\145\146\127\017\229\114\041\202\020\025\170\201\092\033\100\250\007\110\185\222\044\122\088\201\040\187\239\227\060\157\141\105\133\080\139\140\080\131\026\099\039\234\236\243\030\129\215\104\054\155\133\247\089\173\217",
	"\060\202\136\197\067\031\208\127\137\020\120\114\133\066\062\012\072\182\028\207\228\147\215\121\104\084\201\120\182\204\074\196\236\185\207\153\189\135\169\019\219\205\134\027\128\068\160\198\209\117\251\009\048\135\188\070\163\209\108\052\106\111\126\237",
	"\140\121\078\198\136\135\254\039\147\042\132\153\089\049\062\014\155\044\070\121\155\204\229\243\087\164\178\098\209\061\217\240\016\151\000\137\086\141\202\072\210\134\113\099\209\067\202\252\045\174\241\200\075\095\061\054\234\245\058\016\027\173\070\009",
	"\037\090\230\148\140\072\140\214\119\236\103\141\003\030\034\097\232\102\088\136\035\018\249\092\006\154\149\082\044\050\156\123\184\230\145\086\165\005\159\186\054\024\240\232\002\241\104\128\123\196\149\015\120\205\006\001\182\090\173\230\091\020\037\046",
	"\041\007\213\142\155\082\049\149\075\208\082\185\076\062\080\008\006\161\004\034\159\191\070\096\034\240\091\009\094\062\015\122\018\079\048\234\090\108\224\083\000\066\017\130\071\059\187\129\199\052\229\053\027\013\202\107\061\215\122\243\090\243\220\143",
	"\173\047\187\180\143\221\026\171\028\029\150\126\001\142\203\196\098\211\067\018\090\000\159\075\070\143\028\144\074\166\211\184\215\223\177\078\131\079\033\079\025\008\161\109\070\051\117\084\089\187\188\034\060\193\090\004\248\244\018\215\206\088\126\064",
	"\219\254\245\031\006\045\220\201\014\073\040\112\124\188\079\084\038\146\208\087\115\233\184\255\016\004\142\238\007\226\001\238\109\111\090\165\199\032\050\174\229\069\155\086\163\107\199\060\215\192\171\099\178\180\026\245\071\248\132\064\144\104\157\134",
	"\141\244\247\239\115\063\126\204\245\013\190\155\131\143\031\075\118\184\017\135\082\162\144\127\240\198\039\101\098\003\056\021\178\212\119\098\016\139\025\195\057\076\175\028\095\212\171\166\230\096\029\102\032\132\022\045\086\253\230\117\250\010\148\061",
	"\061\181\234\047\188\239\165\065\129\205\231\140\240\008\168\111\070\139\145\124\166\246\195\190\189\163\148\142\127\240\192\036\178\040\044\030\153\216\209\218\168\072\164\252\029\136\133\046\061\177\206\044\013\034\003\091\079\044\138\206\094\240\234\138",
	"\058\243\169\213\008\108\166\005\098\179\089\123\121\121\125\125\255\176\222\192\222\159\147\017\251\156\109\123\123\084\254\161\015\108\092\002\018\051\080\019\074\145\120\200\121\020\077\196\083\126\127\199\062\173\049\083\160\013\128\007\037\119\252\138",
	"\166\102\163\145\217\244\108\122\099\181\070\235\009\112\181\103\124\188\130\079\201\132\039\023\157\103\184\129\087\225\030\122\189\172\221\182\109\144\124\194\129\073\097\196\008\158\069\128\039\006\135\038\226\241\100\192\251\230\158\214\096\037\050\088",
	"\133\042\253\093\214\115\085\175\063\061\161\170\070\033\182\233\245\231\048\156\205\218\085\213\244\175\101\215\240\222\064\028\050\095\094\094\158\223\095\055\022\118\148\242\079\056\144\040\223\140\157\113\163\162\033\017\229\197\047\098\158\210\177\086",
	"\163\135\032\050\043\011\054\173\202\216\142\122\095\176\248\032\130\173\167\214\107\194\095\127\193\102\083\043\093\086\217\047\171\174\136\049\116\031\209\201\175\047\004\248\242\246\252\190\177\197\202\038\063\120\223\038\191\041\076\101\211\136\104\072",
	"\108\184\001\030\204\121\023\062\014\186\027\000\173\008\132\178\159\237\004\162\002\016\062\158\090\165\084\171\222\108\052\235\181\235\228\173\082\068\139\124\132\216\232\136\167\211\120\233\027\041\157\231\210\250\162\108\192\251\246\237\219\164\206\125",
	"\206\098\123\016\120\201\139\216\038\151\168\026\167\177\215\048\246\005\139\070\101\237\248\227\173\058\250\148\088\011\101\146\000\230\179\222\033\209\167\022\058\050\172\172\064\112\091\148\069\112\144\200\199\235\202\113\202\066\155\050\156\115\074\102",
	"\072\060\098\186\245\197\147\184\185\140\109\110\114\193\246\044\000\109\020\168\089\110\251\115\045\129\071\174\131\158\005\129\133\204\157\073\036\238\183\049\002\100\059\215\077\210\021\158\176\003\214\097\077\105\214\242\191\038\062\128\198\189\050\011",
	"\055\041\026\229\238\098\201\076\038\117\145\012\109\122\189\092\000\122\141\214\130\064\076\210\141\055\111\190\089\111\062\125\088\227\009\244\149\138\023\119\044\051\244\105\201\031\025\050\032\016\173\014\075\244\099\009\023\234\210\245\009\059\046\200",
	"\211\109\148\077\152\157\034\229\209\093\040\133\188\020\240\060\094\014\235\098\122\000\116\087\188\005\188\215\001\015\239\188\086\042\228\067\055\024\194\079\043\239\136\231\237\177\089\003\216\227\035\142\203\056\051\195\175\221\008\064\253\114\217\163",
	"\020\065\182\012\027\110\018\113\024\086\211\169\075\072\121\175\215\195\121\097\090\036\192\069\004\238\085\252\181\250\007\017\190\168\215\074\249\102\033\153\056\025\021\247\005\142\032\080\201\023\107\077\084\069\183\087\048\052\129\229\202\236\228\020",
	"\224\172\183\231\232\205\033\145\146\043\071\147\056\137\167\083\065\224\225\067\036\111\199\053\061\013\099\006\000\103\084\154\131\138\191\004\183\221\236\091\173\084\202\023\095\163\145\068\150\131\187\253\164\079\202\182\115\068\029\208\242\116\183\010",
	"\159\051\015\044\226\110\206\013\048\029\012\137\070\012\101\019\123\151\193\127\077\249\252\004\200\001\112\141\002\023\000\056\117\080\244\195\093\215\032\009\048\050\165\082\161\152\105\230\029\027\124\186\106\016\013\018\020\254\040\020\134\054\015\192",
	"\002\193\229\114\025\216\183\101\050\153\228\189\090\189\124\014\056\017\142\006\074\079\217\160\096\203\073\248\133\056\062\042\003\224\026\231\244\118\220\159\128\135\160\176\080\035\086\130\168\020\249\100\219\051\235\172\023\210\109\086\052\016\056\044",
	"\029\031\087\112\213\043\140\029\046\232\233\076\050\158\160\230\119\160\058\012\158\072\105\042\135\117\227\114\182\154\228\211\113\124\024\008\060\055\236\131\194\031\064\088\055\192\165\005\018\126\020\007\184\196\131\065\023\121\205\023\115\109\165\120",
	"\192\147\141\079\142\143\197\138\100\111\005\203\107\038\153\072\004\163\071\071\071\129\192\217\121\132\029\033\184\081\195\077\217\000\093\071\014\227\091\042\030\011\034\208\227\094\091\091\115\186\063\128\070\149\038\082\241\227\117\240\074\069\062\155",
	"\056\059\099\213\039\165\028\240\227\163\253\146\024\150\067\143\028\103\171\057\184\173\002\228\009\240\162\071\254\072\100\119\247\247\111\019\059\130\115\150\104\132\061\168\058\116\216\086\229\038\000\094\224\227\078\116\040\152\035\012\163\226\007\048",
	"\092\241\231\073\030\228\249\012\240\252\234\169\243\076\022\212\182\057\129\055\060\060\254\013\074\027\066\152\043\033\144\207\196\019\071\254\240\134\107\117\203\206\066\033\080\220\102\219\195\146\230\061\046\243\220\167\051\241\024\241\040\017\184\028",
	"\238\103\041\001\174\033\144\036\120\054\017\061\245\142\105\126\037\147\197\082\237\170\107\016\035\013\254\035\188\073\133\169\154\007\224\117\062\147\140\250\035\027\171\075\115\198\137\017\017\081\055\202\110\118\014\102\177\147\162\071\149\183\144\081",
	"\241\032\010\012\003\206\233\252\185\215\093\165\157\006\129\042\103\213\159\187\230\137\188\232\097\068\169\090\248\019\205\022\106\205\171\046\043\030\033\233\050\073\175\052\022\045\022\001\152\207\036\162\126\183\107\201\172\146\194\180\013\052\241\040",
	"\027\104\071\013\083\223\250\064\182\154\225\083\033\004\162\067\001\184\120\208\093\068\032\214\161\089\165\090\126\243\199\175\121\028\236\162\254\223\172\066\191\119\156\224\075\144\177\111\074\201\040\166\203\055\122\165\073\221\003\095\192\154\137\249",
	"\035\191\182\140\099\067\012\014\172\162\033\165\225\188\227\167\056\248\053\028\022\077\213\028\001\010\002\151\127\174\037\186\243\180\121\047\218\044\042\149\161\029\008\094\231\008\239\132\149\107\230\247\143\178\224\209\218\179\079\006\163\174\068\078",
	"\214\128\169\041\189\118\254\141\047\020\211\241\196\249\225\042\043\003\097\195\176\135\025\081\154\110\239\119\103\167\224\055\250\002\199\101\129\251\124\238\034\134\030\117\099\000\157\185\064\162\131\171\197\002\244\082\235\220\164\098\182\029\013\228",
	"\161\128\019\071\135\014\185\106\202\181\255\039\091\044\212\010\029\019\108\001\101\019\051\122\189\158\188\218\210\058\155\153\116\177\090\142\024\148\035\048\003\075\135\197\195\074\214\117\120\230\048\034\078\224\017\143\150\211\000\068\143\162\192\229",
	"\181\226\139\063\007\235\033\089\241\001\168\086\232\030\018\126\004\130\067\039\020\170\169\157\189\083\080\216\188\238\026\096\176\086\147\119\119\102\128\106\167\162\048\222\004\077\202\081\024\184\021\114\137\084\201\090\127\157\028\085\012\072\163\060",
	"\010\028\229\202\133\235\052\201\025\055\056\212\223\170\243\222\202\095\253\244\012\206\052\043\086\219\148\066\157\224\189\185\076\038\113\180\015\002\085\147\171\225\163\004\095\044\229\187\172\084\174\067\030\208\244\230\089\215\093\213\103\000\154\028",
	"\058\128\066\062\193\154\078\206\079\163\209\182\233\019\015\061\058\041\083\150\083\245\124\042\020\008\128\064\231\070\178\085\168\039\253\157\061\045\086\197\050\179\108\181\233\020\042\119\211\027\007\143\098\004\199\085\010\195\239\072\052\201\023\043",
	"\188\082\174\051\163\190\089\235\206\121\059\205\193\100\047\145\141\127\155\254\054\201\026\060\247\213\251\004\044\176\221\127\243\198\199\071\184\219\235\071\062\133\033\116\059\221\165\167\235\194\083\048\218\093\158\214\146\049\017\006\111\163\002\103",
	"\140\104\014\067\056\001\010\085\010\235\239\147\179\068\178\228\145\235\108\214\229\095\039\213\110\154\051\040\033\129\228\227\223\180\090\221\172\035\212\233\062\231\249\098\049\223\233\025\038\063\241\072\138\074\216\155\068\163\128\057\227\245\174\069",
	"\158\234\144\215\079\126\146\051\150\005\251\058\204\165\086\203\184\130\109\071\253\208\066\143\126\035\080\163\146\179\166\200\223\106\245\237\185\253\210\008\121\096\239\060\134\059\022\160\233\103\029\190\230\251\235\115\013\218\096\237\025\223\081\080",
	"\125\159\028\042\085\158\159\150\026\133\052\022\197\154\247\169\094\002\043\120\043\021\061\201\025\023\179\186\130\089\163\062\203\122\179\000\060\103\165\010\008\162\070\053\062\070\094\017\178\234\137\177\254\144\171\179\110\036\090\048\112\195\116\248",
	"\218\237\194\023\013\015\059\241\077\255\089\031\240\228\035\220\121\246\165\150\071\143\134\035\184\224\149\074\079\009\255\043\132\016\114\006\247\022\203\011\024\068\103\219\027\132\253\213\233\134\076\010\062\157\252\214\191\134\112\033\181\126\102\165",
	"\093\041\066\035\002\139\249\124\062\124\243\163\086\079\233\245\159\229\033\111\200\112\126\248\210\042\241\073\240\104\164\248\132\192\066\203\159\232\090\049\132\139\171\000\092\181\207\091\020\080\137\001\047\172\019\209\115\131\012\034\165\129\066\215",
	"\130\145\075\077\233\141\184\123\250\185\244\003\054\080\223\201\027\110\157\014\072\090\253\204\191\228\001\015\182\244\123\149\215\250\053\241\104\226\169\254\015\042\228\035\021\050\149\226\179\104\220\031\090\231\038\228\224\211\072\018\156\026\061\119",
	"\179\016\048\240\171\070\003\189\069\111\052\226\214\204\098\158\251\009\182\184\184\132\212\239\096\248\166\091\255\085\031\118\024\017\123\030\254\243\222\162\041\019\000\125\255\252\083\042\181\002\007\221\200\052\241\232\058\238\128\177\048\228\010\083",
	"\219\127\196\103\179\137\068\182\252\199\067\054\184\062\206\066\054\131\248\118\123\014\096\148\006\034\201\079\008\240\019\143\236\211\128\183\187\255\218\170\241\041\168\122\111\001\129\224\209\122\056\011\141\020\170\112\105\197\181\131\192\069\240\169",
	"\092\087\077\068\160\246\179\217\108\050\083\033\111\121\123\046\243\119\124\151\014\023\255\202\251\222\231\233\063\250\011\046\186\098\145\225\183\059\252\252\082\047\228\146\177\160\055\129\179\060\120\244\041\022\121\077\104\073\231\094\197\167\024\196",
	"\167\106\185\138\171\122\163\124\038\007\213\085\196\156\111\062\191\207\247\079\009\252\064\119\254\255\120\040\111\132\025\177\254\222\217\169\188\054\075\185\084\034\024\008\192\232\078\114\180\181\155\232\218\169\192\117\242\156\006\124\058\111\148\195",
	"\018\150\136\240\153\124\177\080\002\024\216\123\145\030\070\208\018\222\207\255\205\163\209\099\024\229\214\047\215\078\229\189\001\037\001\211\012\217\059\160\071\091\193\189\183\162\158\044\190\224\209\093\102\119\205\181\186\056\063\055\033\029\231\158",
	"\189\209\034\008\044\017\222\115\047\002\105\056\163\213\206\044\125\229\125\167\247\129\189\124\176\062\200\197\204\144\110\107\123\125\027\120\143\215\057\124\088\030\124\170\083\143\214\215\178\239\032\112\134\228\168\059\204\132\137\079\231\141\082\148",
	"\024\230\121\080\136\192\214\115\015\042\071\011\213\186\244\225\079\204\079\203\039\222\020\213\039\135\133\120\108\110\107\125\107\231\249\181\009\188\075\028\215\120\002\172\021\090\094\026\065\011\166\204\198\046\062\077\036\105\003\018\021\142\170\223",
	"\095\000\159\082\151\246\160\114\160\193\255\252\200\023\146\160\002\079\219\215\055\046\019\051\162\049\243\210\150\125\107\255\245\181\089\191\230\083\040\048\246\036\232\203\172\085\222\231\081\160\205\078\159\151\070\118\215\136\068\179\084\170\190\225",
	"\035\137\124\030\128\064\124\201\107\167\097\247\001\242\236\075\031\188\239\253\147\038\004\008\052\137\120\072\198\218\000\103\095\255\219\123\105\214\011\248\246\001\004\022\040\175\212\088\075\188\239\078\163\064\225\213\037\019\217\115\131\068\251\252",
	"\156\090\034\055\180\019\158\076\014\137\207\181\046\007\188\217\109\162\111\080\125\230\126\232\200\186\078\158\190\179\214\173\173\045\251\210\214\222\203\123\003\226\007\250\208\161\253\146\120\137\068\094\160\109\107\204\115\228\157\055\062\130\062\192",
	"\067\044\171\144\168\022\185\004\006\249\128\055\207\099\081\148\122\243\026\237\194\246\207\117\176\159\212\236\194\217\036\171\085\056\160\176\248\115\251\215\175\109\124\071\189\021\046\189\191\180\106\005\062\151\034\250\002\037\202\107\069\221\077\168",
	"\121\013\212\224\034\214\068\024\129\145\048\068\017\026\234\156\081\034\157\248\083\244\006\138\121\200\155\082\087\167\093\016\072\132\058\176\237\117\242\250\098\123\155\220\011\248\219\238\058\108\246\094\091\144\046\124\250\050\014\250\130\129\100\139",
	"\242\146\206\226\059\108\011\053\224\080\044\122\124\051\011\192\189\176\155\212\226\220\132\088\010\243\100\036\006\149\095\122\139\233\191\219\102\103\103\231\254\219\072\076\127\000\236\231\206\065\241\189\247\250\220\000\121\248\170\042\129\188\000\246",
	"\108\072\152\226\070\242\221\063\061\173\018\050\134\188\011\098\142\129\136\137\106\183\206\090\228\195\176\009\137\067\226\020\011\079\153\200\129\031\237\224\000\062\190\218\033\216\241\241\241\209\159\191\247\205\247\094\015\156\217\040\193\102\010\112",
	"\241\088\044\024\013\004\082\152\162\133\122\097\035\241\154\213\078\171\192\161\208\182\183\233\161\005\000\238\071\136\196\197\249\089\243\136\004\118\033\049\079\018\082\245\249\203\083\174\255\097\239\239\175\173\231\086\043\159\074\037\227\113\080\135",
	"\175\225\002\032\176\094\003\125\133\141\232\107\201\056\173\018\028\042\188\007\102\142\080\162\027\218\013\148\134\069\047\198\196\137\122\160\195\145\006\135\207\071\062\140\062\123\026\060\163\121\105\225\071\235\229\058\065\223\181\001\045\074\142\078",
	"\164\254\169\213\010\245\107\224\061\001\079\101\161\025\042\188\091\103\078\143\200\011\089\226\212\121\203\148\072\050\198\085\131\158\036\118\184\230\191\128\047\159\128\045\080\246\252\212\124\106\093\159\030\028\208\243\018\081\250\151\063\000\229\007",
	"\033\001\127\034\079\097\038\025\010\014\013\227\233\001\124\097\073\222\175\017\167\066\024\039\128\232\001\141\241\124\190\006\013\224\233\185\245\223\214\172\055\155\181\122\163\120\028\134\235\008\070\098\238\245\102\112\168\136\109\036\222\043\198\105",
	"\013\229\097\134\162\067\079\078\255\016\032\150\198\026\041\198\089\243\024\003\026\219\137\072\176\128\235\006\062\103\120\106\018\004\062\178\109\052\159\158\026\164\071\194\102\181\222\200\237\239\064\234\133\195\123\145\136\183\111\225\064\253\186\240",
	"\226\095\227\223\147\058\170\111\105\165\031\192\147\083\242\210\249\020\163\072\138\113\101\193\070\136\208\085\019\088\143\249\002\050\209\112\109\035\015\029\106\181\071\124\012\112\125\253\088\075\132\093\224\169\157\181\053\055\066\145\187\135\007\253",
	"\248\066\253\209\189\219\236\250\181\255\226\029\244\129\071\244\024\155\155\016\231\103\045\099\034\200\213\118\222\235\077\021\120\040\016\220\098\023\106\100\186\196\071\000\005\220\112\023\030\243\071\059\164\033\184\092\219\219\059\184\167\118\035\024",
	"\062\031\061\254\019\220\056\122\233\058\128\055\014\188\126\130\010\002\001\120\118\250\137\104\199\035\122\016\071\185\161\092\137\122\162\176\005\135\171\231\133\253\255\245\053\121\092\146\047\213\146\123\235\075\139\118\161\011\185\208\054\168\057\215",
	"\090\143\123\080\238\111\176\064\040\084\168\143\242\208\161\244\188\009\243\055\129\231\044\015\132\134\179\106\071\141\106\241\176\084\237\111\039\189\222\068\145\062\107\066\195\087\003\060\127\253\152\063\116\045\066\147\033\125\245\075\239\115\058\215",
	"\157\252\129\203\255\210\243\235\032\093\212\150\127\241\200\025\030\134\028\046\059\198\196\033\169\186\106\199\092\213\015\139\165\048\199\189\005\061\222\120\062\151\225\169\229\248\066\045\031\093\091\252\049\176\037\202\181\219\237\002\217\181\177\150",
	"\233\062\089\161\157\041\244\022\033\126\059\225\065\000\255\002\240\239\013\106\004\034\052\028\162\017\170\099\222\098\150\137\097\004\240\180\043\001\143\063\014\123\255\076\006\223\183\102\142\214\126\254\248\015\019\184\139\063\108\174\035\216\111\232",
	"\052\026\005\009\223\034\229\237\013\120\055\183\183\076\246\239\205\025\209\008\045\110\143\030\016\164\110\029\145\072\021\134\068\183\226\119\195\052\007\204\132\119\227\231\146\064\160\047\047\208\062\245\242\239\182\149\068\175\023\152\213\128\188\041",
	"\226\206\126\126\018\127\158\255\065\222\029\147\205\222\082\226\225\033\169\142\029\234\214\249\057\243\216\176\084\062\102\072\116\154\209\093\119\120\195\137\131\205\199\202\143\235\113\223\232\119\054\087\182\215\243\025\166\053\170\129\188\117\215\014",
	"\241\231\225\009\073\208\155\219\187\219\123\230\054\139\103\190\206\232\129\224\125\218\115\086\081\164\109\078\039\147\032\050\208\233\038\034\171\139\214\031\086\058\185\009\139\255\135\193\196\097\089\140\188\224\009\056\013\226\244\115\054\148\183\238",
	"\218\222\161\249\002\184\115\240\039\061\215\086\070\226\013\061\164\123\252\113\016\018\207\093\218\230\212\128\084\140\177\028\158\061\060\128\220\068\041\148\054\051\152\109\128\102\143\060\247\122\121\147\078\003\123\089\133\026\112\011\232\077\192\237",
	"\018\127\158\156\252\249\003\254\068\096\185\204\180\129\120\043\016\133\147\172\032\114\027\143\233\046\044\032\082\042\135\139\024\184\098\183\215\201\030\172\193\110\210\034\208\096\106\053\026\231\029\155\121\088\167\114\028\171\006\154\028\106\129\224",
	"\136\188\221\048\229\145\003\202\055\228\124\050\005\222\097\028\241\040\235\151\179\179\235\002\082\055\134\072\149\154\197\067\150\096\221\082\054\122\132\141\058\154\121\038\139\098\201\099\032\052\133\124\076\135\234\022\063\188\041\148\031\205\079\194",
	"\171\048\237\106\249\238\046\075\014\123\018\145\039\244\240\243\174\112\024\121\113\097\201\054\059\065\100\170\052\106\157\193\196\249\146\165\087\220\255\118\187\207\153\040\108\075\117\106\021\165\169\141\182\165\133\037\065\221\014\057\038\220\079\151",
	"\051\122\226\027\120\021\166\218\046\151\239\179\002\241\227\252\051\065\130\099\145\185\180\100\051\170\199\016\009\155\070\152\142\245\058\029\238\073\117\048\049\078\107\052\036\112\132\182\068\196\009\184\126\053\008\103\118\111\239\041\015\020\002\144",
	"\016\033\089\009\018\115\231\243\129\114\116\173\125\107\107\105\094\071\246\251\008\253\108\176\029\215\025\231\241\060\010\165\017\028\073\150\003\193\157\232\079\146\160\015\004\088\045\163\221\223\103\111\033\089\041\145\212\228\062\170\004\153\059\219",
	"\219\174\245\245\149\021\059\158\111\089\152\005\101\106\052\220\138\162\210\217\121\024\187\183\200\025\250\117\065\028\085\007\189\229\132\134\143\030\103\047\087\004\133\064\171\086\009\242\238\142\030\210\023\106\242\128\030\100\023\152\000\093\093\089",
	"\217\026\152\221\062\248\106\005\140\192\182\169\047\251\184\083\042\143\242\238\129\085\169\086\042\015\076\149\024\081\121\119\079\144\253\154\028\200\068\223\082\170\011\023\133\149\015\163\171\132\203\069\097\238\095\100\021\006\028\061\057\079\120\183",
	"\131\116\001\096\169\004\046\173\086\154\002\146\252\143\001\183\183\130\200\001\147\232\012\239\254\250\181\067\176\196\200\026\040\124\141\063\222\249\069\060\185\071\067\247\129\163\217\137\064\036\002\175\194\060\060\084\031\004\149\248\243\251\187\254",
	"\255\252\240\149\073\160\097\250\114\123\103\096\244\251\093\097\192\128\223\131\196\028\056\019\112\055\196\155\120\252\185\076\016\064\252\127\214\022\210\152\115\178\023\000\000\000\000\000\073\069\078\068\174\066\096\130",
})
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

local function ApplyThemeEntry(Instance, Properties)
	for Property, ColorIdx in next, Properties do
		local ok, err = pcall(function()
			Instance[Property] = Creator.GetThemeProperty(ColorIdx)
		end)
		if not ok then
			warn("DimensiUI theme property update failed:", err)
			Creator.Registry[Instance] = nil
			return false
		end
	end
	return true
end

function Creator.UpdateTheme()
	for Instance, Object in next, Creator.Registry do
		ApplyThemeEntry(Instance, Object.Properties)
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
	ApplyThemeEntry(Object, Properties)
	return Object
end

function Creator.OverrideTag(Object, Properties)
	local Entry = Creator.Registry[Object]
	if not Entry or type(Properties) ~= "table" then
		return false
	end
	Entry.Properties = Properties
	ApplyThemeEntry(Object, Properties)
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

__DimensiModules['Surface'] = function(script, require)
-- Solid surface: flat fill, rounded corners, no blur and no textures.
-- ColorKey picks the theme color (default WindowBackground). Outline adds a 1px hairline.
local Root = script.Parent
local Creator = require(Root.Creator)

local New = Creator.New

return function(ColorKey, Outline)
	local Surface = {}

	local Children = {
		New("UICorner", {
			CornerRadius = UDim.new(0, 12),
		}),
	}

	if Outline then
		table.insert(
			Children,
			New("UIStroke", {
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "Divider",
				},
			})
		)
	end

	Surface.Frame = New("Frame", {
		Name = "Surface",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, {
		New("Frame", {
			Name = "Background",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ThemeTag = {
				BackgroundColor3 = ColorKey or "WindowBackground",
			},
		}, Children),
	})

	return Surface
end
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
		FontFace = Typography.Medium,
		TextColor3 = Color3.fromRGB(241, 243, 247),
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
			CornerRadius = UDim.new(0, 8),
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
			CornerRadius = UDim.new(0, 8),
		}),
		Button.HoverFrame,
		Button.Title,
	})

	local Motor, SetTransparency = Creator.SpringMotor(1, Button.HoverFrame, "BackgroundTransparency", DialogCheck)
	Creator.AddSignal(Button.Frame.MouseEnter, function()
		SetTransparency(0.92)
	end, Button.Frame)
	Creator.AddSignal(Button.Frame.MouseLeave, function()
		SetTransparency(1)
	end, Button.Frame)
	Creator.AddSignal(Button.Frame.MouseButton1Down, function()
		SetTransparency(1)
	end, Button.Frame)
	Creator.AddSignal(Button.Frame.MouseButton1Up, function()
		SetTransparency(0.92)
	end, Button.Frame)

	return Button
end
end

__DimensiModules['Components/Card'] = function(script, require)
-- Card: a rounded container that groups rows. Rows are separated by hairlines, not borders.
local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New

local Card = {}

-- One implicit card per tab container, used by elements added directly to a tab.
local AutoCards = setmetatable({}, { __mode = "k" })

function Card.New(Parent)
	return New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		LayoutOrder = 7,
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = "Card",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 12),
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 3),
			PaddingBottom = UDim.new(0, 3),
			PaddingLeft = UDim.new(0, 3),
			PaddingRight = UDim.new(0, 3),
		}),
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0),
		}),
	})
end

function Card.Auto(Parent)
	local Existing = AutoCards[Parent]
	if Existing and Existing.Parent == Parent then
		return Existing
	end
	local Frame = Card.New(Parent)
	AutoCards[Parent] = Frame
	return Frame
end

-- Called when a section is added so later loose elements start a fresh card below it.
function Card.Reset(Parent)
	AutoCards[Parent] = nil
end

return Card
end

__DimensiModules['Components/Dialog'] = function(script, require)
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local Library = require(Root)

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
		_IsOpen = false,
	}

	function NewDialog:SetOpenState(IsOpen)
		IsOpen = not not IsOpen
		if self._IsOpen == IsOpen then
			return
		end
		self._IsOpen = IsOpen
		Library._OpenDialogCount = math.max(0, (Library._OpenDialogCount or 0) + (IsOpen and 1 or -1))
		Library.DialogOpen = Library._OpenDialogCount > 0
	end

	NewDialog.TintFrame = New("TextButton", {
		Text = "",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Parent = Dialog.Window.Root,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 12),
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
		TextColor3 = Color3.fromRGB(241, 243, 247),
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
			CornerRadius = UDim.new(0, 12),
		}),
		New("UIStroke", {
			Transparency = 0,
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
		if NewDialog.Closed or Library.Unloaded or not NewDialog.TintFrame.Parent then return false end
		NewDialog:SetOpenState(true)
		NewDialog.Scale.Scale = 1.1
		TintTransparency(0.75)
		RootTransparency(0)
		Scale(1)
	end

	function NewDialog:Close()
		if NewDialog.Closed then return end
		NewDialog.Closed = true
		NewDialog:SetOpenState(false)
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

	Creator.AddSignal(NewDialog.TintFrame.Destroying, function()
		NewDialog:SetOpenState(false)
		NewDialog.Closed = true
	end, NewDialog.TintFrame)

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
		end, Button.Frame)

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

local Card = require(script.Parent.Card)

local Spring = Motion.Spring.new

return function(Title, Desc, Parent, Hover)
	local Element = {}

	-- Elements added straight to a tab are grouped into one implicit card.
	if Parent and Parent:IsA("ScrollingFrame") then
		Parent = Card.Auto(Parent)
	end

	Element.TitleLabel = New("TextLabel", {
		FontFace = Typography.Medium,
		Text = Title,
		TextColor3 = Color3.fromRGB(241, 243, 247),
		TextSize = 14,
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
		TextColor3 = Color3.fromRGB(150, 158, 172),
		TextSize = 13,
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
			Padding = UDim.new(0, 2),
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 7),
			PaddingTop = UDim.new(0, 7),
		}),
		New("UISizeConstraint", {
			MinSize = Vector2.new(0, 44),
		}),
		Element.TitleLabel,
		Element.DescLabel,
	})

	Element.Separator = New("Frame", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -24, 0, 1),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ThemeTag = {
			BackgroundColor3 = "Divider",
		},
	})

	Element.Frame = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(33, 38, 48),
		Parent = Parent,
		AutomaticSize = Enum.AutomaticSize.Y,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = 7,
		ThemeTag = {
			BackgroundColor3 = "Tone",
			BackgroundTransparency = "ElementTransparency",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 10),
		}),
		Element.Separator,
		Element.LabelHolder,
	})

	-- Hairline above every row except the first one in its card.
	local Rows = 0
	if Parent then
		for _, Child in next, Parent:GetChildren() do
			if Child:IsA("GuiObject") then
				Rows += 1
			end
		end
	end
	Element.Separator.Visible = Rows > 1

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
		end, Element.Frame)
		Creator.AddSignal(Element.Frame.MouseLeave, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency"))
		end, Element.Frame)
		Creator.AddSignal(Element.Frame.MouseButton1Down, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange") - 0.15)
		end, Element.Frame)
		Creator.AddSignal(Element.Frame.MouseButton1Up, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
		end, Element.Frame)
	end

	return Element
end
end

__DimensiModules['Components/Notification'] = function(script, require)
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local Surface = require(Root.Surface)

local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local New = Creator.New

local Notification = {}

function Notification:Init(GUI)
	local function GetViewportWidth()
		local Camera = workspace.CurrentCamera
		return Camera and Camera.ViewportSize.X or 800
	end

	Notification.Holder = New("Frame", {
		Position = UDim2.new(1, -12, 1, -12),
		Size = UDim2.new(0, math.max(220, math.min(310, GetViewportWidth() - 24)), 1, -24),
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

	local function UpdateWidth()
		if Notification.Holder and Notification.Holder.Parent then
			Notification.Holder.Size = UDim2.new(0, math.max(220, math.min(310, GetViewportWidth() - 24)), 1, -24)
		end
	end

	local BoundCamera
	local CameraConnection
	local function BindCamera(Camera)
		if Camera == BoundCamera then return end
		if CameraConnection then Creator.DisconnectSignal(CameraConnection) end
		BoundCamera = Camera
		CameraConnection = nil
		if Camera then
			CameraConnection = Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), UpdateWidth, GUI)
		end
		UpdateWidth()
	end

	BindCamera(workspace.CurrentCamera)
	Creator.AddSignal(workspace:GetPropertyChangedSignal("CurrentCamera"), function()
		BindCamera(workspace.CurrentCamera)
	end, GUI)
end

function Notification:New(Config)
	assert(type(Config) == "table", "Notification config must be a table")
	assert(Config.Duration == nil or (type(Config.Duration) == "number" and Config.Duration == Config.Duration and Config.Duration >= 0 and math.abs(Config.Duration) < math.huge), "Notification duration must be a finite non-negative number")
	Config.Title = Config.Title or "Title"
	Config.Content = Config.Content or "Content"
	Config.SubContent = Config.SubContent or ""
	Config.Duration = Config.Duration or nil
	Config.Buttons = Config.Buttons or {}
	assert(type(Config.Buttons) == "table", "Notification Buttons must be a table")
	assert(type(Config.Title) == "string" and type(Config.Content) == "string" and type(Config.SubContent) == "string", "Notification text must be strings")
	for Index, Button in ipairs(Config.Buttons) do
		assert(type(Button) == "table", "Notification button #" .. Index .. " must be a table")
		assert(type(Button.Title) == "string" and Button.Title ~= "", "Notification button #" .. Index .. " requires a title")
		assert(Button.Callback == nil or type(Button.Callback) == "function", "Notification button callback must be a function")
	end
	local NewNotification = {
		Closed = false,
	}

	NewNotification.Surface = Surface("Card", true)

	NewNotification.Title = New("TextLabel", {
		Position = UDim2.new(0, 14, 0, 17),
		Text = Config.Title,
		RichText = true,
		TextColor3 = Color3.fromRGB(241, 243, 247),
		TextTransparency = 0,
		FontFace = Typography.SemiBold,
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
			TextColor3 = "SubText",
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

	NewNotification.Accent = New("Frame", {
		Position = UDim2.new(0, 6, 0, 12),
		Size = UDim2.new(0, 3, 1, -24),
		BackgroundTransparency = 0,
		ThemeTag = {
			BackgroundColor3 = "Accent",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
	})

	NewNotification.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(1, 0),
	}, {
		NewNotification.Surface.Frame,
		NewNotification.Accent,
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

	Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function()
		NewNotification:Close()
	end, NewNotification.Holder)

	local RootMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		Scale = 1,
		Offset = 60,
	}), NewNotification.Holder)

	RootMotor:onStep(function(Values)
		NewNotification.Root.Position = UDim2.new(Values.Scale, Values.Offset, 0, 0)
	end)

	function NewNotification:Open()
		local ContentSize = NewNotification.LabelHolder.AbsoluteSize.Y
		local ButtonHeight = NewNotification.ButtonHolder and 38 or 0
		NewNotification.Holder.Size = UDim2.new(1, 0, 0, 58 + ContentSize + ButtonHeight)
		if NewNotification.ButtonHolder then
			NewNotification.ButtonHolder.Position = UDim2.new(0, 14, 0, 48 + ContentSize)
		end

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
			if NewNotification.Holder and NewNotification.Holder.Parent then
				NewNotification.Holder:Destroy()
			end
		end)
	end

	if #Config.Buttons > 0 then
		local ButtonHolder = New("Frame", {
			Name = "ButtonHolder",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 14, 0, 0),
			Size = UDim2.new(1, -28, 0, 30),
			Parent = NewNotification.Root,
		})
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ButtonHolder,
		})
		NewNotification.ButtonHolder = ButtonHolder
		for Index, ButtonConfig in ipairs(Config.Buttons) do
			local Button = require(script.Parent.Button)("", ButtonHolder, true)
			Button.Title.Text = ButtonConfig.Title
			Button.Frame.LayoutOrder = Index
			Button.Frame.Size = UDim2.new(1 / #Config.Buttons, -((#Config.Buttons - 1) * 6 / #Config.Buttons), 0, 28)
			Creator.AddSignal(Button.Frame.MouseButton1Click, function()
				local Library = require(Root)
				if ButtonConfig.Callback then Library:SafeCallback(ButtonConfig.Callback) end
				NewNotification:Close()
			end, NewNotification.Holder)
		end
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
local Card = require(script.Parent.Card)

local New = Creator.New

return function(Title, Parent)
	local Section = {}

	-- Section.Container is the card that holds this section's rows.
	Section.Container = Card.New(nil)
	Section.Container.Position = UDim2.fromOffset(0, 24)
	Section.Layout = Section.Container:FindFirstChildOfClass("UIListLayout")

	Section.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 32),
		LayoutOrder = 7,
		Parent = Parent,
	}, {
		New("TextLabel", {
			RichText = true,
			Text = Title,
			TextTransparency = 0,
			FontFace = Typography.Medium,
			TextSize = 14,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 16),
			Position = UDim2.fromOffset(5, 0),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		}),
		Section.Container,
	})

	-- Card height = compact row stack + title spacing.
	Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 6 + 24)
	end, Section.Root)

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
local Card = require(Components.Card)

-- Background tint (Tab theme color) per interaction state
local TINT_IDLE = 1
local TINT_HOVER = 0.6
local TINT_PRESSED = 0.4
local TINT_SELECTED = 0
local TINT_SELECTED_HOVER = 0.12

local function SetActive(Item, Active)
	if Item.Label then
		Item.Label.FontFace = Active and Typography.Medium or Typography.Regular
		Creator.OverrideTag(Item.Label, { TextColor3 = Active and "Text" or "SubText" })
	end
	if Item.IconImage then
		Creator.OverrideTag(Item.IconImage, { ImageColor3 = Active and "Accent" or "SubText" })
	end
end

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

function TabModule:New(Title, Icon, Parent, Description)
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
		Description = Description or "",
		HasIcon = false,
		Type = "Tab",
	}

	if Library:GetIcon(Icon) then
		Icon = Library:GetIcon(Icon)
	end

	if Icon == "" or Icon == nil then
		Icon = nil
	end
	Tab.HasIcon = Icon ~= nil

	Tab.Label = New("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = Icon and UDim2.new(0, 40, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
		Text = Title,
		RichText = true,
		TextTransparency = 0,
		FontFace = Typography.Regular,
		TextSize = 14,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		Size = UDim2.new(1, Icon and -48 or -20, 1, 0),
		BackgroundTransparency = 1,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ThemeTag = {
			TextColor3 = "SubText",
		},
	})

	Tab.IconImage = New("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.new(0, 12, 0.5, 0),
		BackgroundTransparency = 1,
		Image = Icon and Icon or nil,
		ThemeTag = {
			ImageColor3 = "SubText",
		},
	})

	Tab.Frame = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = "Tab",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 10),
		}),
		Tab.Label,
		Tab.IconImage,
	})

	local ContainerLayout = New("UIListLayout", {
		Padding = UDim.new(0, 16),
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
		ScrollBarImageColor3 = Color3.fromRGB(150, 158, 172),
		ScrollBarImageTransparency = 0.7,
		ScrollBarThickness = 3,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		ContainerLayout,
		New("UIPadding", {
			PaddingRight = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 1),
			PaddingTop = UDim.new(0, 1),
			PaddingBottom = UDim.new(0, 1),
		}),
	})

	Creator.AddSignal(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 2)
	end, Tab.ContainerFrame)

	Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")

	Creator.AddSignal(Tab.Frame.MouseEnter, function()
		Tab.SetTransparency(Tab.Selected and TINT_SELECTED_HOVER or TINT_HOVER)
	end, Tab.Frame)
	Creator.AddSignal(Tab.Frame.MouseLeave, function()
		Tab.SetTransparency(Tab.Selected and TINT_SELECTED or TINT_IDLE)
	end, Tab.Frame)
	Creator.AddSignal(Tab.Frame.MouseButton1Down, function()
		Tab.SetTransparency(TINT_PRESSED)
	end, Tab.Frame)
	Creator.AddSignal(Tab.Frame.MouseButton1Up, function()
		Tab.SetTransparency(Tab.Selected and TINT_SELECTED_HOVER or TINT_HOVER)
	end, Tab.Frame)
	Creator.AddSignal(Tab.Frame.MouseButton1Click, function()
		TabModule:SelectTab(TabIndex)
	end, Tab.Frame)

	table.insert(Window.TabItems, Tab)
	TabModule.Containers[TabIndex] = Tab.ContainerFrame
	TabModule.Tabs[TabIndex] = Tab

	Tab.Container = Tab.ContainerFrame
	Tab.ScrollFrame = Tab.Container

	function Tab:AddSection(SectionTitle)
		assert(type(SectionTitle) == "string" and SectionTitle ~= "", "Section title must be a non-empty string")
		local Section = { Type = "Section" }
		Card.Reset(Tab.Container)

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
		Item.SetTransparency(TINT_IDLE)
		Item.Selected = false
		SetActive(Item, false)
	end
	TabObject.SetTransparency(TINT_SELECTED)
	TabObject.Selected = true
	SetActive(TabObject, true)
	Window.TabDisplay.Text = TabObject.Name
	Window.PageDescription.Text = TabObject.Description or ""
	task.spawn(function()
		if Generation ~= TabModule.SelectionGeneration or require(Root).Unloaded then return end
		Window.ContainerPosMotor:setGoal(Spring(Window.ContentTop + 16, { frequency = 10 }))
		Window.ContainerBackMotor:setGoal(Spring(1, { frequency = 10 }))
		task.wait(0.15)
		if Generation ~= TabModule.SelectionGeneration or require(Root).Unloaded then return end
		for _, Container in next, TabModule.Containers do
			if Container and Container.Parent then Container.Visible = false end
		end
		local SelectedContainer = TabModule.Containers[Tab]
		if SelectedContainer and SelectedContainer.Parent then SelectedContainer.Visible = true end
		Window.ContainerPosMotor:setGoal(Spring(Window.ContentTop, { frequency = 5 }))
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
local Creator = require(Root.Creator)
local New = Creator.New

return function(Parent, InElement)
	InElement = InElement or false
	local Textbox = {}

	Textbox.Input = New("TextBox", {
		FontFace = Typography.Regular,
		TextColor3 = Color3.fromRGB(241, 243, 247),
		TextSize = 13,
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

	Textbox.Stroke = New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Transparency = 1,
		ThemeTag = {
			Color = "Accent",
		},
	})

	Textbox.Frame = New("Frame", {
		Size = UDim2.new(0, 0, 0, 30),
		BackgroundTransparency = 0,
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = "Tone",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
		Textbox.Stroke,
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

	Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), Update, Textbox.Frame)
	Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("CursorPosition"), Update, Textbox.Frame)

	Creator.AddSignal(Textbox.Input.Focused, function()
		Update()
		Textbox.Stroke.Transparency = 0
	end, Textbox.Frame)

	Creator.AddSignal(Textbox.Input.FocusLost, function()
		Update()
		Textbox.Stroke.Transparency = 1
	end, Textbox.Frame)

	return Textbox
end
end

__DimensiModules['Components/TitleBar'] = function(script, require)
local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Assets = require(script.Parent.Assets)
local Creator = require(Root.Creator)

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
			Size = UDim2.fromOffset(32, 32),
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
				CornerRadius = UDim.new(0, 8),
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
		end, Button.Frame)
		AddSignal(Button.Frame.MouseLeave, function()
			SetTransparency(1, true)
		end, Button.Frame)
		AddSignal(Button.Frame.MouseButton1Down, function()
			SetTransparency(0.96)
		end, Button.Frame)
		AddSignal(Button.Frame.MouseButton1Up, function()
			SetTransparency(0.94)
		end, Button.Frame)
		AddSignal(Button.Frame.MouseButton1Click, Button.Callback, Button.Frame)

		Button.SetCallback = function(Func)
			Button.Callback = Func
		end

		return Button
	end

	-- Keep the DimensiUI brand prefix enforced by the library itself.
	-- Callers only need to provide the app name (for example, "BLOOM").
	local BrandPrefix = "DIMENSI-HUB | "
	local AppTitle = tostring(Config.Title or "")
	if string.sub(AppTitle, 1, #BrandPrefix) ~= BrandPrefix then
		AppTitle = BrandPrefix .. AppTitle
	end

	TitleBar.Brand = New("Frame", {
		Position = UDim2.fromOffset(24, 12),
		Size = UDim2.fromOffset(math.max(96, (Config.Window and Config.Window.TabWidth or 160) - 12), 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		New("TextLabel", {
			RichText = true,
			Text = AppTitle,
			FontFace = Typography.SemiBold,
			TextSize = 15,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 17),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		}),
		New("TextLabel", {
			RichText = true,
			Text = Config.SubTitle,
			TextTransparency = 0,
			FontFace = Typography.Regular,
			TextSize = 12,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		}),
	})

	TitleBar.Frame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundTransparency = 1,
		Parent = Config.Parent,
	}, {
		TitleBar.Brand,
	})

	TitleBar.CollapseButton = New("TextButton", {
		Name = "SidebarToggle",
		Size = UDim2.fromOffset(28, 28),
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromOffset((Config.Window and Config.Window.TabWidth or 160) + 12, 14),
		BackgroundTransparency = 1,
		Text = "≡",
		TextSize = 15,
		FontFace = Typography.Medium,
		Parent = TitleBar.Frame,
		ThemeTag = { TextColor3 = "SubText", BackgroundColor3 = "Tone" },
	}, {
		New("UICorner", { CornerRadius = UDim.new(0, 8) }),
	})
	AddSignal(TitleBar.CollapseButton.MouseEnter, function()
		TitleBar.CollapseButton.BackgroundTransparency = 0.35
	end, TitleBar.CollapseButton)
	AddSignal(TitleBar.CollapseButton.MouseLeave, function()
		TitleBar.CollapseButton.BackgroundTransparency = 1
	end, TitleBar.CollapseButton)
	AddSignal(TitleBar.CollapseButton.MouseButton1Click, function()
		if Config.Window then Config.Window:ToggleSidebar() end
	end, TitleBar.CollapseButton)

	TitleBar.CloseButton = BarButton(Assets.Close, UDim2.new(1, -12, 0, 12), TitleBar.Frame, function()
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
	TitleBar.MinButton = BarButton(Assets.Min, UDim2.new(1, -48, 0, 12), TitleBar.Frame, function()
		Library.Window:Minimize()
	end)

	return TitleBar
end
end

__DimensiModules['Components/Window'] = function(script, require)
-- DimensiUI window: layout, drag/resize, sidebar, minimize bubble, dialogs and tab API.
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ContentProvider = game:GetService("ContentProvider")
local GuiService = game:GetService("GuiService")
local Camera = Workspace.CurrentCamera

local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local Surface = require(Root.Surface)
local Assets = require(script.Parent.Assets)
local BubbleIconData = require(Root.BubbleIcon)
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
		Collapsed = false,
		Hidden = false,
		Size = UDim2.fromOffset(initialWidth, initialHeight),
		TabWidth = initialTabWidth,
		ExpandedTabWidth = initialTabWidth,
		SidebarCollapsed = false,
		TabItems = {},
		ContentTop = 76,
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

	Window.Surface = Surface()

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

	Window.Sidebar = New("Frame", {
		Size = UDim2.new(0, Window.TabWidth + 24, 1, 0),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ThemeTag = {
			BackgroundColor3 = "Sidebar",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 12),
		}),
		-- Squares off the sidebar's right-hand corners so only the window's left corners stay round.
		New("Frame", {
			Name = "Patch",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, 14, 1, 0),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ThemeTag = {
				BackgroundColor3 = "Sidebar",
			},
		}),
	})

	local TabFrame = New("Frame", {
		Size = UDim2.new(0, Window.TabWidth, 1, -76),
		Position = UDim2.new(0, 12, 0, 64),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	}, {
		Window.TabHolder,
	})

	Window.TabDisplay = New("TextLabel", {
		RichText = true,
		Text = "Tab",
		TextTransparency = 0,
		FontFace = Typography.SemiBold,
		TextSize = 20,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, -(Window.TabWidth + 144), 0, 28),
		Position = UDim2.fromOffset(Window.TabWidth + 48, 14),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Window.PageDescription = New("TextLabel", {
		Text = "",
		FontFace = Typography.Regular,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, -(Window.TabWidth + 144), 0, 18),
		Position = UDim2.fromOffset(Window.TabWidth + 48, 38),
		BackgroundTransparency = 1,
		ThemeTag = { TextColor3 = "SubText" },
	})

	Window.ContainerHolder = New("CanvasGroup", {
		Size = UDim2.new(1, -(Window.TabWidth + 72), 1, -(Window.ContentTop + 20)),
		Position = UDim2.fromOffset(Window.TabWidth + 48, Window.ContentTop),
		BackgroundTransparency = 1,
	})

	Window.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = Window.Size,
		Position = Window.Position,
		Parent = Config.Parent,
		Active = true,
	}, {
		Window.Surface.Frame,
		Window.Sidebar,
		Window.TabDisplay,
		Window.PageDescription,
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

	-- The tab list starts below the brand block, which grows when a long title wraps.
	local function LayoutSidebar()
		local Brand = Window.TitleBar.Brand
		Brand.Visible = not Window.SidebarCollapsed
		local Top = Window.SidebarCollapsed and 64 or math.max(64, Brand.Position.Y.Offset + Brand.AbsoluteSize.Y + 18)
		TabFrame.Position = UDim2.fromOffset(12, Top)
		TabFrame.Size = UDim2.new(0, Window.TabWidth, 1, -(Top + 12))
		if Window.TitleBar and Window.TitleBar.CollapseButton then
			Window.TitleBar.CollapseButton.Position = UDim2.fromOffset(Window.TabWidth + 12, 14)
		end
		for _, TabItem in ipairs(Window.TabItems) do
			if TabItem.Label then
				TabItem.Label.Visible = not Window.SidebarCollapsed or not TabItem.HasIcon
				TabItem.Label.Text = Window.SidebarCollapsed and not TabItem.HasIcon and string.sub(TabItem.Name, 1, 1) or TabItem.Name
				TabItem.Label.Position = Window.SidebarCollapsed and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 40, 0.5, 0)
				TabItem.Label.AnchorPoint = Window.SidebarCollapsed and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
			end
			if TabItem.IconImage then
				TabItem.IconImage.Position = Window.SidebarCollapsed and UDim2.new(0.5, -8, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
			end
			if TabItem.Frame then
				TabItem.Frame.Size = UDim2.new(1, 0, 0, 36)
				TabItem.Frame:SetAttribute("TabTitle", TabItem.Name)
			end
		end
	end

	function Window:SetSidebarCollapsed(Collapsed)
		Collapsed = not not Collapsed
		if Window.SidebarCollapsed == Collapsed then return false end
		Window.SidebarCollapsed = Collapsed
		Window.TabWidth = Collapsed and 64 or Window.ExpandedTabWidth
		local sidebarWidth = Window.TabWidth + 24
		local contentX = Window.TabWidth + 48
		local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		TweenService:Create(Window.Sidebar, tweenInfo, { Size = UDim2.new(0, sidebarWidth, 1, 0) }):Play()
		TweenService:Create(TabFrame, tweenInfo, { Size = UDim2.new(0, Window.TabWidth, 1, -(TabFrame.Position.Y.Offset + 12)) }):Play()
		TweenService:Create(Window.TabDisplay, tweenInfo, { Position = UDim2.fromOffset(contentX, 10), Size = UDim2.new(1, -(contentX + 24), 0, 28) }):Play()
		TweenService:Create(Window.PageDescription, tweenInfo, { Position = UDim2.fromOffset(contentX, 36), Size = UDim2.new(1, -(contentX + 24), 0, 18) }):Play()
		TweenService:Create(Window.ContainerHolder, tweenInfo, { Position = UDim2.fromOffset(contentX, Window.ContentTop), Size = UDim2.new(1, -(contentX + 24), 1, -(Window.ContentTop + 20)) }):Play()
		LayoutSidebar()
		return true
	end

	function Window:ToggleSidebar()
		return self:SetSidebarCollapsed(not self.SidebarCollapsed)
	end
	LayoutSidebar()
	Creator.AddSignal(Window.TitleBar.Brand:GetPropertyChangedSignal("AbsoluteSize"), LayoutSidebar, Window.Root)

	local SizeMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		X = Window.Size.X.Offset,
		Y = Window.Size.Y.Offset,
	}), Window.Root)

	local PosMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		X = Window.Position.X.Offset,
		Y = Window.Position.Y.Offset,
	}), Window.Root)

	Window.ContainerBackMotor = Creator.TrackMotor(Motion.SingleMotor.new(0), Window.Root)
	Window.ContainerPosMotor = Creator.TrackMotor(Motion.SingleMotor.new(Window.ContentTop), Window.Root)

	SizeMotor:onStep(function(values)
		Window.Root.Size = UDim2.new(0, values.X, 0, values.Y)
	end)

	PosMotor:onStep(function(values)
		Window.Root.Position = UDim2.new(0, values.X, 0, values.Y)
	end)

	Window.ContainerBackMotor:onStep(function(Value)
		Window.ContainerHolder.GroupTransparency = Value
	end)

	Window.ContainerPosMotor:onStep(function(Value)
		Window.ContainerHolder.Position = UDim2.fromOffset(Window.TabWidth + 48, Value)
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
			DragEndConnection = Creator.AddSignal(Input.Changed, function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
					if DragEndConnection then
						Creator.DisconnectSignal(DragEndConnection)
						DragEndConnection = nil
					end
				end
			end, Window.Root)
		end
	end, Window.Root)

	Creator.AddSignal(Window.TitleBar.Frame.InputChanged, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			DragInput = Input
		end
	end, Window.Root)

	Creator.AddSignal(ResizeStartFrame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Resizing = true
			ResizePos = Input.Position
		end
	end, Window.Root)

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
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if Resizing == true or Input.UserInputType == Enum.UserInputType.Touch then
			Resizing = false
			Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
		end
	end, Window.Root)

	-- Assigned once the minimize bubble exists, so it can re-clamp itself when the viewport changes.
	local BubbleViewportHook

	local function FitToViewport()
		if not Window.Root or not Window.Root.Parent then return end
		local view, minW, minH, maxW, maxH, isMobile = getBounds()
		local width = math.clamp(Window.Size.X.Offset, minW, maxW)
		local height = math.clamp(Window.Size.Y.Offset, minH, maxH)
		local x = math.clamp(Window.Position.X.Offset, 0, math.max(0, view.X - width))
		local y = math.clamp(Window.Position.Y.Offset, 0, math.max(0, view.Y - height))
		Window.Size = UDim2.fromOffset(width, height)
		Window.Position = UDim2.fromOffset(x, y)
		Window.ExpandedTabWidth = isMobile and math.clamp(Window.ExpandedTabWidth, 92, 108) or math.clamp(Window.ExpandedTabWidth, 120, 220)
		Window.TabWidth = Window.SidebarCollapsed and 64 or Window.ExpandedTabWidth
		SizeMotor:setGoal({ X = Instant(width), Y = Instant(height) })
		PosMotor:setGoal({ X = Instant(x), Y = Instant(y) })
		Window.Sidebar.Size = UDim2.new(0, Window.TabWidth + 24, 1, 0)
		Window.TitleBar.Brand.Size = UDim2.fromOffset(math.max(96, Window.TabWidth - 12), 0)
		LayoutSidebar()
		Window.TabDisplay.Position = UDim2.fromOffset(Window.TabWidth + 48, 10)
		Window.TabDisplay.Size = UDim2.new(1, -(Window.TabWidth + 72), 0, 28)
		Window.PageDescription.Position = UDim2.fromOffset(Window.TabWidth + 48, 36)
		Window.PageDescription.Size = UDim2.new(1, -(Window.TabWidth + 72), 0, 18)
		Window.ContainerHolder.Size = UDim2.new(1, -(Window.TabWidth + 72), 1, -(Window.ContentTop + 20))
		Window.ContainerHolder.Position = UDim2.fromOffset(Window.TabWidth + 48, Window.ContentTop)
		if BubbleViewportHook then BubbleViewportHook() end
	end

	local ViewportConnection
	local function BindCamera()
		if ViewportConnection then
			Creator.DisconnectSignal(ViewportConnection)
			ViewportConnection = nil
		end
		Camera = Workspace.CurrentCamera
		if Camera then
			ViewportConnection = Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), FitToViewport, Window.Root)
			FitToViewport()
		end
	end
	Creator.AddSignal(Workspace:GetPropertyChangedSignal("CurrentCamera"), BindCamera, Window.Root)
	BindCamera()

	Creator.AddSignal(Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, Window.TabHolder.UIListLayout.AbsoluteContentSize.Y)
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if
			type(Library.MinimizeKeybind) == "table"
			and Library.MinimizeKeybind.Type == "Keybind"
			and not UserInputService:GetFocusedTextBox()
		then
			if Input.KeyCode.Name == Library.MinimizeKeybind.Value then
				Window:ToggleHidden()
			end
		elseif Input.KeyCode == Library.MinimizeKey and not UserInputService:GetFocusedTextBox() then
			Window:ToggleHidden()
		end
	end, Window.Root)

	-- Floating round "D" bubble shown while the window is minimized: docked at the left edge,
	-- at 25% of the screen height, and clickable to restore the window.
	local BUBBLE_SIZE = 56
	local BUBBLE_MARGIN = 0 -- leftmost edge of the screen
	local BUBBLE_DOCK_Y = 0.25 -- docked vertical centre, as a fraction of the screen height (from the top)

	local function ResolveIcon(Icon)
		-- Hanya sumber yang bisa dimuat langsung oleh ImageLabel. URL biasa ditangani FetchIcon.
		if type(Icon) == "number" then
			return "rbxassetid://" .. Icon
		end
		if type(Icon) ~= "string" or Icon == "" then
			return nil
		end
		if Icon:match("^rbxassetid://") or Icon:match("^rbxasset://") or Icon:match("^rbxthumb://") or Icon:match("roblox%.com/asset") then
			return Icon
		end
		if tonumber(Icon) then
			return "rbxassetid://" .. Icon
		end
		if Icon:match("^https?://") then
			return nil
		end
		local AssetFn = getcustomasset or getsynasset
		if type(AssetFn) == "function" then
			local ok, asset = pcall(AssetFn, Icon)
			if ok and type(asset) == "string" and asset ~= "" then
				return asset
			end
		end
		return nil
	end

	-- Unduh PNG dari URL (mis. GitHub) sekali, simpan di workspace executor, lalu pakai file lokalnya.
	local PNG_SIGNATURE = "\137PNG\r\n\26\n"
	local ICON_FOLDER = "DimensiUI"

	local function HashText(Text)
		local h = 5381
		for i = 1, #Text do
			h = (h * 33 + Text:byte(i)) % 4294967296
		end
		return string.format("%08x", h)
	end

	local function FetchIcon(Url)
		-- Halaman github.com/.../blob/... diubah ke link raw supaya yang terunduh gambarnya, bukan HTML.
		local User, Repo, Rest = Url:match("^https?://github%.com/([^/]+)/([^/]+)/blob/(.+)$")
		if User then
			Url = ("https://raw.githubusercontent.com/%s/%s/%s"):format(User, Repo, (Rest:gsub("%?.*$", "")))
		end

		if type(writefile) ~= "function" or type(getcustomasset or getsynasset) ~= "function" then
			return nil, "executor tidak mendukung writefile/getcustomasset"
		end

		local Path = ("%s/icon_%s.png"):format(ICON_FOLDER, HashText(Url))
		pcall(function()
			if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(ICON_FOLDER) then
				makefolder(ICON_FOLDER)
			end
		end)

		-- Cache: pakai file yang sudah ada kalau isinya memang PNG.
		if type(isfile) == "function" and isfile(Path) then
			if type(readfile) ~= "function" then return Path end
			local okRead, Cached = pcall(readfile, Path)
			if okRead and type(Cached) == "string" and Cached:sub(1, 8) == PNG_SIGNATURE then
				return Path
			end
		end

		local Body
		local okGet, Res = pcall(function() return game:HttpGet(Url) end)
		if okGet and type(Res) == "string" then
			Body = Res
		end
		if not Body then
			local Req = (syn and syn.request) or http_request or request
			if type(Req) == "function" then
				local okReq, Resp = pcall(Req, { Url = Url, Method = "GET" })
				if okReq and type(Resp) == "table" and Resp.StatusCode == 200 and type(Resp.Body) == "string" then
					Body = Resp.Body
				end
			end
		end
		if not Body then
			return nil, "unduhan gagal (cek URL dan apakah repo publik)"
		end
		if Body:sub(1, 8) ~= PNG_SIGNATURE then
			return nil, "isi unduhan bukan file PNG (pakai link raw, bukan halaman /blob/)"
		end
		if not pcall(writefile, Path, Body) then
			return nil, "writefile gagal"
		end
		return Path
	end

	local BubbleIcon = New("ImageLabel", {
		Name = "Icon",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = "",
		ScaleType = Enum.ScaleType.Fit,
		Visible = false,
	}, {
		New("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})

	local BubbleLetter = New("TextLabel", {
		Name = "Letter",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "D",
		FontFace = Typography.Bold,
		TextSize = 28,
		ThemeTag = { TextColor3 = "Accent" },
	})

	local BubbleStroke = New("UIStroke", {
		Thickness = 2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		ThemeTag = { Color = "Accent" },
	})

	local BubbleScale = New("UIScale", { Scale = 1 })

	Window.Bubble = New("TextButton", {
		Name = "MinimizedBubble",
		Size = UDim2.fromOffset(BUBBLE_SIZE, BUBBLE_SIZE),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, BUBBLE_MARGIN + BUBBLE_SIZE / 2, 0.5, 0),
		Visible = false,
		Active = true,
		ZIndex = 100,
		Text = "",
		AutoButtonColor = false,
		Parent = Config.Parent,
		ThemeTag = { BackgroundColor3 = "WindowBackground" },
	}, {
		New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		BubbleStroke,
		BubbleScale,
		BubbleIcon,
		BubbleLetter,
	})

	local IconToken = 0
	Window.IconStatus = "huruf D"

	local function ShowLetter()
		BubbleIcon.Visible = false
		BubbleLetter.Visible = true
	end

	local function ReportIconProblem(Message)
		warn("[DimensiUI] Icon: " .. Message)
		task.defer(function()
			pcall(function()
				Library:Notify({ Title = "DimensiUI", Content = "Icon: " .. Message, Duration = 10 })
			end)
		end)
	end

	-- Logo "D" bawaan: PNG tertanam di library, ditulis sekali ke workspace executor.
	local function LoadEmbeddedIcon()
		local AssetFn = getcustomasset or getsynasset
		if type(writefile) ~= "function" or type(AssetFn) ~= "function" then
			return nil, "executor tidak mendukung writefile/getcustomasset"
		end
		local Path = ("%s/bubble_%d_%s.png"):format(ICON_FOLDER, #BubbleIconData, HashText(BubbleIconData))
		pcall(function()
			if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(ICON_FOLDER) then
				makefolder(ICON_FOLDER)
			end
		end)
		local NeedWrite = true
		if type(isfile) == "function" and type(readfile) == "function" and isfile(Path) then
			local okRead, Cached = pcall(readfile, Path)
			if okRead and Cached == BubbleIconData then
				NeedWrite = false
			end
		end
		if NeedWrite and not pcall(writefile, Path, BubbleIconData) then
			return nil, "writefile gagal"
		end
		local ok, Asset = pcall(AssetFn, Path)
		if ok and type(Asset) == "string" and Asset ~= "" then
			return Asset
		end
		return nil, "getcustomasset gagal"
	end

	local function ApplyIcon(Resolved, Label, OnFail)
		BubbleIcon.Image = Resolved
		BubbleIcon.Visible = true
		BubbleLetter.Visible = false
		Window.IconStatus = Label .. ": " .. tostring(Resolved)
		-- File lokal (rbxasset://) langsung dipercaya. Hanya asset Roblox yang dicek; kalau gagal
		-- (id salah / Decal / belum lolos moderasi) panggil OnFail.
		if not tostring(Resolved):match("^rbxasset://") then
			task.spawn(function()
				pcall(function()
					ContentProvider:PreloadAsync({ BubbleIcon }, function(_, status)
						if status ~= Enum.AssetFetchStatus.Success and BubbleIcon.Parent and BubbleIcon.Image == Resolved then
							OnFail("gambar gagal dimuat (" .. tostring(status) .. "): " .. tostring(Resolved))
						end
					end)
				end)
			end)
		end
	end

	local function UseDefaultIcon()
		local Asset, Reason = LoadEmbeddedIcon()
		if Asset then
			ApplyIcon(Asset, "bawaan", function(Message)
				ShowLetter()
				Window.IconStatus = "huruf D (" .. Message .. ")"
			end)
			return true
		end
		ShowLetter()
		Window.IconStatus = "huruf D (logo bawaan tidak bisa dipakai: " .. tostring(Reason) .. ")"
		return false, Reason
	end

	-- Icon: nil = logo bawaan, false = huruf "D", angka/"rbxassetid://ID"/path file/URL = gambar sendiri.
	function Window:SetIcon(Icon)
		IconToken = IconToken + 1
		local Token = IconToken
		ShowLetter()
		BubbleIcon.Image = ""

		if Icon == false then
			Window.IconStatus = "huruf D (Icon = false)"
			return false
		end

		if Icon == nil or Icon == "" then
			local ok, Reason = UseDefaultIcon()
			if not ok then
				warn("[DimensiUI] Logo bawaan tidak bisa dipakai, bubble memakai huruf D: " .. tostring(Reason))
			end
			return ok
		end

		local function Fail(Message)
			if Token ~= IconToken then return end
			ReportIconProblem(Message .. " (memakai logo bawaan)")
			UseDefaultIcon()
		end

		local Resolved = ResolveIcon(Icon)
		if Resolved then
			ApplyIcon(Resolved, "dimuat", Fail)
			return true
		end

		if type(Icon) == "string" and Icon:match("^https?://") then
			-- Async: window tetap langsung muncul dengan logo bawaan sampai gambar dari URL siap.
			UseDefaultIcon()
			Window.IconStatus = "mengunduh: " .. Icon
			task.spawn(function()
				local Path, Reason = FetchIcon(Icon)
				if Token ~= IconToken or not BubbleIcon.Parent then return end
				local Asset
				if Path then
					local ok, result = pcall(getcustomasset or getsynasset, Path)
					if ok and type(result) == "string" and result ~= "" then
						Asset = result
					else
						Reason = "getcustomasset gagal untuk " .. tostring(Path)
					end
				end
				if Asset then
					ApplyIcon(Asset, "dimuat dari URL", Fail)
				else
					Fail(tostring(Reason))
				end
			end)
			return true
		end

		Fail("bukan asset id, URL, atau file executor yang valid: " .. tostring(Icon))
		return false
	end

	Window:SetIcon(Config.Icon)

	-- Bubble placement. X is the pixel offset of the bubble's left edge; Y is a pixel offset from the
	-- vertical centre of the GUI area. The bubble is anchored at its own centre, so Y = 0 is centred
	-- and the pop / hover scale grows symmetrically around the logo.
	local BubbleDocked = true
	local BubbleX, BubbleY = BUBBLE_MARGIN, 0
	local BubbleShown = false
	local BubbleToken = 0
	local BubbleHovering = false
	local BubbleMoveTween
	local BubbleDragging, BubbleMoved, BubbleStart = false, false, nil
	local BubbleOriginX, BubbleOriginY = 0, 0

	local BubbleShowInfo = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local BubbleFadeInInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local BubbleHideInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	local BubbleHoverInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local BubblePressInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local function BubblePosition(X, Y)
		return UDim2.new(0, X + BUBBLE_SIZE / 2, 0.5, Y)
	end

	-- Width and height of the GUI area plus the top inset that the ScreenGui reserves (if any).
	local function GetGuiArea()
		Camera = Workspace.CurrentCamera or Camera
		local view = Camera and Camera.ViewportSize or Vector2.new(800, 600)
		local inset = 0
		local Gui = Window.Bubble:FindFirstAncestorOfClass("ScreenGui")
		if Gui and not Gui.IgnoreGuiInset then
			local ok, value = pcall(function()
				return GuiService:GetGuiInset()
			end)
			if ok and typeof(value) == "Vector2" then
				inset = value.Y
			end
		end
		return view.X, math.max(BUBBLE_SIZE, view.Y - inset), inset
	end

	-- Docked: leftmost edge, vertical centre at BUBBLE_DOCK_Y of the full screen height (the GUI area is
	-- the screen minus the top inset, so the inset is folded in). Dragged: keep the chosen spot, on screen.
	local function ResolveBubbleCoords()
		local width, height, inset = GetGuiArea()
		if BubbleDocked then
			BubbleX, BubbleY = BUBBLE_MARGIN, -(height + inset) * BUBBLE_DOCK_Y - inset / 2
		end
		local limitY = math.max(0, (height - BUBBLE_SIZE) / 2)
		BubbleX = math.clamp(BubbleX, 0, math.max(0, width - BUBBLE_SIZE))
		BubbleY = math.clamp(BubbleY, -limitY, limitY)
	end

	local function PlayBubbleTween(Object, Info, Goal)
		local Tween = TweenService:Create(Object, Info, Goal)
		Tween:Play()
		return Tween
	end

	local function SetBubbleFade(Alpha)
		Window.Bubble.BackgroundTransparency = Alpha
		BubbleStroke.Transparency = Alpha
		BubbleIcon.ImageTransparency = Alpha
		BubbleLetter.TextTransparency = Alpha
	end

	local function TweenBubbleFade(Info, Alpha)
		PlayBubbleTween(Window.Bubble, Info, { BackgroundTransparency = Alpha })
		PlayBubbleTween(BubbleStroke, Info, { Transparency = Alpha })
		PlayBubbleTween(BubbleIcon, Info, { ImageTransparency = Alpha })
		PlayBubbleTween(BubbleLetter, Info, { TextTransparency = Alpha })
	end

	-- Show or hide the bubble with a short slide / scale / fade. A token discards stale hide callbacks
	-- so rapid minimize / restore / hide-key presses can never leave the bubble in the wrong state.
	local function SetBubbleShown(Show)
		local Bubble = Window.Bubble
		if not Bubble or not Bubble.Parent then return end
		if Show == BubbleShown then return end
		BubbleShown = Show
		BubbleToken += 1
		local Token = BubbleToken
		if BubbleMoveTween then
			BubbleMoveTween:Cancel()
			BubbleMoveTween = nil
		end

		if Show then
			ResolveBubbleCoords()
			Bubble.Visible = true
			Bubble.Position = BubblePosition(BubbleDocked and -BUBBLE_SIZE or (BubbleX - 18), BubbleY)
			BubbleScale.Scale = 0.5
			BubbleStroke.Thickness = 2
			SetBubbleFade(1)
			BubbleMoveTween = PlayBubbleTween(Bubble, BubbleShowInfo, { Position = BubblePosition(BubbleX, BubbleY) })
			PlayBubbleTween(BubbleScale, BubbleShowInfo, { Scale = 1 })
			TweenBubbleFade(BubbleFadeInInfo, 0)
		else
			BubbleMoveTween = PlayBubbleTween(Bubble, BubbleHideInfo, { Position = BubblePosition(BubbleX - 14, BubbleY) })
			PlayBubbleTween(BubbleScale, BubbleHideInfo, { Scale = 0.6 })
			TweenBubbleFade(BubbleHideInfo, 1)
			task.delay(BubbleHideInfo.Time + 0.03, function()
				if Token == BubbleToken and Bubble.Parent then
					Bubble.Visible = false
				end
			end)
		end
	end

	local function SetBubbleHover(Hovering)
		BubbleHovering = Hovering
		if not BubbleShown or BubbleDragging then return end
		PlayBubbleTween(BubbleScale, BubbleHoverInfo, { Scale = Hovering and 1.08 or 1 })
		PlayBubbleTween(BubbleStroke, BubbleHoverInfo, { Thickness = Hovering and 3 or 2 })
	end

	BubbleViewportHook = function()
		if not BubbleShown or not Window.Bubble.Parent then return end
		if BubbleMoveTween then
			BubbleMoveTween:Cancel()
			BubbleMoveTween = nil
		end
		ResolveBubbleCoords()
		Window.Bubble.Position = BubblePosition(BubbleX, BubbleY)
	end

	local function ApplyVisibility()
		local ShowWindow = not Window.Hidden and not Window.Collapsed
		Window.Root.Visible = ShowWindow
		SetBubbleShown(not Window.Hidden and Window.Collapsed)
		Window.Minimized = Window.Collapsed
		if not ShowWindow then
			for _, frame in ipairs(Library.OpenFrames) do
				if frame and frame.Parent then frame.Visible = false end
			end
		end
	end

	-- Title-bar minimize button: collapse into the bubble (or restore from it).
	function Window:SetCollapsed(Collapsed)
		Collapsed = not not Collapsed
		if Window.Collapsed == Collapsed then return false end
		Window.Collapsed = Collapsed
		if Collapsed then
			-- Every minimize docks the bubble back at the left edge, vertically centered.
			BubbleDocked = true
		end
		ApplyVisibility()
		return true
	end

	function Window:Minimize()
		return Window:SetCollapsed(not Window.Collapsed)
	end

	-- Hotkey: hide everything (window and bubble) or bring back what was showing.
	function Window:ToggleHidden()
		Window.Hidden = not Window.Hidden
		ApplyVisibility()
		if Window.Hidden and not MinimizeNotif then
			MinimizeNotif = true
			local Key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey.Name
			Library:Notify({
				Title = "Interface",
				Content = "Press " .. Key .. " to show the interface again.",
				Duration = 6,
			})
		end
	end

	-- Bubble input: hover and press feedback, click restores, drag moves.
	Creator.AddSignal(Window.Bubble.MouseEnter, function()
		SetBubbleHover(true)
	end, Window.Bubble)

	Creator.AddSignal(Window.Bubble.MouseLeave, function()
		SetBubbleHover(false)
	end, Window.Bubble)

	Creator.AddSignal(Window.Bubble.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			BubbleDragging = true
			BubbleMoved = false
			BubbleStart = Input.Position
			BubbleOriginX, BubbleOriginY = BubbleX, BubbleY
			if BubbleMoveTween then
				BubbleMoveTween:Cancel()
				BubbleMoveTween = nil
			end
			PlayBubbleTween(BubbleScale, BubblePressInfo, { Scale = 0.92 })
		end
	end, Window.Bubble)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if not BubbleDragging then return end
		if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
		local Delta = Input.Position - BubbleStart
		if not BubbleMoved and Delta.Magnitude < 5 then return end
		if not BubbleMoved then
			BubbleMoved = true
			BubbleDocked = false
			PlayBubbleTween(BubbleScale, BubblePressInfo, { Scale = 1.06 })
		end
		BubbleX, BubbleY = BubbleOriginX + Delta.X, BubbleOriginY + Delta.Y
		ResolveBubbleCoords()
		Window.Bubble.Position = BubblePosition(BubbleX, BubbleY)
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if not BubbleDragging then return end
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			BubbleDragging = false
			if not BubbleMoved and not Window.Hidden then
				Window:SetCollapsed(false)
			elseif BubbleShown then
				PlayBubbleTween(BubbleScale, BubbleHoverInfo, { Scale = BubbleHovering and 1.08 or 1 })
			end
		end
	end, Window.Root)

	function Window:Destroy()
		for index = #Library.OpenFrames, 1, -1 do
			local frame = Library.OpenFrames[index]
			if frame and frame.Parent then pcall(function() frame:Destroy() end) end
			table.remove(Library.OpenFrames, index)
		end
		if Window.Bubble then Window.Bubble:Destroy() end
		if Window.Root then Window.Root:Destroy() end
	end

	local DialogModule = require(Components.Dialog):Init(Window)
	function Window:Dialog(Config)
		assert(type(Config) == "table" and type(Config.Title) == "string" and type(Config.Content) == "string", "Window:Dialog requires Title and Content strings")
		Config.Buttons = Config.Buttons or {}
		assert(type(Config.Buttons) == "table", "Window:Dialog Buttons must be a table")
		for Index, Button in ipairs(Config.Buttons) do
			assert(type(Button) == "table" and type(Button.Title) == "string" and Button.Title ~= "", "Window:Dialog button #" .. Index .. " requires a title")
			assert(Button.Callback == nil or type(Button.Callback) == "function", "Window:Dialog button callback must be a function")
		end
		if require(Root).Unloaded then return nil end
		local Dialog = DialogModule:Create()
		Dialog.Title.Text = Config.Title

		local Content = New("TextLabel", {
			FontFace = Typography.Regular,
			Text = Config.Content,
			TextColor3 = Color3.fromRGB(150, 158, 172),
			TextSize = 13,
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
				TextColor3 = "SubText",
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
		assert(TabConfig.Description == nil or type(TabConfig.Description) == "string", "Window:AddTab Description must be a string")
		return TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder, TabConfig.Description)
	end

	function Window:SelectTab(Tab)
		local Index = type(Tab) == "table" and Tab.Index or Tab
		return TabModule:SelectTab(Index)
	end

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
		Position = UDim2.new(1, -12, 0.5, 0),
		BackgroundTransparency = 1,
		Parent = ButtonFrame.Frame,
		ThemeTag = {
			ImageColor3 = "SubText",
		},
	})
	ButtonFrame.LabelHolder.Size = UDim2.new(1, -56, 0, 0)

	Creator.AddSignal(ButtonFrame.Frame.MouseButton1Click, function()
		self.Library:SafeCallback(Config.Callback)
	end, ButtonFrame.Frame)

	return ButtonFrame
end

return Element
end

__DimensiModules['Elements/Colorpicker'] = function(script, require)
local UserInputService = game:GetService("UserInputService")
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

	ColorpickerFrame.LabelHolder.Size = UDim2.new(1, -66, 0, 0)
	Colorpicker.SetTitle = ColorpickerFrame.SetTitle
	Colorpicker.SetDesc = ColorpickerFrame.SetDesc

	local DisplayFrameColor = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Colorpicker.Value,
		Parent = ColorpickerFrame.Frame,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
	})

	local DisplayFrame = New("ImageLabel", {
		Size = UDim2.fromOffset(28, 28),
		Position = UDim2.new(1, -12, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Parent = ColorpickerFrame.Frame,
		Image = "https://www.roblox.com/asset/?id=14204231522",
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(40, 40),
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
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
				TextSize = 13,
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
		end, Dialog.Root)

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
		end, Dialog.Root)

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
		end, Dialog.Root)

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
		end, Dialog.Root)

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
			end, Dialog.Root)
		end

		local ActiveDrag = nil
		local ActiveTouch = nil

		local function UpdateDrag(Position)
			if not ActiveDrag or not Dialog.Root.Parent then return end
			if ActiveDrag == "SV" then
				local Min = SatVibMap.AbsolutePosition
				local Size = SatVibMap.AbsoluteSize
				if Size.X <= 0 or Size.Y <= 0 then return end
				Sat = math.clamp((Position.X - Min.X) / Size.X, 0, 1)
				Vib = 1 - math.clamp((Position.Y - Min.Y) / Size.Y, 0, 1)
			elseif ActiveDrag == "Hue" then
				local Min = HueSlider.AbsolutePosition.Y
				local Size = HueSlider.AbsoluteSize.Y
				if Size <= 0 then return end
				Hue = math.clamp((Position.Y - Min) / Size, 0, 1)
			elseif ActiveDrag == "Transparency" then
				local Min = TransparencySlider.AbsolutePosition.Y
				local Size = TransparencySlider.AbsoluteSize.Y
				if Size <= 0 then return end
				Transparency = 1 - math.clamp((Position.Y - Min) / Size, 0, 1)
			end
			Display()
		end

		local function BeginDrag(Kind, Input)
			if Input.UserInputType ~= Enum.UserInputType.MouseButton1
				and Input.UserInputType ~= Enum.UserInputType.Touch then return end
			ActiveDrag = Kind
			ActiveTouch = Input.UserInputType == Enum.UserInputType.Touch and Input or nil
			UpdateDrag(Input.Position)
		end

		Creator.AddSignal(SatVibMap.InputBegan, function(Input) BeginDrag("SV", Input) end, Dialog.Root)
		Creator.AddSignal(HueSlider.InputBegan, function(Input) BeginDrag("Hue", Input) end, Dialog.Root)
		if Config.Transparency then
			Creator.AddSignal(TransparencySlider.InputBegan, function(Input)
				BeginDrag("Transparency", Input)
			end, Dialog.Root)
		end

		Creator.AddSignal(UserInputService.InputChanged, function(Input)
			if not ActiveDrag then return end
			if ActiveTouch then
				if Input == ActiveTouch or Input.UserInputType == Enum.UserInputType.Touch then
					UpdateDrag(Input.Position)
				end
			elseif Input.UserInputType == Enum.UserInputType.MouseMovement then
				UpdateDrag(Input.Position)
			end
		end, Dialog.Root)

		Creator.AddSignal(UserInputService.InputEnded, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1
				or (ActiveTouch and Input == ActiveTouch) then
				ActiveDrag = nil
				ActiveTouch = nil
			end
		end, Dialog.Root)

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
		Library:UnregisterOption(Idx, Colorpicker)
	end

	Creator.AddSignal(ColorpickerFrame.Frame.MouseButton1Click, function()
		CreateColorDialog()
	end, ColorpickerFrame.Frame)

	Colorpicker:Display()

	Library:RegisterOption(Idx, Colorpicker)
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
	DropdownFrame.LabelHolder.Size = UDim2.new(1, -180, 0, 0)
	DropdownFrame.DescLabel.Size = UDim2.new(1, 0, 0, 0)

	Dropdown.SetTitle = DropdownFrame.SetTitle
	Dropdown.SetDesc = DropdownFrame.SetDesc

	local DropdownDisplay = New("TextLabel", {
		FontFace = Typography.Regular,
		Text = "Value",
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 13,
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
		Size = UDim2.fromOffset(132, 30),
		Position = UDim2.new(1, -12, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 0,
		AutoButtonColor = false,
		Text = "",
		Parent = DropdownFrame.Frame,
		ThemeTag = {
			BackgroundColor3 = "Tone",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
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
			CornerRadius = UDim.new(0, 10),
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "DropdownBorder",
			},
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

	Creator.AddSignal(DropdownInner:GetPropertyChangedSignal("AbsolutePosition"), RecalculateListPosition, DropdownFrame.Frame)

	Creator.AddSignal(DropdownInner.MouseButton1Click, function()
		Dropdown:Open()
	end, DropdownFrame.Frame)

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
					CornerRadius = UDim.new(0, 8),
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
			end, Button)
			Creator.AddSignal(Button.MouseLeave, function()
				SetBackTransparency(Selected and 0.89 or 1)
			end, Button)
			Creator.AddSignal(Button.MouseButton1Down, function()
				SetBackTransparency(0.92)
			end, Button)
			Creator.AddSignal(Button.MouseButton1Up, function()
				SetBackTransparency(Selected and 0.85 or 0.89)
			end, Button)

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
			end, Button)

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
		Library:UnregisterOption(Idx, Dropdown)
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

	Library:RegisterOption(Idx, Dropdown)
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
	Textbox.Frame.Position = UDim2.new(1, -12, 0.5, 0)
	Textbox.Frame.AnchorPoint = Vector2.new(1, 0.5)
	Textbox.Frame.Size = UDim2.fromOffset(132, 30)
	InputFrame.LabelHolder.Size = UDim2.new(1, -180, 0, 0)
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
		end, InputFrame.Frame)
	else
		AddSignal(Box:GetPropertyChangedSignal("Text"), function()
			Input:SetValue(Box.Text)
		end, InputFrame.Frame)
	end

	function Input:OnChanged(Func)
		Input.Changed = Func
		Library:SafeCallback(Func, Input.Value)
	end

	function Input:Destroy()
		InputFrame:Destroy()
		Library:UnregisterOption(Idx, Input)
	end

	Library:RegisterOption(Idx, Input)
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

	KeybindFrame.LabelHolder.Size = UDim2.new(1, -180, 0, 0)
	Keybind.SetTitle = KeybindFrame.SetTitle
	Keybind.SetDesc = KeybindFrame.SetDesc

	local KeybindDisplayLabel = New("TextLabel", {
		FontFace = Typography.Regular,
		Text = Config.Default,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(0, 0, 0, 14),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local KeybindDisplayFrame = New("TextButton", {
		Size = UDim2.fromOffset(132, 30),
		Position = UDim2.new(1, -12, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 0,
		AutoButtonColor = false,
		Text = "",
		Parent = KeybindFrame.Frame,
		ThemeTag = {
			BackgroundColor3 = "Tone",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
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
		Library:UnregisterOption(Idx, Keybind)
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
			CaptureConnection = Creator.AddSignal(UserInputService.InputBegan, function(CapturedInput)
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
			end, KeybindFrame.Frame)
		end)
	end, KeybindFrame.Frame)

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
	end, KeybindFrame.Frame)

	Library:RegisterOption(Idx, Keybind)
	return Keybind
end

return Element
end

__DimensiModules['Elements/Paragraph'] = function(script, require)
local Root = script.Parent.Parent
local Components = Root.Components
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
	SliderFrame.LabelHolder.Size = UDim2.new(1, -180, 0, 0)
	SliderFrame.DescLabel.Size = UDim2.new(1, 0, 0, 0)

	Slider.SetTitle = SliderFrame.SetTitle
	Slider.SetDesc = SliderFrame.SetDesc

	local SliderDot = New("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, -7, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 0,
		ThemeTag = {
			BackgroundColor3 = "SliderKnob",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
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
		TextSize = 13,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 32, 0, 14),
		Position = UDim2.new(1, 4, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		ThemeTag = {
			TextColor3 = "SubText",
		},
	})

	local SliderInner = New("Frame", {
		Size = UDim2.new(0, 104, 0, 4),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -48, 0.5, 0),
		BackgroundTransparency = 0,
		Parent = SliderFrame.Frame,
		ThemeTag = {
			BackgroundColor3 = "SliderRail",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
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
	end, SliderFrame.Frame)

	Creator.AddSignal(SliderDot.InputEnded, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = false
		end
	end, SliderFrame.Frame)

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
	end, SliderFrame.Frame)

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
		Dragging = false
		SliderFrame:Destroy()
		Library:UnregisterOption(Idx, Slider)
	end

	Slider:SetValue(Config.Default)

	Library:RegisterOption(Idx, Slider)
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
	ToggleFrame.LabelHolder.Size = UDim2.new(1, -76, 0, 0)
	ToggleFrame.DescLabel.Size = UDim2.new(1, 0, 0, 0)

	Toggle.SetTitle = ToggleFrame.SetTitle
	Toggle.SetDesc = ToggleFrame.SetDesc

	local KNOB_SIZE = 14
	local TRACK_WIDTH = 36
	local TRACK_HEIGHT = 20
	local KNOB_PAD = 3

	local ToggleKnob = New("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromOffset(KNOB_SIZE, KNOB_SIZE),
		Position = UDim2.new(0, KNOB_PAD, 0.5, 0),
		BackgroundTransparency = 0,
		ThemeTag = {
			BackgroundColor3 = "ToggleKnob",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
	})

	local ToggleTrack = New("Frame", {
		Size = UDim2.fromOffset(TRACK_WIDTH, TRACK_HEIGHT),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Parent = ToggleFrame.Frame,
		BackgroundTransparency = 0,
		ThemeTag = {
			BackgroundColor3 = "ToggleOff",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
		ToggleKnob,
	})

	function Toggle:OnChanged(Func)
		Toggle.Changed = Func
		Library:SafeCallback(Func, Toggle.Value)
	end

	function Toggle:SetValue(Value)
		Value = not not Value
		Toggle.Value = Value

		Creator.OverrideTag(ToggleTrack, { BackgroundColor3 = Toggle.Value and "Accent" or "ToggleOff" })
		TweenService:Create(
			ToggleKnob,
			TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Position = UDim2.new(0, Toggle.Value and (TRACK_WIDTH - KNOB_SIZE - KNOB_PAD) or KNOB_PAD, 0.5, 0) }
		):Play()

		Library:SafeCallback(Toggle.Callback, Toggle.Value)
		Library:SafeCallback(Toggle.Changed, Toggle.Value)
	end

	function Toggle:Destroy()
		ToggleFrame:Destroy()
		Library:UnregisterOption(Idx, Toggle)
	end

	Creator.AddSignal(ToggleFrame.Frame.MouseButton1Click, function()
		Toggle:SetValue(not Toggle.Value)
	end, ToggleFrame.Frame)

	Toggle:SetValue(Toggle.Value)

	Library:RegisterOption(Idx, Toggle)
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
    Style = "Midnight",

    -- Brand
    Accent = Color3.fromRGB(139, 120, 246),

    -- Surfaces (separated by tone, not by borders)
    WindowBackground = Color3.fromRGB(16, 20, 31),
    Sidebar = Color3.fromRGB(23, 30, 45),
    Card = Color3.fromRGB(28, 37, 55),
    Tone = Color3.fromRGB(39, 49, 70),
    Divider = Color3.fromRGB(48, 59, 81),

    -- Sidebar tab (selected / hover tint)
    Tab = Color3.fromRGB(48, 55, 82),

    -- Rows are transparent; hover fades the Tone fill in by HoverChange
    ElementTransparency = 1,
    HoverChange = 0.6,

    -- Toggle
    ToggleOff = Color3.fromRGB(66, 77, 101),
    ToggleKnob = Color3.fromRGB(238, 240, 244),

    -- Slider
    SliderRail = Color3.fromRGB(55, 67, 91),
    SliderKnob = Color3.fromRGB(238, 240, 244),

    -- Dropdown popup
    DropdownHolder = Color3.fromRGB(29, 38, 57),
    DropdownBorder = Color3.fromRGB(54, 67, 92),
    DropdownOption = Color3.fromRGB(73, 62, 125),

    -- Dialog
    Dialog = Color3.fromRGB(28, 36, 53),
    DialogHolder = Color3.fromRGB(20, 27, 41),
    DialogHolderLine = Color3.fromRGB(48, 59, 81),
    DialogButton = Color3.fromRGB(44, 55, 78),
    DialogBorder = Color3.fromRGB(48, 59, 81),
    DialogInput = Color3.fromRGB(39, 49, 70),

    -- Text
    Text = Color3.fromRGB(239, 242, 250),
    SubText = Color3.fromRGB(157, 169, 191),

    -- Interaction
    Hover = Color3.fromRGB(174, 160, 255),
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
