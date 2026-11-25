local Signal = {}
Signal.__index = Signal

local Connection = {}
Connection.__index = Connection

function Connection:Disconnect()
	if not self.Connected then return end
	self.Connected = false
	local signal = self.Signal
	if signal then
		for i = #signal._connections, 1, -1 do
			if signal._connections[i] == self then
				table.remove(signal._connections, i)
				break
			end
		end
	end
	self.Signal = nil
end
Connection.disconnect = Connection.Disconnect


function Signal.new()
	return setmetatable({ _connections = {}, _destroyed = false }, Signal)
end


function Signal:Connect(callback)
	assert(type(callback) == "function", "Signal:Connect expects a callback")
	assert(not self._destroyed, "Cannot connect to a destroyed signal")
	local connection = setmetatable({ Signal = self, Connected = true, Callback = callback }, Connection)
	table.insert(self._connections, connection)
	return connection
end
Signal.connect = Signal.Connect


function Signal:Fire(...)
	if self._destroyed then return end
	local args = table.pack(...)
	local snapshot = table.clone(self._connections)
	for _, connection in ipairs(snapshot) do
		if connection.Connected then
			local ok, err = pcall(connection.Callback, table.unpack(args, 1, args.n))
			if not ok then warn("DimensiMotion signal callback failed:", err) end
		end
	end
end
Signal.fire = Signal.Fire

function Signal:Wait()
	assert(not self._destroyed, "Cannot wait on a destroyed signal")
	local thread = coroutine.running()
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		if coroutine.status(thread) == "suspended" then
			local ok, err = coroutine.resume(thread, ...)
			if not ok then warn("DimensiMotion signal waiter failed:", err) end
		end
	end)
	return coroutine.yield()
end
Signal.wait = Signal.Wait


function Signal:Destroy()
	if self._destroyed then return end
	self._destroyed = true
	for i = #self._connections, 1, -1 do
		self._connections[i]:Disconnect()
	end
	table.clear(self._connections)
end


return Signal
