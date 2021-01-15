modifier_bard_symphony_guitar = class({})

function modifier_bard_symphony_guitar:IsHidden()
	return false
end

function modifier_bard_symphony_guitar:IsDebuff()
	return false
end

function modifier_bard_symphony_guitar:OnCreated( kv )
	self.attack_damage_percent = self:GetAbility():GetSpecialValueFor( "attack_damage_percent" )
end

function modifier_bard_symphony_guitar:OnRefresh( kv )
	self.OnCreated( kv )
end

function modifier_bard_symphony_guitar:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_bard_symphony_guitar:GetModifierBaseDamageOutgoing_Percentage()
	return self.attack_damage_percent
end

function modifier_bard_symphony_guitar:GetEffectName()
	return	"particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
end

function modifier_bard_symphony_guitar:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end