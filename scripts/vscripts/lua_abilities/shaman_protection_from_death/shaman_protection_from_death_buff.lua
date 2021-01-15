shaman_protection_from_death_buff = class({})

LinkLuaModifier( "modifier_shaman_protection_from_death_buff", "lua_abilities/shaman_protection_from_death/modifier_shaman_protection_from_death_buff", LUA_MODIFIER_MOTION_NONE )

function shaman_protection_from_death_buff:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetDuration()

	target:AddNewModifier(
		caster,
		self, "modifier_shaman_protection_from_death_buff",
		{ duration = duration }
	)

end