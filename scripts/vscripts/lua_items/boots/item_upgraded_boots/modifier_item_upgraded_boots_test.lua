modifier_item_upgraded_boots = class({})

function modifier_item_upgraded_boots:IsHidden()
	return false
end

function modifier_item_upgraded_boots:IsDebuff()
	return false
end

function modifier_item_upgraded_boots:IsPurgable()
	return false
end

function modifier_item_upgraded_boots:GetTexture()
	return "item_upgraded_boots"
end

function modifier_item_upgraded_boots:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_upgraded_boots:OnRefresh( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_upgraded_boots:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}

	return funcs
end

function modifier_item_upgraded_boots:GetModifierMoveSpeedBonus_Percentage_Unique()
	return self.movespeed
end

function modifier_item_upgraded_boots:GetModifierMoveSpeedBonus_Special_Boots()
	return self.movespeed
end

function modifier_item_upgraded_boots:GetModifierPhysicalArmorBonusUnique()
	return self.armor
end

function modifier_item_upgraded_boots:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end

function modifier_item_upgraded_boots:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "cleric_mass_heal" then
		return 0
	end

	if szSpecialValueName == "radius" then
		--print( 'modifier_item_upgraded_boots:GetModifierOverrideAbilitySpecial - looking for max_charges!' )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_item_upgraded_boots:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "cleric_mass_heal" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "radius" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		--print( 'modifier_item_upgraded_boots:GetModifierOverrideAbilitySpecialValue - max_charges is ' .. flBaseValue .. '. Adding on an additional ' .. self.max_charges )

		return flBaseValue + 500
	end

	return 0
end