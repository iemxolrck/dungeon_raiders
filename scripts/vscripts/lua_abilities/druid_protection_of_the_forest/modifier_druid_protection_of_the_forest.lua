modifier_druid_protection_of_the_forest = class ({})

function modifier_druid_protection_of_the_forest:IsHidden()
	if self:GetStackCount()<=0 then
		return true
	else
		return false
	end
end

function modifier_druid_protection_of_the_forest:IsDebuff()
	return false
end

function modifier_druid_protection_of_the_forest:IsPurgable()
	return false
end

function modifier_druid_protection_of_the_forest:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetCastRange( self:GetParent():GetAbsOrigin(), nil )
		self:StartIntervalThink(0)
	end
end

function modifier_druid_protection_of_the_forest:OnRefresh( kv )

end

function modifier_druid_protection_of_the_forest:OnRemoved( kv )

end

function modifier_druid_protection_of_the_forest:OnIntervalThink()
	self.radius = self:GetAbility():GetCastRange( self:GetParent():GetAbsOrigin(), nil )
	local count = 0
	local summons = FindUnitsInRadius(
		self:GetParent():GetTeam(),
		self:GetParent():GetAbsOrigin(),
		nil, 
		self.radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, summon in pairs(summons) do
		if summon:IsSummoned()==true then
			if  summon:GetOwnerEntity()==self:GetParent() then
				count = count + 1
			end
		end
	end
	self:SetStackCount( count )
	count = 0
end

function modifier_druid_protection_of_the_forest:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}

	return funcs
end

function modifier_druid_protection_of_the_forest:GetModifierConstantHealthRegen()
	local hp_regen_per_summon = self:GetAbility():GetSpecialValueFor( "hp_regen_per_summon" )
	local total = math.floor( self:GetStackCount() * hp_regen_per_summon )
	return total
end

function modifier_druid_protection_of_the_forest:GetModifierConstantManaRegen()
	local mana_regen_per_summon = self:GetAbility():GetSpecialValueFor( "mana_regen_per_summon" )
	local total = math.floor( self:GetStackCount() * mana_regen_per_summon )
	return total
end