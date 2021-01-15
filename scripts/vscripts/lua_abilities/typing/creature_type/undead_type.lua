undead_type = class({})

function undead_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function undead_type:IsHidden()
	return false
end

function undead_type:RemoveOnDeath()
	return false
end

function undead_type:IsPurgable()
	return false
end

function undead_type:OnCreated(kv)
	if not IsServer() then return end
	
end
