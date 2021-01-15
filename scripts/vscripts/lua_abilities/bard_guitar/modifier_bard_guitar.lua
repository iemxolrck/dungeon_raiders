modifier_bard_guitar = class({})

function modifier_bard_guitar:RemoveOnDeath()
	return false
end

function modifier_bard_guitar:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end