modifier_warrior_perseverance_buff = class({})

function modifier_warrior_perseverance_buff:IsHidden()
	return false
end

function modifier_warrior_perseverance_buff:IsPurgable()
	return false
end

function modifier_warrior_perseverance_buff:OnCreated( kv )
	self.str_as_health_regen = self:GetAbility():GetSpecialValueFor( "str_as_health_regen" ) / 100
	self.max_damage_reduction = -self:GetAbility():GetSpecialValueFor( "max_damage_reduction" )
	self.threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold_max" )
	self.range = 100 - self.threshold
end

function modifier_warrior_perseverance_buff:OnRefresh( kv )
	self.str_as_health_regen = self:GetAbility():GetSpecialValueFor( "str_as_health_regen" ) / 100
	self.max_damage_reduction = -self:GetAbility():GetSpecialValueFor( "max_damage_reduction" )
	self.threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold_max" )
	self.range = 100 - self.threshold
end

function modifier_warrior_perseverance_buff:OnDestroy( kv )

end

function modifier_warrior_perseverance_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		--MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end


function modifier_warrior_perseverance_buff:GetModifierConstantHealthRegen()
	if self:GetCaster():PassivesDisabled() then return end
	local str = 1
	if self:GetParent():IsHero() then str = self:GetParent():GetStrength() * self.str_as_health_regen end
	local pct = math.max(((self:GetParent():GetHealthPercent()-self.threshold)/self.range),0)
	return (1-pct) * (str)
end

function modifier_warrior_perseverance_buff:GetModifierIncomingDamage_Percentage()
	--return self.max_damage_reduction
end