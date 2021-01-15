item_basic_spear = class({})

LinkLuaModifier( "modifier_item_basic_spear", "lua_items/spear/item_basic_spear/modifier_item_basic_spear", LUA_MODIFIER_MOTION_NONE )

function item_basic_spear:GetIntrinsicModifierName()
	return "modifier_item_basic_spear"
end