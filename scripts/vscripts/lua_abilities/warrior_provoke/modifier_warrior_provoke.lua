modifier_warrior_provoke = class({})

function modifier_warrior_provoke:IsHidden()
	return false
end

function modifier_warrior_provoke:IsDebuff()
	return false
end

function modifier_warrior_provoke:IsPurgable()
	return false
end

function modifier_warrior_provoke:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function modifier_warrior_provoke:OnRefresh( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function modifier_warrior_provoke:OnRemoved()

end

function modifier_warrior_provoke:OnDestroy()

end

function modifier_warrior_provoke:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_warrior_provoke:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_warrior_provoke:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf"
end

function modifier_warrior_provoke:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
