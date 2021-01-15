item_sorcery_cape = class({})

LinkLuaModifier( "modifier_item_sorcery_cape", "lua_items/armor/item_sorcery_cape/modifier_item_sorcery_cape", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_channel_protection", "lua_abilities/generic/modifier_generic_channel_protection", LUA_MODIFIER_MOTION_NONE )

function item_sorcery_cape:GetIntrinsicModifierName()
	return "modifier_item_sorcery_cape"
end