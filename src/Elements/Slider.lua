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
