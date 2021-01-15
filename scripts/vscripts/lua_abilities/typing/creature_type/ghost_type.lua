ghost_type = class({})

function ghost_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function ghost_type:IsHidden()
	return false
end

function ghost_type:RemoveOnDeath()
	return false
end

function ghost_type:IsPurgable()
	return false
end

function ghost_type:OnCreated(kv)
	if not IsServer() then return end
	
end

