warrior_sprint = class({})

LinkLuaModifier( "modifier_warrior_sprint", "lua_abilities/warrior_sprint/modifier_warrior_sprint", LUA_MODIFIER_MOTION_NONE )

function warrior_sprint:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local max_target = self:GetSpecialValueFor("max_target")
	
	caster:Purge(false, true, false, true, false)

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)
	duration = duration + math.min( #enemies, max_target )

	caster:AddNewModifier(
		caster,
		self,
		"modifier_warrior_sprint",
		{ duration = duration }
	)

	self:PlayEffects()
end


function warrior_sprint:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end