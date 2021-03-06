marksman_triple_shot_third_arrow = class({})

function marksman_triple_shot_third_arrow:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()
	local angle = 33.33

	local direction = point-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	local slide_pos = point-caster:GetOrigin()

	self.count = 0

	local projectile_name = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_v2.vpcf"
	local projectile_speed = self:GetSpecialValueFor("arrow_speed")
	local projectile_distance = self:GetCastRange( Vector(0,0,0), nil ) + self:GetCaster():GetCastRangeBonus()
	local projectile_start_radius = self:GetSpecialValueFor("arrow_width")
	local projectile_end_radius = self:GetSpecialValueFor("arrow_width")
	local projectile_vision = self:GetSpecialValueFor("arrow_vision")

	local min_damage = self:GetAbilityDamage()
	local bonus_damage = self:GetSpecialValueFor( "arrow_bonus_damage" )
	local min_stun = self:GetSpecialValueFor( "arrow_min_stun" )
	local max_stun = self:GetSpecialValueFor( "arrow_max_stun" )
	local max_distance = self:GetSpecialValueFor( "arrow_max_stunrange" )

	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()
	projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, 11.11, 0 ), direction )

	local bonus_speed = 0
	local ability = self:GetCaster():FindAbilityByName( "marksman_piercing" )
	if ability and ability:GetLevel()>0 then
		bonus_speed = ability:GetLevelSpecialValueFor( "projectile_speed", ability:GetLevel()-1 ) -- zero-based
		projectile_speed = projectile_speed + bonus_speed
	end

	info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),

		ExtraData = {
			originX = origin.x,
			originY = origin.y,
			originZ = origin.z,

			max_distance = max_distance,
			min_stun = min_stun,
			max_stun = max_stun,

			min_damage = min_damage,
			bonus_damage = bonus_damage,

			arrow_count = 2,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

end

function marksman_triple_shot_third_arrow:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	if hTarget==nil then return end

	-- calculate distance percentage
	local origin = Vector( extraData.originX, extraData.originY, extraData.originZ )
	local distance = (vLocation-origin):Length2D()
	local bonus_pct = math.min(1,distance/extraData.max_distance)

	local damageTable = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = extraData.min_damage + extraData.bonus_damage*bonus_pct,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun
	hTarget:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = math.max(extraData.min_stun, extraData.max_stun*bonus_pct) } -- kv
	)

	AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, 500, 3, false )

	-- effects
	local sound_cast = "Hero_Mirana.ArrowImpact"
	EmitSoundOn( sound_cast, hTarget )

	self.count = self.count + 1
	if self.count>=2 then
		return true
	end

end