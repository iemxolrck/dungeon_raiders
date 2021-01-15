modifier_ranger_heighten_senses_aura = class({})

function modifier_ranger_heighten_senses_aura:IsHidden()
	return false
end

function modifier_ranger_heighten_senses_aura:IsDebuff()
	return true
end

function modifier_ranger_heighten_senses_aura:IsStunDebuff()
	return false
end

function modifier_ranger_heighten_senses_aura:IsPurgable()
	return false
end

function modifier_ranger_heighten_senses_aura:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_ranger_heighten_senses_aura:OnCreated( kv )

end

function modifier_ranger_heighten_senses_aura:OnRefresh( kv )
	
end

function modifier_ranger_heighten_senses_aura:OnRemoved()

end

function modifier_ranger_heighten_senses_aura:OnDestroy()

end

function modifier_ranger_heighten_senses_aura:DeclareFunctions()
    local funcs = {
		--MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
    }

    return DeclareFunction
end

function modifier_ranger_heighten_senses_aura:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_ranger_heighten_senses_aura:DestroyOnExpire()
    return true
end

function modifier_ranger_heighten_senses_aura:GetModifierProvidesFOWVision( params )
    return 1
end