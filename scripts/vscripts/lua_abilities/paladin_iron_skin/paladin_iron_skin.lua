paladin_iron_skin = class({})

LinkLuaModifier( "modifier_paladin_iron_skin", "lua_abilities/paladin_iron_skin/modifier_paladin_iron_skin", LUA_MODIFIER_MOTION_NONE )

function paladin_iron_skin:OnSpellStart()

    local caster = self:GetCaster()

    local duration = self:GetDuration()

    caster:AddNewModifier(
        caster,   
        self,
        "modifier_paladin_iron_skin", 
        { duration = duration }
    )

end

function paladin_iron_skin:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), 
		true 
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
