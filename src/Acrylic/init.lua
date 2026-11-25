local Lighting = game:GetService("Lighting")

local Acrylic = {
	AcrylicBlur = require(script.AcrylicBlur),
	CreateAcrylic = require(script.CreateAcrylic),
	AcrylicPaint = require(script.AcrylicPaint),
}

local BaseEffect
local Destroyed = false

local function CreateEffect()
	local Effect = Instance.new("DepthOfFieldEffect")
	Effect.Name = "DimensiUI_AcrylicBlur"
	Effect.FarIntensity = 0
	Effect.InFocusRadius = 0.1
	Effect.NearIntensity = 1
	return Effect
end

function Acrylic.init()
	if Destroyed then return false end
	if not BaseEffect then
		BaseEffect = CreateEffect()
	end
	BaseEffect.Parent = Lighting
	return true
end

function Acrylic.Enable()
	if Destroyed or not BaseEffect then return false end
	BaseEffect.Parent = Lighting
	return true
end

function Acrylic.Disable()
	if Destroyed or not BaseEffect then return false end
	BaseEffect.Parent = nil
	return true
end

function Acrylic.Destroy()
	if Destroyed then return end
	Destroyed = true
	if BaseEffect then
		pcall(function() BaseEffect:Destroy() end)
		BaseEffect = nil
	end
end

return Acrylic
