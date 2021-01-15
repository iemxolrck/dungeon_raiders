wizard_meteor = class({})

LinkLuaModifier( "modifier_wizard_meteor_thinker", "lua_abilities/wizard_meteor/modifier_wizard_meteor_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned", "lua_abilities/generic/modifier_generic_stunned", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_burned", "lua_abilities/generic/modifier_generic_burned", LUA_MODIFIER_MOTION_NONE )

function wizard_meteor:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function wizard_meteor:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function wizard_meteor:OnSpellStart()

end

function wizard_meteor:OnChannelFinish( bInterrupted )
	local min_radius = self:GetSpecialValueFor( "inner_radius" )
	local max_radius = self:GetSpecialValueFor( "area_of_effect" )
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	local radius = ( max_radius - min_radius ) * channel_pct
	--if bInterrupted then return end

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	CreateModifierThinker(
		caster,
		self,
		"modifier_wizard_meteor_thinker",
		{ radius = radius },
		point,
		self:GetCaster():GetTeamNumber(),
		false
	)
end