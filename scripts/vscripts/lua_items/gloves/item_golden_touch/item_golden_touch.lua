item_golden_touch = class({})

LinkLuaModifier( "modifier_item_golden_touch", "lua_items/gloves/item_golden_touch/modifier_item_golden_touch", LUA_MODIFIER_MOTION_NONE )

function item_golden_touch:GetIntrinsicModifierName()
	return "modifier_item_golden_touch"
end