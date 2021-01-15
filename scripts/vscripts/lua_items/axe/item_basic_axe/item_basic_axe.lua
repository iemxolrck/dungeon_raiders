item_basic_axe = class({})

LinkLuaModifier( "modifier_item_basic_axe", "lua_items/axe/item_basic_axe/modifier_item_basic_axe", LUA_MODIFIER_MOTION_NONE )

function item_basic_axe:GetIntrinsicModifierName()
	return "modifier_item_basic_axe"
end