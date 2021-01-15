modifier_warlock_soulbind_target = class({})

function modifier_warlock_soulbind_target:IsHidden()
	return false
end

function modifier_warlock_soulbind_target:IsDebuff()
	return true
end

function modifier_warlock_soulbind_target:IsStunDebuff()
	return false
end

function modifier_warlock_soulbind_target:IsPurgable()
	return false
end

function modifier_warlock_soulbind_target:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_warlock_soulbind_target:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_reflect" ) / 100
	self.heal = self:GetAbility():GetSpecialValueFor( "heal_percent" ) / 100
	
	self.distance = 600
	self.min_distance = self.distance - 100
	self.speed = 0
	
	self:StartIntervalThink(0)
	if not IsServer() then return end
	self:PlayEffects()
end

function modifier_warlock_soulbind_target:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_reflect" ) / 100
	self.heal = self:GetAbility():GetSpecialValueFor( "heal_percent" ) / 100
	self.distance = 600
end

function modifier_warlock_soulbind_target:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end

function modifier_warlock_soulbind_target:OnDestroy( kv )
	if IsServer() then
		-- destroy the pair, if still exist
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end

function modifier_warlock_soulbind_target:OnIntervalThink()
	if not IsServer() then return end
	local distance = math.max(math.min( math.floor((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()) , self.distance ),self.min_distance)
	self.speed = math.floor(((distance-self.min_distance)/(self.distance-self.min_distance))*100)
end

function modifier_warlock_soulbind_target:Bind()
	if not IsServer() then return end
	-- get info
	local vectorToPair = self:GetCaster():GetOrigin() - self:GetParent():GetOrigin()
	local facingAngle = self:GetParent():GetAnglesAsVector().y

	-- calculate facing angle
	local angleToPair = VectorToAngles(vectorToPair).y
	local angleDifference = math.abs(AngleDiff( angleToPair, facingAngle ))

	-- calculate distance
	local distanceToPair = vectorToPair:Length2D()

	-- check if it is within boundaries
	if distanceToPair < self.distance - 100 then
		-- within limit
		self.limit = self.normal_ms_limit

	elseif distanceToPair < self.distance then
		-- slowed if facing away
		if angleDifference > 90 then
			-- slow interpolates linearly between buffer radius and chain radius
			local interpolate = math.min( (distanceToPair-self.distance)/100, 1 )

			-- slow inversely related with interpolation
			self.limit = (1-interpolate) * self.normal_ms_limit

			-- 0 limit means no limit
			if self.limit < 1 then
				self.limit = 0.01
			end
		else
			-- not slowed if facing towards pair
			self.limit = self.normal_ms_limit
		end

		-- interrupts weak motion controllers
		self:GetParent():InterruptMotionControllers( true )
	else
		return 0.1
	end
end

function modifier_warlock_soulbind_target:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_warlock_soulbind_target:GetModifierProvidesFOWVision()
    return 1
end

function modifier_warlock_soulbind_target:GetModifierMoveSpeedBonus_Percentage()
	if not IsServer() then return end
    return -self.speed
end

function modifier_warlock_soulbind_target:OnTakeDamage( keys )
	if IsServer() then 
		if keys.inflictor~=nil then
			if keys.inflictor:GetName()==self:GetAbility():GetName() then return end
		end
		if keys.unit==self:GetParent() and keys.attacker==self:GetCaster() then
			local heal = keys.damage + self.heal
			self:GetCaster():Heal( heal, self:GetAbility() )
		end
		if keys.unit==self:GetCaster() and keys.attacker==self:GetParent() then
			local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = keys.damage * self.damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility(),
			}
			ApplyDamage( damage )
		end
	end

end

function modifier_warlock_soulbind_target:OnHealReceived( keys )
	if not IsServer() then return end
	if keys.inflictor and keys.inflictor~=self:GetAbility() then
		if keys.unit~=self:GetParent() then return end
		local heal = keys.gain + self.heal
		self:GetCaster():Heal( heal, self:GetAbility() )
	end
end

function modifier_warlock_soulbind_target:OnDeath( keys )
	if not IsServer() then return end
	if keys.unit==self:GetCaster() then
		if keys.attacker==self:GetParent() then
			self:GetParent():Kill( self:GetAbility() ,self:GetCaster() )
		end
		self:Destroy()
	end
end

function modifier_warlock_soulbind_target:CheckState()

	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_UNSLOWABLE] = false
	}

	return state
end

function modifier_warlock_soulbind_target:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_grimstroke/grimstroke_soulchain_marker.vpcf"
	local sound_target = "Hero_Grimstroke.SoulChain.Target"

	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast1,
		2,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		nil,
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false,
		false,
		-1,
		false,
		false
	)
	local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )

	self:AddParticle(
		effect_cast2,
		false,
		false,
		-1,
		false,
		true
	)
	self:PlayEffects2()

	EmitSoundOn( sound_target, target )
end

function modifier_warlock_soulbind_target:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf"
	local sound_cast = "Hero_Grimstroke.SoulChain.Partner"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )

end

function modifier_warlock_soulbind_target:PlayEffects3()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_grimstroke/grimstroke_soulchain_proc.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_grimstroke/grimstroke_soulchain_proc_tgt.vpcf"

	-- Create chain proc particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast1, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create main proc particle
	effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create pair proc particle
	effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end