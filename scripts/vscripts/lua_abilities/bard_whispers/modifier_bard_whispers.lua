modifier_bard_whispers = class({})

function modifier_bard_whispers:IsHidden()
	return false
end

function modifier_bard_whispers:IsDebuff()
	return false
end

function modifier_bard_whispers:IsPurgable()
	return true
end

function modifier_bard_whispers:OnCreated( kv )
	if IsServer() then
		
	end
end

function modifier_bard_whispers:OnRefresh( kv )
	if IsServer() then
		
	end
end

function modifier_bard_whispers:OnRemoved()
	if IsServer() then
		
	end
end

function modifier_bard_whispers:OnDestroy()
	if IsServer() then
		
	end
end

function modifier_bard_whispers:OnIntervalThink()
	if IsServer() then
	
	end	
end

function modifier_bard_whispers:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}

	return funcs
end

function modifier_bard_whispers:GetModifierInvisibilityLevel()
	return 1
end

function modifier_bard_whispers:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
	}

	return state
end

function modifier_bard_whispers:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end
