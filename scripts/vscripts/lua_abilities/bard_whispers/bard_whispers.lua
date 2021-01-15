bard_whispers = class({})	

LinkLuaModifier( "modifier_bard_whispers", "lua_abilities/bard_whispers/modifier_bard_whispers", LUA_MODIFIER_MOTION_NONE )

function bard_whispers:OnSpellStart()
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
			caster,
			self,
			"modifier_bard_whispers",
			{ duration = duration }
		)
	end
	self:PlayEffects()
end

function bard_whispers:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "DOTA_Item.FaerieSpark.Activate", self:GetCaster() )
end