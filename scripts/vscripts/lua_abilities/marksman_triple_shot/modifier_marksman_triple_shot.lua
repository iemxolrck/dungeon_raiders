modifier_marksman_triple_shot = class({})

function modifier_marksman_triple_shot:IsHidden()
	return false
end

function modifier_marksman_triple_shot:IsDebuff()
	return false
end

function modifier_marksman_triple_shot:IsPurgable()
	return false
end

function modifier_marksman_triple_shot:OnCreated( kv )
	
end

function modifier_marksman_triple_shot:OnRefresh( kv )

end

function modifier_marksman_triple_shot:OnDestroy( kv )
	
end

function modifier_marksman_triple_shot:OnRemoved( kv )
	
end

function modifier_marksman_triple_shot:CheckState()
	local state = {
		
	}

	return state
end

function modifier_marksman_triple_shot:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_marksman_triple_shot:GetModifierPercentageCasttime( params )
	--if not IsServer() then return end
	--if params.ability~=self:GetAbility() then return end
	return 100
end

function modifier_marksman_triple_shot:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end
	--if params.ability~=self:GetAbility() then return end
	if params.ability:GetName()=="marksman_dash" or
		params.ability:GetName()==self:GetAbility():GetName() or
		params.ability:GetName()=="marksman_triple_shot_first_arrow" or
		params.ability:GetName()=="marksman_triple_shot_third_arrow" then return end
	self:Destroy()
end