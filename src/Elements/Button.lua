local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Button"

function Element:New(Idx, Config)
	-- The public element dispatcher always calls New(Idx, Config).
	-- Also accept the one-argument config form for backwards compatibility.
	if Config == nil and type(Idx) == "table" then
		Config = Idx
	end
	assert(type(Config) == "table", "Button - Config must be a table")
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Button - Missing Title")
	assert(Config.Callback == nil or type(Config.Callback) == "function", "Button - Callback must be a function")
	Config.Callback = Config.Callback or function() end

	local ButtonFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)

	local ButtonIco = New("ImageLabel", {
		Image = "rbxassetid://10709791437",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		BackgroundTransparency = 1,
		Parent = ButtonFrame.Frame,
		ThemeTag = {
			ImageColor3 = "Text",
		},
	})

	Creator.AddSignal(ButtonFrame.Frame.MouseButton1Click, function()
		self.Library:SafeCallback(Config.Callback)
	end, ButtonFrame.Frame)

	return ButtonFrame
end

return Element
