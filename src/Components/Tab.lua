local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)

local New = Creator.New
local Spring = Motion.Spring.new
local Instant = Motion.Instant.new
local Components = Root.Components
local Card = require(Components.Card)

-- Background tint (Tab theme color) per interaction state
local TINT_IDLE = 1
local TINT_HOVER = 0.6
local TINT_PRESSED = 0.4
local TINT_SELECTED = 0
local TINT_SELECTED_HOVER = 0.12

local function SetActive(Item, Active)
	if Item.Label then
		Item.Label.FontFace = Active and Typography.Medium or Typography.Regular
		Creator.OverrideTag(Item.Label, { TextColor3 = Active and "Text" or "SubText" })
	end
	if Item.IconImage then
		Creator.OverrideTag(Item.IconImage, { ImageColor3 = Active and "Accent" or "SubText" })
	end
end

local TabModule = {
	Window = nil,
	Tabs = {},
	Containers = {},
	SelectedTab = 0,
	TabCount = 0,
	SelectionGeneration = 0,
}

function TabModule:Init(Window)
	TabModule.Window = Window
	return TabModule
end

function TabModule:New(Title, Icon, Parent)
	assert(type(Title) == "string" and Title ~= "", "Tab requires a non-empty title")
	local Library = require(Root)
	local Window = TabModule.Window
	assert(Window and Window.TabHolder and not Library.Unloaded, "Cannot create a tab after the library is destroyed")
	local Elements = Library.Elements

	TabModule.TabCount = TabModule.TabCount + 1
	local TabIndex = TabModule.TabCount

	local Tab = {
		Selected = false,
		Index = TabIndex,
		Name = Title,
		Type = "Tab",
	}

	if Library:GetIcon(Icon) then
		Icon = Library:GetIcon(Icon)
	end

	if Icon == "" or nil then
		Icon = nil
	end

	Tab.Label = New("TextLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = Icon and UDim2.new(0, 40, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
		Text = Title,
		RichText = true,
		TextTransparency = 0,
		FontFace = Typography.Regular,
		TextSize = 13,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		Size = UDim2.new(1, Icon and -48 or -20, 1, 0),
		BackgroundTransparency = 1,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ThemeTag = {
			TextColor3 = "SubText",
		},
	})

	Tab.IconImage = New("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.new(0, 12, 0.5, 0),
		BackgroundTransparency = 1,
		Image = Icon and Icon or nil,
		ThemeTag = {
			ImageColor3 = "SubText",
		},
	})

	Tab.Frame = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = "Tab",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 10),
		}),
		Tab.Label,
		Tab.IconImage,
	})

	local ContainerLayout = New("UIListLayout", {
		Padding = UDim.new(0, 14),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	Tab.ContainerFrame = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent = Window.ContainerHolder,
		Visible = false,
		BottomImage = "rbxassetid://6889812791",
		MidImage = "rbxassetid://6889812721",
		TopImage = "rbxassetid://6276641225",
		ScrollBarImageColor3 = Color3.fromRGB(150, 158, 172),
		ScrollBarImageTransparency = 0.7,
		ScrollBarThickness = 3,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		ContainerLayout,
		New("UIPadding", {
			PaddingRight = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 1),
			PaddingTop = UDim.new(0, 1),
			PaddingBottom = UDim.new(0, 1),
		}),
	})

	Creator.AddSignal(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 2)
	end, Tab.ContainerFrame)

	Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")

	Creator.AddSignal(Tab.Frame.MouseEnter, function()
		Tab.SetTransparency(Tab.Selected and TINT_SELECTED_HOVER or TINT_HOVER)
	end, Tab.Frame)
	Creator.AddSignal(Tab.Frame.MouseLeave, function()
		Tab.SetTransparency(Tab.Selected and TINT_SELECTED or TINT_IDLE)
	end, Tab.Frame)
	Creator.AddSignal(Tab.Frame.MouseButton1Down, function()
		Tab.SetTransparency(TINT_PRESSED)
	end, Tab.Frame)
	Creator.AddSignal(Tab.Frame.MouseButton1Up, function()
		Tab.SetTransparency(Tab.Selected and TINT_SELECTED_HOVER or TINT_HOVER)
	end, Tab.Frame)
	Creator.AddSignal(Tab.Frame.MouseButton1Click, function()
		TabModule:SelectTab(TabIndex)
	end, Tab.Frame)

	TabModule.Containers[TabIndex] = Tab.ContainerFrame
	TabModule.Tabs[TabIndex] = Tab

	Tab.Container = Tab.ContainerFrame
	Tab.ScrollFrame = Tab.Container

	function Tab:AddSection(SectionTitle)
		assert(type(SectionTitle) == "string" and SectionTitle ~= "", "Section title must be a non-empty string")
		local Section = { Type = "Section" }
		Card.Reset(Tab.Container)

		local SectionFrame = require(Components.Section)(SectionTitle, Tab.Container)
		Section.Container = SectionFrame.Container
		Section.ScrollFrame = Tab.Container

		setmetatable(Section, Elements)
		return Section
	end

	setmetatable(Tab, Elements)
	if TabIndex == 1 then TabModule:SelectTab(TabIndex) end
	return Tab
end

function TabModule:SelectTab(Tab)
	local Window = TabModule.Window
	local TabObject = TabModule.Tabs[Tab]
	if not Window or not TabObject or require(Root).Unloaded then return false end
	TabModule.SelectionGeneration += 1
	local Generation = TabModule.SelectionGeneration
	TabModule.SelectedTab = Tab
	for _, Item in next, TabModule.Tabs do
		Item.SetTransparency(TINT_IDLE)
		Item.Selected = false
		SetActive(Item, false)
	end
	TabObject.SetTransparency(TINT_SELECTED)
	TabObject.Selected = true
	SetActive(TabObject, true)
	task.spawn(function()
		if Generation ~= TabModule.SelectionGeneration or require(Root).Unloaded then return end
		Window.ContainerPosMotor:setGoal(Spring(Window.ContentTop + 16, { frequency = 10 }))
		Window.ContainerBackMotor:setGoal(Spring(1, { frequency = 10 }))
		task.wait(0.15)
		if Generation ~= TabModule.SelectionGeneration or require(Root).Unloaded then return end
		for _, Container in next, TabModule.Containers do
			if Container and Container.Parent then Container.Visible = false end
		end
		local SelectedContainer = TabModule.Containers[Tab]
		if SelectedContainer and SelectedContainer.Parent then SelectedContainer.Visible = true end
		Window.ContainerPosMotor:setGoal(Spring(Window.ContentTop, { frequency = 5 }))
		Window.ContainerBackMotor:setGoal(Spring(0, { frequency = 8 }))
	end)
	return true
end

return TabModule
