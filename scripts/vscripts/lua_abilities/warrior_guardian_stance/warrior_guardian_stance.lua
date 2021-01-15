warrior_guardian_stance = class({})

LinkLuaModifier( "modifier_warrior_guardian_stance", "lua_abilities/warrior_guardian_stance/modifier_warrior_guardian_stance", LUA_MODIFIER_MOTION_NONE )

function warrior_guardian_stance:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	
	caster:Purge(false, true, false, true, false)

	caster:AddNewModifier(
		caster,
		self,
		"modifier_warrior_guardian_stance",
		{ duration = duration }
	)

	self:PlayEffects()
end


function warrior_guardian_stance:PlayEffects()
	local caster = self:GetCaster()
	caster:EmitSound("Item.CrimsonGuard.Cast")
	local pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active_launch.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("active_radius"),0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
end