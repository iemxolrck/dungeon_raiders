modifier_bard_inspire_crit_rate = class({})

function modifier_bard_inspire_crit_rate:IsHidden()
	return true
end

function modifier_bard_inspire_crit_rate:IsDebuff()
	return false
end

function modifier_bard_inspire_crit_rate:IsPurgable()
	return true
end

function modifier_bard_inspire_crit_rate:OnCreated( kv )
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )/100
end

function modifier_bard_inspire_crit_rate:OnRefresh( kv )
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )/100
end

function modifier_bard_inspire_crit_rate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end