bird_type = class({})

function bird_type:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function bird_type:IsHidden()
	return false
end

function bird_type:RemoveOnDeath()
	return false
end

function bird_type:IsPurgable()
	return false
end

function bird_type:OnCreated(kv)
	if not IsServer() then return end
	self:GetParent():AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"beast_type",
				{}
			)
end
