neutral_gain = class({})

LinkLuaModifier( "modifier_neutral_gain", "lua_abilities/resource/neutral_gain/modifier_neutral_gain", LUA_MODIFIER_MOTION_NONE )

function neutral_gain:GetIntrinsicModifierName()
	return "modifier_neutral_gain"
end