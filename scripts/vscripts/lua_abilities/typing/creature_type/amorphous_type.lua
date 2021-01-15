amorphous_type = class({})

function amorphous_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function amorphous_type:IsHidden()
	return false
end

function amorphous_type:RemoveOnDeath()
	return false
end

function amorphous_type:IsPurgable()
	return false
end

function amorphous_type:OnCreated(kv)
	if not IsServer() then return end
	
end

