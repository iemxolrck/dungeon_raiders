modifier_marksman_dash_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_marksman_dash_slow:IsHidden()
	return false
end

function modifier_marksman_dash_slow:IsDebuff()
	return true
end

function modifier_marksman_dash_slow:IsStunDebuff()
	return false
end

function modifier_marksman_dash_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_marksman_dash_slow:OnCreated( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow" ) -- special value
end

function modifier_marksman_dash_slow:OnRefresh( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow" ) -- special value	
end

function modifier_marksman_dash_slow:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_marksman_dash_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_marksman_dash_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self.slow
end