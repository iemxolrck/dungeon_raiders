modifier_bard_lullaby_lua_debuff = class({})

function modifier_bard_lullaby_lua_debuff:IsHidden()
	return false
end

function modifier_bard_lullaby_lua_debuff:IsDebuff()
	return true
end

function modifier_bard_lullaby_lua_debuff:IsStunDebuff()
	return false
end

function modifier_bard_lullaby_lua_debuff:IsPurgable()
	return false
end

function modifier_bard_lullaby_lua_debuff:OnCreated( kv )
	local attacks = self:GetAbility():GetSpecialValueFor( "attacks" )
	self:SetStackCount(attacks)
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.drowzy_duration = self:GetAbility():GetSpecialValueFor( "drowzy_duration" )
end

function modifier_bard_lullaby_lua_debuff:OnRefresh( kv )
end

function modifier_bard_lullaby_lua_debuff:OnRemoved()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )

		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_bard_drowzy_debuff", -- modifier name
			{ duration = self.drowzy_duration } -- kv
		)
	end
end

function modifier_bard_lullaby_lua_debuff:OnDestroy()

end

function modifier_bard_lullaby_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}

	return funcs
end

function modifier_bard_lullaby_lua_debuff:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	self:DecrementStackCount()

	if self:GetStackCount() == 0 then
		self:Destroy()
	end

end

function modifier_bard_lullaby_lua_debuff:OnTooltip()
	return self:GetStackCount()
end

function modifier_bard_lullaby_lua_debuff:OnTooltip2()
	return self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_bard_lullaby_lua_debuff:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end

function modifier_bard_lullaby_lua_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_NIGHTMARED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_bard_lullaby_lua_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_bard_lullaby_lua_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end