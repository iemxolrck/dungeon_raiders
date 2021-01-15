modifier_marksman_precision = class({})

function modifier_marksman_precision:IsHidden()
	return false
end

function modifier_marksman_precision:IsDebuff()
	return false
end

function modifier_marksman_precision:IsPurgable()
	return false
end

function modifier_marksman_precision:OnCreated( kv )
	self.attack_range = self:GetAbility():GetSpecialValueFor( "attack_range" )
	self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
	self.damage_percent = self:GetAbility():GetSpecialValueFor( "damage_per_distance" )
	self.min_range = 500
end

function modifier_marksman_precision:OnRefresh( kv )
	self.attack_range = self:GetAbility():GetSpecialValueFor( "attack_range" )
	self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
	self.damage_percent = self:GetAbility():GetSpecialValueFor( "damage_per_distance" )
	self.min_range = 500
end

function modifier_marksman_precision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		--MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		--MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_marksman_precision:GetModifierAttackRangeBonus()
	return self.attack_range
end

function modifier_marksman_precision:GetModifierCastRangeBonusStacking()
	return self.cast_range
end

function modifier_marksman_precision:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "item_basic_bow" then
		return 0
	end

	if szSpecialValueName == "attackrange" then
		--print( 'modifier_marksman_precision:GetModifierOverrideAbilitySpecial - looking for max_charges!' )
		return 1
	end

	return 0
end

function modifier_marksman_precision:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	--print(szAbilityName)
	if szAbilityName ~= "item_basic_bow" then
		return 0
	end
	print("izz bow")
	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "attackrange" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		--print( 'modifier_marksman_precision:GetModifierOverrideAbilitySpecialValue - max_charges is ' .. flBaseValue .. '. Adding on an additional ' .. self.max_charges )
		print(flBaseValue)
		return flBaseValue + self.attack_range
	end

	return 0
end