modifier_cleric_blessing_agi = class({})

function modifier_cleric_blessing_agi:IsHidden()
	return false
end

function modifier_cleric_blessing_agi:IsDebuff()
	return false
end

function modifier_cleric_blessing_agi:IsPurgable()
	return true
end

function modifier_cleric_blessing_agi:OnCreated( kv )
	self.bonus_attribute = self:GetAbility():GetSpecialValueFor( "bonus_attribute" )
	self.bonus_agi = self:GetAbility():GetSpecialValueFor( "bonus_attribute" ) / 100
end

function modifier_cleric_blessing_agi:OnRefresh( kv )
	self.bonus_attribute = self:GetAbility():GetSpecialValueFor( "bonus_attribute" )
	self.bonus_agi = self:GetAbility():GetSpecialValueFor( "bonus_attribute" ) / 100
end

function modifier_cleric_blessing_agi:OnDestroy( kv )
	if IsServer() then
		StopSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_cleric_blessing_agi:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_cleric_blessing_agi:GetModifierBonusStats_Agility()
	local total = math.floor(self:GetParent():GetBaseAgility() * self.bonus_agi)
	return total
end

function modifier_cleric_blessing_agi:OnTooltip()
	return self.bonus_attribute
end

function modifier_cleric_blessing_agi:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_beam.vpcf"
end

function modifier_cleric_blessing_agi:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end