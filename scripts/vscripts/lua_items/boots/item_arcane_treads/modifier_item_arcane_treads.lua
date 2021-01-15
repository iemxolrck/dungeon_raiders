modifier_item_arcane_treads = class({})

function modifier_item_arcane_treads:IsHidden()
	return true
end

function modifier_item_arcane_treads:IsDebuff()
	return false
end

function modifier_item_arcane_treads:IsPurgable()
	return false
end

function modifier_item_arcane_treads:GetTexture()
	return "../items/boots/item_arcane_treads"
end


function modifier_item_arcane_treads:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
end

function modifier_item_arcane_treads:OnRefresh( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
end

function modifier_item_arcane_treads:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_arcane_treads:GetModifierMoveSpeedBonus_Percentage_Unique()
	return self.movespeed
end

function modifier_item_arcane_treads:GetModifierMoveSpeedBonus_Special_Boots()
	return self.movespeed
end

function modifier_item_arcane_treads:GetModifierPhysicalArmorBonusUnique()
	return self.armor
end

function modifier_item_arcane_treads:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end

function modifier_item_arcane_treads:GetModifierBonusStats_Intellect()
	return self.int
end

function modifier_item_arcane_treads:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end