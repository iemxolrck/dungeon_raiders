item_arcane_treads = class({})

LinkLuaModifier( "modifier_item_arcane_treads", "lua_items/boots/item_arcane_treads/modifier_item_arcane_treads", LUA_MODIFIER_MOTION_NONE )

function item_arcane_treads:GetIntrinsicModifierName()
	return "modifier_item_arcane_treads"
end