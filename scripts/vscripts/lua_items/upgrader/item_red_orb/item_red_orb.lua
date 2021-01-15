item_red_orb = class({})

LinkLuaModifier( "modifier_item_red_orb", "lua_items/upgrader/item_red_orb/modifier_item_red_orb", LUA_MODIFIER_MOTION_NONE )

function item_red_orb:GetIntrinsicModifierName()
	return "modifier_item_red_orb"
end