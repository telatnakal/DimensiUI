-- i will rewrite this someday
local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local Surface = require(Root.Surface)
local Assets = require(script.Parent.Assets)
local Components = script.Parent

local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local New = Creator.New

return function(Config)
	local Library = require(Root)

	local function getBounds()
		Camera = Workspace.CurrentCamera or Camera
		local viewport = Camera and Camera.ViewportSize or Vector2.new(800, 600)
		local mobile = viewport.X < 600
		local minWidth = math.min(mobile and 300 or 420, math.max(260, viewport.X - 24))
		local minHeight = math.min(mobile and 280 or 340, math.max(240, viewport.Y - 24))
		return viewport, minWidth, minHeight, math.max(minWidth, viewport.X - 24), math.max(minHeight, viewport.Y - 24), mobile
	end

	local viewport, minWidth, minHeight, maxWidth, maxHeight, mobile = getBounds()
	local initialWidth = math.clamp(Config.Size.X.Offset, minWidth, maxWidth)
	local initialHeight = math.clamp(Config.Size.Y.Offset, minHeight, maxHeight)
	local initialTabWidth = mobile and math.clamp(Config.TabWidth, 92, 108) or math.clamp(Config.TabWidth, 120, 220)

	local Window = {
		Minimized = false,
		Size = UDim2.fromOffset(initialWidth, initialHeight),
		TabWidth = initialTabWidth,
		ContentTop = 72,
		CurrentPos = 0,
		Position = UDim2.fromOffset(
			math.max(12, viewport.X / 2 - initialWidth / 2),
			math.max(12, viewport.Y / 2 - initialHeight / 2)
		),
	}

	local Dragging, DragInput, MousePos, StartPos = false
	local Resizing, ResizePos = false
	local DragEndConnection
	local MinimizeNotif = false

	Window.Surface = Surface()

	local ResizeStartFrame = New("Frame", {
		Size = UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -28, 1, -28),
	})

	Window.TabHolder = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ScrollBarImageTransparency = 1,
		ScrollBarThickness = 0,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 4),
		}),
	})

	Window.Sidebar = New("Frame", {
		Size = UDim2.new(0, Window.TabWidth + 24, 1, -56),
		Position = UDim2.fromOffset(0, 56),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ThemeTag = {
			BackgroundColor3 = "Sidebar",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 12),
		}),
		-- Squares off the sidebar's right-hand corners so only the window's left corners stay round.
		New("Frame", {
			Name = "Patch",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, 14, 1, 0),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ThemeTag = {
				BackgroundColor3 = "Sidebar",
			},
		}),
	})

	local TabFrame = New("Frame", {
		Size = UDim2.new(0, Window.TabWidth, 1, -84),
		Position = UDim2.new(0, 12, 0, 72),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	}, {
		Window.TabHolder,
	})


	Window.ContainerHolder = New("CanvasGroup", {
		Size = UDim2.new(1, -(Window.TabWidth + 64), 1, -(Window.ContentTop + 16)),
		Position = UDim2.fromOffset(Window.TabWidth + 40, Window.ContentTop),
		BackgroundTransparency = 1,
	})

	Window.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = Window.Size,
		Position = Window.Position,
		Parent = Config.Parent,
		Active = true,
	}, {
		Window.Surface.Frame,
		Window.Sidebar,
		Window.ContainerHolder,
		TabFrame,
		ResizeStartFrame,
	})

	Window.TitleBar = require(script.Parent.TitleBar)({
		Title = Config.Title,
		SubTitle = Config.SubTitle,
		Brand = Config.Brand,
		Parent = Window.Root,
		Window = Window,
	})

	-- The tab list starts below the brand block, which grows when a long title wraps.
	local function LayoutSidebar()
		local Brand = Window.TitleBar.Brand
		local Top = 72
		TabFrame.Position = UDim2.fromOffset(12, Top)
		TabFrame.Size = UDim2.new(0, Window.TabWidth, 1, -(Top + 12))
	end
	Creator.AddSignal(Window.TitleBar.Brand:GetPropertyChangedSignal("AbsoluteSize"), LayoutSidebar, Window.Root)

	local SizeMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		X = Window.Size.X.Offset,
		Y = Window.Size.Y.Offset,
	}), Window.Root)

	local PosMotor = Creator.TrackMotor(Motion.GroupMotor.new({
		X = Window.Position.X.Offset,
		Y = Window.Position.Y.Offset,
	}), Window.Root)

	Window.ContainerBackMotor = Creator.TrackMotor(Motion.SingleMotor.new(0), Window.Root)
	Window.ContainerPosMotor = Creator.TrackMotor(Motion.SingleMotor.new(Window.ContentTop), Window.Root)

	SizeMotor:onStep(function(values)
		Window.Root.Size = UDim2.new(0, values.X, 0, values.Y)
	end)

	PosMotor:onStep(function(values)
		Window.Root.Position = UDim2.new(0, values.X, 0, values.Y)
	end)

	Window.ContainerBackMotor:onStep(function(Value)
		Window.ContainerHolder.GroupTransparency = Value
	end)

	Window.ContainerPosMotor:onStep(function(Value)
		Window.ContainerHolder.Position = UDim2.fromOffset(Window.TabWidth + 40, Value)
	end)

	Creator.AddSignal(Window.TitleBar.Frame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = true
			MousePos = Input.Position
			StartPos = Window.Root.Position

			if DragEndConnection then
				Creator.DisconnectSignal(DragEndConnection)
			end
			DragEndConnection = Creator.AddSignal(Input.Changed, function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
					if DragEndConnection then
						Creator.DisconnectSignal(DragEndConnection)
						DragEndConnection = nil
					end
				end
			end, Window.Root)
		end
	end, Window.Root)

	Creator.AddSignal(Window.TitleBar.Frame.InputChanged, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			DragInput = Input
		end
	end, Window.Root)

	Creator.AddSignal(ResizeStartFrame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Resizing = true
			ResizePos = Input.Position
		end
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - MousePos
			local view = Camera.ViewportSize
			local x = math.clamp(StartPos.X.Offset + Delta.X, 0, math.max(0, view.X - Window.Size.X.Offset))
			local y = math.clamp(StartPos.Y.Offset + Delta.Y, 0, math.max(0, view.Y - Window.Size.Y.Offset))
			Window.Position = UDim2.fromOffset(x, y)
			PosMotor:setGoal({
				X = Instant(Window.Position.X.Offset),
				Y = Instant(Window.Position.Y.Offset),
			})

		end

		if
			(Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
			and Resizing
		then
			local Delta = Input.Position - ResizePos
			local StartSize = Window.Size

			local TargetSize = Vector3.new(StartSize.X.Offset, StartSize.Y.Offset, 0) + Vector3.new(1, 1, 0) * Delta
			local _, minW, minH, maxW, maxH = getBounds()
			local viewport = Camera.ViewportSize
			maxW = math.max(minW, math.min(maxW, viewport.X - Window.Position.X.Offset - 12))
			maxH = math.max(minH, math.min(maxH, viewport.Y - Window.Position.Y.Offset - 12))
			local TargetSizeClamped = Vector2.new(
				math.clamp(TargetSize.X, minW, maxW),
				math.clamp(TargetSize.Y, minH, maxH)
			)

			SizeMotor:setGoal({
				X = Motion.Instant.new(TargetSizeClamped.X),
				Y = Motion.Instant.new(TargetSizeClamped.Y),
			})
		end
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if Resizing == true or Input.UserInputType == Enum.UserInputType.Touch then
			Resizing = false
			Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
		end
	end, Window.Root)

	local function FitToViewport()
		if not Window.Root or not Window.Root.Parent then return end
		local view, minW, minH, maxW, maxH, isMobile = getBounds()
		local width = math.clamp(Window.Size.X.Offset, minW, maxW)
		local height = math.clamp(Window.Size.Y.Offset, minH, maxH)
		local x = math.clamp(Window.Position.X.Offset, 0, math.max(0, view.X - width))
		local y = math.clamp(Window.Position.Y.Offset, 0, math.max(0, view.Y - height))
		Window.Size = UDim2.fromOffset(width, height)
		Window.Position = UDim2.fromOffset(x, y)
		Window.TabWidth = isMobile and math.clamp(Window.TabWidth, 92, 108) or math.clamp(Window.TabWidth, 120, 220)
		SizeMotor:setGoal({ X = Instant(width), Y = Instant(height) })
		PosMotor:setGoal({ X = Instant(x), Y = Instant(y) })
		Window.Sidebar.Size = UDim2.new(0, Window.TabWidth + 24, 1, -56)
		Window.Sidebar.Position = UDim2.fromOffset(0, 56)
		Window.TitleBar.Brand.Size = UDim2.new(1, -116, 1, 0)
		LayoutSidebar()
		Window.ContainerHolder.Size = UDim2.new(1, -(Window.TabWidth + 64), 1, -(Window.ContentTop + 16))
		Window.ContainerHolder.Position = UDim2.fromOffset(Window.TabWidth + 40, Window.ContentTop)
	end

	local ViewportConnection
	local function BindCamera()
		if ViewportConnection then
			Creator.DisconnectSignal(ViewportConnection)
			ViewportConnection = nil
		end
		Camera = Workspace.CurrentCamera
		if Camera then
			ViewportConnection = Creator.AddSignal(Camera:GetPropertyChangedSignal("ViewportSize"), FitToViewport, Window.Root)
			FitToViewport()
		end
	end
	Creator.AddSignal(Workspace:GetPropertyChangedSignal("CurrentCamera"), BindCamera, Window.Root)
	BindCamera()

	Creator.AddSignal(Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, Window.TabHolder.UIListLayout.AbsoluteContentSize.Y)
	end, Window.Root)

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if
			type(Library.MinimizeKeybind) == "table"
			and Library.MinimizeKeybind.Type == "Keybind"
			and not UserInputService:GetFocusedTextBox()
		then
			if Input.KeyCode.Name == Library.MinimizeKeybind.Value then
				Window:Minimize()
			end
		elseif Input.KeyCode == Library.MinimizeKey and not UserInputService:GetFocusedTextBox() then
			Window:Minimize()
		end
	end, Window.Root)

	function Window:Minimize()
		Window.Minimized = not Window.Minimized
		Window.Root.Visible = not Window.Minimized
		if not MinimizeNotif then
			MinimizeNotif = true
			local Key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey.Name
			Library:Notify({
				Title = "Interface",
				Content = "Press " .. Key .. " to toggle the interface.",
				Duration = 6
			})
		end
	end

	function Window:Destroy()
		for index = #Library.OpenFrames, 1, -1 do
			local frame = Library.OpenFrames[index]
			if frame and frame.Parent then pcall(function() frame:Destroy() end) end
			table.remove(Library.OpenFrames, index)
		end
		if Window.Root then Window.Root:Destroy() end
	end

	local DialogModule = require(Components.Dialog):Init(Window)
	function Window:Dialog(Config)
		assert(type(Config) == "table" and type(Config.Title) == "string" and type(Config.Content) == "string", "Window:Dialog requires Title and Content strings")
		Config.Buttons = Config.Buttons or {}
		assert(type(Config.Buttons) == "table", "Window:Dialog Buttons must be a table")
		for Index, Button in ipairs(Config.Buttons) do
			assert(type(Button) == "table" and type(Button.Title) == "string" and Button.Title ~= "", "Window:Dialog button #" .. Index .. " requires a title")
			assert(Button.Callback == nil or type(Button.Callback) == "function", "Window:Dialog button callback must be a function")
		end
		if require(Root).Unloaded then return nil end
		local Dialog = DialogModule:Create()
		Dialog.Title.Text = Config.Title

		local Content = New("TextLabel", {
			FontFace = Typography.Regular,
			Text = Config.Content,
			TextColor3 = Color3.fromRGB(150, 158, 172),
			TextSize = 13,
			TextWrapped = true,
			LineHeight = 1.12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, -40, 1, 0),
			Position = UDim2.fromOffset(20, 60),
			BackgroundTransparency = 1,
			Parent = Dialog.Root,
			ClipsDescendants = false,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		New("UISizeConstraint", {
			MinSize = Vector2.new(220, 150),
			MaxSize = Vector2.new(620, math.huge),
			Parent = Dialog.Root,
		})

		Dialog.Root.Size = UDim2.fromOffset(Content.TextBounds.X + 40, 165)
		if Content.TextBounds.X + 40 > Window.Size.X.Offset - 120 then
			Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, 165)
			Content.TextWrapped = true
			Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, Content.TextBounds.Y + 150)
		end

		for _, Button in next, Config.Buttons do
			Dialog:Button(Button.Title, Button.Callback)
		end

		Dialog:Open()
	end

	local TabModule = require(Components.Tab):Init(Window)
	function Window:AddTab(TabConfig)
		assert(type(TabConfig) == "table", "Window:AddTab expects a table")
		assert(type(TabConfig.Title) == "string" and TabConfig.Title ~= "", "Window:AddTab requires Title")
		return TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder)
	end

	function Window:SelectTab(Tab)
		local Index = type(Tab) == "table" and Tab.Index or Tab
		return TabModule:SelectTab(Index)
	end

	return Window
end
