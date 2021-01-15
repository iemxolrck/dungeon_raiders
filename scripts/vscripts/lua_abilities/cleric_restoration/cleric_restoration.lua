cleric_restoration = class({})

LinkLuaModifier("modifier_cleric_restoration", "lua_abilities/cleric_restoration/modifier_cleric_restoration", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_heal", "lua_abilities/generic/modifier_generic_heal", LUA_MODIFIER_MOTION_NONE )

function cleric_restoration:GetManaCost()
	return self:GetCaster():GetMana()*(self:GetSpecialValueFor("mana_as_heal")/100)
end

function cleric_restoration:GetCooldown(iLevel)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return 0
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function cleric_restoration:GetIntrinsicModifierName()
	return "modifier_cleric_restoration"
end