item_blue_orb = class({})

LinkLuaModifier( "modifier_item_blue_orb", "lua_items/upgrader/item_blue_orb/modifier_item_blue_orb", LUA_MODIFIER_MOTION_NONE )

function item_blue_orb:GetIntrinsicModifierName()
	return "modifier_item_blue_orb"
end