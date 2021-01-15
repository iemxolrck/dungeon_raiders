bard_inspire = class({})

LinkLuaModifier( "modifier_bard_inspire", "lua_abilities/bard_inspire/modifier_bard_inspire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_inspire_target", "lua_abilities/bard_inspire/modifier_bard_inspire_target", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_inspire_attack_speed", "lua_abilities/bard_inspire/modifier_bard_inspire_attack_speed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_inspire_evasion", "lua_abilities/bard_inspire/modifier_bard_inspire_evasion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_inspire_crit_rate", "lua_abilities/bard_inspire/modifier_bard_inspire_crit_rate", LUA_MODIFIER_MOTION_NONE )

function bard_inspire:CastFilterResultTarget( hTarget )
	if IsServer() then
		if self:GetCaster() == hTarget then
			return UF_FAIL_CUSTOM
		end

		local result = UnitFilter(
			hTarget,
			self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			self:GetCaster():GetTeamNumber()
		)
		
		if result ~= UF_SUCCESS then
			return result
		end

		return UF_SUCCESS
	end
end

function bard_inspire:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

function bard_inspire:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function bard_inspire:OnSpellStart(start)
	self.target = self:GetCursorTarget()
	self.switch = false
	if self:GetCaster():HasModifier("modifier_bard_discord") == true then
		self:GetCaster():FindAbilityByName("bard_discord_cancel"):OnSpellStart()
	end
	if self:GetCaster():HasModifier("modifier_bard_symphony") == true then
		self:GetCaster():FindAbilityByName("bard_symphony_cancel"):OnSpellStart()
		self.switch = true
	end
end

function bard_inspire:OnChannelFinish(bInterrupted)
	if not bInterrupted then
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetSpecialValueFor("radius")
		local target = self.target
		local istarget = 1
		local multiplier = self:GetSpecialValueFor( "multiplier" )/100

		local ability = caster:FindAbilityByName( "bard_symphony" )
		local attack_speed = ability:GetLevelSpecialValueFor( "attack_speed" , 0 )
		local evasion = ability:GetLevelSpecialValueFor( "evasion" , 0 )
		local crit_rate = ability:GetLevelSpecialValueFor( "crit_rate" , 0 )	
		
		if ability and ability:GetLevel()>0 then
			attack_speed = ability:GetLevelSpecialValueFor( "attack_speed" , ability:GetLevel()-1 )
			evasion = ability:GetLevelSpecialValueFor( "evasion" , ability:GetLevel()-1 )
			crit_rate = ability:GetLevelSpecialValueFor( "crit_rate" , ability:GetLevel()-1 )
		end

		local target_attack_speed = attack_speed
		local target_evasion = evasion
		local target_crit_rate = crit_rate

		print(attack_speed.." attack_speed")
		print(evasion.." evasion")
		print(crit_rate.." crit_rate")

		--self:SetModifierStackCount("modifier_bard_inspire_attack_speed", caster, attack_speed)
		--self:SetModifierStackCount("modifier_bard_inspire_evasion", caster, evasion)
		--self:SetModifierStackCount("modifier_bard_inspire_crit_rate", caster, crit_rate)

		if caster:HasModifier("modifier_bard_discord") == true then
			self:GetCaster():FindAbilityByName("bard_discord_cancel"):OnSpellStart()
		end
		if self.switch==true then
			self:GetCaster():FindAbilityByName("bard_symphony"):OnSpellStart()
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
			if ally==target then
				istarget = multiplier
				ally:AddNewModifier(
			        caster,   
			        self,
			        "modifier_bard_inspire_target", 
			        { duration = duration }
			    )
			else
				ally:AddNewModifier(
			        caster,   
			        self,
			        "modifier_bard_inspire", 
			        { duration = duration }
			    )
			end
			if ally~=caster then
			    ally:AddNewModifier(
			        caster,   
			        self,
			        "modifier_bard_inspire_attack_speed", 
			        { duration = duration, target = istarget }
			    )
				ally:SetModifierStackCount("modifier_bard_inspire_attack_speed", self, math.floor( attack_speed * istarget ) )
			    ally:AddNewModifier(
			        caster,   
			        self,
			        "modifier_bard_inspire_evasion", 
			        { duration = duration, target = istarget }
			    )
				ally:SetModifierStackCount("modifier_bard_inspire_evasion", self, math.floor( evasion * istarget ) )
			    ally:AddNewModifier(
			        caster,   
			        self,
			        "modifier_bard_inspire_crit_rate", 
			        { duration = duration, target = istarget }
			    )
				ally:SetModifierStackCount("modifier_bard_inspire_crit_rate", self, math.floor( crit_rate * istarget ) )
			    --self:PlayEffects(ally)
			end
			istarget = 1
		end
	else
		if self.switch==true then
			self:GetCaster():FindAbilityByName("bard_symphony"):OnSpellStart()
		end
	end

end