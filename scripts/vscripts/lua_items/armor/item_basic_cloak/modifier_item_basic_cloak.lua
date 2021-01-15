modifier_item_basic_cloak = class({})

function modifier_item_basic_cloak:IsHidden()
	return true
end

function modifier_item_basic_cloak:IsDebuff()
	return false
end

function modifier_item_basic_cloak:IsPurgable()
	return false
end

function modifier_item_basic_cloak:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_basic_cloak:OnRefresh( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_basic_cloak:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_item_basic_cloak:GetModifierPhysicalArmorBonusUnique()
	return self.armor
end

function modifier_item_basic_cloak:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end