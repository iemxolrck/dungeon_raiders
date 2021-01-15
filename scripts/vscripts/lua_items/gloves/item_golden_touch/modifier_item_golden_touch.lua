modifier_item_golden_touch = class({})

function modifier_item_golden_touch:IsHidden()
	return true
end

function modifier_item_golden_touch:IsDebuff()
	return false
end

function modifier_item_golden_touch:IsPurgable()
	return false
end

function modifier_item_golden_touch:OnCreated( kv )
	self.castspeed = self:GetAbility():GetSpecialValueFor( "castspeed" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
	self.all = self:GetAbility():GetSpecialValueFor( "all" )
	self.gold_per_level = self:GetAbility():GetSpecialValueFor( "gold_per_level" )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
end

function modifier_item_golden_touch:OnRefresh( kv )
	self.castspeed = self:GetAbility():GetSpecialValueFor( "castspeed" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
	self.all = self:GetAbility():GetSpecialValueFor( "all" )
	self.gold_per_level = self:GetAbility():GetSpecialValueFor( "gold_per_level" )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
end

function modifier_item_golden_touch:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_item_golden_touch:GetModifierPercentageCasttime()
	return self.castspeed
end

function modifier_item_golden_touch:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end

function modifier_item_golden_touch:GetModifierBonusStats_Strength()
	return self.all
end

function modifier_item_golden_touch:GetModifierBonusStats_Agility()
	return self.all
end

function modifier_item_golden_touch:GetModifierBonusStats_Intellect()
	return self.all
end

function modifier_item_golden_touch:OnDeath( params )
	if not IsServer() then return end
	
	if params.attacker:IsSummoned()==true or params.attacker:IsDominated()==true then
		if params.attacker:GetOwner()~=self:GetParent() then return end
	else
		if params.attacker~=self:GetParent() then return end
	end

	if self:GetCaster():GetTeamNumber()==params.unit:GetTeamNumber() then return end
	if RandomInt(1, 100)>self.proc_chance then return end
	if params.unit:IsBuilding() then return end
	if self:GetParent():IsMuted() then return end
	local level = self:GetParent():GetLevel()

	-- gold
	local gold = level * self.gold_per_level
	PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )

	-- Play effects
	self:PlayEffects1()
	self:PlayEffects2( gold )
end

function modifier_item_golden_touch:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_item_golden_touch:PlayEffects2( gold )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"

	-- get data
	local digit = math.ceil(math.log( gold ))

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 0, gold, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, digit, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( 255, 255, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end