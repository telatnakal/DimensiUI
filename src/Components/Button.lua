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
		TextSize = 13,
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
<<<<<<< HEAD
			CornerRadius = UDim.new(0, 8),
=======
			CornerRadius = UDim.new(0, 6),
>>>>>>> 00e015507899790ef9c108a8b3a8e5c2a22a47ed
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
<<<<<<< HEAD
			CornerRadius = UDim.new(0, 8),
=======
			CornerRadius = UDim.new(0, 6),
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = 0,
			ThemeTag = {
				Color = "DialogButtonBorder",
			},
>>>>>>> 00e015507899790ef9c108a8b3a8e5c2a22a47ed
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
