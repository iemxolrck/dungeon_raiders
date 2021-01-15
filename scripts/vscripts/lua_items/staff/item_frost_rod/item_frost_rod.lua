item_frost_rod = class({})

LinkLuaModifier( "modifier_item_frost_rod", "lua_items/staff/item_frost_rod/modifier_item_frost_rod", LUA_MODIFIER_MOTION_NONE )

function item_frost_rod:GetIntrinsicModifierName()
	return "modifier_item_frost_rod"
end