local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)
local New = Creator.New

local Card = require(script.Parent.Card)

local Spring = Motion.Spring.new

return function(Title, Desc, Parent, Hover)
	local Element = {}

	-- Elements added straight to a tab are grouped into one implicit card.
	if Parent and Parent:IsA("ScrollingFrame") then
		Parent = Card.Auto(Parent)
	end

	Element.TitleLabel = New("TextLabel", {
		FontFace = Typography.Medium,
		Text = Title,
		TextColor3 = Color3.fromRGB(241, 243, 247),
		TextSize = 13,
		TextWrapped = true,
		LineHeight = 1.12,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Element.DescLabel = New("TextLabel", {
		FontFace = Typography.Regular,
		Text = Desc,
		TextColor3 = Color3.fromRGB(150, 158, 172),
		TextSize = 12,
		TextWrapped = true,
		LineHeight = 1.12,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		ThemeTag = {
			TextColor3 = "SubText",
		},
	})

	Element.LabelHolder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -24, 0, 0),
	}, {
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 8),
		}),
		New("UISizeConstraint", {
			MinSize = Vector2.new(0, 48),
		}),
		Element.TitleLabel,
		Element.DescLabel,
	})

	Element.Separator = New("Frame", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -24, 0, 1),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ThemeTag = {
			BackgroundColor3 = "Divider",
		},
	})

	Element.Frame = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(33, 38, 48),
		Parent = Parent,
		AutomaticSize = Enum.AutomaticSize.Y,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = 7,
		ThemeTag = {
			BackgroundColor3 = "Tone",
			BackgroundTransparency = "ElementTransparency",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 10),
		}),
		Element.Separator,
		Element.LabelHolder,
	})

	-- Hairline above every row except the first one in its card.
	local Rows = 0
	if Parent then
		for _, Child in next, Parent:GetChildren() do
			if Child:IsA("GuiObject") then
				Rows += 1
			end
		end
	end
	Element.Separator.Visible = Rows > 1

	function Element:SetTitle(Set)
		assert(type(Set) == "string", "Element:SetTitle expects a string")
		Element.TitleLabel.Text = Set
	end

	function Element:SetDesc(Set)
		assert(Set == nil or type(Set) == "string", "Element:SetDesc expects a string or nil")
		if Set == nil then
			Set = ""
		end
		if Set == "" then
			Element.DescLabel.Visible = false
		else
			Element.DescLabel.Visible = true
		end
		Element.DescLabel.Text = Set
	end

	function Element:Destroy()
		Element.Frame:Destroy()
	end

	Element:SetTitle(Title)
	Element:SetDesc(Desc)

	if Hover then
		local Themes = Root.Themes
		local Motor, SetTransparency = Creator.SpringMotor(
			Creator.GetThemeProperty("ElementTransparency"),
			Element.Frame,
			"BackgroundTransparency",
			false,
			true
		)

		Creator.AddSignal(Element.Frame.MouseEnter, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
		end, Element.Frame)
		Creator.AddSignal(Element.Frame.MouseLeave, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency"))
		end, Element.Frame)
		Creator.AddSignal(Element.Frame.MouseButton1Down, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange") - 0.15)
		end, Element.Frame)
		Creator.AddSignal(Element.Frame.MouseButton1Up, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
		end, Element.Frame)
	end

	return Element
end
