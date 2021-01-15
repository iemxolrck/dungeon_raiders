modifier_item_basic_bow = class({})

function modifier_item_basic_bow:IsHidden()
	return false
end

function modifier_item_basic_bow:IsDebuff()
	return false
end

function modifier_item_basic_bow:IsPurgable()
	return false
end

function modifier_item_basic_bow:GetTexture()
	return "../items/bow/item_basic_bow"
end


function modifier_item_basic_bow:OnCreated( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
	self.attackrange = self:GetAbility():GetSpecialValueFor( "attackrange" )
end

function modifier_item_basic_bow:OnRefresh( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_basic_bow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	if self:GetParent():GetName()=="npc_dota_hero_drow_ranger"
		or self:GetParent():GetName()=="npc_dota_hero_windrunner" then 
		return funcs
	end
end

function modifier_item_basic_bow:GetModifierMoveSpeedBonus_Percentage_Unique()
	return self.movespeed
end

function modifier_item_basic_bow:GetModifierPreAttack_BonusDamage()
	return self.physical_damage
end

function modifier_item_basic_bow:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end

function modifier_item_basic_bow:GetModifierAttackRangeBonus()
	return self.attackrange
end