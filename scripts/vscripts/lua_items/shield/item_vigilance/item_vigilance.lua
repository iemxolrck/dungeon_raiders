item_vigilance = class({})

LinkLuaModifier( "modifier_item_vigilance", "lua_items/shield/item_vigilance/modifier_item_vigilance", LUA_MODIFIER_MOTION_NONE )

function item_vigilance:GetIntrinsicModifierName()
	return "modifier_item_vigilance"
end