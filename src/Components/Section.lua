local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Creator = require(Root.Creator)
local Card = require(script.Parent.Card)

local New = Creator.New

return function(Title, Parent)
	local Section = {}

<<<<<<< HEAD
	-- Section.Container is the card that holds this section's rows.
	Section.Container = Card.New(nil)
	Section.Container.Position = UDim2.fromOffset(0, 26)
	Section.Layout = Section.Container:FindFirstChildOfClass("UIListLayout")
=======
	Section.Layout = New("UIListLayout", {
		Padding = UDim.new(0, 7),
	})

	Section.Container = New("Frame", {
		Size = UDim2.new(1, 0, 0, 26),
		Position = UDim2.fromOffset(0, 30),
		BackgroundTransparency = 1,
	}, {
		Section.Layout,
	})
>>>>>>> 00e015507899790ef9c108a8b3a8e5c2a22a47ed

	Section.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 34),
		LayoutOrder = 7,
		Parent = Parent,
	}, {
		New("TextLabel", {
			RichText = true,
			Text = Title,
			TextTransparency = 0,
<<<<<<< HEAD
			FontFace = Typography.Medium,
			TextSize = 12,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 18),
			Position = UDim2.fromOffset(4, 0),
			BackgroundTransparency = 1,
=======
			FontFace = Typography.SemiBold,
			TextSize = 13,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 18),
			Position = UDim2.fromOffset(2, 8),
>>>>>>> 00e015507899790ef9c108a8b3a8e5c2a22a47ed
			ThemeTag = {
				TextColor3 = "SubText",
			},
		}),
		Section.Container,
	})

	-- Card height = rows + 8px of inner padding; the title takes the first 26px.
	Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
<<<<<<< HEAD
		Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 8 + 26)
=======
		Section.Container.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y)
		Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 30)
>>>>>>> 00e015507899790ef9c108a8b3a8e5c2a22a47ed
	end, Section.Root)

	return Section
end
