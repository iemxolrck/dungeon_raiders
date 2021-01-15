modifier_summon_treant_chlorophyll_buff = class ({})

function modifier_summon_treant_chlorophyll_buff:IsHidden()
	return false
end

function modifier_summon_treant_chlorophyll_buff:IsDebuff()
	return false
end

function modifier_summon_treant_chlorophyll_buff:IsPurgable()
	return false
end

function modifier_summon_treant_chlorophyll_buff:OnCreated( kv )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
end

function modifier_summon_treant_chlorophyll_buff:OnRefresh( kv )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
end

function modifier_summon_treant_chlorophyll_buff:OnRemoved( kv )

end

function modifier_summon_treant_chlorophyll_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_summon_treant_chlorophyll_buff:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_summon_treant_chlorophyll_buff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_summon_treant_chlorophyll_buff:GetModifierMoveSpeedBonus_Constant()
	return self.move_speed
end