item_green_orb = class({})

LinkLuaModifier( "modifier_item_green_orb", "lua_items/upgrader/item_green_orb/modifier_item_green_orb", LUA_MODIFIER_MOTION_NONE )

function item_green_orb:GetIntrinsicModifierName()
	return "modifier_item_green_orb"
end