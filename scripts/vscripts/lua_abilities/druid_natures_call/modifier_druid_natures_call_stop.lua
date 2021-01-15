modifier_druid_natures_call_stop = class({})

function modifier_druid_natures_call_stop:IsPurgable()
	return false
end

function modifier_druid_natures_call_stop:CheckState()
	local state = {
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}

	return state
end