modifier_bard_inspire_target = class({})

function modifier_bard_inspire_target:IsHidden()
	return false
end

function modifier_bard_inspire_target:IsDebuff()
	return false
end

function modifier_bard_inspire_target:IsPurgable()
	return true
end

function modifier_bard_inspire_target:OnCreated( kv )
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )
end

function modifier_bard_inspire_target:OnRefresh( kv )
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )
end

function modifier_bard_inspire_target:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_bard_inspire_target:OnTooltip()
	return self.multiplier
end

function modifier_bard_inspire_target:GetEffectName()
	return	"particles/units/heroes/hero_siren/naga_siren_song_debuff_d.vpcf"
end

function modifier_bard_inspire_target:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end