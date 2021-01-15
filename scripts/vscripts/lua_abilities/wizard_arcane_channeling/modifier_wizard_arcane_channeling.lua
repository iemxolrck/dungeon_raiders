modifier_wizard_arcane_channeling = class({})

function modifier_wizard_arcane_channeling:IsHidden()
	return self:GetParent():PassivesDisabled()
end

function modifier_wizard_arcane_channeling:IsDebuff()
	return false
end

function modifier_wizard_arcane_channeling:IsPurgable()
	return false
end

function modifier_wizard_arcane_channeling:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_amp" )
	self.min_range = 500
end

function modifier_wizard_arcane_channeling:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_amp" )
end

function modifier_wizard_arcane_channeling:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end


function modifier_wizard_arcane_channeling:OnTooltip()
	return self.damage
end

function modifier_wizard_arcane_channeling:GetModifierPercentageCooldown()
	return -self.damage / 2
end

function modifier_wizard_arcane_channeling:GetModifierPercentageManacostStacking()
	return -self.damage / 2
end

function modifier_wizard_arcane_channeling:GetModifierTotalDamageOutgoing_Percentage( params )
	if not IsServer() then return end
	local inflictor = params.inflictor
	if inflictor==nil then return end
	if inflictor:GetChannelTime()==nil then return end
	local isChannel = inflictor:GetChannelTime()>0
	if not isChannel then return end
	print( inflictor )
	print( inflictor:GetChannelTime() )
	return self.damage
end