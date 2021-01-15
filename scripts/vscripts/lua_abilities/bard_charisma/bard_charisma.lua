bard_charisma = class({})

LinkLuaModifier( "modifier_bard_charisma", "lua_abilities/bard_charisma/modifier_bard_charisma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_charisma_aura", "lua_abilities/bard_charisma/modifier_bard_charisma_aura", LUA_MODIFIER_MOTION_NONE )

function bard_charisma:GetIntrinsicModifierName()
	return	"modifier_bard_charisma"
end