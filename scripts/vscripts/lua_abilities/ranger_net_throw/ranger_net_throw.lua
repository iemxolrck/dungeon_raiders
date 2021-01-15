ranger_net_throw = class({})

LinkLuaModifier( "modifier_ranger_net_throw", "lua_abilities/ranger_net_throw/modifier_ranger_net_throw", LUA_MODIFIER_MOTION_NONE )

function ranger_net_throw.OnAbilityPhaseStart(self)
    self.GetCaster(self).EmitSound(self.GetCaster(self),"Hero_Meepo.Earthbind.Cast")
    return true
end
function ranger_net_throw.OnAbilityPhaseInterrupted(self)
    self.GetCaster(self).StopSound(self.GetCaster(self),"Hero_Meepo.Earthbind.Cast")
end

ranger_net_throw.projectiles = {}

function ranger_net_throw:OnSpellStart()

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local max_target = self:GetSpecialValueFor( "max_target" )

	local projectile_name = "particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	-- create projectile
	self.info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(self.info)

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		target:GetOrigin(),
		nil,
		400,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		0,
		false
	)

	local count = 1
	for _,enemy in pairs(enemies) do
		if max_target == count then break end
		if enemy~=target and ( not enemy:HasModifier("modifier_ranger_net_throw") ) then
			self.info.Target = enemy
			ProjectileManager:CreateTrackingProjectile(self.info)
			count = count + 1
		end
	end

end

function ranger_net_throw:OnProjectileHit( target, location )
	if not target then return end
	if target:TriggerSpellAbsorb( self ) then return end

	local duration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():PerformAttack(
			target,
			true,
			true,
			true,
			true,
			false,
			false,
			true
		)
	target:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_ranger_net_throw",
		{ duration = duration }
	)

	local sound_cast = "Hero_Meepo.Earthbind.Target"
	EmitSoundOn( sound_cast, target )
end

--[[function ranger_net_throw:OnProjectileThinkHandle( iProjectileHandle )


	local tree_radius = 120
	local wall_radius = 50
	local building_radius = 30
	local blocker_radius = 70

	local location = ProjectileManager:GetTrackingProjectileLocation( iProjectileHandle )
	--data.location = location


	local arena_walls = Entities:FindAllByClassnameWithin( "npc_dota_phantomassassin_gravestone", location, wall_radius )
	for _,arena_wall in pairs(arena_walls) do
		if arena_wall:HasModifier( "modifier_mars_arena_of_blood_lua_blocker" ) then
			--ProjectileManager:DestroyLinearProjectile( self.info )
			return	true
		end
	end
end]]