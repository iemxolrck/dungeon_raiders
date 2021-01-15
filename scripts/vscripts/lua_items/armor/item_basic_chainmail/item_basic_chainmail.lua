item_basic_chainmail = class({})

LinkLuaModifier( "modifier_item_basic_chainmail", "lua_items/armor/item_basic_chainmail/modifier_item_basic_chainmail", LUA_MODIFIER_MOTION_NONE )

function item_basic_chainmail:GetIntrinsicModifierName()
	return "modifier_item_basic_chainmail"
end