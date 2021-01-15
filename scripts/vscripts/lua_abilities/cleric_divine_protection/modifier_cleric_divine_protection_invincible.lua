modifier_cleric_divine_protection_invincible = class({})

function modifier_cleric_divine_protection_invincible:IsHidden()
	return false
end

function modifier_cleric_divine_protection_invincible:IsDebuff()
	return false
end

function modifier_cleric_divine_protection_invincible:IsPurgable()
	return true
end

function modifier_cleric_divine_protection_invincible:OnCreated( kv )
	local sound_cast = "Hero_Omniknight.GuardianAngel"
	EmitSoundOn( sound_cast, self:GetParent() )

	self:StartIntervalThink(0)
end

function modifier_cleric_divine_protection_invincible:OnRefresh( kv )
	self:OnCreated( kv )
	
end

function modifier_cleric_divine_protection_invincible:OnDestroy( kv )

end

function modifier_cleric_divine_protection_invincible:OnIntervalThink()
	if IsServer() then
		self:GetParent():Purge(false, true, false, false, false)
	end
end

function modifier_cleric_divine_protection_invincible:DeclareFunctions()
	return {
		--MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
	}
end

function modifier_cleric_divine_protection_invincible:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_cleric_divine_protection_invincible:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_cleric_divine_protection_invincible:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_cleric_divine_protection_invincible:CheckState()
	local states = {
		--[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}
	return states
 end

function modifier_cleric_divine_protection_invincible:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf"
end

function modifier_cleric_divine_protection_invincible:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end