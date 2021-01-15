modifier_item_chaos_staff = class({})

function modifier_item_chaos_staff:IsHidden()
	return false
end

function modifier_item_chaos_staff:IsDebuff()
	return false
end

function modifier_item_chaos_staff:IsPurgable()
	return false
end

function modifier_item_chaos_staff:GetTexture()
	return "../items/staff/item_chaos_staff"
end


function modifier_item_chaos_staff:OnCreated( kv )
	self.magical_damage = self:GetAbility():GetSpecialValueFor( "magical_damage" )
	self.castrange = self:GetAbility():GetSpecialValueFor( "castrange" )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
	self.critdamage = self:GetAbility():GetSpecialValueFor( "critdamage" )
	self.meteor_radius = self:GetAbility():GetSpecialValueFor( "meteor_radius" )
end

function modifier_item_chaos_staff:OnRefresh( kv )
	self.magical_damage = self:GetAbility():GetSpecialValueFor( "magical_damage" )
	self.castrange = self:GetAbility():GetSpecialValueFor( "castrange" )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
	self.critdamage = self:GetAbility():GetSpecialValueFor( "critdamage" )
	self.meteor_radius = self:GetAbility():GetSpecialValueFor( "meteor_radius" )
end

function modifier_item_chaos_staff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
	return funcs
end

function modifier_item_chaos_staff:GetModifierPreAttack_BonusDamage()
	return self.magical_damage
end

function modifier_item_chaos_staff:GetModifierCastRangeBonusStacking()
	return self.castrange
end

function modifier_item_chaos_staff:GetModifierBonusStats_Intellect()
	return self.int
end

function modifier_item_chaos_staff:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then return 0 end

	local ability = params.ability:GetAbilityName()
	local value = params.ability_special_value

	if ability ~= "wizard_meteor" then
		return 0
	end

	if value == "area_of_effect" or value == "inner_radius" then
		return 1
	end

	return 0
end

function modifier_item_chaos_staff:GetModifierOverrideAbilitySpecialValue( params )
	local ability = params.ability:GetAbilityName() 
	if ability ~= "wizard_meteor" then return 0	end

	local value = params.ability_special_value
	if value == "area_of_effect" or value == "inner_radius" then
		local level = params.ability_special_level
		local basevalue = params.ability:GetLevelSpecialValueNoOverride( value, level )

		return basevalue + self.meteor_radius
	end

	return 0
end