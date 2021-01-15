dragon_type = class({})

function dragon_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function dragon_type:IsHidden()
	return false
end

function dragon_type:RemoveOnDeath()
	return false
end

function dragon_type:IsPurgable()
	return false
end

function dragon_type:OnCreated(kv)
	if not IsServer() then return end
	
end

