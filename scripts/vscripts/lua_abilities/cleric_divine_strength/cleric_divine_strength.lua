cleric_divine_strength = class({})

LinkLuaModifier("modifier_cleric_divine_strength", "lua_abilities/cleric_divine_strength/modifier_cleric_divine_strength", LUA_MODIFIER_MOTION_NONE)

function cleric_divine_strength:GetIntrinsicModifierName()
	return "modifier_cleric_divine_strength"
end