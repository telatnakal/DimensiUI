local function createFont(weight)
	local candidates = {
		"rbxasset://fonts/families/BuilderSans.json",
		"rbxasset://fonts/families/GothamSSm.json",
		"rbxasset://fonts/families/SourceSansPro.json",
	}

	for _, family in ipairs(candidates) do
		local ok, font = pcall(function()
			return Font.new(family, weight, Enum.FontStyle.Normal)
		end)
		if ok and font then
			return font
		end
	end

	return Font.fromEnum(Enum.Font.SourceSans)
end

return {
	Regular = createFont(Enum.FontWeight.Regular),
	Medium = createFont(Enum.FontWeight.Medium),
	SemiBold = createFont(Enum.FontWeight.SemiBold),
	Bold = createFont(Enum.FontWeight.Bold),
}
