modifier_shaman_minimize = class({})

function modifier_shaman_minimize:IsHidden()
	return false
end

function modifier_shaman_minimize:IsDebuff()
	return self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()
end

function modifier_shaman_minimize:IsPurgable()
	return true
end

function modifier_shaman_minimize:OnCreated( kv )
	self.modelscale = self:GetAbility():GetSpecialValueFor( "modelscale" )
	self.movement_speed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.health_percent = self:GetAbility():GetSpecialValueFor( "health_percent" )

	if not IsServer() then return end

	local sound_cast = "Hero_OgreMagi.Bloodlust.Target"
	EmitSoundOn( sound_cast, self:GetParent() )

	local sound_player = "Hero_OgreMagi.Bloodlust.Target.FP"
	EmitSoundOnClient( sound_player, self:GetParent():GetPlayerOwner() )
end

function modifier_shaman_minimize:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_shaman_minimize:OnRemoved()
end

function modifier_shaman_minimize:OnDestroy()
end

function modifier_shaman_minimize:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

function modifier_shaman_minimize:GetModifierModelScale()
	return self.modelscale
end

function modifier_shaman_minimize:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end

function modifier_shaman_minimize:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_shaman_minimize:GetModifierExtraHealthPercentage()
	return self.health_percent
end

function modifier_shaman_minimize:CheckState()
	local states = {
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
	return states
 end

function modifier_shaman_minimize:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_shaman_minimize:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end