modifier_engineer_scan_debuff = class({})

function modifier_engineer_scan_debuff:IsHidden()
	return false
end

function modifier_engineer_scan_debuff:IsDebuff()
	return true
end

function modifier_engineer_scan_debuff:IsPurgable()
	return true
end

function modifier_engineer_scan_debuff:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_engineer_scan_debuff:OnCreated( kv )
	self.movement_slow = -self:GetAbility():GetSpecialValueFor( "movement_slow" )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	self.resist_reduction = -self:GetAbility():GetSpecialValueFor( "resist_reduction" )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	self.miss_chance = self:GetAbility():GetSpecialValueFor( "miss_chance" )
	self:GetParent():SetAggroTarget(self:GetCaster())
end

function modifier_engineer_scan_debuff:OnRefresh( kv )
self.movement_slow = -self:GetAbility():GetSpecialValueFor( "movement_slow" )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	self.resist_reduction = -self:GetAbility():GetSpecialValueFor( "resist_reduction" )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	self.miss_chance = self:GetAbility():GetSpecialValueFor( "miss_chance" )
end

function modifier_engineer_scan_debuff:OnDestroy( kv )
	
end

function modifier_engineer_scan_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_NEGATIVE_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}

	return funcs
end

function modifier_engineer_scan_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.movement_slow 
end

function modifier_engineer_scan_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction 
end

function modifier_engineer_scan_debuff:GetModifierStatusResistanceStacking()
	return self.resist_reduction 
end

function modifier_engineer_scan_debuff:GetModifierNegativeEvasion_Constant()
	return self.evasion 
end

function modifier_engineer_scan_debuff:GetModifierMiss_Percentage()
	return self.miss_chance 
end

function modifier_engineer_scan_debuff:GetModifierProvidesFOWVision()
	return 1
end

function modifier_engineer_scan_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end