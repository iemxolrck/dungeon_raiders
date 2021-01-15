modifier_druid_entangle_root = class ({})

function modifier_druid_entangle_root:IsHidden()
	return false
end

function modifier_druid_entangle_root:IsDebuff()
	return true
end

function modifier_druid_entangle_root:IsPurgable()
	return true
end

function modifier_druid_entangle_root:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_druid_entangle_root:OnCreated( kv )
	if IsServer() then
		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage_per_second,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
			damage_flags = self:GetAbility():GetAbilityTargetFlags(),
	}
		self:StartIntervalThink(1)
	end
end

function modifier_druid_entangle_root:OnRefresh( kv )
	if IsServer() then
		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage_per_second,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
			damage_flags = self:GetAbility():GetAbilityTargetFlags(),
		}
	end
end

function modifier_druid_entangle_root:OnRemoved( kv )

end

function modifier_druid_entangle_root:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_druid_entangle_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_FLYING] = false,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
	}

	return state
end

function modifier_druid_entangle_root:GetEffectName()
	return "particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle.vpcf"
end

function modifier_druid_entangle_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end