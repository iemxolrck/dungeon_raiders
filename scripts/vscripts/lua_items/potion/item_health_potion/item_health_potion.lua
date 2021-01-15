item_health_potion = class({})

LinkLuaModifier( "modifier_item_health_potion", "lua_items/potion/item_health_potion/modifier_item_health_potion", LUA_MODIFIER_MOTION_NONE )

function item_health_potion:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("buff_duration")
	
	caster:AddNewModifier(
		caster,
		self,
		"modifier_item_health_potion",
		{ duration = duration }
	)
	self:SpendCharge()
end
