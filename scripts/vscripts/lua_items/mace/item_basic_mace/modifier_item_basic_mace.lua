modifier_item_basic_mace = class({})

function modifier_item_basic_mace:IsHidden()
	return false
end

function modifier_item_basic_mace:IsDebuff()
	return false
end

function modifier_item_basic_mace:IsPurgable()
	return false
end

function modifier_item_basic_mace:GetTexture()
	return "../items/mace/item_basic_mace"
end


function modifier_item_basic_mace:OnCreated( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.channelreduction = 1 - ( self:GetAbility():GetSpecialValueFor( "channelreduction" ) / 100 )
	self.splash_radius = self:GetAbility():GetSpecialValueFor( "splash_radius" )
	self.splash_damage = self:GetAbility():GetSpecialValueFor( "splash_damage" ) / 100
end

function modifier_item_basic_mace:OnRefresh( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.channelreduction = 1 - ( self:GetAbility():GetSpecialValueFor( "channelreduction" ) / 100 )
	self.splash_radius = self:GetAbility():GetSpecialValueFor( "splash_radius" )
	self.splash_damage = self:GetAbility():GetSpecialValueFor( "splash_damage" ) / 100
end

function modifier_item_basic_mace:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		--MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		--MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_item_basic_mace:GetModifierPreAttack_BonusDamage()
	return self.physical_damage
end

function modifier_item_basic_mace:GetModifierCastRangeBonusStacking()
	--return self.castrange
end

function modifier_item_basic_mace:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then return 0 end

	local ability = params.ability:GetAbilityName()
	local value = params.ability_special_value

	local channel_exemptions = LoadKeyValues("scripts/kv/channel.kv")
	local list = channel_exemptions["ability"]

	for k,v in pairs( list ) do
		if ability == v then return 0 end
	end

	if value == "abilitychanneltime" then
		return 1
	end

	return 0
end

function modifier_item_basic_mace:GetModifierOverrideAbilitySpecialValue( params )
	local ability = params.ability:GetAbilityName()
	local value = params.ability_special_value

	local channel_exemptions = LoadKeyValues("scripts/kv/channel.kv")
	local list = channel_exemptions["ability"]

	for k,v in pairs( list ) do
		if ability == v then return 0 end
	end
	
	if value == "abilitychanneltime" then
		local level = params.ability_special_level
		local basevalue = params.ability:GetLevelSpecialValueNoOverride( value, level )

		return basevalue * self.channelreduction
	end

	return 0
end

function modifier_item_basic_mace:OnAttackLanded( params )
	if not IsServer() then return end
	if params.attacker~= self:GetParent() then return end
	local parent = params.attacker
	local target = params.target
	local damageTable = {
		attacker = parent,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL
	}

	local enemies = FindUnitsInRadius(
		parent:GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		self.splash_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		0,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do
		if enemy~=target then
			damageTable.damage = math.floor( self:DamageCalculation( parent ) * self.splash_damage )
			--print(damageTable.damage)
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
	end
	self:PlayEffects( target )

end

function modifier_item_basic_mace:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if params.attacker:GetAttackCapability()~=DOTA_UNIT_CAP_MELEE_ATTACK then return end

	-- cleave
	DoCleaveAttack(
		params.attacker,
		params.target,
		self:GetAbility(),
		self.splash_damage*100,
		150,
		360,
		650,
		"particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf"
	)
end

function modifier_item_basic_mace:DamageCalculation(caster)
	if not IsServer() then return end

	local BaseDamage
    local maxdamage
    local mindamage
    local averagedamage

    averagedamage = caster:GetAverageTrueAttackDamage(caster)
    BaseDamage = caster:GetAttackDamage()
    maxdamage = caster:GetBaseDamageMax()
    mindamage = caster:GetBaseDamageMin()

    maxdamage = maxdamage - mindamage
    averagedamage = averagedamage - (maxdamage/2)
    averagedamage = averagedamage - mindamage
    BaseDamage = BaseDamage + averagedamage

    return BaseDamage
end

function modifier_item_basic_mace:PlayEffects( target )
	local effects = "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect_b.vpcf"
	local nFXIndex = ParticleManager:CreateParticle( effects, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, self.radius ) )
	self:AddParticle( nFXIndex, false, false, -1, false, false )

end