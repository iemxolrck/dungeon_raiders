modifier_engineer_laser_beam = class({})

function modifier_engineer_laser_beam:IsHidden()
	return false
end

function modifier_engineer_laser_beam:IsDebuff()
	return true
end

function modifier_engineer_laser_beam:IsStunDebuff()
	return false
end

function modifier_engineer_laser_beam:IsPurgable()
	return true
end

function modifier_engineer_laser_beam:OnCreated( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end

function modifier_engineer_laser_beam:OnRefresh( kv )
	-- references
	self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
end

function modifier_engineer_laser_beam:OnDestroy( kv )

end

function modifier_engineer_laser_beam:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}

	return funcs
end

function modifier_engineer_laser_beam:GetModifierMiss_Percentage()
	return self.miss_rate
end