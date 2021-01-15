modifier_bard_charisma = class({})

function modifier_bard_charisma:IsHidden()
	return false
end

function modifier_bard_charisma:IsAura()
	return true
end

function modifier_bard_charisma:IsPurgable()
	return false
end

function modifier_bard_charisma:OnCreated()
	self.exp_gain = self:GetAbility():GetSpecialValueFor( "exp_gain" )
	self.self_multiplier = self:GetAbility():GetSpecialValueFor( "self_multiplier" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_bard_charisma:OnRefresh()
	self.exp_gain = self:GetAbility():GetSpecialValueFor( "exp_gain" )
	self.self_multiplier = self:GetAbility():GetSpecialValueFor( "self_multiplier" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_bard_charisma:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
	}

	return funcs
end

function modifier_bard_charisma:GetModifierPercentageExpRateBoost()
	return self.exp_gain * self.self_multiplier
end

function modifier_bard_charisma:GetModifierAura()
	return "modifier_bard_charisma_aura"
end

function modifier_bard_charisma:GetAuraRadius()
	return self.radius
end

function modifier_bard_charisma:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()

end

function modifier_bard_charisma:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_bard_charisma:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_bard_charisma:GetAuraEntityReject(hEntity)
	if IsServer() then
		local caster = self:GetCaster()
		if hEntity==caster then
			return true
		else
			return false
		end
	end
end