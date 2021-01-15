modifier_bard_confuse_debuff = class({})


function modifier_bard_confuse_debuff:IsHidden()
	return false
end

function modifier_bard_confuse_debuff:IsDebuff()
	return true
end

function modifier_bard_confuse_debuff:IsStunDebuff()
	return false
end

function modifier_bard_confuse_debuff:IsPurgable()
	return true
end

function modifier_bard_confuse_debuff:OnCreated( kv )
	self.confused_miss_chance = self:GetAbility():GetSpecialValueFor( "confused_miss_chance" )
end

function modifier_bard_confuse_debuff:OnRefresh( kv )

end

function modifier_bard_confuse_debuff:OnRemoved()

end

function modifier_bard_confuse_debuff:OnDestroy()
end

function modifier_bard_confuse_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_bard_confuse_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.confused_miss_chance
end

function modifier_bard_confuse_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
	}

	return state
end

function modifier_bard_confuse_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_stunned_old.vpcf"
end

function modifier_bard_confuse_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end