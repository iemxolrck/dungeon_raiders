modifier_cleric_resurrection_invincible = class({})

function modifier_cleric_resurrection_invincible:IsHidden()
	return false
end

function modifier_cleric_resurrection_invincible:IsDebuff()
	return false
end

function modifier_cleric_resurrection_invincible:IsPurgable()
	return true
end

function modifier_cleric_resurrection_invincible:OnCreated( kv )
	local sound_cast = "Hero_Omniknight.GuardianAngel"
	EmitSoundOn( sound_cast, self:GetParent() )
	sound_cast = "Hero_Chen.HandOfGodHealHero"
	EmitSoundOn( sound_cast, self:GetParent() )
	--StopSound( DOTA_MUSIC_STATUS_DEAD, self:GetParent() )
	self:StartIntervalThink(0)
end

function modifier_cleric_resurrection_invincible:OnRefresh( kv )
	self:OnCreated( kv )
	
end

function modifier_cleric_resurrection_invincible:OnDestroy( kv )

end

function modifier_cleric_resurrection_invincible:OnIntervalThink()
	if IsServer() then
		self:GetParent():Purge(false, true, false, false, false)
	end
end

function modifier_cleric_resurrection_invincible:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end

function modifier_cleric_resurrection_invincible:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_cleric_resurrection_invincible:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_cleric_resurrection_invincible:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_cleric_resurrection_invincible:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}
	return states
end

function modifier_cleric_resurrection_invincible:GetEffectName()
	return "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf"
end

function modifier_cleric_resurrection_invincible:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end