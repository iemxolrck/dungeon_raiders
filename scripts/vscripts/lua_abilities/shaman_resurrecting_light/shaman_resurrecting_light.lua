shaman_resurrecting_light = class({})

LinkLuaModifier( "modifier_shaman_resurrecting_light", "lua_abilities/shaman_resurrecting_light/modifier_shaman_resurrecting_light", LUA_MODIFIER_MOTION_NONE )

function shaman_resurrecting_light:GetIntrinsicModifierName()
	return "modifier_shaman_resurrecting_light"
end