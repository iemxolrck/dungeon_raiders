modifier_item_basic_dagger = class({})

function modifier_item_basic_dagger:IsHidden()
	return false
end

function modifier_item_basic_dagger:IsDebuff()
	return false
end

function modifier_item_basic_dagger:IsPurgable()
	return false
end

function modifier_item_basic_dagger:GetTexture()
	return "../items/dagger/item_basic_dagger"
end

function modifier_item_basic_dagger:OnCreated( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
	self.critrate = self:GetAbility():GetSpecialValueFor( "critrate" )
end

function modifier_item_basic_dagger:OnRefresh( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
	self.critrate = self:GetAbility():GetSpecialValueFor( "critrate" )
end

function modifier_item_basic_dagger:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_basic_dagger:GetModifierPreAttack_BonusDamage()
	return self.physical_damage
end

function modifier_item_basic_dagger:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end