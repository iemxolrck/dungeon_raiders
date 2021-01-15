modifier_bard_tuning = class({})

function modifier_bard_tuning:IsHidden()
    return false
end

function modifier_bard_tuning:IsDebuff()
    return false
end

function modifier_bard_tuning:IsPurgable()
    return false
end

function modifier_bard_tuning:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_bard_tuning:OnCreated( kv )
	self.mana_cost_reduction = self:GetAbility():GetSpecialValueFor( "mana_cost_reduction" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.cdr = self:GetAbility():GetSpecialValueFor( "cdr" )
	self.active_movespeed = self:GetAbility():GetSpecialValueFor( "active_movespeed" )
end

function modifier_bard_tuning:OnRefresh( kv )
	self.mana_cost_reduction = self:GetAbility():GetSpecialValueFor( "mana_cost_reduction" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.cdr = self:GetAbility():GetSpecialValueFor( "cdr" )
	self.active_movespeed = self:GetAbility():GetSpecialValueFor( "active_movespeed" )
end

function modifier_bard_tuning:OnDestroy( kv )
	
end

function modifier_bard_tuning:OnIntervalThink()
	
end

function modifier_bard_tuning:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
	return funcs
end

function modifier_bard_tuning:GetModifierPercentageManacostStacking()
	return self.mana_cost_reduction
end

function modifier_bard_tuning:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end

function modifier_bard_tuning:GetModifierPercentageCooldown()
	return self.cdr
end

function modifier_bard_tuning:GetModifierMoveSpeed_Absolute()
	if self:GetParent():HasModifier("modifier_bard_symphony")==true
		or self:GetParent():HasModifier("modifier_bard_discord")==true then
			return self.active_movespeed
	end
end