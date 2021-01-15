item_basic_boots = class({})

LinkLuaModifier( "modifier_item_basic_boots", "lua_items/boots/item_basic_boots/modifier_item_basic_boots", LUA_MODIFIER_MOTION_NONE )

function item_basic_boots:GetIntrinsicModifierName()
	return "modifier_item_basic_boots"
end