fairy_type = class({})

function fairy_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function fairy_type:IsHidden()
	return false
end

function fairy_type:RemoveOnDeath()
	return false
end

function fairy_type:IsPurgable()
	return false
end

function fairy_type:OnCreated(kv)
	if not IsServer() then return end
	
end

