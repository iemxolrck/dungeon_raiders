modifier_marksman_barrage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_marksman_barrage:IsHidden()
	return false
end

function modifier_marksman_barrage:IsDebuff()
	return false
end

function modifier_marksman_barrage:IsStunDebuff()
	return false
end

function modifier_marksman_barrage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_marksman_barrage:OnCreated( kv )
	-- references
	local count = self:GetAbility():GetSpecialValueFor( "arrow_count" )
	self.width = self:GetAbility():GetSpecialValueFor( "arrow_width" )
	self.speed = self:GetAbility():GetSpecialValueFor( "arrow_speed" )
	
	-- self.angle = self:GetAbility():GetSpecialValueFor( "arrow_angle" )
	self.angle = 33.33

	if not IsServer() then return end
	local vision = 100
	local delay = 0.1
	local wave = 5
	local wave_interval = 0.2
	self.arrow_delay = 0

	-- calculate stuff
	self.arrows = count/wave
	self.wave_delay = wave_interval - self.arrow_delay*(self.arrows-1)

	-- get projectile main direction
	local point = Vector(kv.x, kv.y, kv.z)
	self.range = kv.range
	self.direction = point-self:GetCaster():GetOrigin()
	self.direction.z = 0
	self.direction = self.direction:Normalized()

	-- set states
	self.state = STATE_SALVO
	self.current_arrows = 0
	self.current_wave = 0
	self.frost = false

	local bonus_speed = 0
	local ability = self:GetCaster():FindAbilityByName( "marksman_piercing" )
	if ability and ability:GetLevel()>0 then
		bonus_speed = ability:GetLevelSpecialValueFor( "projectile_speed", ability:GetLevel()-1 ) -- zero-based
		self.speed = self.speed + bonus_speed
	end

	-- check frost arrows ability
	local ability = self:GetCaster():FindAbilityByName( "drow_ranger_frost_arrows_lua" )
	if ability and ability:GetLevel()>0 then
		self.frost = true
	end

	-- precache projectile
	local caster = self:GetCaster()
	local projectile_name = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf"
	--local projectile_name = "particles/units/heroes/hero_drow/drow_base_attack_linear_proj.vpcf"
	self.projectile_name = {
		"particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot.vpcf",
		"particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_v2.vpcf",
		"particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
	}

	self.info = {
		Source = caster,
		Ability = self:GetAbility(),
		--vSpawnOrigin = caster:GetAttachmentOrigin( caster:ScriptLookupAttachment( "attach_attack1" ) ),
		--vSpawnOrigin = caster:GetOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = self:GetAbility():GetAbilityTargetTeam(),
	    iUnitTargetType = self:GetAbility():GetAbilityTargetType(),
	    iUnitTargetFlags = self:GetAbility():GetAbilityTargetFlags(),

	    --EffectName = projectile_name,
	    fDistance = self.range,
	    fStartRadius = self.width,
	    fEndRadius = self.width,
		-- vVelocity = projectile_direction * self.speed,
	
		bProvidesVision = true,
		iVisionRadius = vision,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	-- ProjectileManager:CreateLinearProjectile(info)

	-- Start interval
	self:StartIntervalThink( delay )

	-- play effects
	local sound_cast = "Hero_DrowRanger.Multishot.Channel"
	EmitSoundOn( sound_cast, caster )
end

function modifier_marksman_barrage:OnRefresh( kv )
end

function modifier_marksman_barrage:OnRemoved()
end

function modifier_marksman_barrage:OnDestroy()
	if not IsServer() then return end

	-- stop effects
	local sound_cast = "Hero_DrowRanger.Multishot.Channel"
	StopSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_marksman_barrage:OnIntervalThink()
	-- count arrows
	if self.current_arrows<self.arrows then

		self:StartIntervalThink( self.arrow_delay )
	else
		self.current_arrows = 0
		self.current_wave = self.current_wave+1

		self:StartIntervalThink( self.wave_delay )
		return
	end

	local front = self:GetCaster():GetForwardVector():Normalized()
	local direction = self:GetCaster():GetOrigin() + front * self.range
	direction = direction - self:GetCaster():GetOrigin()

	-- calculate relative angle of current arrow against cast direction
	local step = self.angle/(self.arrows-1)
	local angle = -self.angle/2 + self.current_arrows*step

	-- calculate actual direction
	direction.z = 0
	direction = direction:Normalized()
	local projectile_direction = direction
	local angler = RandomInt( -10,10 )
	self.info.EffectName = self.projectile_name[RandomInt( 1,3 )]
	self.info.vSpawnOrigin = self:GetCaster():GetOrigin()
	projectile_direction = RotatePosition( Vector(0,0,0), QAngle( 0, angler, 0 ), direction )

	-- launch projectile
	self.info.vVelocity = projectile_direction * self.speed
	self.info.ExtraData = {
		arrow = self.current_arrows,
		wave = self.current_wave,
		frost = self.frost,
	}
	ProjectileManager:CreateLinearProjectile(self.info)

	self:PlayEffects()

	self.current_arrows = self.current_arrows+1
end

function modifier_marksman_barrage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end

function modifier_marksman_barrage:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_3
end

function modifier_marksman_barrage:GetOverrideAnimationRate()
	return 2
end

function modifier_marksman_barrage:GetModifierDisableTurning()
	return 1
end

function modifier_marksman_barrage:PlayEffects()
	-- Get Resources
	local sound_cast
	if self.frost then
		sound_cast = "Hero_DrowRanger.Multishot.FrostArrows"
	else
		sound_cast = "Hero_DrowRanger.Multishot.Attack"
	end

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

