modifier_summon_treant_chlorophyll = class ({})

function modifier_summon_treant_chlorophyll:IsHidden()
	return true
end

function modifier_summon_treant_chlorophyll:IsDebuff()
	return false
end

function modifier_summon_treant_chlorophyll:IsPurgable()
	return false
end

function modifier_summon_treant_chlorophyll:OnCreated( kv )
	self:StartIntervalThink(0)
end

function modifier_summon_treant_chlorophyll:OnRefresh( kv )
	
end

function modifier_summon_treant_chlorophyll:OnRemoved( kv )

end

function modifier_summon_treant_chlorophyll:OnIntervalThink(keys)
	if IsServer() then
		if self:GetParent():PassivesDisabled()==false then
			if GameRules:IsDaytime()==true then
				if self:GetParent():HasModifier("modifier_summon_treant_chlorophyll_buff")==false then
					self:GetParent():AddNewModifier( 
						self:GetCaster(),
						self:GetAbility(),
						"modifier_summon_treant_chlorophyll_buff",
						{ }
					)
				end
			else
				if self:GetParent():HasModifier("modifier_summon_treant_chlorophyll_buff")==true then
					self:GetParent():FindModifierByName("modifier_summon_treant_chlorophyll_buff"):Destroy()
				end
			end
		else
			if self:GetParent():HasModifier("modifier_summon_treant_chlorophyll_buff")==true then
				self:GetParent():FindModifierByName("modifier_summon_treant_chlorophyll_buff"):Destroy()
			end
		end
	end
end

function modifier_summon_treant_chlorophyll:CheckState()
	local state = {
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}

	return state
end