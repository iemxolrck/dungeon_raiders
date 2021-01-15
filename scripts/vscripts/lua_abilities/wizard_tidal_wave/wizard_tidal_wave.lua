wizard_tidal_wave = class({})

LinkLuaModifier( "modifier_generic_drenched", "lua_abilities/generic/modifier_generic_drenched", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned", "lua_abilities/generic/modifier_generic_stunned", LUA_MODIFIER_MOTION_NONE )

function wizard_tidal_wave:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function wizard_tidal_wave:OnSpellStart()
	-- unit identifier
	self:SetFrozenCooldown(true)
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- Play effects
	local sound_cast = "Ability.PowershotPull"
	--EmitSoundOnLocationForAllies( caster:GetOrigin(), sound_cast, caster )
end

function wizard_tidal_wave:OnChannelFinish( bInterrupted )
	if not IsServer() then return end
	self:SetFrozenCooldown(false)
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local max_distance = self:GetCastRange( Vector(0,0,0), nil ) + self:GetCaster():GetCastRangeBonus()
	local min_distance = self:GetSpecialValueFor( "min_distance" )
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()

	-- load data
	local damage = self:GetAbilityDamage()
	local vision_radius = self:GetSpecialValueFor( "radius" )
	
	local projectile_name =	"particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "wave_speed" )
	local projectile_radius = self:GetSpecialValueFor( "radius" )
	local projectile_distance = min_distance + math.floor( ( max_distance - min_distance ) * channel_pct )
	local projectile_direction = point-caster:GetOrigin()

	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	self.count = 0

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetFlags = self:GetAbilityTargetFlags(),
	    iUnitTargetType = self:GetAbilityTargetType(),
	    
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
	local sound_cast = "Ability.GushCast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function wizard_tidal_wave:OnProjectileHitHandle( target, location, handle )
	if not target then return end
	local inRiver = target:GetAbsOrigin().z <= 0.5

	if target:HasModifier("modifier_generic_burned")==true then
		local modifier = target:FindModifierByName("modifier_generic_burned")
		modifier:Destroy()
	end

	local duration = self:GetSpecialValueFor( "drenched_duration" )

	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = self:GetAbilityDamageType(),
		ability = self,
	}
	ApplyDamage(damageTable)

	if inRiver then
		target:AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_generic_stunned",
			{ duration = 1 }
		)
	end
		
	target:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_generic_drenched",
		{ duration = duration }
	)

	-- Play effects
	local sound_cast = "Ability.GushImpact"
	EmitSoundOn( sound_cast, target )

	self.count = self.count + 1
	if self.count>=5 then
		--return true
	end
end

function wizard_tidal_wave:OnProjectileThink( location )
	local radius = self:GetSpecialValueFor( "radius" )
	GridNav:DestroyTreesAroundPoint(location, radius, false)
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, 100, 1,false )
end