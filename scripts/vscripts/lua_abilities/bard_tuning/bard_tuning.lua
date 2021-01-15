bard_tuning = class({})

LinkLuaModifier( "modifier_bard_tuning", "lua_abilities/bard_tuning/modifier_bard_tuning", LUA_MODIFIER_MOTION_NONE )

function bard_tuning:GetIntrinsicModifierName()
	return "modifier_bard_tuning"
end