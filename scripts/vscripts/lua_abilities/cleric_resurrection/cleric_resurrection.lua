cleric_resurrection = class({})

LinkLuaModifier( "modifier_cleric_resurrection_invincible", "lua_abilities/cleric_resurrection/modifier_cleric_resurrection_invincible", LUA_MODIFIER_MOTION_NONE )

function cleric_resurrection:GetCooldown(iLevel)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return self:GetSpecialValueFor("cooldown")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function cleric_resurrection:GetManaCost(iCost)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return 0
	else
		return self.BaseClass.GetManaCost(self, iCost)
	end
end

function cleric_resurrection:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function cleric_resurrection:OnSpellStart()
	local sound_cast = "Hero_Chen.TeleportLoop"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( "Hero_Wisp.Spirits.Loop", self:GetCaster() )
end
function cleric_resurrection:InterruptSound()
	StopSoundOn( "Hero_Chen.TeleportLoop", self:GetCaster() )
	StopSoundOn( "Hero_Wisp.Spirits.Loop", self:GetCaster() )
end

function cleric_resurrection:OnChannelFinish(bInterrupted)
	self:InterruptSound()
	
	if not bInterrupted then 	

	    local caster = self:GetCaster()
	    local ability = caster:FindAbilityByName( "cleric_channel_divinity" )
		local radius = self:GetSpecialValueFor("radius")
	    local duration = self:GetSpecialValueFor("duration")
	    local max_hero = self:GetSpecialValueFor("max_hero")
	    local heal = 0
	    if ability and ability:GetLevel()>0 then
			heal = ability:GetLevelSpecialValueFor( "resurrect_heal_percent" , ability:GetLevel()-1 )
			heal = heal/100
		end

		local allies = FindUnitsInRadius(
			self:GetCaster():GetTeam(),
			self:GetCaster():GetAbsOrigin(),
			nil, 
			radius,
			self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false
		)

		for _, ally in pairs(allies) do
			if max_hero==0 then
				break
			end
		 	if ally:IsAlive()==true then
		 		if caster:HasModifier("modifier_cleric_channel_divinity") then
		   			self:HealAllies(caster, ally, heal)
		   		end
		   	else
		   		if ally:IsRealHero()==true then
		 			--ally:SetUnitCanRespawn(true)
		 			ally:SetRespawnPosition(ally:GetOrigin())
		 			ally:RespawnHero(false, false)
		 		else
		 			ally:RespawnUnit()
		 		end
			 	--[[print(ally:GetName()..": ")
			 	print(ally:UnitCanRespawn())
			 	print("")]]
			 	self:PlayEffects(ally)

			 	ally:AddNewModifier(
			        caster,   
			        self,
			        "modifier_cleric_resurrection_invincible", 
			        { duration = duration }
		   		)
		   		max_hero = max_hero - 1
			end
			self:PlayEffects(ally)
		 end
	end
end

function cleric_resurrection:HealAllies( caster, ally, heal )
	local int_as_heal = 0
	local mod_count = caster:GetModifierCount()
	local total_heal = 0
	local max_health = 0

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

	max_health = ally:GetMaxHealth()
	heal = heal * max_health
	heal = math.floor ( heal * ( 1 + ( heal_amplify/100 ) ) )
	ally:Heal(heal, self)
	self:PlayEffects2( ally )
	
end

function cleric_resurrection:PlayEffects(target)

	local sound_cast = "Hero_Chen.HandOfGodHealHero"
	EmitSoundOn( sound_cast, self:GetCaster() )

	local particle_target = "particles/econ/events/league_teleport_2014/teleport_start_league_gold.vpcf"
	
	particle_target = "particles/econ/events/ti5/teleport_start_i_ti5.vpcf"
	effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_target,
		0,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)

	ParticleManager:ReleaseParticleIndex( effect_target )

	sound_cast = "Hero_Omniknight.GuardianAngel"
	EmitSoundOn( sound_cast, target)

end

function cleric_resurrection:PlayEffects2( ally )

	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, ally )
	
	ParticleManager:SetParticleControl( effect_target, 1, Vector( 10, 1000, 10 ) )
	ParticleManager:ReleaseParticleIndex( effect_target )

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, ally )
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