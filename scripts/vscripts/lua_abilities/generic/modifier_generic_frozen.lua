modifier_generic_frozen = class ({})

function modifier_generic_frozen:IsHidden()
	return false
end

function modifier_generic_frozen:IsDebuff()
	return true
end

function modifier_generic_frozen:IsPurgable()
	return false
end

function modifier_generic_frozen:GetTexture()
	return "status/modifier_generic_frozen"
end

function modifier_generic_frozen:OnCreated( kv )
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_generic_chilled")==true then
		local modifier = self:GetParent():FindModifierByName("modifier_generic_chilled")
		if modifier~=nil then modifier:Destroy() end
	end
end

function modifier_generic_frozen:OnRefresh( kv )
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_generic_chilled")==true then
		local modifier = self:GetParent():FindModifierByName("modifier_generic_chilled")
		if modifier~=nil then modifier:Destroy() end
	end
end

function modifier_generic_frozen:OnRemoved( kv )

end

function modifier_generic_frozen:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_generic_frozen:OnTakeDamage( params )
	if not IsServer() then return end
	local parent = self:GetParent()
	if params.target~=parent then return end
	if parent:IsMagicImmune()==true then return end
end

function modifier_generic_frozen:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function modifier_generic_frozen:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_generic_frozen:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end