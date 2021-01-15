ranger_latent_venom = class({})

LinkLuaModifier( "modifier_ranger_latent_venom", "lua_abilities/ranger_latent_venom/modifier_ranger_latent_venom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ranger_latent_venom_armor", "lua_abilities/ranger_latent_venom/modifier_ranger_latent_venom_armor", LUA_MODIFIER_MOTION_NONE )

function ranger_latent_venom:OnSpellStart()

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local projectile_name = "particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bReplaceExisting = false,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)

	local sound_cast = "Hero_QueenOfPain.ShadowStrike"
	EmitSoundOn( sound_cast, caster )
end

function ranger_latent_venom:OnProjectileHit( target, location )
	if target==nil or target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
		return
	end

	local duration = self:GetDuration()
	
	
	target:AddNewModifier(
		self:GetCaster(), 
		self, 
		"modifier_ranger_latent_venom", 
		{ duration = duration } 
	)	
end

function ranger_latent_venom:AbilityConsiderations()
	local bScepter = caster:HasScepter()
	local bBlocked = target:TriggerSpellAbsorb( self )
	local bBroken = caster:PassivesDisabled()
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()
	local bIllusion = target:IsIllusion()
end