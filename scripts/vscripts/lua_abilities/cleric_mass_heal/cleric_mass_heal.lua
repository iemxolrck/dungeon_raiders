cleric_mass_heal = class({})

LinkLuaModifier( "modifier_cleric_mass_heal", "lua_abilities/cleric_mass_heal/modifier_cleric_mass_heal", LUA_MODIFIER_MOTION_NONE )

function cleric_mass_heal:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function cleric_mass_heal:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor( "radius" )
end

function cleric_mass_heal:GetCooldown(iLevel)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return self:GetSpecialValueFor("cooldown")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function cleric_mass_heal:GetManaCost(iCost)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return 0
	else
		return self.BaseClass.GetManaCost(self, iCost)
	end
end

function cleric_mass_heal:OnSpellStart(hInflictor)
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local heal = self:GetSpecialValueFor("heal")
	local caster_loc = self:GetCaster():GetAbsOrigin()
	local ability = caster:FindAbilityByName( "cleric_channel_divinity" )
	local heal_per_stack = 0
	local stack = 0
	local damage = heal

	if ability and ability:GetLevel()>0 then
		heal_per_stack = ability:GetLevelSpecialValueFor( "heal_per_stack" , ability:GetLevel()-1 )
	end
	
	if caster:HasModifier("modifier_cleric_mass_heal") then
		stack = caster:GetModifierStackCount("modifier_cleric_mass_heal", caster) * heal_per_stack
	end

	heal = heal + stack

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		caster:GetOrigin(),	
		nil,	
		radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		0,	
		false	
	)

	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		ability = self, 
	}

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)
			self:PlayEffects2( caster, enemy )
		end
	end

	local allies = FindUnitsInRadius(
		self:GetCaster():GetTeam(),
		caster_loc,
		nil, 
		radius,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false
		)

	self:HealCalculate(caster, allies, heal, stack)

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		caster:AddNewModifier(
			caster,
			self,
			"modifier_cleric_mass_heal",
			{}
		)
	end

	self:PlayEffects1( caster, radius )

end

function cleric_mass_heal:AbilityConsiderations()
	
	local bScepter = caster:HasScepter()

	local bBlocked = caster:TriggerSpellAbsorb( self )

	local bBroken = caster:PassivesDisabled()

	local bInvulnerable = caster:IsInvulnerable()
	local bInvisible = caster:IsInvisible()
	local bHexed = caster:IsHexed()
	local bMagicImmune = caster:IsMagicImmune()

	local bIllusion = caster:IsIllusion()
end

function cleric_mass_heal:HealCalculate( caster, allies, heal, stack )
	local int_as_heal = 0
	local mod_count = caster:GetModifierCount()
	local total_heal = 0

	for i=0, mod_count-1 do
		local modifier = caster:FindModifierByName(caster:GetModifierNameByIndex(i))
		if modifier:HasFunction(41)==true then
			local has_heal = modifier:GetAbility():GetSpecialValueFor("heal_amp")
			if has_heal~=nil then
				total_heal = total_heal + has_heal
			end
		end
		if modifier:HasFunction(42)==true then
			local has_heal = modifier:GetAbility():GetSpecialValueFor("int_as_heal")
			if has_heal~=nil then
				int_as_heal = caster:GetIntellect() * (has_heal/100)
			end
		end
	end
	heal_amplify = total_heal + int_as_heal
	heal = math.floor ( heal * ( 1 + ( heal_amplify/100 ) ) )

	for _, ally in pairs(allies) do
		ally:Heal(heal, self)
		self:PlayEffects2( caster, ally )
	end
end

function cleric_mass_heal:PlayEffects1( caster, radius )
	
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	local sound_target = "Hero_Omniknight.Purification"

	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_target )
	EmitSoundOn( sound_target, caster )

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

function cleric_mass_heal:PlayEffects2( caster, ally )
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf"
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, ally )
	ParticleManager:SetParticleControlEnt(
		effect_target,
		0,
		ally,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		ally:GetOrigin(),
		true
	)
	ParticleManager:SetParticleControlEnt(
		effect_target,
		1,
		ally,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		ally:GetOrigin(),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_target )

	particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, ally )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( 10, 1000, 10 ) )
	ParticleManager:ReleaseParticleIndex( effect_target )

	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, ally )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		ally,
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		ally:GetOrigin(), 
		true 
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

end