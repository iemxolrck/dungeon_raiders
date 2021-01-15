summon_treant_fury_swipes = class({})
LinkLuaModifier( "modifier_summon_treant_fury_swipes", "lua_abilities/summon_treant_fury_swipes/modifier_summon_treant_fury_swipes", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_summon_treant_fury_swipes_debuff", "lua_abilities/summon_treant_fury_swipes/modifier_summon_treant_fury_swipes_debuff", LUA_MODIFIER_MOTION_NONE )

function summon_treant_fury_swipes:GetIntrinsicModifierName()
	return "modifier_summon_treant_fury_swipes"
end
