modifier_ranger_heighten_senses = class({})

function modifier_ranger_heighten_senses:IsHidden()
	return false
end

function modifier_ranger_heighten_senses:IsDebuff()
	return false
end

function modifier_ranger_heighten_senses:IsPurgable()
	return false
end

function modifier_ranger_heighten_senses:OnCreated( kv )
	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.thinker = kv.isProvidedByAura~=1

end

function modifier_ranger_heighten_senses:OnRefresh( kv )
	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.thinker = kv.isProvidedByAura~=1

end

function modifier_ranger_heighten_senses:OnRemoved()

end

function modifier_ranger_heighten_senses:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end
end

function modifier_ranger_heighten_senses:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS_PERCENTAGE

	}

	return funcs
end

function modifier_ranger_heighten_senses:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_ranger_heighten_senses:GetModifierProjectileSpeedBonusPercentage()
	return self.projectile_speed
end

function modifier_ranger_heighten_senses:CheckState()
	local state = {
		[MODIFIER_STATE_UNSLOWABLE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end


function modifier_ranger_heighten_senses:IsAura()
	return self.thinker
end

function modifier_ranger_heighten_senses:GetModifierAura()
	return "modifier_ranger_heighten_senses_aura"
end

function modifier_ranger_heighten_senses:GetAuraRadius()
	return self.radius
end

function modifier_ranger_heighten_senses:GetAuraDuration()
	return 1
end

function modifier_ranger_heighten_senses:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_ranger_heighten_senses:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_ranger_heighten_senses:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end