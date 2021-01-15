shaman_minimize = class({})

LinkLuaModifier( "modifier_shaman_minimize", "lua_abilities/shaman_minimize/modifier_shaman_minimize", LUA_MODIFIER_MOTION_NONE )

function shaman_minimize:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- add buff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_shaman_minimize", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	self:PlayEffects( target )
end

function shaman_minimize:CastFilterResultTarget( hTarget )
	if not IsServer() then return end

	if hTarget:HasModifier("modifier_shaman_maximize") then
		return UF_FAIL_CUSTOM
	end

	local result = UnitFilter(
		hTarget,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		self:GetCaster():GetTeamNumber()
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS

end

function shaman_minimize:GetCustomCastErrorTarget( hTarget )
	if hTarget:HasModifier("modifier_shaman_maximize") then
		return "#dota_hud_error_cant_cast_on_maximized"
	else
		return
	end
end

function shaman_minimize:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf"
	local sound_cast = "Hero_OgreMagi.Bloodlust.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
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
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
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