modifier_ranger_smokescreen_debuff = class({})

function modifier_ranger_smokescreen_debuff:IsHidden()
	return false
end

function modifier_ranger_smokescreen_debuff:IsDebuff()
	return true
end

function modifier_ranger_smokescreen_debuff:IsStunDebuff()
	return false
end

function modifier_ranger_smokescreen_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ranger_smokescreen_debuff:OnCreated( kv )
	-- references
	local interval = self:GetAbility():GetSpecialValueFor( "interval" )
	local damage = self:GetAbility():GetSpecialValueFor( "suffocate_damage" )
	self.slow = -self:GetAbility():GetSpecialValueFor( "slow" )
	self.miss_chance = -self:GetAbility():GetSpecialValueFor( "miss_chance" )
	self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end

	self.damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )

	self.sound_cast = "Hero_Riki.Smoke_Screen"

	-- Play effects
	self:PlayEffects()
end

function modifier_ranger_smokescreen_debuff:OnRefresh( kv )
	
end

function modifier_ranger_smokescreen_debuff:OnRemoved()

end

function modifier_ranger_smokescreen_debuff:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end

function modifier_ranger_smokescreen_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER
	}

	return funcs
end

function modifier_ranger_smokescreen_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_ranger_smokescreen_debuff:GetModifierMiss_Percentage()
	return self.miss_chance
end

function modifier_ranger_smokescreen_debuff:GetModifierNoVisionOfAttacker()
	return 1
end

function modifier_ranger_smokescreen_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_BLIND] = true,
	}

	return state
end

function modifier_ranger_smokescreen_debuff:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end
end

function modifier_ranger_smokescreen_debuff:IsAura()
	return self.thinker
end

function modifier_ranger_smokescreen_debuff:GetModifierAura()
	return "modifier_ranger_smokescreen_debuff"
end

function modifier_ranger_smokescreen_debuff:GetAuraRadius()
	return self.radius
end

function modifier_ranger_smokescreen_debuff:GetAuraDuration()
	return 0.5
end

function modifier_ranger_smokescreen_debuff:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_ranger_smokescreen_debuff:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_ranger_smokescreen_debuff:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_ranger_smokescreen_debuff:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_ranger_smokescreen_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ranger_smokescreen_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/items2_fx/smoke_of_deceit.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	particle_cast = "particles/units/heroes/hero_riki/riki_smokebomb.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	
	particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance_sceptor_outer_smoke.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	EmitSoundOn( self.sound_cast, self:GetParent() )
end