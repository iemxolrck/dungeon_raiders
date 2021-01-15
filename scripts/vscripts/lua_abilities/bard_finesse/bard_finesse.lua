bard_finesse = class({})

LinkLuaModifier( "modifier_bard_finesse", "lua_abilities/bard_finesse/modifier_bard_finesse", LUA_MODIFIER_MOTION_NONE )

function bard_finesse:GetIntrinsicModifierName()
	return "modifier_bard_finesse"
end