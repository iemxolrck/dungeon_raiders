modifier_bard_drowzy_debuff = class({})


function modifier_bard_drowzy_debuff:IsHidden()
	return false
end

function modifier_bard_drowzy_debuff:IsDebuff()
	return true
end

function modifier_bard_drowzy_debuff:IsStunDebuff()
	return false
end

function modifier_bard_drowzy_debuff:IsPurgable()
	return true
end

function modifier_bard_drowzy_debuff:OnCreated( kv )
	self.drowzy_miss_chance = self:GetAbility():GetSpecialValueFor( "drowzy_miss_chance" )
end

function modifier_bard_drowzy_debuff:OnRefresh( kv )

end

function modifier_bard_drowzy_debuff:OnRemoved()

end

function modifier_bard_drowzy_debuff:OnDestroy()
end

function modifier_bard_drowzy_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}

	return funcs
end

function modifier_bard_drowzy_debuff:GetModifierMiss_Percentage()
	return self.drowzy_miss_chance
end

function modifier_bard_drowzy_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
	}

	return state
end