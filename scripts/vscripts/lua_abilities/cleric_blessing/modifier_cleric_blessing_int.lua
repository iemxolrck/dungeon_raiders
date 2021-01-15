modifier_cleric_blessing_int = class({})

function modifier_cleric_blessing_int:IsHidden()
	return false
end

function modifier_cleric_blessing_int:IsDebuff()
	return false
end

function modifier_cleric_blessing_int:IsPurgable()
	return true
end

function modifier_cleric_blessing_int:OnCreated( kv )
	self.bonus_attribute = self:GetAbility():GetSpecialValueFor( "bonus_attribute" )
	self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_attribute" ) / 100
end

function modifier_cleric_blessing_int:OnRefresh( kv )
	self.bonus_attribute = self:GetAbility():GetSpecialValueFor( "bonus_attribute" )
	self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_attribute" ) / 100
end

function modifier_cleric_blessing_int:OnDestroy( kv )
	if IsServer() then
		StopSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_cleric_blessing_int:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_cleric_blessing_int:GetModifierBonusStats_Intellect()
	local total = math.floor(self:GetParent():GetBaseIntellect() * self.bonus_int)
	return total
end

function modifier_cleric_blessing_int:OnTooltip()
	return self.bonus_attribute
end

function modifier_cleric_blessing_int:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_beam.vpcf"
end

function modifier_cleric_blessing_int:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end