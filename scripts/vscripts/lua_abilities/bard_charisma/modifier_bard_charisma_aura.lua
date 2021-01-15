modifier_bard_charisma_aura = class({})

function modifier_bard_charisma_aura:IsHidden()
	return false
end

function modifier_bard_charisma_aura:IsDebuff()
	return false
end

function modifier_bard_charisma_aura:IsPurgable()
	return false
end

function modifier_bard_charisma_aura:OnCreated( kv )
	self.exp_gain = self:GetAbility():GetSpecialValueFor( "exp_gain" )
end

function modifier_bard_charisma_aura:OnRefresh( kv )
	self.exp_gain = self:GetAbility():GetSpecialValueFor( "exp_gain" )
end

function modifier_bard_charisma_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
	}

	return funcs
end

function modifier_bard_charisma_aura:GetModifierPercentageExpRateBoost()
	return self.exp_gain
end

--[[function modifier_bard_charisma_aura:GetEffectName()
	return	"particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
end

function modifier_bard_charisma_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end]]