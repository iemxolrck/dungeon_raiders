druid_entangle = class({})

LinkLuaModifier("modifier_druid_entangle", "lua_abilities/druid_entangle/modifier_druid_entangle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_druid_entangle_root", "lua_abilities/druid_entangle/modifier_druid_entangle_root", LUA_MODIFIER_MOTION_NONE)

function druid_entangle:GetIntrinsicModifierName()
	return "modifier_druid_entangle"
end