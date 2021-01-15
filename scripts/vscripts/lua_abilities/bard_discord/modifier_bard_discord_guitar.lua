modifier_bard_discord_guitar = class({})

function modifier_bard_discord_guitar:IsHidden()
	return false
end

function modifier_bard_discord_guitar:IsDebuff()
	return true
end

function modifier_bard_discord_guitar:OnCreated( kv )
	
end

function modifier_bard_discord_guitar:OnRefresh( kv )
	
end

function modifier_bard_discord_guitar:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}

	return funcs
end

function modifier_bard_discord_guitar:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor( "evasion" )
end

function modifier_bard_discord_guitar:GetEffectName()
	return	"particles/units/heroes/hero_morphling/morphling_morph_str.vpcf"
end

function modifier_bard_discord_guitar:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end