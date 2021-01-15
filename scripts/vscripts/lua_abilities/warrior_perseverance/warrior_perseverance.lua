warrior_perseverance = class({})

LinkLuaModifier( "modifier_warrior_perseverance", "lua_abilities/warrior_perseverance/modifier_warrior_perseverance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warrior_perseverance_buff", "lua_abilities/warrior_perseverance/modifier_warrior_perseverance_buff", LUA_MODIFIER_MOTION_NONE )

function warrior_perseverance:GetIntrinsicModifierName()
	return "modifier_warrior_perseverance_buff"
end 