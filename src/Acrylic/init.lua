local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Acrylic = {
	AcrylicBlur = require(script.AcrylicBlur),
	CreateAcrylic = require(script.CreateAcrylic),
	AcrylicPaint = require(script.AcrylicPaint),
}

local BaseEffect
local DepthOfFieldDefaults = {}
local Initialized = false
local Destroyed = false

local function CaptureDefaults()
	table.clear(DepthOfFieldDefaults)
	local function Capture(Parent)
		if not Parent then return end
		for _, Object in ipairs(Parent:GetChildren()) do
			if Object:IsA("DepthOfFieldEffect") and Object ~= BaseEffect then
				DepthOfFieldDefaults[Object] = Object.Enabled
			end
		end
	end
	Capture(Lighting)
	Capture(Workspace.CurrentCamera)
end

function Acrylic.init()
	if Destroyed then return false end
	if Initialized then
		Acrylic.Enable()
		return true
	end

	BaseEffect = Instance.new("DepthOfFieldEffect")
	BaseEffect.Name = "DimensiUI_AcrylicBlur"
	BaseEffect.FarIntensity = 0
	BaseEffect.InFocusRadius = 0.1
	BaseEffect.NearIntensity = 1
	CaptureDefaults()
	for Effect in pairs(DepthOfFieldDefaults) do
		pcall(function() Effect.Enabled = false end)
	end
	BaseEffect.Parent = Lighting
	Initialized = true
	return true
end

function Acrylic.Enable()
	if Destroyed or not BaseEffect then return false end
	for Effect in pairs(DepthOfFieldDefaults) do
		if Effect and Effect.Parent then
			pcall(function() Effect.Enabled = false end)
		end
	end
	BaseEffect.Parent = Lighting
	return true
end

function Acrylic.Disable()
	if Destroyed or not BaseEffect then return false end
	BaseEffect.Parent = nil
	for Effect, WasEnabled in pairs(DepthOfFieldDefaults) do
		if Effect and Effect.Parent then
			pcall(function() Effect.Enabled = WasEnabled end)
		end
	end
	return true
end

function Acrylic.Destroy()
	if Destroyed then return end
	Destroyed = true
	if BaseEffect then
		pcall(function() BaseEffect:Destroy() end)
		BaseEffect = nil
	end
	for Effect, WasEnabled in pairs(DepthOfFieldDefaults) do
		if Effect and Effect.Parent then
			pcall(function() Effect.Enabled = WasEnabled end)
		end
	end
	table.clear(DepthOfFieldDefaults)
	Initialized = false
end

return Acrylic
