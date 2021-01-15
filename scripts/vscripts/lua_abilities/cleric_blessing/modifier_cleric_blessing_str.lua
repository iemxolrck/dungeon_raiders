modifier_cleric_blessing_str = class({})

function modifier_cleric_blessing_str:IsHidden()
	return false
end

function modifier_cleric_blessing_str:IsDebuff()
	return false
end

function modifier_cleric_blessing_str:IsPurgable()
	return true
end

function modifier_cleric_blessing_str:OnCreated( kv )
	self.bonus_attribute = self:GetAbility():GetSpecialValueFor( "bonus_attribute" )
	self.bonus_str = self:GetAbility():GetSpecialValueFor( "bonus_attribute" )/100
end

function modifier_cleric_blessing_str:OnRefresh( kv )
	self.bonus_attribute = self:GetAbility():GetSpecialValueFor( "bonus_attribute" )
	self.bonus_str = self:GetAbility():GetSpecialValueFor( "bonus_attribute" )/100
end

function modifier_cleric_blessing_str:OnDestroy( kv )
	if IsServer() then
		StopSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_cleric_blessing_str:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_cleric_blessing_str:GetModifierBonusStats_Strength()
	local total = math.floor(self:GetParent():GetBaseStrength() * self.bonus_str)
	return total
end

function modifier_cleric_blessing_str:OnTooltip()
	return self.bonus_attribute
end

function modifier_cleric_blessing_str:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_beam.vpcf"
end

function modifier_cleric_blessing_str:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end