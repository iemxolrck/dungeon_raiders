item_basic_sword = class({})

LinkLuaModifier( "modifier_item_basic_sword", "lua_items/sword/item_basic_sword/modifier_item_basic_sword", LUA_MODIFIER_MOTION_NONE )

function item_basic_sword:GetIntrinsicModifierName()
	return "modifier_item_basic_sword"
end