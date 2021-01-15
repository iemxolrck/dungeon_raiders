modifier_warlock_shadowraze = class({})

function modifier_warlock_shadowraze:IsHidden()
	return false
end

function modifier_warlock_shadowraze:IsDebuff()
	return false
end

function modifier_warlock_shadowraze:IsPurgable()
	return false
end

function modifier_warlock_shadowraze:OnCreated( kv )
	
end

function modifier_warlock_shadowraze:OnRefresh( kv )
	
end

function modifier_warlock_shadowraze:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_warlock_shadowraze:OnDeath( params )
	if not IsServer() then return end
	if params.attacker~=self:GetCaster() then return end
	if params.inflictor~=self:GetAbility() then return end
	local cd = self:GetAbility():GetCooldownTimeRemaining()
	if cd<=1 then return end
	self:GetAbility():EndCooldown()
	self:GetAbility():StartCooldown(math.max(cd-1,1))
end