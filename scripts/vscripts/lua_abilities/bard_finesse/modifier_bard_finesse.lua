modifier_bard_finesse = class({})

function modifier_bard_finesse:IsHidden()
    return false
end

function modifier_bard_finesse:IsDebuff()
    return false
end

function modifier_bard_finesse:IsPurgable()
    return false
end

function modifier_bard_finesse:OnCreated( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
end

function modifier_bard_finesse:OnRefresh( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
end

function modifier_bard_finesse:OnDestroy( kv )
	
end

function modifier_bard_finesse:OnIntervalThink()
	
end

function modifier_bard_finesse:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_bard_finesse:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end