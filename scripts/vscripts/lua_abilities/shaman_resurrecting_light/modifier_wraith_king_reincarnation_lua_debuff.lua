modifier_shaman_resurrecting_light_debuff = class({})

function modifier_shaman_resurrecting_light_debuff:IsHidden()
	return false
end

function modifier_shaman_resurrecting_light_debuff:IsDebuff()
	return true
end

function modifier_shaman_resurrecting_light_debuff:IsStunDebuff()
	return false
end

function modifier_shaman_resurrecting_light_debuff:IsPurgable()
	return true
end

function modifier_shaman_resurrecting_light_debuff:OnCreated( kv )
	-- references
	self.move_slow = self:GetAbility():GetSpecialValueFor( "movespeed" ) -- special value
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attackslow_tooltip" ) -- special value
end

function modifier_shaman_resurrecting_light_debuff:OnRefresh( kv )
	-- references
	self.move_slow = self:GetAbility():GetSpecialValueFor( "movespeed" ) -- special value
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attackslow_tooltip" ) -- special value
end

function modifier_shaman_resurrecting_light_debuff:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_shaman_resurrecting_light_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_shaman_resurrecting_light_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end

function modifier_shaman_resurrecting_light_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_shaman_resurrecting_light_debuff:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf"
end

function modifier_shaman_resurrecting_light_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end