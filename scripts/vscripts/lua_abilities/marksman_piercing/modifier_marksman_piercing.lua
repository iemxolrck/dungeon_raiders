modifier_marksman_piercing = class({})

function modifier_marksman_piercing:IsHidden()
	return false
end

function modifier_marksman_piercing:IsDebuff()
	return false
end

function modifier_marksman_piercing:IsPurgable()
	return false
end

function modifier_marksman_piercing:OnCreated( kv )
	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
end

function modifier_marksman_piercing:OnRefresh( kv )
	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
end

function modifier_marksman_piercing:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}

	return funcs
end

function modifier_marksman_piercing:GetModifierProjectileSpeedBonus()
	return self.projectile_speed
end