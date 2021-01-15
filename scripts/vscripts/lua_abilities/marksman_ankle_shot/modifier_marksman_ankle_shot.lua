modifier_marksman_ankle_shot = class({})

function modifier_marksman_ankle_shot:IsHidden()
	return false
end

function modifier_marksman_ankle_shot:IsDebuff()
	return true
end

function modifier_marksman_ankle_shot:IsStunDebuff()
	return false
end

function modifier_marksman_ankle_shot:IsPurgable()
	return true
end

function modifier_marksman_ankle_shot:OnCreated( kv )
	
end

function modifier_marksman_ankle_shot:OnRefresh( kv )
	
end

function modifier_marksman_ankle_shot:OnDestroy( kv )

end

function modifier_marksman_ankle_shot:CheckState()
	local state = {
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end