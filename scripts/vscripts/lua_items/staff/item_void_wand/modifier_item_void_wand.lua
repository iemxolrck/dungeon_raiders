modifier_item_void_wand = class({})

function modifier_item_void_wand:IsHidden()
	return false
end

function modifier_item_void_wand:IsDebuff()
	return false
end

function modifier_item_void_wand:IsPurgable()
	return false
end

function modifier_item_void_wand:GetTexture()
	return "../items/staff/item_void_wand"
end


function modifier_item_void_wand:OnCreated( kv )
	self.magical_damage = self:GetAbility():GetSpecialValueFor( "magical_damage" )
	self.channelreduction = 1 - ( self:GetAbility():GetSpecialValueFor( "channelreduction" ) / 100 )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
	self.critrate = self:GetAbility():GetSpecialValueFor( "critrate" )
	self.meteor_radius = self:GetAbility():GetSpecialValueFor( "meteor_radius" )
end

function modifier_item_void_wand:OnRefresh( kv )
	self.magical_damage = self:GetAbility():GetSpecialValueFor( "magical_damage" )
	self.channelreduction = 1 - ( self:GetAbility():GetSpecialValueFor( "channelreduction" ) / 100 )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
	self.critrate = self:GetAbility():GetSpecialValueFor( "critrate" )
	self.meteor_radius = self:GetAbility():GetSpecialValueFor( "meteor_radius" )
end

function modifier_item_void_wand:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
	return funcs
end

function modifier_item_void_wand:GetModifierPreAttack_BonusDamage()
	return self.magical_damage
end

function modifier_item_void_wand:GetModifierchannelreductionBonusStacking()
	return self.channelreduction
end

function modifier_item_void_wand:GetModifierBonusStats_Intellect()
	return self.int
end

function modifier_item_void_wand:GetModifierOverrideAbilitySpecial( params )
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

function modifier_item_void_wand:GetModifierOverrideAbilitySpecialValue( params )
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