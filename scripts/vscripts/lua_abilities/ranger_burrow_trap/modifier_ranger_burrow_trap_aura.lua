modifier_ranger_burrow_trap_aura = class({})

function modifier_ranger_burrow_trap_aura:IsHidden()
	return true
end

function modifier_ranger_burrow_trap_aura:IsDebuff()
	return false
end

function modifier_ranger_burrow_trap_aura:IsPurgable()
	return false
end

function modifier_ranger_burrow_trap_aura:OnCreated()

end

function modifier_ranger_burrow_trap_aura:OnRefresh()

end

function modifier_ranger_burrow_trap_aura:OnRemoved()
	
end

function modifier_ranger_burrow_trap_aura:OnDestroy()
	
end

function modifier_ranger_burrow_trap_aura:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function modifier_ranger_burrow_trap_aura:IsAura()
	return true
end

function modifier_ranger_burrow_trap_aura:GetModifierAura()
	return "modifier_ranger_burrow_trap_int"
end

function modifier_ranger_burrow_trap_aura:GetAuraRadius()
	return 100
end

function modifier_ranger_burrow_trap_aura:GetAuraDuration()
	return 0.5
end

function modifier_ranger_burrow_trap_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_ranger_burrow_trap_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP 
end

function modifier_ranger_burrow_trap_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_ranger_burrow_trap_aura:GetAuraEntityReject(hEntity)
	if not IsServer() then return end
	if hEntity==self:GetParent():GetOwner() then return false end
	if hEntity:IsDominated()==true or hEntity:IsSummoned()==true then 
		if hEntity:GetOwner()==self:GetParent():GetOwner() then
			return false
		end
	end		
end