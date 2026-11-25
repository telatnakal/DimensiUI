local Root = script.Parent.Parent
local Typography = require(Root.Typography)
local Creator = require(Root.Creator)
local Card = require(script.Parent.Card)

local New = Creator.New

return function(Title, Parent)
	local Section = {}

	-- Section.Container is the card that holds this section's rows.
	Section.Container = Card.New(nil)
	Section.Container.Position = UDim2.fromOffset(0, 24)
	Section.Layout = Section.Container:FindFirstChildOfClass("UIListLayout")

	Section.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 32),
		LayoutOrder = 7,
		Parent = Parent,
	}, {
		New("TextLabel", {
			RichText = true,
			Text = Title,
			TextTransparency = 0,
			FontFace = Typography.Medium,
			TextSize = 14,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 16),
			Position = UDim2.fromOffset(5, 0),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		}),
		Section.Container,
	})

	-- Card height = compact row stack + title spacing.
	Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 6 + 24)
	end, Section.Root)

	return Section
end
