marksman_precision = class({})

LinkLuaModifier( "modifier_marksman_precision", "lua_abilities/marksman_precision/modifier_marksman_precision", LUA_MODIFIER_MOTION_NONE )

function marksman_precision:GetIntrinsicModifierName()
	return	"modifier_marksman_precision"
end