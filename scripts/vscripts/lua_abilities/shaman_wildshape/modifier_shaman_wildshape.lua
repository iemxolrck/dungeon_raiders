modifier_shaman_wildshape = class({})

function modifier_shaman_wildshape:IsHidden()
	return false
end

function modifier_shaman_wildshape:IsDebuff()
	return false
end

function modifier_shaman_wildshape:IsPurgable()
	return false
end

function modifier_shaman_wildshape:OnCreated()
	local particle_effects = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(particle_effects, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_effects, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_effects)

	self.attackCapability = DOTA_UNIT_CAP_NO_ATTACK
	self.max_attack = self:GetAbility():GetSpecialValueFor( "max_attack" )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.fixed_vision = self:GetAbility():GetSpecialValueFor( "fixed_vision" )
	self:SetStackCount(self.max_attack)
	if IsServer() then
		self.attack_capacity = self:GetParent():GetAttackCapability()
		self:GetParent():SetAttackCapability(0)
		self:StartIntervalThink(0)
	end
end

function modifier_shaman_wildshape:OnRefresh()
	self.attackCapability = DOTA_UNIT_CAP_NO_ATTACK
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.fixed_vision = self:GetAbility():GetSpecialValueFor( "fixed_vision" )
	if IsServer() then
		self:GetParent():SetAttackCapability(0)
	end
end

function modifier_shaman_wildshape:OnRemoved()
	if IsServer() then
		local particle_effects = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(particle_effects, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_effects, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_effects)
		self:GetParent():SetAttackCapability(self.attack_capacity)
	end
end

function modifier_shaman_wildshape:OnDestroy()
	if IsServer() then
		local particle_effects = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(particle_effects, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_effects, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_effects)
		self:GetParent():SetAttackCapability(self.attack_capacity)
	end
end

function modifier_shaman_wildshape:OnIntervalThink()
	if not IsServer() then return end
	local radius = self:GetParent():GetCurrentVisionRange()

	AddFOWViewer( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), radius, 0.1, false )
end

function modifier_shaman_wildshape:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
		
	}

	return funcs
end

function modifier_shaman_wildshape:GetModifierModelChange()
	return "models/heroes/beastmaster/beastmaster_bird.vmdl"
end

function modifier_shaman_wildshape:GetDisableHealing()
	return 1
end

function modifier_shaman_wildshape:GetModifierAttackRangeOverride()
	return 600
end

function modifier_shaman_wildshape:GetModifierMoveSpeed_Absolute()
	return self.movespeed
end

function modifier_shaman_wildshape:GetModifierModelScale()
	return 0
end

function modifier_shaman_wildshape:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_shaman_wildshape:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_shaman_wildshape:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_shaman_wildshape:GetFixedDayVision()
	return self.fixed_vision
end

function modifier_shaman_wildshape:GetFixedNightVision()
	return self.fixed_vision
end

function modifier_shaman_wildshape:OnTakeDamageKillCredit( params )
	if not IsServer() then return end
	if params.target~=self:GetParent() then return end
	self:DecrementStackCount()
	local health = self:GetStackCount()
	if health<=0 then self:Destroy() end
end

function modifier_shaman_wildshape:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
		--[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end