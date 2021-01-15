modifier_warlock_eldritch_blast = class({})

function modifier_warlock_eldritch_blast:IsHidden()
	return true
end

function modifier_warlock_eldritch_blast:IsPurgable()
	return false
end

function modifier_warlock_eldritch_blast:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_warlock_eldritch_blast:OnCreated( kv )
	local delay = self:GetAbility():GetSpecialValueFor( "damage_delay" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.count = 4
	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage/4,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	self:StartIntervalThink(delay/4)
end

function modifier_warlock_eldritch_blast:OnRefresh( kv )
end

function modifier_warlock_eldritch_blast:OnRemoved()
end

function modifier_warlock_eldritch_blast:OnDestroy()
end

function modifier_warlock_eldritch_blast:OnIntervalThink()
	if not IsServer() then return end
	if self.count==0 then self:Destroy() end

	ApplyDamage(self.damageTable)
	self.count = self.count-1 
end