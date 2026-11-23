local BaseMotor = require(script.Parent.BaseMotor)
local SingleMotor = setmetatable({}, BaseMotor)
SingleMotor.__index = SingleMotor
function SingleMotor.new(initialValue, useImplicitConnections)
	assert(type(initialValue) == "number" and initialValue == initialValue and math.abs(initialValue) < math.huge,
		"SingleMotor initial value must be finite")
	local self = setmetatable(BaseMotor.new(), SingleMotor)
	self._useImplicitConnections = useImplicitConnections ~= false
	self._goal = nil
	self._state = { complete = true, value = initialValue, velocity = 0 }
	return self
end
function SingleMotor:step(dt)
	if self._destroyed or self._state.complete or not self._goal then return true end
	local result = self._goal:step(self._state, dt)
	if type(result) ~= "table" or type(result.value) ~= "number" then
		self._state.complete = true
		self:stop()
		warn("DimensiMotion motor received invalid goal output")
		return true
	end
	self._state = result
	self._onStep:Fire(result.value)
	if result.complete then
		if self._useImplicitConnections then self:stop() end
		self._onComplete:Fire()
	end
	return result.complete
end
function SingleMotor:getValue() return self._state.value end
function SingleMotor:setGoal(goal)
	if self._destroyed then return false end
	assert(type(goal) == "table" and type(goal.step) == "function", "Motor goal must implement step")
	self._state.complete = false
	self._goal = goal
	self._onStart:Fire()
	if self._useImplicitConnections then self:start() end
	return true
end
function SingleMotor:__tostring() return "DimensiMotionMotor(Single)" end
return SingleMotor
