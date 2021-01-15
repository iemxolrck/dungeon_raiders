paladin_holy_field = class({})

LinkLuaModifier( "modifier_paladin_holy_field_aura", "lua_abilities/paladin_holy_field/modifier_paladin_holy_field_aura",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_paladin_holy_field_bonus", "lua_abilities/paladin_holy_field/modifier_paladin_holy_field_bonus",LUA_MODIFIER_MOTION_NONE )

function paladin_holy_field:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	
	caster:AddNewModifier( 
		caster,
		self,
		"modifier_paladin_holy_field_aura",
		{ duration = duration }
	)

end

function paladin_holy_field:PlayEffects( caster , distance, target )

	local origin = self:GetCaster():GetAbsOrigin()
	local particle_effect = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"

	local nFXIndex = ParticleManager:CreateParticle( particle_effect, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_staff_base", caster:GetOrigin(), true )

	ParticleManager:SetParticleControl( nFXIndex, 1, target )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( distance, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOnLocationWithCaster( target, "Hero_Furion.ForceOfNature", caster )
end