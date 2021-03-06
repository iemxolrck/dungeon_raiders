modifier_paladin_holy_field_bonus = class({})

function modifier_paladin_holy_field_bonus:IsHidden()
	return false
end

function modifier_paladin_holy_field_bonus:IsDebuff()
	return false
end

function modifier_paladin_holy_field_bonus:IsPurgable()
	return false
end

function modifier_paladin_holy_field_bonus:OnCreated()
		self.mana_as_attack_damage = self:GetAbility():GetSpecialValueFor( "mana_as_attack_damage" ) / 100
		self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
		self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
		--self:StartIntervalThink(0)
end

function modifier_paladin_holy_field_bonus:OnRefresh()
		self.mana_as_attack_damage = self:GetAbility():GetSpecialValueFor( "mana_as_attack_damage" ) / 100
		self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
		self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
end

function modifier_paladin_holy_field_bonus:OnDestroy()

end

function modifier_paladin_holy_field_bonus:OnIntervalThink()
	
end

function modifier_paladin_holy_field_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_paladin_holy_field_bonus:GetModifierPreAttack_BonusDamage()
	local total = math.floor( self:GetCaster():GetMaxMana() * self.mana_as_attack_damage )
	return total
end

function modifier_paladin_holy_field_bonus:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_paladin_holy_field_bonus:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end
