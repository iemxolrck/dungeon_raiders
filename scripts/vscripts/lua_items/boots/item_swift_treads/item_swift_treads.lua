item_swift_treads = class({})

LinkLuaModifier( "modifier_item_swift_treads", "lua_items/boots/item_swift_treads/modifier_item_swift_treads", LUA_MODIFIER_MOTION_NONE )

function item_swift_treads:GetIntrinsicModifierName()
	return "modifier_item_swift_treads"
end