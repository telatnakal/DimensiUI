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
<<<<<<< HEAD
	ToggleFrame.LabelHolder.Size = UDim2.new(1, -76, 0, 0)
=======
	ToggleFrame.LabelHolder.Size = UDim2.new(1, -70, 0, 0)
>>>>>>> 00e015507899790ef9c108a8b3a8e5c2a22a47ed
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
