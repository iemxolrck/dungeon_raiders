marksman_sniper = class({})

LinkLuaModifier( "modifier_marksman_sniper", "lua_abilities/marksman_sniper/modifier_marksman_sniper", LUA_MODIFIER_MOTION_NONE )

function marksman_sniper:GetIntrinsicModifierName()
	return	"modifier_marksman_sniper"
end