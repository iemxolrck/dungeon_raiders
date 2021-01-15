modifier_bard_discord_flute = class({})

function modifier_bard_discord_flute:IsHidden()
	return false
end

function modifier_bard_discord_flute:IsDebuff()
	return true
end

function modifier_bard_discord_flute:OnCreated( kv )
	
end

function modifier_bard_discord_flute:OnRefresh( kv )
	
end

function modifier_bard_discord_flute:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_bard_discord_flute:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

function modifier_bard_discord_flute:GetEffectName()
	return	"particles/units/heroes/hero_morphling/morphling_morph_str.vpcf"
end

function modifier_bard_discord_flute:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end