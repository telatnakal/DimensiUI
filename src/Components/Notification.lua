local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local Acrylic = require(Root.Acrylic)

local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local New = Creator.New

local Notification = {}

function Notification:Init(GUI)
	Notification.Holder = New("Frame", {
		Position = UDim2.new(1, -12, 1, -12),
		Size = UDim2.new(0, math.max(220, math.min(310, workspace.CurrentCamera.ViewportSize.X - 24)), 1, -24),
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
	local Camera = workspace.CurrentCamera
	if Camera then
		Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), function()
			if Notification.Holder and Notification.Holder.Parent then
				Notification.Holder.Size = UDim2.new(0, math.max(220, math.min(310, Camera.ViewportSize.X - 24)), 1, -24)
			end
		end, GUI)
	end
end

function Notification:New(Config)
	assert(type(Config) == "table", "Notification config must be a table")
	assert(Config.Duration == nil or (type(Config.Duration) == "number" and Config.Duration == Config.Duration and Config.Duration >= 0 and math.abs(Config.Duration) < math.huge), "Notification duration must be a finite non-negative number")
	Config.Title = Config.Title or "Title"
	Config.Content = Config.Content or "Content"
	Config.SubContent = Config.SubContent or ""
	Config.Duration = Config.Duration or nil
	Config.Buttons = Config.Buttons or {}
	assert(type(Config.Title) == "string" and type(Config.Content) == "string" and type(Config.SubContent) == "string", "Notification text must be strings")
	local NewNotification = {
		Closed = false,
	}

	NewNotification.AcrylicPaint = Acrylic.AcrylicPaint()

	NewNotification.Title = New("TextLabel", {
		Position = UDim2.new(0, 14, 0, 17),
		Text = Config.Title,
		RichText = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextTransparency = 0,
		FontFace = Typography.Regular,
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
			TextColor3 = "Text",
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

	NewNotification.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(1, 0),
	}, {
		NewNotification.AcrylicPaint.Frame,
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

	local RootMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		Scale = 1,
		Offset = 60,
	}), NewNotification.Holder)

	RootMotor:onStep(function(Values)
		NewNotification.Root.Position = UDim2.new(Values.Scale, Values.Offset, 0, 0)
	end)

	Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function()
		NewNotification:Close()
	end)

	function NewNotification:Open()
		local ContentSize = NewNotification.LabelHolder.AbsoluteSize.Y
		NewNotification.Holder.Size = UDim2.new(1, 0, 0, 58 + ContentSize)

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
			if require(Root).UseAcrylic then
				local Paint = NewNotification.AcrylicPaint
				if Paint and Paint.Model then pcall(function() Paint.Model:Destroy() end) end
			end
			if NewNotification.Holder and NewNotification.Holder.Parent then
				NewNotification.Holder:Destroy()
			end
		end)
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
