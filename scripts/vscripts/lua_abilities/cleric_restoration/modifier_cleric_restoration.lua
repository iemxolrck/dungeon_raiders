modifier_cleric_restoration = class ({})

function modifier_cleric_restoration:IsHidden()
	return true
end

function modifier_cleric_restoration:IsDebuff()
	return false
end

function modifier_cleric_restoration:IsPurgable()
	return false
end

function modifier_cleric_restoration:OnCreated( kv )
	if IsServer() then
		self.heal_amp = self:GetAbility():GetSpecialValueFor( "heal_amp" )
		self.mana_as_heal = self:GetAbility():GetSpecialValueFor( "mana_as_heal" )/100
		self.loss_health_as_heal = self:GetAbility():GetSpecialValueFor( "loss_health_as_heal" )/100
		self.radius = self:GetAbility():GetCastRange( self:GetParent():GetAbsOrigin(), nil )
		--print(self.radius)
	end
end

function modifier_cleric_restoration:OnRefresh( kv )

end

function modifier_cleric_restoration:OnRemoved( kv )

end

function modifier_cleric_restoration:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		--MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_cleric_restoration:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit == self:GetParent() and self:GetAbility():IsCooldownReady()==true then
			local ability_name = params.ability:GetName()
			--self:HealAllies(ability_name)
			--self:GetAbility():StartCooldown(5)
			--self:GetAbility():UseResources(true, false, true)
		end
	end
	--for i=0, self:GetCaster():GetAbilityCount()-1 do
		--if params.ability:GetName() == self:GetCaster():GetAbilityByIndex(i) and params.unit == self:GetParent() then
      		--owner = true
       		--print("my spell")
       		--self:HealAllies()
       		--break
    	--end
    --end

end

function modifier_cleric_restoration:HealAllies(ability_name)
	if IsServer() then
		local caster = self:GetCaster()
		local max_mana = self:GetCaster():GetMana()

		local int_as_heal = 0
		local mod_count = caster:GetModifierCount()
		local missing_health = 0
		local total_heal = 0
		local heal_amount = 1
		local count = 1

		for i=0, mod_count-1 do
			local modifier = caster:FindModifierByName(caster:GetModifierNameByIndex(i))
			for v=1, count do
				if modifier==nil then
					modifier = caster:FindModifierByName(caster:GetModifierNameByIndex(i))
					count = count + 1
				else
					print(modifier:GetName())
					break
				end
			end
			print("")
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

		local allies = FindUnitsInRadius(
			self:GetParent():GetTeam(),
			self:GetParent():GetAbsOrigin(),
			nil, 
			self.radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		for _, ally in pairs(allies) do
			if ally==nil then break end
			missing_health = ally:GetMaxHealth()-ally:GetHealth()
			heal_amount = (missing_health*self.loss_health_as_heal)+(max_mana*self.mana_as_heal)
			heal_amount = math.floor( heal_amount * ( 1 + ( heal_amplify/100 ) ))
			--print(ability_name)
			self:OnIntervalThink(ally, heal_amount)
			self:StartIntervalThink(1)
			
			heal_amount = 0
		end
	end
end

function modifier_cleric_restoration:OnIntervalThink(ally, heal_amount)
	if IsServer() then
		if ally~=nil then
			ally:Heal(heal_amount, self:GetAbility())
			print(ally:GetName())
			print(heal_amount)
			self:PlayEffects(ally)
		end
		self:StartIntervalThink(-1)
	end
end
function modifier_cleric_restoration:GetModifierHealAmplify_Percentage( params )
	if not IsServer() then return end
	return 30
end

function modifier_cleric_restoration:PlayEffects(target)

	local particle_cast = "particles/generic_gameplay/generic_lifesteal_blue.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
	particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end