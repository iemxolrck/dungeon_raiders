modifier_bard_symphony_lyre = class({})

function modifier_bard_symphony_lyre:IsHidden()
	return false
end

function modifier_bard_symphony_lyre:IsDebuff()
	return false
end

function modifier_bard_symphony_lyre:OnCreated( kv )

end

function modifier_bard_symphony_lyre:OnRefresh( kv )
	
end

function modifier_bard_symphony_lyre:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function modifier_bard_symphony_lyre:OnTooltip()
	return	self:GetAbility():GetSpecialValueFor( "crit_rate" )
end

function modifier_bard_symphony_lyre:GetEffectName()
	return	"particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
end

function modifier_bard_symphony_lyre:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end