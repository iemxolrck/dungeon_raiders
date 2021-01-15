dirge_zombie_apocalypse = class({})

LinkLuaModifier( "modifier_dirge_zombie_apocalypse", "lua_abilities/dirge_zombie_apocalypse/modifier_dirge_zombie_apocalypse", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_summon_zombie", "lua_abilities/dirge_zombie_apocalypse/modifier_summon_zombie", LUA_MODIFIER_MOTION_NONE )

function dirge_zombie_apocalypse:GetIntrinsicModifierName()
	return "modifier_dirge_zombie_apocalypse"
end