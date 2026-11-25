local RunService = game:GetService("RunService")
local Signal = require(script.Parent.Signal)

local BaseMotor = {}
BaseMotor.__index = BaseMotor
function BaseMotor.new()
	return setmetatable({
		_onStep = Signal.new(), _onStart = Signal.new(), _onComplete = Signal.new(),
			_connection = nil, _destroyed = false,
		}, BaseMotor)
end
function BaseMotor:onStep(callback) return self._onStep:Connect(callback) end
function BaseMotor:onStart(callback) return self._onStart:Connect(callback) end
function BaseMotor:onComplete(callback) return self._onComplete:Connect(callback) end
function BaseMotor:start()
	if self._destroyed or self._connection then return end
	self._connection = RunService.RenderStepped:Connect(function(dt)
		if self._destroyed then return end
		local ok, done = pcall(self.step, self, dt)
		if not ok then
			warn("DimensiMotion motor step failed:", done)
			self:stop()
			return
		end
		if done and self._connection then
			self._connection:Disconnect()
			self._connection = nil
		end
	end)
end
function BaseMotor:stop()
	if self._connection then self._connection:Disconnect(); self._connection = nil end
end
function BaseMotor:destroy()
	if self._destroyed then return end
	self._destroyed = true
	self:stop()
	self._onStep:Destroy(); self._onStart:Destroy(); self._onComplete:Destroy()
end
BaseMotor.Destroy = BaseMotor.destroy
BaseMotor.step = function() return true end
BaseMotor.getValue = function() return nil end
BaseMotor.setGoal = function() end
function BaseMotor:__tostring() return "DimensiMotionMotor" end
return BaseMotor
