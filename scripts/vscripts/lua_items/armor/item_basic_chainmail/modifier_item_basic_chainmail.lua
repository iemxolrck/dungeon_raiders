modifier_item_basic_chainmail = class({})

function modifier_item_basic_chainmail:IsHidden()
	return true
end

function modifier_item_basic_chainmail:IsDebuff()
	return false
end

function modifier_item_basic_chainmail:IsPurgable()
	return false
end

function modifier_item_basic_chainmail:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_basic_chainmail:OnRefresh( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_basic_chainmail:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_item_basic_chainmail:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_item_basic_chainmail:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end