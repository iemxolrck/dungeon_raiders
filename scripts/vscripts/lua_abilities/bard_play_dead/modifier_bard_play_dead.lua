modifier_bard_play_dead = class({})

function modifier_bard_play_dead:IsHidden()
	return false
end

function modifier_bard_play_dead:IsDebuff()
	return false
end

function modifier_bard_play_dead:IsPurgable()
	return false
end

function modifier_bard_play_dead:OnCreated( kv )

end

function modifier_bard_play_dead:OnRefresh( kv )

end

function modifier_bard_play_dead:OnDestroy( kv )

end

function modifier_bard_play_dead:DeclareFunctions()
	return {
		--MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
	}
end

function modifier_bard_play_dead:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_bard_play_dead:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_bard_play_dead:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_bard_play_dead:CheckState()
	local states = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
	return states
 end

function modifier_bard_play_dead:GetEffectName()
	--return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf"
end

function modifier_bard_play_dead:GetEffectAttachType()
	--return PATTACH_ABSORIGIN_FOLLOW
end