modifier_generic_blinded = class({})

function modifier_generic_blinded:IsHidden()
	return false
end

function modifier_generic_blinded:IsDebuff()
	return true
end

function modifier_generic_blinded:IsStunDebuff()
	return false
end

function modifier_generic_blinded:IsPurgable()
	return true
end

function modifier_generic_blinded:OnCreated( kv )

end

function modifier_generic_blinded:OnRefresh( kv )

end

function modifier_generic_blinded:OnRemoved()

end

function modifier_generic_blinded:OnDestroy()

end

function modifier_generic_blinded:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER
	}

	return funcs
end

function modifier_generic_blinded:GetModifierMiss_Percentage()
	return 100
end

function modifier_generic_blinded:GetModifierNoVisionOfAttacker()
	return 1
end

function modifier_generic_blinded:CheckState()
	local state = {
		[MODIFIER_STATE_BLIND] = true,
	}

	return state
end