item_mana_potion = class({})

LinkLuaModifier( "modifier_item_mana_potion", "lua_items/potion/item_mana_potion/modifier_item_mana_potion", LUA_MODIFIER_MOTION_NONE )

function item_mana_potion:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("buff_duration")
	
	caster:AddNewModifier(
		caster,
		self,
		"modifier_item_mana_potion",
		{ duration = duration }
	)
	self:SpendCharge()

end
