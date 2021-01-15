modifier_bard_discord_lyre = class({})

function modifier_bard_discord_lyre:IsHidden()
	return false
end

function modifier_bard_discord_lyre:IsDebuff()
	return true
end

function modifier_bard_discord_lyre:OnCreated( kv )
	
end

function modifier_bard_discord_lyre:OnRefresh( kv )
	
end

function modifier_bard_discord_lyre:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function modifier_bard_discord_lyre:OnTooltip()
	return self:GetAbility():GetSpecialValueFor( "crit_rate" )
end

function modifier_bard_discord_lyre:GetEffectName()
	return	"particles/units/heroes/hero_morphling/morphling_morph_str.vpcf"
end

function modifier_bard_discord_lyre:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end