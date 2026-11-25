-- Solid window/notification surface. Flat fill with a 1px border (no blur, no textures).
local Root = script.Parent
local Creator = require(Root.Creator)

local New = Creator.New

return function()
	local Surface = {}

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
				BackgroundColor3 = "WindowBackground",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 10),
			}),
			New("UIStroke", {
				Thickness = 1,
				Transparency = 0,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "WindowBorder",
				},
			}),
		}),
	})

	return Surface
end
