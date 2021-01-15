modifier_item_basic_boots = class({})

function modifier_item_basic_boots:IsHidden()
	return false
end

function modifier_item_basic_boots:IsDebuff()
	return false
end

function modifier_item_basic_boots:IsPurgable()
	return false
end

function modifier_item_basic_boots:GetTexture()
	return "../items/boots/item_basic_boots"
end

function modifier_item_basic_boots:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_basic_boots:OnRefresh( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_basic_boots:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

--function modifier_item_basic_boots:GetModifierMoveSpeedBonus_Percentage_Unique()
--	return self.movespeed
--end

function modifier_item_basic_boots:GetModifierMoveSpeedBonus_Special_Boots()
	return self.movespeed
end

function modifier_item_basic_boots:GetModifierPhysicalArmorBonusUnique()
	return self.armor
end

function modifier_item_basic_boots:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end