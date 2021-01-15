modifier_item_basic_sword = class({})

function modifier_item_basic_sword:IsHidden()
	return false
end

function modifier_item_basic_sword:IsDebuff()
	return false
end

function modifier_item_basic_sword:IsPurgable()
	return false
end

function modifier_item_basic_sword:GetTexture()
	return "../items/sword/item_basic_sword"
end

function modifier_item_basic_sword:OnCreated( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
end

function modifier_item_basic_sword:OnRefresh( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
end

function modifier_item_basic_sword:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_basic_sword:GetModifierPreAttack_BonusDamage()
	return self.physical_damage
end

function modifier_item_basic_sword:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end