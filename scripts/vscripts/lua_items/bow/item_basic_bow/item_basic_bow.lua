item_basic_bow = class({})

LinkLuaModifier( "modifier_item_basic_bow", "lua_items/bow/item_basic_bow/modifier_item_basic_bow", LUA_MODIFIER_MOTION_NONE )

function item_basic_bow:GetIntrinsicModifierName()
	return "modifier_item_basic_bow"
end