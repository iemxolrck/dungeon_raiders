modifier_cleric_divine_protection_resist = class({})

function modifier_cleric_divine_protection_resist:IsHidden()
	return false
end

function modifier_cleric_divine_protection_resist:IsDebuff()
	return false
end

function modifier_cleric_divine_protection_resist:IsPurgable()
	return true
end

function modifier_cleric_divine_protection_resist:OnCreated( kv )
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName( "cleric_channel_divinity" )
	self.resist = ability:GetLevelSpecialValueFor( "damage_resist" , ability:GetLevel()-1 )
	self:SetStackCount(self.resist)
end

function modifier_cleric_divine_protection_resist:OnRefresh( kv )
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName( "cleric_channel_divinity" )
	self.resist = ability:GetLevelSpecialValueFor( "damage_resist" , ability:GetLevel()-1 )
	self:SetStackCount(self.resist)
end

function modifier_cleric_divine_protection_resist:OnDestroy( kv )

end

function modifier_cleric_divine_protection_resist:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_cleric_divine_protection_resist:GetModifierIncomingDamage_Percentage()
	return -self:GetStackCount()
end

function modifier_cleric_divine_protection_resist:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf"
end

function modifier_cleric_divine_protection_resist:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end