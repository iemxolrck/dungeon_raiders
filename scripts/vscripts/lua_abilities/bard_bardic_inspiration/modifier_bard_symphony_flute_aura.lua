modifier_bard_symphony_flute_aura = class({})

function modifier_bard_symphony_flute_aura:IsHidden()
	return false
end

function modifier_bard_symphony_flute_aura:IsAura()
	return true
end

function modifier_bard_symphony_flute_aura:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_bard_symphony_flute_aura:OnRefresh()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_bard_symphony_flute_aura:GetModifierAura()
	return "modifier_bard_symphony_flute"
end

function modifier_bard_symphony_flute_aura:GetAuraRadius()
	return self.radius
end

function modifier_bard_symphony_flute_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY

end

function modifier_bard_symphony_flute_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_bard_symphony_flute_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_bard_symphony_flute_aura:GetAuraEntityReject(hEntity)
	if IsServer() then
		local caster = self:GetCaster()
		if hEntity==caster then
			return true
		else
			return false
		end
	end
end