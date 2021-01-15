modifier_item_vigilance = class({})

function modifier_item_vigilance:IsHidden()
	return false
end

function modifier_item_vigilance:IsDebuff()
	return false
end

function modifier_item_vigilance:IsPurgable()
	return false
end

function modifier_item_vigilance:GetTexture()
	return "../items/shield/item_vigilance"
end


function modifier_item_vigilance:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
	self.str = self:GetAbility():GetSpecialValueFor( "str" )
	self.block = self:GetAbility():GetSpecialValueFor( "block" )
	self.iron_skin_resist = self:GetAbility():GetSpecialValueFor( "iron_skin_resist" )
end

function modifier_item_vigilance:OnRefresh( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
	self.str = self:GetAbility():GetSpecialValueFor( "str" )
	self.block = self:GetAbility():GetSpecialValueFor( "block" )
	self.iron_skin_resist = self:GetAbility():GetSpecialValueFor( "iron_skin_resist" )
end

function modifier_item_vigilance:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
	return funcs
end

function modifier_item_vigilance:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_item_vigilance:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end

function modifier_item_vigilance:GetModifierPhysical_ConstantBlock( params )
	if RandomInt(1,100)>self.block then return end
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BLOCKED , self:GetParent(), params.damage, nil )
	return params.damage
end

function modifier_item_vigilance:GetModifierBonusStats_Strength()
	return self.str
end

function modifier_item_vigilance:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then return 0 end

	local ability = params.ability:GetAbilityName()
	local value = params.ability_special_value

	if ability ~= "paladin_iron_skin" then return 0	end

	if value == "damage_resistance" then
		return 1
	end

	return 0
end 

function modifier_item_vigilance:GetModifierOverrideAbilitySpecialValue( params )
	local ability = params.ability:GetAbilityName() 
	if ability ~= "paladin_iron_skin" then return 0	end

	local value = params.ability_special_value
	if value == "damage_resistance" then
		local level = params.ability_special_level
		local basevalue = params.ability:GetLevelSpecialValueNoOverride( value, level )

		return basevalue + self.iron_skin_resist
	end

	return 0
end