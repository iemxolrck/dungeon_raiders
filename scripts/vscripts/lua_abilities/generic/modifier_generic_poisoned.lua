modifier_generic_poisoned = class({})

function modifier_generic_poisoned:IsHidden()
	return false
end

function modifier_generic_poisoned:IsDebuff()
	return true
end

function modifier_generic_poisoned:IsStunDebuff()
	return false
end

function modifier_generic_poisoned:IsPurgable()
	return true
end

function modifier_generic_poisoned:GetTexture()
	return "status/modifier_generic_poisoned"
end

function modifier_generic_poisoned:OnCreated( kv )
	-- references
	self.damage = 50 --Max Health as damage
	self.bonus_damage = 0.05 --Missing health as bonus damage
	self.count = 0

	if not IsServer() then return end

	local interval = 1

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	self:StartIntervalThink( interval )
end

function modifier_generic_poisoned:OnRefresh( kv )
	self.damage = 50 --Max Health as damage
	self.bonus_damage = 0.05 --Missing health as bonus damage
	
end

function modifier_generic_poisoned:OnRemoved()
end

function modifier_generic_poisoned:OnDestroy()
end

function modifier_generic_poisoned:OnIntervalThink()
	if not IsServer() then return end
	local damage = math.floor( self.damage * ( 1 + (self.count * self.bonus_damage ) ) )
	self.damageTable.damage = damage
	ApplyDamage( self.damageTable )
	self.count = self.count + 1
end

function modifier_generic_poisoned:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_generic_poisoned:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end