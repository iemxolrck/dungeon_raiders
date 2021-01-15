modifier_generic_bleeding = class({})

function modifier_generic_bleeding:IsHidden()
	return false
end

function modifier_generic_bleeding:IsDebuff()
	return true
end

function modifier_generic_bleeding:IsStunDebuff()
	return false
end

function modifier_generic_bleeding:IsPurgable()
	return true
end

function modifier_generic_bleeding:GetTexture()
	return "status/modifier_generic_bleeding"
end

function modifier_generic_bleeding:OnCreated( kv )
	-- references
	self.damage = 0.05 --Max Health as damage
	self.bonus_damage = 0.1 --Missing health as bonus damage

	if not IsServer() then return end

	local interval = 1

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
	}
	
	self:Bleed()
	self:PlayEffects()

	self:StartIntervalThink( interval )
end

function modifier_generic_bleeding:OnRefresh( kv )
	-- references
	self.damage = 0.05 --Max Health as damage
	self.bonus_damage = 0.1 --Missing health as bonus damage
	
	if not IsServer() then return end
	self.damageTable.damage = damage
end

function modifier_generic_bleeding:OnRemoved()
end

function modifier_generic_bleeding:OnDestroy()
end

function modifier_generic_bleeding:OnIntervalThink()
	self:Bleed()
	self:PlayEffects()	
end

function modifier_generic_bleeding:Bleed()
	if not IsServer() then return end
	-- apply damage
	local max_health = self:GetParent():GetMaxHealth()
	local missing_health = max_health - self:GetParent():GetHealth()

	local damage = math.floor( ( max_health * self.damage ) + ( missing_health * self.bonus_damage ) )
	self.damageTable.damage = damage
	ApplyDamage( self.damageTable )
end


function modifier_generic_bleeding:PlayEffects()
	local blood = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(blood, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(blood)
end
