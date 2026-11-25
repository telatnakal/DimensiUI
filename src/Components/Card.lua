-- Card: a rounded container that groups rows. Rows are separated by hairlines, not borders.
local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New

local Card = {}

-- One implicit card per tab container, used by elements added directly to a tab.
local AutoCards = setmetatable({}, { __mode = "k" })

function Card.New(Parent)
	return New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		LayoutOrder = 7,
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = "Card",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 14),
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
		}),
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0),
		}),
	})
end

function Card.Auto(Parent)
	local Existing = AutoCards[Parent]
	if Existing and Existing.Parent == Parent then
		return Existing
	end
	local Frame = Card.New(Parent)
	AutoCards[Parent] = Frame
	return Frame
end

-- Called when a section is added so later loose elements start a fresh card below it.
function Card.Reset(Parent)
	AutoCards[Parent] = nil
end

return Card
