modifier_bard_flute = class({})

function modifier_bard_flute:RemoveOnDeath()
	return false
end

function modifier_bard_flute:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end