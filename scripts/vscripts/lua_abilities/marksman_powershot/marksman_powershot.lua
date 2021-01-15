marksman_powershot = class({})

function marksman_powershot:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function marksman_powershot:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- Play effects
	local sound_cast = "Ability.PowershotPull"
	EmitSoundOnLocationForAllies( caster:GetOrigin(), sound_cast, caster )
end

function marksman_powershot:OnChannelFinish( bInterrupted )
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()

	-- load data
	local damage = self:GetSpecialValueFor( "powershot_damage" )
	local reduction = 1-self:GetSpecialValueFor( "damage_reduction" )
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	
	local projectile_name = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "arrow_speed" )
	local projectile_distance = self:GetCastRange( Vector(0,0,0), nil ) + self:GetCaster():GetCastRangeBonus()
	print(projectile_distance)
	local projectile_radius = self:GetSpecialValueFor( "arrow_width" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()
	self.count = 0

	local bonus_speed = 0
	local ability = self:GetCaster():FindAbilityByName( "marksman_piercing" )
	if ability and ability:GetLevel()>0 then
		bonus_speed = ability:GetLevelSpecialValueFor( "projectile_speed", ability:GetLevel()-1 ) -- zero-based
		projectile_speed = projectile_speed + bonus_speed
	end

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
marksman_powershot.projectiles = {}

function marksman_powershot:OnProjectileHitHandle( target, location, handle )
	if not target then
		-- unregister projectile
		self.projectiles[handle] = nil

		-- create Vision
		local vision_radius = self:GetSpecialValueFor( "vision_radius" )
		local vision_duration = self:GetSpecialValueFor( "vision_duration" )
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

function marksman_powershot:OnProjectileThink( location )
	local tree_width = self:GetSpecialValueFor( "tree_width" )
	GridNav:DestroyTreesAroundPoint(location, tree_width, false)
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, 100, 1,false )

end