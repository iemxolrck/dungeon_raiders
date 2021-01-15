bard_haste = class({})	

LinkLuaModifier( "modifier_bard_haste", "lua_abilities/bard_haste/modifier_bard_haste", LUA_MODIFIER_MOTION_NONE )

function bard_haste:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	if caster:HasModifier("modifier_bard_discord") == true then
		self:GetCaster():FindAbilityByName("bard_discord_cancel"):OnSpellStart()
	end
	if caster:HasModifier("modifier_bard_symphony") == true then
		self:GetCaster():FindAbilityByName("bard_symphony_cancel"):OnSpellStart()
	end

	local allies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		radius,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		0,
		false
	)

	for _,ally in pairs(allies) do
		ally:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_bard_haste", -- modifier name
			{ duration = duration } -- kv
		)
		--self:PlayEffects(ally)
	end
	
end

function bard_haste:PlayEffects( target )
	local particle_target = "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_target,
		0,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_target,
		1,
		self:GetCaster(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetAbsOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_target )

end