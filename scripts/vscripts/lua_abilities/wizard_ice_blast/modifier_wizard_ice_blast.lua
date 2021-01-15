modifier_wizard_ice_blast = class({})

function modifier_wizard_ice_blast:IsHidden()
	return true
end

function modifier_wizard_ice_blast:OnCreated( kv )
	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self:GetAbility():GetSpecialValueFor("frozen_damage"),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		inflictor = self:GetAbility(),
	}

	ApplyDamage(self.damageTable)
	self:Destroy()
end

function modifier_wizard_ice_blast:OnRefresh( kv )
	
end

function modifier_wizard_ice_blast:OnDestroy( kv )
	
end