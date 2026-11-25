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
		local Button = { Callback = Callback or function() end }
		Button.Frame = New("TextButton", {
			Size = UDim2.fromOffset(30, 30),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Parent = Parent,
			Position = Pos,
			Text = "",
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 7) }),
			New("ImageLabel", {
				Image = Icon, Size = UDim2.fromOffset(15, 15),
				Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1, ThemeTag = { ImageColor3 = "Text" },
			}),
		})
		local _, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")
		AddSignal(Button.Frame.MouseEnter, function() SetTransparency(0.92) end, Button.Frame)
		AddSignal(Button.Frame.MouseLeave, function() SetTransparency(1, true) end, Button.Frame)
		AddSignal(Button.Frame.MouseButton1Click, Button.Callback, Button.Frame)
		return Button.Frame
	end

	TitleBar.Brand = New("Frame", {
		Position = UDim2.fromOffset(20, 0),
		Size = UDim2.new(1, -112, 1, 0),
		BackgroundTransparency = 1,
	}, {
		New("TextLabel", {
			Name = "HeaderTitle", RichText = true, Text = Config.Title,
			FontFace = Typography.SemiBold, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd, Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, ThemeTag = { TextColor3 = "Text" },
		}),
	})

	TitleBar.Frame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1,
		Parent = Config.Parent,
	}, {
		TitleBar.Brand,
		New("Frame", {
			Name = "HeaderDivider", Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0,
			ThemeTag = { BackgroundColor3 = "Divider" },
		}),
	})

	TitleBar.CloseButton = BarButton(Assets.Close, UDim2.new(1, -10, 0, 9), TitleBar.Frame, function()
		Library.Window:Dialog({
			Title = "Close", Content = "Are you sure you want to unload the interface?",
			Buttons = {
				{ Title = "Yes", Callback = function() Library:Destroy() end },
				{ Title = "No" },
			},
		})
	end)
	TitleBar.MinButton = BarButton(Assets.Min, UDim2.new(1, -44, 0, 9), TitleBar.Frame, function()
		Library.Window:Minimize()
	end)
	return TitleBar
end
