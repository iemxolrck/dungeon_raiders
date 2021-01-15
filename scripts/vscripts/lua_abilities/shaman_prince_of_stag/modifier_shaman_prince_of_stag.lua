modifier_shaman_prince_of_stag = class({})

function modifier_shaman_prince_of_stag:IsHidden()
	return true
end

function modifier_shaman_prince_of_stag:IsPurgable()
	return false
end

function modifier_shaman_prince_of_stag:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_shaman_prince_of_stag:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	if self:GetCaster():HasScepter() then
		self.type = DAMAGE_TYPE_PURE
	else
		self.type = DAMAGE_TYPE_MAGICAL
	end
end

function modifier_shaman_prince_of_stag:OnRefresh( kv )
end

function modifier_shaman_prince_of_stag:OnRemoved()
end

function modifier_shaman_prince_of_stag:OnDestroy()
	if not IsServer() then return end

	-- cancel if magic immune or invulnerable
	if self:GetParent():IsInvulnerable() then return end
	if self:GetParent():IsMagicImmune() and (not self:GetCaster():HasScepter()) then return end	

	-- cancel if linken
	if self:GetParent():TriggerSpellAbsorb( self:GetAbility() ) then return end

	-- apply damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self.type,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
end