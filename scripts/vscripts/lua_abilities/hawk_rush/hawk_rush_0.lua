hawk_rush = class({})

function hawk_rush:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- Play effects
	local sound_cast = "Ability.PowershotPull"
	EmitSoundOnLocationForAllies( caster:GetOrigin(), sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Ability Channeling
function hawk_rush:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local channel_pct = 1

	-- load data
	local damage = 100
	local reduction = 1-0.2
	local vision_radius = 500
	
	local projectile_name = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf"
	local projectile_speed = 2000
	local projectile_distance = 1000
	local projectile_radius = 200
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()
	self.count = 0

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
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

	-- register projectile data
	self.projectiles[projectile] = {}
	self.projectiles[projectile].damage = damage*channel_pct
	self.projectiles[projectile].reduction = reduction

	-- Play effects
	local sound_cast = "Ability.Powershot"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Projectile
-- projectile data table
hawk_rush.projectiles = {}

function hawk_rush:OnProjectileHitHandle( target, location, handle )
	if not target then
		-- unregister projectile
		self.projectiles[handle] = nil

		-- create Vision
		local vision_radius = 500
		local vision_duration = 1
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

function hawk_rush:OnProjectileThink( location )
	-- destroy trees
	local tree_width = 200
	GridNav:DestroyTreesAroundPoint(location, tree_width, false)
	

end