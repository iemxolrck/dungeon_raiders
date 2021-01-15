modifier_ranger_heighten_senses_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ranger_heighten_senses_buff:IsHidden()
	return true
end

function modifier_ranger_heighten_senses_buff:IsDebuff()
	return false
end

function modifier_ranger_heighten_senses_buff:IsPurgable()
	return false
end

function modifier_ranger_heighten_senses_buff:IsAura()
	return true
end

function modifier_ranger_heighten_senses_buff:GetModifierAura()
	return "modifier_ranger_heighten_senses"
end

function modifier_ranger_heighten_senses_buff:GetAuraRadius()
	return FIND_UNITS_EVERYWHERE
end

function modifier_ranger_heighten_senses_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ranger_heighten_senses_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC

function modifier_ranger_heighten_senses_buff:GetAuraEntityReject(hEntity)
	if IsServer() then
		local id = self:GetCaster():GetPlayerOwnerID()
		if hEntity:IsDominated()==true or hEntity:IsSummoned()==true then
			if hEntity:GetPlayerOwnerID()==id then
				return false
			end
		elseif hEntity:GetPlayerID()==id then
			return false
		else
			return true
		end
	end
end