item_basic_robe = class({})

LinkLuaModifier( "modifier_item_basic_robe", "lua_items/armor/item_basic_robe/modifier_item_basic_robe", LUA_MODIFIER_MOTION_NONE )

function item_basic_robe:GetIntrinsicModifierName()
	return "modifier_item_basic_robe"
end