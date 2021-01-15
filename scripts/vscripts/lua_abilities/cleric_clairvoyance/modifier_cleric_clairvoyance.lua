modifier_cleric_clairvoyance = class({})

function modifier_cleric_clairvoyance:IsHidden()
	return true
end

function modifier_cleric_clairvoyance:IsDebuff()
	return false
end

function modifier_cleric_clairvoyance:IsStunDebuff()
	return false
end

function modifier_cleric_clairvoyance:IsPurgable()
	return false
end

function modifier_cleric_clairvoyance:OnCreated( kv )
	-- references
	--self:GetParent():HasFlyingVision()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end

	-- precache effects

	-- Play effects
	--self:PlayEffects()
end

function modifier_cleric_clairvoyance:OnRefresh( kv )
	--self:GetParent():HasFlyingVision()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	
end

function modifier_cleric_clairvoyance:OnRemoved()
end

function modifier_cleric_clairvoyance:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end

function modifier_cleric_clairvoyance:IsAura()
	if self:GetCaster() == self:GetParent() then
		if not self:GetCaster():PassivesDisabled() then
			return true
		else
			return false
		end
	end
end

function modifier_cleric_clairvoyance:GetModifierAura()
	return "modifier_cleric_clairvoyance_aura"
end

function modifier_cleric_clairvoyance:GetAuraRadius()
	return self.radius
end

function modifier_cleric_clairvoyance:GetAuraDuration()
	return 0.5
end

function modifier_cleric_clairvoyance:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_cleric_clairvoyance:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_cleric_clairvoyance:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD 
end