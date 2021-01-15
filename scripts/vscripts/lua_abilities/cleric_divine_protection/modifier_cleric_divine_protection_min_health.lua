modifier_cleric_divine_protection_min_health = class({})

function modifier_cleric_divine_protection_min_health:IsHidden()
	return false
end

function modifier_cleric_divine_protection_min_health:IsDebuff()
	return false
end

function modifier_cleric_divine_protection_min_health:IsPurgable()
	return true
end

function modifier_cleric_divine_protection_min_health:OnCreated( kv )
	self.min_health = self:GetAbility():GetSpecialValueFor( "min_health" )
	self.health_regen_amp = self:GetAbility():GetSpecialValueFor( "health_regen_amp" )
	self.mana_regen_amp = self:GetAbility():GetSpecialValueFor( "mana_regen_amp" )
	self.invulnerable_duration = self:GetAbility():GetSpecialValueFor( "invulnerable_duration" )
	self:StartIntervalThink(0)
end

function modifier_cleric_divine_protection_min_health:OnRefresh( kv )
	self:OnCreated( kv )
	
end

function modifier_cleric_divine_protection_min_health:OnIntervalThink()
	if IsServer() then
		local current_health = self:GetParent():GetHealth()
		--print(current_health)
		if current_health == self.min_health then
			self:GetParent():AddNewModifier(
				self:GetCaster(),
				self:GetAbility(),
				"modifier_cleric_divine_protection_invincible",
				{ duration = self.invulnerable_duration }
			)
			self:GetParent():AddNewModifier(
				self:GetCaster(),
				self:GetAbility(),
				"modifier_cleric_divine_protection_regen",
				{ }
			)

			self:Destroy()
		end
	end
end

function modifier_cleric_divine_protection_min_health:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function modifier_cleric_divine_protection_min_health:GetMinHealth()
	return self.min_health
end

function modifier_cleric_divine_protection_min_health:GetModifierHPRegenAmplify_Percentage()
	return self.health_regen_amp
end

function modifier_cleric_divine_protection_min_health:GetModifierMPRegenAmplify_Percentage()
	return self.mana_regen_amp
end

function modifier_cleric_divine_protection_min_health:GetEffectName()
	return --"particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf"
end

function modifier_cleric_divine_protection_min_health:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end