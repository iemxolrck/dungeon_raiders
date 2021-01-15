marksman_splinter_shot = class({})

--LinkLuaModifier( "modifier_marksman_splinter_shot", "lua_abilities/marksman_splinter_shot/modifier_marksman_splinter_shot", LUA_MODIFIER_MOTION_NONE )

function marksman_splinter_shot:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	self.point = self:GetCursorPosition()

	-- load data
	local damage = self:GetAbilityDamage()
	local vision_radius = self:GetSpecialValueFor( "arrow_vision" )
	
	local projectile_name = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_v2.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "arrow_speed" )
	local projectile_distance = self:GetCastRange( Vector(0,0,0), nil ) + self:GetCaster():GetCastRangeBonus()
	local projectile_radius = self:GetSpecialValueFor( "arrow_width" )
	local projectile_direction = self.point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()
	self.count = 0

	local bonus_speed = 0
	local ability = self:GetCaster():FindAbilityByName( "marksman_piercing" )
	if ability and ability:GetLevel()>0 then
		bonus_speed = ability:GetLevelSpecialValueFor( "projectile_speed", ability:GetLevel()-1 ) -- zero-based
		projectile_speed = projectile_speed + bonus_speed
	end

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

	self.projectiles[projectile] = {}
	self.projectiles[projectile].damage = damage
	--self.projectiles[projectile].reduction = reduction

	local sound_cast = "Ability.Powershot"
	EmitSoundOn( sound_cast, caster )
end

marksman_splinter_shot.projectiles = {}

function marksman_splinter_shot:OnProjectileHitHandle( target, location, handle )
	if not target then
		-- unregister projectile
		self.projectiles[handle] = nil

		-- create Vision
		local vision_radius = self:GetSpecialValueFor( "arrow_vision" )
		local vision_duration = self:GetSpecialValueFor( "vision_duration" )
		AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, false )

		return
	end

	local radius = self:GetSpecialValueFor( "splinter_radius" )
	local angle = self:GetSpecialValueFor( "splinter_angle" )/2
	local max_target = self:GetSpecialValueFor( "max_target" )

	local origin = target:GetOrigin()
	local cast_direction = (self.point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y
	
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	local splinter = {
		Source = target,
		Ability = self,	
		
		EffectName = self:GetCaster():GetRangedProjectileName(),
		iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
		bDodgeable = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
	
		bDrawsOnMinimap = false,
		bVisibleToEnemies = true,
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),

	}
	
	
	self.count = self.count + 1

	if self.count<=1 then
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			origin,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			0,
			false
		)

		for _,enemy in pairs(enemies) do
			splinter.Target = enemy
			local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
			local enemy_angle = VectorToAngles( enemy_direction ).y
			local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
			if angle_diff<=angle then
				ProjectileManager:CreateTrackingProjectile(splinter)
				--[[ attack
				self:GetCaster():PerformAttack(
					enemy,
					true,
					true,
					true,
					true,
					true,
					false,
					true
				)]]
			end
		end

	end

	local sound_cast = "Hero_Windrunner.PowershotDamage"
	EmitSoundOn( sound_cast, target )

	if self.count>=1 then
		return true
	end
end

function marksman_splinter_shot:OnProjectileThink( location )
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, 100, 1,false )
end