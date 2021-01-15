modifier_warlock_nyctophobia = class({})

function modifier_warlock_nyctophobia:IsHidden()
	return self:GetParent():PassivesDisabled()
end

function modifier_warlock_nyctophobia:IsDebuff()
	return false
end

function modifier_warlock_nyctophobia:IsPurgable()
	return false
end

function modifier_warlock_nyctophobia:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_to_blind" )
	self.min_range = 500
end

function modifier_warlock_nyctophobia:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_to_blind" )
end

function modifier_warlock_nyctophobia:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_warlock_nyctophobia:OnTooltip()
	return self.damage
end

function modifier_warlock_nyctophobia:GetModifierTotalDamageOutgoing_Percentage( params )
	if not IsServer() then return end
	local target = params.target
	if not target:IsBlind() then return end
	return self.damage
end