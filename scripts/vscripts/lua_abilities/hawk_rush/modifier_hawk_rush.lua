modifier_hawk_rush = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hawk_rush:IsHidden()
	return false
end

function modifier_hawk_rush:IsDebuff()
	return false
end

function modifier_hawk_rush:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_hawk_rush:OnCreated( kv )
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

function modifier_hawk_rush:OnRefresh( kv )	
end

function modifier_hawk_rush:OnDestroy( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_hawk_rush:OnRemoved( kv )
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
function modifier_hawk_rush:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_hawk_rush:OnIntervalThink()
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
	    
	    EffectName = "",--"particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf",
	    fDistance = self.distance,
	    fStartRadius = self.radius,
	    fEndRadius =self.radius,
		vVelocity = self.direction * self.speed,
	
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
	}
	ProjectileManager:CreateLinearProjectile(info)
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_hawk_rush:UpdateHorizontalMotion( me, dt )
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

function modifier_hawk_rush:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_hawk_rush:End( vector )
	self.pre_collide = vector
	self:Destroy()
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_hawk_rush:PlayEffects()
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