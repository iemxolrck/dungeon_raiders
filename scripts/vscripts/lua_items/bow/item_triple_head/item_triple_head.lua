item_triple_head = class({})

LinkLuaModifier( "modifier_item_triple_head", "lua_items/bow/item_triple_head/modifier_item_triple_head", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_triple_head_crit", "lua_items/bow/item_triple_head/modifier_item_triple_head_crit", LUA_MODIFIER_MOTION_NONE )

function item_triple_head:GetIntrinsicModifierName()
	return "modifier_item_triple_head"
end