modifier_bard_inspire_attack_speed = class({})

function modifier_bard_inspire_attack_speed:IsHidden()
	return true
end

function modifier_bard_inspire_attack_speed:IsDebuff()
	return false
end

function modifier_bard_inspire_attack_speed:IsPurgable()
	return true
end

function modifier_bard_inspire_attack_speed:OnCreated( kv )
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )/100
end

function modifier_bard_inspire_attack_speed:OnRefresh( kv )
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )/100
end

function modifier_bard_inspire_attack_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_bard_inspire_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end