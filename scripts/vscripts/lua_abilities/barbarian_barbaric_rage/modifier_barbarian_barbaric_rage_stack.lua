modifier_barbarian_barbaric_rage_stack = class ({})

function modifier_barbarian_barbaric_rage_stack:IsHidden()
	return true
end

function modifier_barbarian_barbaric_rage_stack:IsPurgable()
	return false
end

function modifier_barbarian_barbaric_rage_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_barbarian_barbaric_rage_stack:OnDestroy()
	if not IsServer() then return end
	if self.parent:GetStackCount()==0 then return end
	self.parent:RemoveStack()
end