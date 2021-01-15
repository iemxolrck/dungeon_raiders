modifier_item_frost_rod = class({})

function modifier_item_frost_rod:IsHidden()
	return false
end

function modifier_item_frost_rod:IsDebuff()
	return false
end

function modifier_item_frost_rod:IsPurgable()
	return false
end

function modifier_item_frost_rod:GetTexture()
	return "../items/staff/item_frost_rod"
end


function modifier_item_frost_rod:OnCreated( kv )
	self.magical_damage = self:GetAbility():GetSpecialValueFor( "magical_damage" )
	self.channelreduction = 1 - ( self:GetAbility():GetSpecialValueFor( "channelreduction" ) / 100 )
	self.castrange = self:GetAbility():GetSpecialValueFor( "castrange" )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
	self.blizzard_interval = 1 - ( self:GetAbility():GetSpecialValueFor( "blizzard_interval" ) / 100 )
end

function modifier_item_frost_rod:OnRefresh( kv )
	self.magical_damage = self:GetAbility():GetSpecialValueFor( "magical_damage" )
	self.channelreduction = 1 - ( self:GetAbility():GetSpecialValueFor( "channelreduction" ) / 100 )
	self.castrange = self:GetAbility():GetSpecialValueFor( "castrange" )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
	self.blizzard_interval = 1 - ( self:GetAbility():GetSpecialValueFor( "blizzard_interval" ) / 100 )
end

function modifier_item_frost_rod:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_item_frost_rod:GetModifierTotalDamageOutgoing_Percentage( params )
	if not IsServer() then return end
	local inflictor = params.inflictor
	local target = params.target
	if inflictor==nil then return end
	local ability = self:GetParent():FindAbilityByName(inflictor:GetName())
	--check if damage is fron frost spells
	if ability:GetSpecialValueFor( "type" )==5 then
		return 50
	end
end

function modifier_item_frost_rod:GetModifierPreAttack_BonusDamage()
	return self.magical_damage
end

function modifier_item_frost_rod:GetModifierCastRangeBonusStacking()
	return self.castrange
end

function modifier_item_frost_rod:GetModifierBonusStats_Intellect()
	return self.int
end

function modifier_item_frost_rod:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then return 0 end

	local ability = params.ability:GetAbilityName()
	local value = params.ability_special_value

	if ability == "wizard_blizzard" and value == "explosion_interval" then
		return 1
	end

	local channel_exemptions = LoadKeyValues("scripts/kv/channel.kv")
	local list = channel_exemptions["ability"]

	for k,v in pairs( list ) do
		if ability == "wizard_blizzard" then break end
		if ability == v then return 0 end
	end

	if value == "abilitychanneltime" then
		return 1
	end

	return 0
end

function modifier_item_frost_rod:GetModifierOverrideAbilitySpecialValue( params )
	local ability = params.ability:GetAbilityName()
	local value = params.ability_special_value

	local channel_exemptions = LoadKeyValues("scripts/kv/channel.kv")
	local list = channel_exemptions["ability"]

	--reduce [Blizzard] explosion interval
	if ability == "wizard_blizzard" and value == "explosion_interval" then
		local level = params.ability_special_level
		local basevalue = params.ability:GetLevelSpecialValueNoOverride( value, level )

		return basevalue * self.blizzard_interval
	end
	--reduce [Blizzard] channel time
	if ability == "wizard_blizzard" and value == "abilitychanneltime" then
		local level = params.ability_special_level
		local basevalue = params.ability:GetLevelSpecialValueNoOverride( value, level )

		return basevalue * self.blizzard_interval
	end
	--channel spells exempted from channel reduction
	for k,v in pairs( list ) do
		if ability == "wizard_blizzard" then break end
		if ability == v then return 0 end
	end
	--reduce spells channel time
	if value == "abilitychanneltime" then
		local level = params.ability_special_level
		local basevalue = params.ability:GetLevelSpecialValueNoOverride( value, level )

		return basevalue * self.channelreduction
	end

	return 0
end