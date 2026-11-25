local Instant = {}
Instant.__index = Instant

function Instant.new(targetValue)
	assert(type(targetValue) == "number" and targetValue == targetValue and math.abs(targetValue) < math.huge,
		"DimensiMotion.Instant target must be a finite number")
	return setmetatable({ Target = targetValue }, Instant)
end

function Instant:step()
	return { complete = true, value = self.Target, velocity = 0 }
end
return Instant
