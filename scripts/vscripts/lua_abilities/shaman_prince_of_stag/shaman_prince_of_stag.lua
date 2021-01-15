shaman_prince_of_stag = class({})

LinkLuaModifier( "modifier_shaman_prince_of_stag", "lua_abilities/shaman_prince_of_stag/modifier_shaman_prince_of_stag", LUA_MODIFIER_MOTION_NONE )

function shaman_prince_of_stag:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local distance = self:GetCastRange( Vector(0,0,0), nil )
	
	local front = caster:GetForwardVector():Normalized()
	local back = RotatePosition( Vector(0,0,0), QAngle( 0, -180, 0 ), front )
	local start = caster:GetOrigin() + back * distance
	local target = caster:GetOrigin() + front * distance

	-- load data
	local damage = 100
	local vision_radius = 100
	local reduction = 1-0.2
	
	local projectile_name = "particles/econ/items/keeper_of_the_light/kotl_stag/keeper_of_the_light_illuminate_stag.vpcf"
	local projectile_speed = 2500
	local projectile_distance = distance*2
	local projectile_radius = 100
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()
	self.count = 0

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = start,
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	--self:PlayEffects( start, target )

	-- register projectile data
	self.projectiles[projectile] = {}
	self.projectiles[projectile].damage = damage
	self.projectiles[projectile].reduction = reduction


end

shaman_prince_of_stag.projectiles = {}

function shaman_prince_of_stag:OnProjectileHitHandle( target, location, handle )
	if not target then
		-- unregister projectile
		self.projectiles[handle] = nil

		-- create Vision
		local vision_radius = 100
		local vision_duration = 10
		AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, false )

		return
	end

	-- get data
	local data = self.projectiles[handle]
	local damage = data.damage

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- reduce damage
	data.damage = damage * data.reduction

	-- Play effects
	local sound_cast = "Hero_Windrunner.PowershotDamage"
	EmitSoundOn( sound_cast, target )

	self.count = self.count + 1
	if self.count>=5 then
		return true
	end
end



function shaman_prince_of_stag:PlayEffects( origin, target )

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate.vpcf"
	local sound_cast = "Ability.LagunaBladeImpact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(
		effect_cast,
		0,
		origin
	)
	ParticleManager:SetParticleControl(
		effect_cast,
		1,
		target
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function shaman_prince_of_stag:OnProjectileThink( location )
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, 100, 1,false )
end