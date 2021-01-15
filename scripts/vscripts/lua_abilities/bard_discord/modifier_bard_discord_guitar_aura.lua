modifier_bard_discord_guitar_aura = class({})

function modifier_bard_discord_guitar_aura:IsHidden()
	return false
end

function modifier_bard_discord_guitar_aura:IsAura()
	return true
end

function modifier_bard_discord_guitar_aura:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_bard_discord_guitar_aura:OnRefresh()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_bard_discord_guitar_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function modifier_bard_discord_guitar_aura:OnTooltip()
	return self:GetAbility():GetSpecialValueFor( "evasion" )
end

function modifier_bard_discord_guitar_aura:GetModifierAura()
	return "modifier_bard_discord_guitar"
end

function modifier_bard_discord_guitar_aura:GetAuraRadius()
	return self.radius
end

function modifier_bard_discord_guitar_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY

end

function modifier_bard_discord_guitar_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_bard_discord_guitar_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_bard_discord_guitar_aura:GetAuraEntityReject(hEntity)
	if IsServer() then
		local caster = self:GetCaster()
		if hEntity==caster then
			return true
		else
			return false
		end
	end
end