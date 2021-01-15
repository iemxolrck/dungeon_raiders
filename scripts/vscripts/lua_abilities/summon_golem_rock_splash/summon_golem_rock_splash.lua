summon_golem_rock_splash = class({})

LinkLuaModifier("modifier_summon_golem_rock_splash", "lua_abilities/summon_golem_rock_splash/modifier_summon_golem_rock_splash", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_stunned", "lua_abilities/generic/modifier_generic_stunned",LUA_MODIFIER_MOTION_NONE )

function summon_golem_rock_splash:GetIntrinsicModifierName()
	return "modifier_summon_golem_rock_splash"
end