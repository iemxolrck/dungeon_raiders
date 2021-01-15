marksman_ankle_shot = class({})

LinkLuaModifier( "modifier_marksman_ankle_shot", "lua_abilities/marksman_ankle_shot/modifier_marksman_ankle_shot", LUA_MODIFIER_MOTION_NONE )

function marksman_ankle_shot:GetCharges()
	local max_charge = self:GetSpecialValueFor( "AbilityCharges" )
	return 10
end

function marksman_ankle_shot:GetChargeRestoreTime()
	local charge_restore = self:GetSpecialValueFor( "AbilityChargeRestoreTime" )
	return 15
end

function marksman_ankle_shot:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local damage = self:GetAbilityDamage()
	local vision_radius = self:GetSpecialValueFor( "arrow_vision" )
	
	local projectile_name = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "arrow_speed" )
	local projectile_distance = self:GetCastRange( Vector(0,0,0), nil ) + self:GetCaster():GetCastRangeBonus()
	local projectile_radius = self:GetSpecialValueFor( "arrow_width" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()
	self.count = 0

	local bonus_speed = 0
	local ability = caster:FindAbilityByName( "marksman_piercing" )
	if ability and ability:GetLevel()>0 then
		bonus_speed = ability:GetLevelSpecialValueFor( "projectile_speed", ability:GetLevel()-1 ) -- zero-based
	end
	projectile_speed = projectile_speed + bonus_speed
	print(bonus_speed)


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

marksman_ankle_shot.projectiles = {}

function marksman_ankle_shot:OnProjectileHitHandle( target, location, handle )
	if not target then
		-- unregister projectile
		self.projectiles[handle] = nil

		-- create Vision
		local vision_radius = self:GetSpecialValueFor( "arrow_vision" )
		local vision_duration = self:GetSpecialValueFor( "vision_duration" )
		AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, false )

		return
	end

	local data = self.projectiles[handle]
	local damage = data.damage

	local duration = self:GetSpecialValueFor( "max_duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	
	self.count = self.count + 1

	if self.count<=1 then
		target:AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_marksman_ankle_shot",
			{ duration = duration }
		)
	end

	local sound_cast = "Hero_Windrunner.PowershotDamage"
	EmitSoundOn( sound_cast, target )

	if self.count>=5 then
		return true
	end
end

function marksman_ankle_shot:OnProjectileThink( location )
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, 100, 1,false )
end