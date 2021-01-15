shaman_synchronize = class({})

LinkLuaModifier( "modifier_shaman_synchronize", "lua_abilities/shaman_synchronize/modifier_shaman_synchronize", LUA_MODIFIER_MOTION_NONE )

function shaman_synchronize:GetIntrinsicModifierName()
	return "modifier_shaman_synchronize"
end