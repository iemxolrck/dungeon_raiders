wizard_torrent = class({})

LinkLuaModifier("modifier_wizard_torrent_thinker", "lua_abilities/wizard_torrent/modifier_wizard_torrent_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wizard_torrent_geyser_thinker", "lua_abilities/wizard_torrent/modifier_wizard_torrent_geyser_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_stunned", "lua_abilities/generic/modifier_generic_stunned", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_airborne", "lua_abilities/generic/modifier_generic_airborne", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_drenched", "lua_abilities/generic/modifier_generic_drenched", LUA_MODIFIER_MOTION_NONE )

function wizard_torrent:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function wizard_torrent:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local inRiver = point.z > 0.5

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "area_of_effect" )
	local geyser_instance = self:GetSpecialValueFor( "geyser_instance" )
	local geyser = self:GetSpecialValueFor( "geyser" )
	
	CreateModifierThinker(
		caster,
		self,
		"modifier_wizard_torrent_thinker",
		{ duration = 3},
		point,
		caster:GetTeamNumber(),
		false
	)
	if inRiver==false then
		CreateModifierThinker(
			caster,
			self,
			"modifier_wizard_torrent_geyser_thinker",
			{	
				x = point.x,
				y = point.y,
				z = point.z
			},
			point,
			caster:GetTeamNumber(),
			false
		)
	end

end