local Root = script.Parent.Parent
local Components = Root.Components
local Motion = require(Root.Packages.DimensiMotion)
local Creator = require(Root.Creator)

local Paragraph = {}
Paragraph.__index = Paragraph
Paragraph.__type = "Paragraph"

function Paragraph:New(Idx, Config)
	-- The public element dispatcher always calls New(Idx, Config).
	-- Also accept the one-argument config form for backwards compatibility.
	if Config == nil and type(Idx) == "table" then
		Config = Idx
	end
	assert(type(Config) == "table", "Paragraph - Config must be a table")
	assert(type(Config.Title) == "string" and Config.Title ~= "", "Paragraph - Missing Title")
	assert(Config.Content == nil or type(Config.Content) == "string", "Paragraph - Content must be a string")
	Config.Content = Config.Content or ""

	local Paragraph = require(Components.Element)(Config.Title, Config.Content, Paragraph.Container, false)
	return Paragraph
end

return Paragraph
