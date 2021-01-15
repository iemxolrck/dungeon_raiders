modifier_bard_inspire_evasion = class({})

function modifier_bard_inspire_evasion:IsHidden()
	return true
end

function modifier_bard_inspire_evasion:IsDebuff()
	return false
end

function modifier_bard_inspire_evasion:IsPurgable()
	return true
end

function modifier_bard_inspire_evasion:OnCreated( kv )
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )/100
end

function modifier_bard_inspire_evasion:OnRefresh( kv )
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )/100
end

function modifier_bard_inspire_evasion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_bard_inspire_evasion:GetModifierEvasion_Constant()
	return self:GetStackCount()
end