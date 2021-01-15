modifier_shaman_maximize = class({})

function modifier_shaman_maximize:IsHidden()
	return false
end

function modifier_shaman_maximize:IsDebuff()
	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()
end

function modifier_shaman_maximize:IsPurgable()
	return true
end

function modifier_shaman_maximize:OnCreated( kv )
	self.modelscale = self:GetAbility():GetSpecialValueFor( "modelscale" )
	self.movement_speed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.health_percent = self:GetAbility():GetSpecialValueFor( "health_percent" )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
	
	if not IsServer() then return end

	local sound_cast = "Hero_OgreMagi.Bloodlust.Target"
	EmitSoundOn( sound_cast, self:GetParent() )

	local sound_player = "Hero_OgreMagi.Bloodlust.Target.FP"
	EmitSoundOnClient( sound_player, self:GetParent():GetPlayerOwner() )
end

function modifier_shaman_maximize:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_shaman_maximize:OnRemoved()
end

function modifier_shaman_maximize:OnDestroy()
end

function modifier_shaman_maximize:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}

	return funcs
end

function modifier_shaman_maximize:GetModifierModelScale()
	return self.modelscale
end

function modifier_shaman_maximize:GetModifierMoveSpeed_Absolute()
	return self.movement_speed
end

function modifier_shaman_maximize:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_shaman_maximize:GetModifierExtraHealthPercentage()
	return self.health_percent
end

function modifier_shaman_maximize:GetModifierEvasion_Constant()
	return self.evasion
end

function modifier_shaman_maximize:CheckState()
	local states = {
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
	return states
 end

function modifier_shaman_maximize:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_shaman_maximize:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end