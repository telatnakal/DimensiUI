local Spring = {}
Spring.__index = Spring


function Spring.new(targetValue, options)
	assert(type(targetValue) == "number" and targetValue == targetValue and math.abs(targetValue) < math.huge,
		"DimensiMotion.Spring target must be a finite number")
	options = options or {}
	local frequency = tonumber(options.frequency) or 8
	local damping = tonumber(options.dampingRatio) or 1
	assert(frequency > 0 and frequency <= 100, "Spring frequency must be between 0 and 100")
	assert(damping >= 0 and damping <= 10, "Spring dampingRatio must be between 0 and 10")
	return setmetatable({ Target = targetValue, Frequency = frequency, Damping = damping }, Spring)
end


function Spring:step(state, dt)
	local target = self.Target
	local position = state.value
	local velocity = state.velocity or 0
	dt = math.clamp(tonumber(dt) or 0, 0, 0.05)
	-- Semi-implicit integration in short steps to remain stable across frame drops.
	local omega = 2 * math.pi * self.Frequency
	local damping = self.Damping
	local remaining = dt
	while remaining > 0 do
		local h = math.min(remaining, 1 / 120)
		local acceleration = (target - position) * omega * omega - 2 * damping * omega * velocity
		velocity += acceleration * h
		position += velocity * h
		remaining -= h
	end
	local complete = math.abs(velocity) < 0.001 and math.abs(position - target) < 0.001
	return { complete = complete, value = complete and target or position, velocity = complete and 0 or velocity }
end
return Spring
