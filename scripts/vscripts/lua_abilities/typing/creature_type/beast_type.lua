beast_type = class({})

function beast_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function beast_type:IsHidden()
	if self:GetParent():HasModifier("bird_type") then
		return true
	else
		return false
	end
end

function beast_type:RemoveOnDeath()
	return false
end

function beast_type:IsPurgable()
	return false
end

function beast_type:OnCreated(kv)
	if not IsServer() then return end
	
end
