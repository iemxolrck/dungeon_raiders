modifier_warrior_sprint = class({})

function modifier_warrior_sprint:IsHidden()
	return false
end

function modifier_warrior_sprint:IsDebuff()
	return false
end

function modifier_warrior_sprint:IsPurgable()
	return false
end

function modifier_warrior_sprint:OnCreated( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
end

function modifier_warrior_sprint:OnRefresh( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
end

function modifier_warrior_sprint:OnRemoved()

end

function modifier_warrior_sprint:OnDestroy()

end

function modifier_warrior_sprint:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_warrior_sprint:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end

function modifier_warrior_sprint:CheckState()
	local state = {
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}

	return state
end

function modifier_warrior_sprint:GetEffectName()
	return "particles/generic_gameplay/rune_haste_owner.vpcf"
end

function modifier_warrior_sprint:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
