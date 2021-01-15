item_sturdy_treads = class({})

LinkLuaModifier( "modifier_item_sturdy_treads", "lua_items/boots/item_sturdy_treads/modifier_item_sturdy_treads", LUA_MODIFIER_MOTION_NONE )

function item_sturdy_treads:GetIntrinsicModifierName()
	return "modifier_item_sturdy_treads"
end