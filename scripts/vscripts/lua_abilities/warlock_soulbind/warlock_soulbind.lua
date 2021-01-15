warlock_soulbind = class({})

LinkLuaModifier( "modifier_warlock_soulbind", "lua_abilities/warlock_soulbind/modifier_warlock_soulbind", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warlock_soulbind_target", "lua_abilities/warlock_soulbind/modifier_warlock_soulbind_target", LUA_MODIFIER_MOTION_NONE )

function warlock_soulbind:GetIntrinsicModifierName()
	return "modifier_warlock_soulbind"
end

function warlock_soulbind:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local effect = true

	if target:TriggerSpellAbsorb( self ) then return end

	local duration = self:GetSpecialValueFor( "duration" )
	if target:HasModifier("modifier_warlock_soulbind_target")==true then
		effect = false
	end


	target:AddNewModifier(
		caster,
		self,
		"modifier_warlock_soulbind_target",
		{ duration = duration }
	)

	--if effect==true then
		self:PlayEffects( target )
	--end
	local sound_cast = "Hero_Grimstroke.SoulChain.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
function warlock_soulbind:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_cast_soulchain.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
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
end