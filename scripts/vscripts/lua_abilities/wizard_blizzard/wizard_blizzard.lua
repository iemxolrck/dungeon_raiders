wizard_blizzard = class({})

LinkLuaModifier( "modifier_wizard_blizzard", "lua_abilities/wizard_blizzard/modifier_wizard_blizzard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wizard_blizzard_thinker", "lua_abilities/wizard_blizzard/modifier_wizard_blizzard_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_chilled", "lua_abilities/generic/modifier_generic_chilled", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_frozen", "lua_abilities/generic/modifier_generic_frozen", LUA_MODIFIER_MOTION_NONE )

function wizard_blizzard:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function wizard_blizzard:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function wizard_blizzard:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- Add modifier
	self.modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_wizard_blizzard", -- modifier name
		{
			x = point.x,
			y = point.y,
			duration = self:GetChannelTime()
		}
	)
end

function wizard_blizzard:OnChannelFinish( bInterrupted )
	if self.modifier then
		self.modifier:Destroy()
		self.modifier = nil
	end
end

--------------------------------------------------------------------------------
-- Ability Considerations
function wizard_blizzard:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end