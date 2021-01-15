item_basic_slippers = class({})

LinkLuaModifier( "modifier_item_basic_slippers", "lua_items/boots/item_basic_slippers/modifier_item_basic_slippers", LUA_MODIFIER_MOTION_NONE )

function item_basic_slippers:GetIntrinsicModifierName()
	return "modifier_item_basic_slippers"
end