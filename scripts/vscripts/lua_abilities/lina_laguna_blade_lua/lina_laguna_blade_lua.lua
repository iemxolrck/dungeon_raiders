-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
lina_laguna_blade_lua = class({})
LinkLuaModifier( "modifier_lina_laguna_blade_lua", "lua_abilities/lina_laguna_blade_lua/modifier_lina_laguna_blade_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Cast Filter
function lina_laguna_blade_lua:CastFilterResultTarget( hTarget )
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

--------------------------------------------------------------------------------
-- Ability Start
function lina_laguna_blade_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local distance = self:GetCastRange( Vector(0,0,0), nil )
	
	local front = caster:GetForwardVector():Normalized()
	local back = RotatePosition( Vector(0,0,0), QAngle( 0, -180, 0 ), front )
	local start = caster:GetOrigin() + back * distance
	local target = caster:GetOrigin() + front * distance

	-- Play effects
	self:PlayEffects( start, target )

	-- load data
	local delay = self:GetSpecialValueFor( "damage_delay" )

	-- add modfier
	--[[target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_lina_laguna_blade_lua", -- modifier name
		{ duration = delay } -- kv
	)]]
end

--------------------------------------------------------------------------------
function lina_laguna_blade_lua:PlayEffects( origin, target )

	-- Get Resources
	local particle_cast = "particles/econ/items/beastmaster/bm_shoulder_ti7/bm_shoulder_ti7_roar_model.vpcf"
	local sound_cast = "Ability.LagunaBladeImpact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(
		effect_cast,
		0,
		origin
	)
	ParticleManager:SetParticleControl(
		effect_cast,
		1,
		target
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end