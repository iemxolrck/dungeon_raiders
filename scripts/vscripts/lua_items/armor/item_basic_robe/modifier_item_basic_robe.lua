modifier_item_basic_robe = class({})

function modifier_item_basic_robe:IsHidden()
	return true
end

function modifier_item_basic_robe:IsDebuff()
	return false
end

function modifier_item_basic_robe:IsPurgable()
	return false
end

function modifier_item_basic_robe:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_basic_robe:OnRefresh( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_basic_robe:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_item_basic_robe:GetModifierPhysicalArmorBonusUnique()
	return self.armor
end

function modifier_item_basic_robe:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end