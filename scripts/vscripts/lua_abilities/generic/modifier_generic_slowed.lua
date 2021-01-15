modifier_generic_slowed = class ({})

function modifier_generic_slowed:IsHidden()
	return false
end

function modifier_generic_slowed:IsDebuff()
	return true
end

function modifier_generic_slowed:IsPurgable()
	return false
end

function modifier_generic_slowed:OnCreated( kv )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
end

function modifier_generic_slowed:OnRefresh( kv )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
end

function modifier_generic_slowed:OnRemoved( kv )

end

function modifier_generic_slowed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_REDUCTION_PERCENTAGE,
	}

	return funcs
end

function modifier_generic_slowed:GetModifierMoveSpeedBonus_Percentage()
	return -25
end

function modifier_generic_slowed:GetModifierAttackSpeedReductionPercentage()
	return -25
end

function modifier_generic_slowed:GetEffectName()
	--return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_generic_slowed:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end