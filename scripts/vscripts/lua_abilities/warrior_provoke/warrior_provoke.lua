warrior_provoke = class({})

LinkLuaModifier( "modifier_warrior_provoke", "lua_abilities/warrior_provoke/modifier_warrior_provoke", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warrior_provoke_debuff", "lua_abilities/warrior_provoke/modifier_warrior_provoke_debuff", LUA_MODIFIER_MOTION_NONE )

function warrior_provoke:OnAbilityPhaseInterrupted()
	-- stop effects 
	local sound_cast = "Hero_Axe.BerserkersCall.Start"
	StopSoundOn( sound_cast, self:GetCaster() )
end
function warrior_provoke:OnAbilityPhaseStart()
	-- play effects 
	local sound_cast = "Hero_Axe.BerserkersCall.Start"
	EmitSoundOn( sound_cast, self:GetCaster() )

	return true -- if success
end

function warrior_provoke:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetOrigin()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			caster,
			self,
			"modifier_warrior_provoke_debuff",
			{ duration = duration }
		)
	end

	caster:AddNewModifier(
		caster,
		self,
		"modifier_warrior_provoke",
		{ duration = duration }
	)

	if #enemies>0 then
		local sound_cast = "Hero_Axe.Berserkers_Call"
		EmitSoundOn( sound_cast, self:GetCaster() )
	end
	self:PlayEffects()
end


function warrior_provoke:PlayEffects()
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