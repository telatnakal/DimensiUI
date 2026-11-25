-- Solid surface: flat fill, rounded corners, no blur and no textures.
-- ColorKey picks the theme color (default WindowBackground). Outline adds a 1px hairline.
local Root = script.Parent
local Creator = require(Root.Creator)

local New = Creator.New

return function(ColorKey, Outline)
	local Surface = {}

	local Children = {
		New("UICorner", {
			CornerRadius = UDim.new(0, 12),
		}),
	}

	if Outline then
		table.insert(
			Children,
			New("UIStroke", {
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "Divider",
				},
			})
		)
	end

	Surface.Frame = New("Frame", {
		Name = "Surface",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, {
		New("Frame", {
			Name = "Background",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ThemeTag = {
				BackgroundColor3 = ColorKey or "WindowBackground",
			},
		}, Children),
	})

	return Surface
end
