modifier_item_sorcery_cape = class({})

function modifier_item_sorcery_cape:IsHidden()
	return true
end

function modifier_item_sorcery_cape:IsDebuff()
	return false
end

function modifier_item_sorcery_cape:IsPurgable()
	return false
end

function modifier_item_sorcery_cape:GetTexture()
	return "../items/armor/item_sorcery_cape"
end

function modifier_item_sorcery_cape:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
	self.channelprotection = -self:GetAbility():GetSpecialValueFor( "channelprotection" )
	if not IsServer() then return end
	self:StartIntervalThink(0)
end

function modifier_item_sorcery_cape:OnRefresh( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
	self.channelprotection = -self:GetAbility():GetSpecialValueFor( "channelprotection" )
	if not IsServer() then return end
	self:StartIntervalThink(0)
end

function modifier_item_sorcery_cape:OnIntervalThink()
	if self:GetParent():IsChanneling()
		and self:GetParent():HasModifier("modifier_generic_channel_protection")==false then
		self:GetParent():AddNewModifier(
			self:GetCaster(), 
			self:GetAbility(), 
			"modifier_generic_channel_protection", 
			{}
		)
	else

	end
end

function modifier_item_sorcery_cape:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_item_sorcery_cape:GetModifierPhysicalArmorBonusUnique()
	return self.armor
end

function modifier_item_sorcery_cape:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end