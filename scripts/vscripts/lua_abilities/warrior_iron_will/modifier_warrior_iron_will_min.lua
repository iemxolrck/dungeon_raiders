modifier_warrior_iron_will_min = class({})

function modifier_warrior_iron_will_min:IsHidden()
	return tru
end

function modifier_warrior_iron_will_min:IsPurgable()
	return false
end

function modifier_warrior_iron_will_min:OnCreated( kv )
	self.hp_threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold" ) 
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self:StartIntervalThink(0)
	
end

function modifier_warrior_iron_will_min:OnRefresh( kv )
	self.hp_threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold" ) 
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	
end

function modifier_warrior_iron_will_min:OnDestroy( kv )

end

function modifier_warrior_iron_will_min:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():PassivesDisabled() then return end
		if self:GetParent():GetHealth()==self.hp_threshold
			and self:GetAbility():IsCooldownReady()
			and self:GetParent():HasModifier("modifier_cleric_divine_protection_min_health")==false
			and self:GetParent():HasModifier("modifier_cleric_divine_protection_regen")==false then
			self:GetParent():AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_warrior_iron_will_buff",
				{ duration = self.duration }
			)
			self:GetAbility():UseResources( false, false, true )
			self:Destroy()
		end
	end
end

function modifier_warrior_iron_will_min:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH
	}

	return funcs
end

function modifier_warrior_iron_will_min:GetMinHealth()
	if not self:GetAbility():IsCooldownReady() then return end
	if self:GetCaster():PassivesDisabled() then return end
	return self.hp_threshold
end

function modifier_warrior_iron_will_min:GetEffectName()
	--return "particles/items_fx/glyph.vpcf"
end

function modifier_warrior_iron_will_min:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
