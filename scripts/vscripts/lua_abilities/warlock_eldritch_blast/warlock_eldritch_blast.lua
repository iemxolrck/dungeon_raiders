warlock_eldritch_blast = class({})

LinkLuaModifier( "modifier_warlock_eldritch_blast", "lua_abilities/warlock_eldritch_blast/modifier_warlock_eldritch_blast", LUA_MODIFIER_MOTION_NONE )

function warlock_eldritch_blast:CastFilterResultTarget( hTarget )
	if hTarget:IsMagicImmune() and (not self:GetCaster():HasScepter()) then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end

	if not IsServer() then return UF_SUCCESS end
	local nResult = UnitFilter(
		hTarget,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		self:GetCaster():GetTeamNumber()
	)

	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function warlock_eldritch_blast:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Play effects
	self:PlayEffects( target )

	-- load data

	-- add modfier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_warlock_eldritch_blast", -- modifier name
		{} -- kv
	)
end

function warlock_eldritch_blast:PlayEffects( target )

	-- Get Resources
	local particle_cast = "particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf"
	local sound_cast = "Hero_Lion.FingerOfDeath"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end