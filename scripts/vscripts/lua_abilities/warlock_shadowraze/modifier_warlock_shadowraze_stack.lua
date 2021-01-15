modifier_warlock_shadowraze_stack = class({})

function modifier_warlock_shadowraze_stack:IsHidden()
	return false
end

function modifier_warlock_shadowraze_stack:IsDebuff()
	return true
end

function modifier_warlock_shadowraze_stack:IsPurgable()
	return false
end
function modifier_warlock_shadowraze_stack:OnCreated( kv )
	self:SetStackCount(1)
end

function modifier_warlock_shadowraze_stack:OnRefresh( kv )

end

function modifier_warlock_shadowraze_stack:GetEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_shadowraze_debuff.vpcf"
end

function modifier_warlock_shadowraze_stack:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end