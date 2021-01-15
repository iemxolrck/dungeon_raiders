modifier_shadow_fiend_shadowraze = class({})

function modifier_shadow_fiend_shadowraze:IsHidden()
	return false
end

function modifier_shadow_fiend_shadowraze:IsDebuff()
	return true
end

function modifier_shadow_fiend_shadowraze:IsPurgable()
	return false
end
function modifier_shadow_fiend_shadowraze:OnCreated( kv )
	self:SetStackCount(1)
end

function modifier_shadow_fiend_shadowraze:OnRefresh( kv )

end

function modifier_shadow_fiend_shadowraze:GetEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_shadowraze_debuff.vpcf"
end

function modifier_shadow_fiend_shadowraze:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end