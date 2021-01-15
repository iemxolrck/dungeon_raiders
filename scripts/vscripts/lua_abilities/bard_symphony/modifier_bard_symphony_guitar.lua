modifier_bard_symphony_guitar = class({})

function modifier_bard_symphony_guitar:IsHidden()
	return false
end

function modifier_bard_symphony_guitar:IsDebuff()
	return false
end

function modifier_bard_symphony_guitar:OnCreated( kv )

end

function modifier_bard_symphony_guitar:OnRefresh( kv )

end

function modifier_bard_symphony_guitar:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}

	return funcs
end

function modifier_bard_symphony_guitar:GetModifierEvasion_Constant()
	return	self:GetAbility():GetSpecialValueFor( "evasion" )
end

function modifier_bard_symphony_guitar:GetEffectName()
	return	"particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
end

function modifier_bard_symphony_guitar:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end