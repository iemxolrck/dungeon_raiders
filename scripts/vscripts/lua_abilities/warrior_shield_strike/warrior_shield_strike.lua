warrior_shield_strike = class({})

LinkLuaModifier( "modifier_warrior_shield_strike", "lua_abilities/warrior_shield_strike/modifier_warrior_shield_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warrior_shield_strike_block", "lua_abilities/warrior_shield_strike/modifier_warrior_shield_strike_block", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "lua_abilities/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )

function warrior_shield_strike:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	--local point = self:GetCursorPosition()

	local range = self:GetCastRange(caster:GetAbsOrigin(), nil )
	local front = self:GetCaster():GetForwardVector():Normalized()
	local point = self:GetCaster():GetOrigin() + front * range

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	caster:AddNewModifier(
		caster, 
		self, 
		"modifier_warrior_shield_strike_block", 
		{ duration = 1 } 
	)

	
	local buff = caster:AddNewModifier(
		caster, 
		self, 
		"modifier_warrior_shield_strike", 
		{  } 
	)

	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			caster:PerformAttack(
				enemy,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)

			-- knockback if not having spear stun
			if not enemy:HasModifier( "modifier_mars_spear_of_mars_lua_debuff" ) then
				enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_generic_knockback_lua", -- modifier name
					{
						duration = duration,
						distance = distance,
						height = 30,
						direction_x = enemy_direction.x,
						direction_y = enemy_direction.y,
					} -- kv
				)
			end

			caught = true

			-- play effects
			self:PlayEffects2( enemy, origin, cast_direction )
		end
	end
	
	if caster:HasModifier("modifier_warrior_shield_strike")==true then
		caster:FindModifierByNameAndCaster("modifier_warrior_shield_strike", caster):Destroy()
	end
	
	self:PlayEffects1( caught, (point-origin):Normalized() )
end

--------------------------------------------------------------------------------
-- Play Effects
function warrior_shield_strike:PlayEffects1( caught, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"
	local sound_cast = "Hero_Mars.Shield.Cast"
	if not caught then
		local sound_cast = "Hero_Mars.Shield.Cast.Small"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function warrior_shield_strike:PlayEffects2( target, origin, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"
	local sound_cast = "Hero_Mars.Shield.Crit"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end