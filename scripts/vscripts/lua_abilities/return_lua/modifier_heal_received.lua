modifier_heal_received = class({})

function modifier_heal_received:IsHidden()
    return true
end

function modifier_heal_received:IsDebuff()
    return false
end

function modifier_heal_received:IsPurgable()
    return false
end

function modifier_heal_received:OnCreated( kv )
	self:StartIntervalThink(0)
	--PlayerResource:SetCustomBuybackCooldown(self:GetParent():GetPlayerID(), 10)

end

function modifier_heal_received:OnRefresh( kv )

end

function modifier_heal_received:OnDestroy( kv )

end

function modifier_heal_received:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    	--MODIFIER_EVENT_ON_MANA_GAINED,
        MODIFIER_EVENT_ON_HEAL_RECEIVED,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT = 26,
    }
    return funcs
end

function modifier_heal_received:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_heal_received:GetModifierHealthRegenPercentage()
	return 0
end

function modifier_heal_received:OnHealReceived(params)
	--local unit = keys.unit
	--local amount = keys.gain
	--SendOverheadEventMessage( unit, OVERHEAD_ALERT_HEAL , unit, amount, nil )

	if IsServer() then
		local parent = self:GetParent()
		local inflictor = params.inflictor
		local unit = params.unit
		local amount = params.gain
		

		if unit == parent then
			if inflictor and inflictor ~= self:GetAbility() then
			print("Amount: "..amount)
			print("Unit:")
			print(unit:GetName())
			print("Parent:")
			print(parent:GetName())
			print("Inflictor:")
			print(inflictor:GetName())
			print(" ")
				SendOverheadEventMessage( unit, OVERHEAD_ALERT_HEAL , unit, amount, nil )
			end
		end

	end

end

function modifier_heal_received:OnManaGained(params)
	if IsServer() then
		local parent = self:GetParent()
		local unit = params.unit
		local amount = params.gain
		

		if unit == parent then
			print("Amount: "..amount)
			print("Unit:")
			print(unit:GetName())
			print("Parent:")
			print(parent:GetName())
			print(" ")
			SendOverheadEventMessage( unit, OVERHEAD_ALERT_MANA_ADD , unit, amount, nil )

		end
	end
end