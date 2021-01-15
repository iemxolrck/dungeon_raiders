marksman_piercing = class({})

LinkLuaModifier( "modifier_marksman_piercing", "lua_abilities/marksman_piercing/modifier_marksman_piercing", LUA_MODIFIER_MOTION_NONE )

function marksman_piercing:GetIntrinsicModifierName()
	return	"modifier_marksman_piercing"
end