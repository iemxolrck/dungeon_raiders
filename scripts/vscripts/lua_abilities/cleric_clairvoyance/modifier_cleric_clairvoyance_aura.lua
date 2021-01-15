modifier_cleric_clairvoyance_aura = class ({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_cleric_clairvoyance_aura:IsHidden()
	return false
end

function modifier_cleric_clairvoyance_aura:IsDebuff()
	return true
end

function modifier_cleric_clairvoyance_aura:IsPurgable()
	return false
end

function modifier_cleric_clairvoyance_aura:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_cleric_clairvoyance_aura:OnCreated( kv )
	self.think = false
end

function modifier_cleric_clairvoyance_aura:OnRefresh( kv )
end

function modifier_cleric_clairvoyance_aura:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
    }

    return funcs
end

function modifier_cleric_clairvoyance_aura:DestroyOnExpire()
    return true
end

function modifier_cleric_clairvoyance_aura:GetModifierProvidesFOWVision()
	--if self:GetCaster():PassivesDisabled() then return end
    return 1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_cleric_clairvoyance_aura:CheckState()

	local state = {
		[MODIFIER_STATE_INVISIBLE] = self.think
	}

	return state
end