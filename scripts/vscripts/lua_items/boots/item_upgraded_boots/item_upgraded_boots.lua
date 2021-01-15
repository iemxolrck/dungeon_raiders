item_upgraded_boots = class({})

LinkLuaModifier( "modifier_item_upgraded_boots", "lua_items/boots/item_upgraded_boots/modifier_item_upgraded_boots", LUA_MODIFIER_MOTION_NONE )

function item_upgraded_boots:GetIntrinsicModifierName()
	return "modifier_item_upgraded_boots"
end