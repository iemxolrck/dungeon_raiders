item_basic_cloak = class({})

LinkLuaModifier( "modifier_item_basic_cloak", "lua_items/armor/item_basic_cloak/modifier_item_basic_cloak", LUA_MODIFIER_MOTION_NONE )

function item_basic_cloak:GetIntrinsicModifierName()
	return "modifier_item_basic_cloak"
end