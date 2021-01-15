ranger_heighten_senses = class({})

LinkLuaModifier( "modifier_ranger_heighten_senses", "lua_abilities/ranger_heighten_senses/modifier_ranger_heighten_senses", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ranger_heighten_senses_aura", "lua_abilities/ranger_heighten_senses/modifier_ranger_heighten_senses_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ranger_heighten_senses_buff", "lua_abilities/ranger_heighten_senses/modifier_ranger_heighten_senses_buff", LUA_MODIFIER_MOTION_NONE )

function ranger_heighten_senses:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetDuration()
	local radius = self:GetSpecialValueFor("radius")

	caster:AddNewModifier(
		caster,
		self,
		"modifier_ranger_heighten_senses",
		{ duration = duration }
	)

end