modifier_paladin_hollowed_ground_reduction = class({})

function modifier_paladin_hollowed_ground_reduction:IsHidden()
	return false
end

function modifier_paladin_hollowed_ground_reduction:IsDebuff()
	return false
end

function modifier_paladin_hollowed_ground_reduction:IsPurgable()
	return false
end

function modifier_paladin_hollowed_ground_reduction:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_paladin_hollowed_ground_reduction:OnCreated( kv )
	self.damage = 0
	self.damage_reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.reduction = 100 - self.damage_reduction

end

function modifier_paladin_hollowed_ground_reduction:OnRefresh( kv )
	
end

function modifier_paladin_hollowed_ground_reduction:OnRemoved()

end

function modifier_paladin_hollowed_ground_reduction:OnDestroy()

end

function modifier_paladin_hollowed_ground_reduction:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
		MODIFIER_PROPERTY_MIN_HEALTH
	}

	return funcs
end

function modifier_paladin_hollowed_ground_reduction:GetModifierIncomingDamage_Percentage( params )
	if not IsServer() then return end
	if params.target==self:GetCaster() then return end
	local damage = params.damage
	self.damage = damage
	return -self.damage_reduction
end

function modifier_paladin_hollowed_ground_reduction:OnTakeDamageKillCredit( params )
	if not IsServer() then return end
	if params.target==self:GetCaster() then return end
	if params.target~=self:GetParent() then return end
	local damage = self.damage - params.damage
	local damageTable = {
		victim = self:GetCaster(),
		attacker = params.attacker,
		damage = damage,
		damage_type = params.damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
		ability = params.inflictor,
	}
	ApplyDamage(damageTable)
	return
end

function modifier_paladin_hollowed_ground_reduction:GetMinHealth()
	if self:GetParent()~=self:GetCaster() then return end
	if not self:GetParent():HasModifier("modifier_paladin_iron_skin") then return end
	return 1
end