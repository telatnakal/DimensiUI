<<<<<<< HEAD
-- Solid surface: flat fill, rounded corners, no blur and no textures.
-- ColorKey picks the theme color (default WindowBackground). Outline adds a 1px hairline.
=======
-- Solid window/notification surface. Flat fill with a 1px border (no blur, no textures).
>>>>>>> 00e015507899790ef9c108a8b3a8e5c2a22a47ed
local Root = script.Parent
local Creator = require(Root.Creator)

local New = Creator.New

<<<<<<< HEAD
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

=======
return function()
	local Surface = {}

>>>>>>> 00e015507899790ef9c108a8b3a8e5c2a22a47ed
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
<<<<<<< HEAD
				BackgroundColor3 = ColorKey or "WindowBackground",
			},
		}, Children),
=======
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
>>>>>>> 00e015507899790ef9c108a8b3a8e5c2a22a47ed
	})

	return Surface
end
