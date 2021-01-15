modifier_bard_discord_lyre_aura = class({})

function modifier_bard_discord_lyre_aura:IsHidden()
	return false
end

function modifier_bard_discord_lyre_aura:IsAura()
	return true
end

function modifier_bard_discord_lyre_aura:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_bard_discord_lyre_aura:OnRefresh()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_bard_discord_lyre_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function modifier_bard_discord_lyre_aura:OnTooltip()
	return self:GetAbility():GetSpecialValueFor( "crit_rate" )
end

function modifier_bard_discord_lyre_aura:GetModifierAura()
	return "modifier_bard_discord_lyre"
end

function modifier_bard_discord_lyre_aura:GetAuraRadius()
	return self.radius
end

function modifier_bard_discord_lyre_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY

end

function modifier_bard_discord_lyre_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_bard_discord_lyre_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_bard_discord_lyre_aura:GetAuraEntityReject(hEntity)
	if IsServer() then
		local caster = self:GetCaster()
		if hEntity==caster then
			return true
		else
			return false
		end
	end
end