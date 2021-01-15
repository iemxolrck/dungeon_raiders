modifier_level_plus = class({})

function modifier_level_plus:IsHidden()
	return false
end

function modifier_level_plus:IsDebuff()
	return false
end

function modifier_level_plus:IsPurgable()
	return false
end

function modifier_level_plus:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_level_plus:OnCreated( kv )
	self.size = 1
	--self:StartIntervalThink(0.5)
end

function modifier_level_plus:OnRefresh( kv )

end

function modifier_level_plus:OnIntervalThink()
	self.size = self.size - 0.05
end

--[[function modifier_level_plus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
end]]

function modifier_level_plus:GetModifierModelScale()
	return self.size
end

function modifier_level_plus:CheckState()
	local state = {
		--[MODIFIER_STATE_UNSELECTABLE ] = false,
		--[MODIFIER_STATE_NO_TEAM_SELECT ] = true,
	}

	return state
end