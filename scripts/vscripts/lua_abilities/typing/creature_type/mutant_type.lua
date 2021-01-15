mutant_type = class({})

function mutant_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function mutant_type:IsHidden()
	return false
end

function mutant_type:RemoveOnDeath()
	return false
end

function mutant_type:IsPurgable()
	return false
end

function mutant_type:OnCreated(kv)
	if not IsServer() then return end
	
end

