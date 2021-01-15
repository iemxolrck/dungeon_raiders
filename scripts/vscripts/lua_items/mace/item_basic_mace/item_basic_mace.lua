item_basic_mace = class({})

LinkLuaModifier( "modifier_item_basic_mace", "lua_items/mace/item_basic_mace/modifier_item_basic_mace", LUA_MODIFIER_MOTION_NONE )

function item_basic_mace:GetIntrinsicModifierName()
	return "modifier_item_basic_mace"
end