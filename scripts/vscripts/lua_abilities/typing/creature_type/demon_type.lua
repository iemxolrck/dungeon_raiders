demon_type = class({})

function demon_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function demon_type:IsHidden()
	return false
end

function demon_type:RemoveOnDeath()
	return false
end

function demon_type:IsPurgable()
	return false
end

function demon_type:OnCreated(kv)
	if not IsServer() then return end
	
end
