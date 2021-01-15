modifier_cleric_divine_protection_regen = class({})

function modifier_cleric_divine_protection_regen:IsHidden()
	return false
end

function modifier_cleric_divine_protection_regen:IsDebuff()
	return false
end

function modifier_cleric_divine_protection_regen:IsPurgable()
	return true
end

function modifier_cleric_divine_protection_regen:OnCreated( kv )
	self.health_percent = 0.01
	self:StartIntervalThink(0)
end

function modifier_cleric_divine_protection_regen:OnRefresh( kv )
	self:OnCreated( kv )
	
end

function modifier_cleric_divine_protection_regen:OnIntervalThink()
	if IsServer() then
		local max_health = self:GetParent():GetMaxHealth()
		local current_health = self:GetParent():GetHealth()
		self:GetParent():SetHealth(current_health+(max_health*self.health_percent))
		if max_health==current_health then
			self:Destroy()
		end
	end
end

function modifier_cleric_divine_protection_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
		--MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_cleric_divine_protection_regen:GetMinHealth()
	return self.min_health
end

function modifier_cleric_divine_protection_regen:GetModifierConstantHealthRegen()
	local max_health = self:GetParent():GetMaxHealth()
	return math.max(self.health_percent*max_health)
end

function modifier_cleric_divine_protection_regen:GetEffectName()
	--return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf"
end

function modifier_cleric_divine_protection_regen:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end