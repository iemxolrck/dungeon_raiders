dragon_knight_breathe_fire_lua = class({})

LinkLuaModifier( "modifier_dragon_knight_breathe_fire_lua", "lua_abilities/dragon_knight_breathe_fire_lua/modifier_dragon_knight_breathe_fire_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_knight_breathe_fire_shoot", "lua_abilities/dragon_knight_breathe_fire_lua/modifier_dragon_knight_breathe_fire_shoot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_knight_breathe_fire_proc", "lua_abilities/dragon_knight_breathe_fire_lua/modifier_dragon_knight_breathe_fire_proc", LUA_MODIFIER_MOTION_NONE )

function dragon_knight_breathe_fire_lua:GetIntrinsicModifierName()
	return "modifier_dragon_knight_breathe_fire_proc"
end

function dragon_knight_breathe_fire_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- unit target just indicates point
	if target then point = target:GetOrigin() end

	local value1 = self:GetSpecialValueFor("some_value")
	
	local projectile_name = "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "range" )
	local projectile_start_radius = self:GetSpecialValueFor( "start_radius" )
	local projectile_end_radius = self:GetSpecialValueFor( "end_radius" )
	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local projectile_direction = point - caster:GetOrigin()
	local origin = caster:GetAbsOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = origin,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetType = self:GetAbilityTargetType(),

	    bProvidesVision = true,
	    iVisionRadius = 300,
	    iVisionTeamNumber = caster:GetTeamNumber(),
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}

	ProjectileManager:CreateLinearProjectile(info)
	origin = caster:GetAbsOrigin() + caster:GetRightVector():Normalized() * 350

	local info1 = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = origin,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetType = self:GetAbilityTargetType(),

	    bProvidesVision = true,
	    iVisionRadius = 300,
	    iVisionTeamNumber = caster:GetTeamNumber(),
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}

	--ProjectileManager:CreateLinearProjectile(info1)
	origin = caster:GetAbsOrigin() + caster:GetRightVector():Normalized() * -350

	local info2 = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = origin,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetType = self:GetAbilityTargetType(),

	    bProvidesVision = true,
	    iVisionRadius = 300,
	    iVisionTeamNumber = caster:GetTeamNumber(),
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}

	--ProjectileManager:CreateLinearProjectile(info2)
	if 1 == 0 then
		caster:AddNewModifier(
				caster,
				self,
				"modifier_dragon_knight_breathe_fire_shoot",
				{ duration = 0.25}
			)
	end
	
	local sound_cast = "Hero_DragonKnight.BreathFire"
	EmitSoundOn( sound_cast, caster )
end

function dragon_knight_breathe_fire_lua:OnIntervalThink()
	if IsServer() then
		local current_health = self:GetCaster():GetHealth()
		print(current_health)
		if current_health == 1 then
			self:AddNewModifier(
				self:GetCaster(),
				self,
				"modifier_cleric_divine_protection_invincible",
				{ }
			)

		end
	end
end
--------------------------------------------------------------------------------
-- Projectile
function dragon_knight_breathe_fire_lua:OnProjectileHitHandle( target, location, iHandle )
	if not IsServer() then return end
	if not target then return end

	-- load data
	local damage = self:GetAbilityDamage()
	local duration = self:GetSpecialValueFor( "duration" )

	local filter = UnitFilter(
		target,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		self:GetCaster():GetTeamNumber()
	)
	if filter~=UF_SUCCESS then
		-- nothing happened
		return false
	end

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- debuff
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_dragon_knight_breathe_fire_lua", -- modifier name
		{ duration = duration } -- kv
	)
end