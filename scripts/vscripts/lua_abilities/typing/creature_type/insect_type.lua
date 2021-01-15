insect_type = class({})

function insect_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function insect_type:IsHidden()
	return false
end

function insect_type:RemoveOnDeath()
	return false
end

function insect_type:IsPurgable()
	return false
end

function insect_type:OnCreated(kv)
	if not IsServer() then return end
	
end

