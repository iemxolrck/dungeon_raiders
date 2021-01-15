modifier_generic_drenched = class ({})

function modifier_generic_drenched:IsHidden()
	return false
end

function modifier_generic_drenched:IsDebuff()
	return true
end

function modifier_generic_drenched:IsPurgable()
	return true
end

function modifier_generic_drenched:GetTexture()
	return "status/modifier_generic_drenched"
end


function modifier_generic_drenched:OnCreated( kv )
	
end

function modifier_generic_drenched:OnRefresh( kv )
	
end

function modifier_generic_drenched:OnRemoved( kv )

end

function modifier_generic_drenched:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_REDUCTION_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_generic_drenched:GetModifierAttackSpeedReductionPercentage()
	return -100
end

function modifier_generic_drenched:GetModifierHPRegenAmplify_Percentage()
	return -100
end

function modifier_generic_drenched:GetModifierMPRegenAmplify_Percentage()
	return -100
end

function modifier_generic_drenched:GetEffectName()
	--return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_generic_drenched:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end