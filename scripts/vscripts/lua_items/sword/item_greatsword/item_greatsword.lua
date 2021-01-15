item_greatsword = class({})

LinkLuaModifier( "modifier_item_greatsword", "lua_items/sword/item_greatsword/modifier_item_greatsword", LUA_MODIFIER_MOTION_NONE )

function item_greatsword:GetIntrinsicModifierName()
	return "modifier_item_greatsword"
end