modifier_bard_hypnotize_slow = class({})

function modifier_bard_hypnotize_slow:IsHidden()
	return false
end

function modifier_bard_hypnotize_slow:IsDebuff()
	return true
end

function modifier_bard_hypnotize_slow:IsPurgable()
	return true
end

function modifier_bard_hypnotize_slow:OnCreated( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
end

function modifier_bard_hypnotize_slow:OnRefresh( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
end

function modifier_bard_hypnotize_slow:OnRemoved()
end

function modifier_bard_hypnotize_slow:OnDestroy()
end

function modifier_bard_hypnotize_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_bard_hypnotize_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end