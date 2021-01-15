summon_golem_craggy_exterior = class({})

LinkLuaModifier("modifier_summon_golem_craggy_exterior", "lua_abilities/summon_golem_craggy_exterior/modifier_summon_golem_craggy_exterior", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_stunned", "lua_abilities/generic/modifier_generic_stunned",LUA_MODIFIER_MOTION_NONE )

function summon_golem_craggy_exterior:GetIntrinsicModifierName()
	return "modifier_summon_golem_craggy_exterior"
end