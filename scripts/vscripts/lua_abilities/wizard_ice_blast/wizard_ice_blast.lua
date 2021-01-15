wizard_ice_blast = class({})

LinkLuaModifier( "modifier_generic_chilled", "lua_abilities/generic/modifier_generic_chilled", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_frozen", "lua_abilities/generic/modifier_generic_frozen", LUA_MODIFIER_MOTION_NONE )

function wizard_ice_blast:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function wizard_ice_blast:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function wizard_ice_blast:OnChannelFinish()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	
	local projectile_direction = ( point - caster:GetAbsOrigin()):Normalized()
	local projectile_distance = (point - caster:GetAbsOrigin()):Length2D()
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local projectile_radius = self:GetSpecialValueFor( "radius" )
	
	local vision_duration = self:GetSpecialValueFor( "vision_duration" )
	local chilled_duration = self:GetSpecialValueFor( "chilled_duration" )
	local frozen_duration = self:GetSpecialValueFor( "frozen_duration" )
	
	self.damageTable = {
		attacker = caster,
		damage = self:GetSpecialValueFor("frozen_damage"),
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "particles/units/heroes/hero_aa/aa_ice_blastfinal.vpcf",
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bProvidesVision = false,
		iVisionRadius = projectile_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = {
			chilled_duration = chilled_duration,
			frozen_duration = frozen_duration,
			vision_duration = vision_duration,
		}
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	local sound_cast = "Hero_Ancient_Apparition.IceBlastRelease.Cast.Self"
	EmitSoundOn( sound_cast, caster )
end
	
function wizard_ice_blast:OnProjectileHit_ExtraData(target, position, extraData)
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor( "area_of_effect" )

	if target then
		if target:HasModifier("modifier_generic_burned")==false
			and target:HasModifier("modifier_generic_frozen")==false then
			target:AddNewModifier(
				caster,
				self,
				"modifier_generic_chilled",
				{ duration = extraData.chilled_duration }
			)	
		end
	else
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			position,
			nil,
			radius,
			self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			0,
			false
		)

		for _, enemy in ipairs(enemies) do
			if enemy:HasModifier("modifier_generic_burned")==false then
				if enemy:HasModifier("modifier_generic_frozen")==true then
					self.damageTable.victim = enemy
					ApplyDamage(self.damageTable)
				end 
				enemy:AddNewModifier(
					caster,
					self,
					"modifier_generic_frozen",
					{ duration = extraData.frozen_duration }
				)
			end
		end

		AddFOWViewer( caster:GetTeamNumber(), position, radius + 100, extraData.vision_duration, false)

		self:PlayEffects( position, caster )
	end
end

function wizard_ice_blast:OnProjectileThink( location )
	local radius = self:GetSpecialValueFor( "area_of_effect" )
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, radius/2, 1,false )
end

function wizard_ice_blast:PlayEffects(  position, caster )
	local groundPos = GetGroundPosition(position, caster) + Vector(0,0,10)

	local explosion_particle = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_explode.vpcf"
	local particle = ParticleManager:CreateParticle(explosion_particle, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(particle, 0, groundPos)
	ParticleManager:SetParticleControl(particle, 3, groundPos)
	
	EmitSoundOnLocationWithCaster(position, "Hero_Ancient_Apparition.IceBlast.Target", caster)
end