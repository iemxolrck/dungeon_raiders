modifier_item_blue_orb = class({})

function modifier_item_blue_orb:IsHidden()
	return false
end

function modifier_item_blue_orb:IsDebuff()
	return false
end

function modifier_item_blue_orb:IsPurgable()
	return false
end

function modifier_item_blue_orb:GetTexture()
	return "../items/upgrader/item_blue_orb"
end

function modifier_item_blue_orb:OnCreated( kv )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
end

function modifier_item_blue_orb:OnRefresh( kv )
	self.int = self:GetAbility():GetSpecialValueFor( "int" )
end

function modifier_item_blue_orb:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_item_blue_orb:GetModifierBonusStats_Intellect()
	return self.int
end