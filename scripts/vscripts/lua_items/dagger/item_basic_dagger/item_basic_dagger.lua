item_basic_dagger = class({})

LinkLuaModifier( "modifier_item_basic_dagger", "lua_items/dagger/item_basic_dagger/modifier_item_basic_dagger", LUA_MODIFIER_MOTION_NONE )

function item_basic_dagger:GetIntrinsicModifierName()
	return "modifier_item_basic_dagger"
end