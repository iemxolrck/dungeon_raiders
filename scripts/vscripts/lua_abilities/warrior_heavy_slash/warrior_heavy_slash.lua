warrior_heavy_slash = class({})

LinkLuaModifier( "modifier_warrior_heavy_slash", "lua_abilities/warrior_heavy_slash/modifier_warrior_heavy_slash", LUA_MODIFIER_MOTION_NONE )

function warrior_heavy_slash:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then
		return
	end

	-- load data
	local damage = self:GetSpecialValueFor("crit_mult")
	local radius = self:GetSpecialValueFor("radius")

	local buff = caster:AddNewModifier(
		caster, 
		self, 
		"modifier_warrior_heavy_slash", 
		{ } 
	)

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
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
	end

	if caster:HasModifier("modifier_warrior_heavy_slash")==true then
		caster:FindModifierByNameAndCaster("modifier_warrior_heavy_slash", caster):Destroy()
	end

	-- Play effects
	self:PlayEffects( target )
end

function warrior_heavy_slash:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf"
	local sound_cast = "Hero_Centaur.DoubleEdge"

	-- Get Data
	local forward = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
	ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end