modifier_bard_symphony_flute = class({})

function modifier_bard_symphony_flute:IsHidden()
	return false
end

function modifier_bard_symphony_flute:IsDebuff()
	return false
end

function modifier_bard_symphony_flute:OnCreated( kv )
	
end

function modifier_bard_symphony_flute:OnRefresh( kv )
	
end

function modifier_bard_symphony_flute:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_bard_symphony_flute:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

function modifier_bard_symphony_flute:GetEffectName()
	return	"particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
end

function modifier_bard_symphony_flute:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end