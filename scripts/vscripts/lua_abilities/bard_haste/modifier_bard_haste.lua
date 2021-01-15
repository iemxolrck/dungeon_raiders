modifier_bard_haste = class({})

function modifier_bard_haste:IsHidden()
	return false
end

function modifier_bard_haste:IsDebuff()
	return false
end

function modifier_bard_haste:IsPurgable()
	return true
end

function modifier_bard_haste:OnCreated( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.agi_as_move_speed = self:GetAbility():GetSpecialValueFor( "agi_as_move_speed" ) / 100
	self.particles = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
end

function modifier_bard_haste:OnRefresh( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.agi_as_move_speed = self:GetAbility():GetSpecialValueFor( "agi_as_move_speed" ) / 100
end

function modifier_bard_haste:OnRemoved()
	ParticleManager:DestroyParticle( self.particles, true )
end

function modifier_bard_haste:OnDestroy()
	ParticleManager:DestroyParticle( self.particles, true )
end

function modifier_bard_haste:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_bard_haste:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end

function modifier_bard_haste:GetModifierMoveSpeedBonus_Constant()
	return self.agi_as_move_speed * self:GetCaster():GetAgility()
end

function modifier_bard_haste:CheckState()
	local state = {
		[MODIFIER_STATE_UNSLOWABLE] = true
	}

	return state
end