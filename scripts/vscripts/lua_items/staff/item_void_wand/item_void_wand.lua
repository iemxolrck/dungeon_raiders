item_void_wand = class({})

LinkLuaModifier( "modifier_item_void_wand", "lua_items/staff/item_void_wand/modifier_item_void_wand", LUA_MODIFIER_MOTION_NONE )

function item_void_wand:GetIntrinsicModifierName()
	return "modifier_item_void_wand"
end