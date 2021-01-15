modifier_summon_treant_fury_swipes_debuff = class({})

--------------------------------------------------------------------------------

function modifier_summon_treant_fury_swipes_debuff:IsHidden()
	return false
end

function modifier_summon_treant_fury_swipes_debuff:IsDebuff()
	return true
end

function modifier_summon_treant_fury_swipes_debuff:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_summon_treant_fury_swipes_debuff:OnCreated( kv )
	self:SetStackCount(1)
end

function modifier_summon_treant_fury_swipes_debuff:OnRefresh( kv )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_summon_treant_fury_swipes_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_summon_treant_fury_swipes_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end