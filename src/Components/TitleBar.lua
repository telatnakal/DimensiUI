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
			Text = Config.Title,
			FontFace = Typography.SemiBold,
			TextSize = 14,
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
			TextSize = 11,
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
