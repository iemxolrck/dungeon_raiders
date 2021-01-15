modifier_cleric_clairvoyance_buff = class ({})

function modifier_cleric_clairvoyance_buff:IsHidden()
	return true
end

function modifier_cleric_clairvoyance_buff:IsDebuff()
	return false
end

function modifier_cleric_clairvoyance_buff:IsPurgable()
	return false
end

function modifier_cleric_clairvoyance_buff:OnCreated( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
end

function modifier_cleric_clairvoyance_buff:OnRefresh( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
end

function modifier_cleric_clairvoyance_buff:OnDestroy( kv )

end

function modifier_cleric_clairvoyance_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_cleric_clairvoyance_buff:GetModifierEvasion_Constant()
	if self:GetParent():PassivesDisabled() then return end
	return self.evasion
end

function modifier_cleric_clairvoyance_buff:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf"
end

function modifier_cleric_clairvoyance_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end