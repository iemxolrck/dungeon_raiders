modifier_ranger_latent_venom_armor = class({})

function modifier_ranger_latent_venom_armor:IsHidden()
	return true
end

function modifier_ranger_latent_venom_armor:IsDebuff()
	return true
end

function modifier_ranger_latent_venom_armor:IsStunDebuff()
	return false
end

function modifier_ranger_latent_venom_armor:IsPurgable()
	return true
end

function modifier_ranger_latent_venom_armor:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ranger_latent_venom_armor:OnCreated( kv )
	self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
	self.armor = -self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	 self.magic_resist = -self:GetAbility():GetSpecialValueFor( "resist_reduction" )
	self:SetStackCount(1)
	self:StartIntervalThink( self.interval )

end

function modifier_ranger_latent_venom_armor:OnRefresh( kv )
	
end

function modifier_ranger_latent_venom_armor:OnDestroy()
	
end

function modifier_ranger_latent_venom_armor:OnRemoved()
	
end

function modifier_ranger_latent_venom_armor:OnIntervalThink()
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_ranger_latent_venom_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_ranger_latent_venom_armor:GetModifierPhysicalArmorBonus()
	return self.armor * self:GetStackCount()
end

function modifier_ranger_latent_venom_armor:GetModifierMagicalResistanceBonus()
	return self.magic_resist * self:GetStackCount()
end