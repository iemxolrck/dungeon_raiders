warlock_nyctophobia = class({})

LinkLuaModifier( "modifier_warlock_nyctophobia", "lua_abilities/warlock_nyctophobia/modifier_warlock_nyctophobia", LUA_MODIFIER_MOTION_NONE )

function warlock_nyctophobia:GetIntrinsicModifierName()
	return	"modifier_warlock_nyctophobia"
end