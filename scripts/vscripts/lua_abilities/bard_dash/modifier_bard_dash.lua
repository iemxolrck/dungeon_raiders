modifier_bard_dash = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bard_dash:IsHidden()
	return false
end

function modifier_bard_dash:IsDebuff()
	return false
end

function modifier_bard_dash:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bard_dash:OnCreated( kv )
	-- references
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
	self.distance = self:GetAbility():GetSpecialValueFor( "distance" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then
		self.direction = Vector( kv.x, kv.y, 0 )
		self.origin = self:GetParent():GetOrigin()

		-- Start interval
		self:StartIntervalThink(0)

		-- effects
		self:PlayEffects()
	end
end

function modifier_bard_dash:OnRefresh( kv )	
end

function modifier_bard_dash:OnDestroy( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_bard_dash:OnRemoved( kv )
	if IsServer() then
		-- effects
		if self.pre_collide then
			ParticleManager:SetParticleControl( self.effect_cast, 3, self.pre_collide )
		else
			ParticleManager:SetParticleControl( self.effect_cast, 3, self:GetParent():GetOrigin() )
		end
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_bard_dash:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_bard_dash:OnIntervalThink()
	-- apply motion controller
	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
		return
	end

	-- launch projectile
	local info = {
		Source = self:GetCaster(),
		Ability = self:GetAbility(),
		vSpawnOrigin = self:GetParent():GetAbsOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
	    iUnitTargetType = DOTA_UNIT_TARGET_ALL,
	    
	    EffectName = "",
	    fDistance = self.distance,
	    fStartRadius = self.radius,
	    fEndRadius =self.radius,
		vVelocity = self.direction * self.speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
	}
	ProjectileManager:CreateLinearProjectile(info)
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_bard_dash:UpdateHorizontalMotion( me, dt )
	local pos = self:GetParent():GetOrigin()
	
	-- stop if already past distance
	if (pos-self.origin):Length2D()>=self.distance then
		self:Destroy()
		return
	end

	-- set position
	local target = pos + self.direction * (self.speed*dt)

	-- change position
	self:GetParent():SetOrigin( target )
end

function modifier_bard_dash:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_bard_dash:End( vector )
	self.pre_collide = vector
	self:Destroy()
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_bard_dash:PlayEffects()
	-- Get Resources
	-- local particle_cast = "particles/units/heroes/hero_earth_spirit/espirit_rollingboulder.vpcf"
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_gyroshell.vpcf"
	local particle_cast_0 = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler_dash_rope.vpcf"
	
	-- Get Data

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self.effect_cast_0 = ParticleManager:CreateParticle( particle_cast_0, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	self:AddParticle(
		self.effect_cast_0,
		false,
		false,
		-1,
		false,
		false
	)

end