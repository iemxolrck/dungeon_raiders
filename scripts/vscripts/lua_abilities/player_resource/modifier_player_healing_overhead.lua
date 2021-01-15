modifier_player_healing_overhead = class ({})

function modifier_player_healing_overhead:IsHidden()
    return false
end

function modifier_player_healing_overhead:IsDebuff()
    return false
end

function modifier_player_healing_overhead:IsPurgable()
    return false
end

function modifier_player_healing_overhead:OnCreated( kv )
	self:StartIntervalThink(0)

end

function modifier_player_healing_overhead:OnRefresh( kv )

end

function modifier_player_healing_overhead:OnDestroy( kv )

end

function modifier_player_healing_overhead:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_HEAL_RECEIVED
    }
    return funcs
end


function modifier_player_healing_overhead:GetModifierHealthRegenPercentage()
	return 0
end

function modifier_player_healing_overhead:OnHealReceived(params)
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