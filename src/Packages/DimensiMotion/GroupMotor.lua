local BaseMotor = require(script.Parent.BaseMotor)
local SingleMotor = require(script.Parent.SingleMotor)
local GroupMotor = setmetatable({}, BaseMotor)
GroupMotor.__index = GroupMotor
local function createMotor(value)
	if type(value) == "number" then return SingleMotor.new(value, false) end
	if type(value) == "table" then return GroupMotor.new(value, false) end
	error("DimensiMotion group values must be numbers or nested tables", 3)
end
function GroupMotor.new(initialValues, useImplicitConnections)
	assert(type(initialValues) == "table", "GroupMotor expects an initial values table")
	local self = setmetatable(BaseMotor.new(), GroupMotor)
	self._useImplicitConnections = useImplicitConnections ~= false
	self._complete = true
	self._motors = {}
	for key, value in pairs(initialValues) do self._motors[key] = createMotor(value) end
	return self
end
function GroupMotor:step(dt)
	if self._destroyed or self._complete then return true end
	local done = true
	for _, motor in pairs(self._motors) do if not motor:step(dt) then done = false end end
	self._onStep:Fire(self:getValue())
	if done then
		self._complete = true
		if self._useImplicitConnections then self:stop() end
		self._onComplete:Fire()
	end
	return done
end
function GroupMotor:setGoal(goals)
	if self._destroyed then return false end
	assert(type(goals) == "table", "GroupMotor goal must be a table")
	for key, goal in pairs(goals) do
		local motor = assert(self._motors[key], "Unknown GroupMotor key: " .. tostring(key))
		assert(type(goal) == "table" and type(goal.step) == "function", "GroupMotor child goal must implement step")
	end
	self._complete = false
	self._onStart:Fire()
	for key, goal in pairs(goals) do self._motors[key]:setGoal(goal) end
	if self._useImplicitConnections then self:start() end
	return true
end
function GroupMotor:getValue()
	local values = {}
	for key, motor in pairs(self._motors) do values[key] = motor:getValue() end
	return values
end
function GroupMotor:destroy()
	if self._destroyed then return end
	for _, motor in pairs(self._motors) do motor:destroy() end
	self._motors = {}
	BaseMotor.destroy(self)
end
function GroupMotor:__tostring() return "DimensiMotionMotor(Group)" end
return GroupMotor
