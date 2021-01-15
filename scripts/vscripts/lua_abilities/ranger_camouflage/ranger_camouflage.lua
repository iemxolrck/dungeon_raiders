ranger_camouflage = class({})

LinkLuaModifier( "modifier_ranger_camouflage", "lua_abilities/ranger_camouflage/modifier_ranger_camouflage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ranger_camouflage_buff", "lua_abilities/ranger_camouflage/modifier_ranger_camouflage_buff", LUA_MODIFIER_MOTION_NONE )

function ranger_camouflage:GetIntrinsicModifierName()
	return "modifier_ranger_camouflage"
end