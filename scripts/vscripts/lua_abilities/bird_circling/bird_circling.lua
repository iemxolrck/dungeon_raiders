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
bird_circling = class({})
LinkLuaModifier( "modifier_wisp_ambient", "lua_abilities/bird_circling/modifier_wisp_ambient", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bird_circling", "lua_abilities/bird_circling/modifier_bird_circling", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bird_circling_attack", "lua_abilities/bird_circling/modifier_bird_circling_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dark_willow_bedlam_lua_cast", "lua_abilities/bird_circling/modifier_dark_willow_bedlam_lua_cast", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function bird_circling:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "roaming_duration" )

	-- add buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_dark_willow_bedlam_lua_cast", -- modifier name
		{ } -- kv
	)

end
--------------------------------------------------------------------------------
-- Projectile
function bird_circling:OnProjectileHit_ExtraData( target, location, ExtraData )
	-- destroy effect projectile
	local effect_cast = ExtraData.effect
	ParticleManager:DestroyParticle( effect_cast, false )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if not target then return end

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster():GetOwner(),
		damage = ExtraData.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
end