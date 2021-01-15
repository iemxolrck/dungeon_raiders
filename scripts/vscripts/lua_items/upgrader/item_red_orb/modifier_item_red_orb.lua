modifier_item_red_orb = class({})

function modifier_item_red_orb:IsHidden()
	return false
end

function modifier_item_red_orb:IsDebuff()
	return false
end

function modifier_item_red_orb:IsPurgable()
	return false
end

function modifier_item_red_orb:GetTexture()
	return "../items/upgrader/item_red_orb"
end

function modifier_item_red_orb:OnCreated( kv )
	self.str = self:GetAbility():GetSpecialValueFor( "str" )
end

function modifier_item_red_orb:OnRefresh( kv )
	self.str = self:GetAbility():GetSpecialValueFor( "str" )
end

function modifier_item_red_orb:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_red_orb:GetModifierBonusStats_Strength()
	return self.str
end