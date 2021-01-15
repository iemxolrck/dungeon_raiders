modifier_warrior_guardian_stance = class({})

function modifier_warrior_guardian_stance:IsHidden()
	return self:GetStackCount()<=0
end

function modifier_warrior_guardian_stance:IsDebuff()
	return false
end

function modifier_warrior_guardian_stance:IsPurgable()
	return false
end

function modifier_warrior_guardian_stance:OnCreated( kv )
	local pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(pfx, false, false, 15, false, false)

	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )
	self.str_as_damage_block = self:GetAbility():GetSpecialValueFor( "str_as_damage_block" ) / 100

	if not IsServer() then return end
	self:SetStackCount(math.floor( self:GetParent():GetStrength() * self.str_as_damage_block ))
	self:StartIntervalThink(0)
end

function modifier_warrior_guardian_stance:OnRefresh( kv )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.str_as_damage_block = self:GetAbility():GetSpecialValueFor( "str_as_damage_block" ) / 100
	self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )
	if not IsServer() then return end
	self:SetStackCount(math.floor( self:GetParent():GetStrength() * self.str_as_damage_block ))
end

function modifier_warrior_guardian_stance:OnRemoved()

end

function modifier_warrior_guardian_stance:OnDestroy()

end

function modifier_warrior_guardian_stance:OnIntervalThink()
	if not IsServer() then return end
	if self:GetStackCount()<=0 then
		self:Destroy()
	end
end

function modifier_warrior_guardian_stance:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		--MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		--MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_warrior_guardian_stance:GetModifierTotal_ConstantBlock( params ) 
	if not IsServer() then return end
	print(params.damage_type)
	if params.damage_type~=1 then return end
	print("Damage: ")
	print(params.damage)
	if params.damage>self:GetStackCount() then
		local block = params.damage - self:GetStackCount()
		self:SetStackCount( self:GetStackCount()-params.damage )
		return block
	else
		self:SetStackCount( self:GetStackCount()-params.damage )
		return params.damage
	end
end

function modifier_warrior_guardian_stance:GetModifierPhysicalArmorBonus()
	--return  self.bonus_armor
end

function modifier_warrior_guardian_stance:GetModifierMagicalResistanceBonus()
	--return  self.magic_resistance
end

function modifier_warrior_guardian_stance:CheckState()
	local state = {
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		--[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}

	return state
end

function modifier_warrior_guardian_stance:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf"
end

function modifier_warrior_guardian_stance:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
