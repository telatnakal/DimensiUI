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

	local BrandName = (Config.Brand or "DIMENSI-HUB"):upper()
	local MapName = (game.Name and game.Name ~= "" and game.Name or "ROBLOX EXPERIENCE"):upper()

	TitleBar.Brand = New("Frame", {
		Position = UDim2.fromOffset(24, 0),
		Size = UDim2.new(1, -116, 1, 0),
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		New("TextLabel", {
			Text = BrandName,
			FontFace = Typography.SemiBold,
			TextSize = 14,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 24),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ThemeTag = { TextColor3 = "Text" },
		}),
		New("TextLabel", {
			Text = "|",
			FontFace = Typography.Regular,
			TextSize = 14,
			Size = UDim2.fromOffset(8, 24),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ThemeTag = { TextColor3 = "Accent" },
		}),
		New("TextLabel", {
			Text = MapName,
			FontFace = Typography.Medium,
			TextSize = 12,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			TextTruncate = Enum.TextTruncate.AtEnd,
			Size = UDim2.new(1, -150, 0, 24),
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			ThemeTag = { TextColor3 = "Accent" },
		}),
	})

	TitleBar.Frame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundColor3 = Color3.fromRGB(16, 14, 23),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Parent = Config.Parent,
		ThemeTag = { BackgroundColor3 = "WindowBackground" },
	}, {
		TitleBar.Brand,
		New("Frame", {
			Name = "HeaderDivider",
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1),
			BorderSizePixel = 0,
			ThemeTag = { BackgroundColor3 = "Divider" },
		}),
	})

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
