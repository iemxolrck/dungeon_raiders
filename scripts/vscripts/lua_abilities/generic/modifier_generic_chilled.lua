modifier_generic_chilled = class ({})

function modifier_generic_chilled:IsHidden()
	return false
end

function modifier_generic_chilled:IsDebuff()
	return true
end

function modifier_generic_chilled:IsPurgable()
	return false
end

function modifier_generic_chilled:OnCreated( kv )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
end

function modifier_generic_chilled:OnRefresh( kv )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
end

function modifier_generic_chilled:OnRemoved( kv )

end

function modifier_generic_chilled:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_REDUCTION_PERCENTAGE,
	}

	return funcs
end

function modifier_generic_chilled:GetModifierMoveSpeedBonus_Percentage()
	return -50
end

function modifier_generic_chilled:GetModifierAttackSpeedReductionPercentage()
	return -50
end

function modifier_generic_chilled:OnTakeDamage( params )
	if not IsServer() then return end
	local parent = self:GetParent()
	if params.unit~=parent then return end
	if parent:IsMagicImmune()==true then return end
	if parent:HasModifier("modifier_generic_airborne")==true then return end

	if not self:RollChance( 50 ) then return end
	parent:AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		"modifier_generic_frozen",
		{ duration = 2 }
	)
	self:Destroy()

end

function modifier_generic_chilled:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

function modifier_generic_chilled:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
end

function modifier_generic_chilled:GetStatusEffectName()
	return "particles/status_fx/status_effect_iceblast.vpcf"
end

function modifier_generic_chilled:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end