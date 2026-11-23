local Root = script.Parent
local Themes = require(Root.Themes)
local Motion = require(Root.Packages.DimensiMotion)

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
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.SourceSans,
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
