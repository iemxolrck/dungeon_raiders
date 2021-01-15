druid_harvest = class({})

LinkLuaModifier("modifier_druid_harvest", "lua_abilities/druid_harvest/modifier_druid_harvest", LUA_MODIFIER_MOTION_NONE)

function druid_harvest:GetIntrinsicModifierName()
	return "modifier_druid_harvest"
end