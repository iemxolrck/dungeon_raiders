modifier_ranger_burrow_trap_slow = class({})

function modifier_ranger_burrow_trap_slow:IsHidden()
	return false
end

function modifier_ranger_burrow_trap_slow:IsDebuff()
	return true
end

function modifier_ranger_burrow_trap_slow:IsStunDebuff()
	return false
end

function modifier_ranger_burrow_trap_slow:IsPurgable()
	return true
end

function modifier_ranger_burrow_trap_slow:OnCreated( kv )
	
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
	--self:PlayEffects()
end

function modifier_ranger_burrow_trap_slow:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
end

function modifier_ranger_burrow_trap_slow:OnRemoved()

end

function modifier_ranger_burrow_trap_slow:OnDestroy()

end


function modifier_ranger_burrow_trap_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_ranger_burrow_trap_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_ranger_burrow_trap_slow:PlayEffects()

end