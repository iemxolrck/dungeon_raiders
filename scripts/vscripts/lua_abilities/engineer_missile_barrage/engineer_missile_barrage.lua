engineer_missile_barrage = class({})

LinkLuaModifier( "modifier_engineer_missile_barrage", "lua_abilities/engineer_missile_barrage/modifier_engineer_missile_barrage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_engineer_missile_barrage_thinker", "lua_abilities/engineer_missile_barrage/modifier_engineer_missile_barrage_thinker", LUA_MODIFIER_MOTION_NONE )

function engineer_missile_barrage:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	caster:AddNewModifier(
        caster,   
        self,
        "modifier_engineer_missile_barrage", 
        {}
    )

end


function engineer_missile_barrage:OnProjectileHit_ExtraData( target, location, extraData )
	-- Apply damage
	print("helo its ankel roger")
	local missile_damage = self:GetSpecialValueFor("damage")
	local damage = {
		victim = target,
		attacker = self:GetCaster(),
		damage = missile_damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}
	ApplyDamage( damage )

	-- effects
	self:PlayEffects1( target )
end

function engineer_missile_barrage:PlayEffects1( target )
	local particle_cast = "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf"
	local sound_cast = "Hero_Tinker.Heat-Seeking_Missile.Impact"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end