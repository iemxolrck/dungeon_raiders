generic_critical_strike = class({})

LinkLuaModifier( "modifier_generic_critical_strike", "lua_abilities/generic/modifier_generic_critical_strike", LUA_MODIFIER_MOTION_NONE )

function generic_critical_strike:GetIntrinsicModifierName()
	return "modifier_generic_critical_strike"
end