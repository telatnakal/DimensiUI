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
	Textbox.Frame.Size = UDim2.fromOffset(136, 34)
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
