modifier_generic_shocked = class ({})

function modifier_generic_shocked:IsHidden()
	return false
end

function modifier_generic_shocked:IsDebuff()
	return false
end

function modifier_generic_shocked:IsPurgable()
	return false
end

function modifier_generic_shocked:OnCreated( kv )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
end

function modifier_generic_shocked:OnRefresh( kv )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
end

function modifier_generic_shocked:OnRemoved( kv )

end

function modifier_generic_shocked:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_generic_shocked:GetModifierMoveSpeedBonus_Percentage()
	return 25
end

function modifier_generic_shocked:GetModifierAttackSpeedBonus_Constant()
	return 25
end

function modifier_generic_shocked:OnTakeDamage( params )
	if not IsServer() then return end
	local parent = self:GetParent()
	local damage = params.damage
	if params.unit~=parent then return end
	if parent:IsMagicImmune()==true then return end
	parent:ReduceMana(damage*0.25)
	parent:AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		"modifier_generic_stunned",
		{ duration = 0.25 }
	)
end

function modifier_generic_shocked:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf"
end

function modifier_generic_shocked:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end