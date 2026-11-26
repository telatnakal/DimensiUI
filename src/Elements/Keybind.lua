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
		TextColor3 = Color3.fromRGB(239, 242, 250),
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
