modifier_bard_lyre = class({})

function modifier_bard_lyre:RemoveOnDeath()
	return false
end

function modifier_bard_lyre:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end