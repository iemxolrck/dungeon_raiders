item_chaos_staff = class({})

LinkLuaModifier( "modifier_item_chaos_staff", "lua_items/staff/item_chaos_staff/modifier_item_chaos_staff", LUA_MODIFIER_MOTION_NONE )

function item_chaos_staff:GetIntrinsicModifierName()
	return "modifier_item_chaos_staff"
end