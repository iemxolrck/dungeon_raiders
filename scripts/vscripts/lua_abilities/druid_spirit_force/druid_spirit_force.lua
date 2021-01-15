druid_spirit_force = class({})

LinkLuaModifier( "modifier_druid_spirit_force_aura", "lua_abilities/druid_spirit_force/modifier_druid_spirit_force_aura",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_druid_spirit_force_bonus", "lua_abilities/druid_spirit_force/modifier_druid_spirit_force_bonus",LUA_MODIFIER_MOTION_NONE )

function druid_spirit_force:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	
	caster:AddNewModifier( 
		caster,
		self,
		"modifier_druid_spirit_force_aura",
		{ duration = duration }
	)

end

function druid_spirit_force:PlayEffects( caster , distance, target )

	local origin = self:GetCaster():GetAbsOrigin()
	local particle_effect = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"

	local nFXIndex = ParticleManager:CreateParticle( particle_effect, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_staff_base", caster:GetOrigin(), true )

	ParticleManager:SetParticleControl( nFXIndex, 1, target )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( distance, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOnLocationWithCaster( target, "Hero_Furion.ForceOfNature", caster )
end