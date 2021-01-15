modifier_item_green_orb = class({})

function modifier_item_green_orb:IsHidden()
	return false
end

function modifier_item_green_orb:IsDebuff()
	return false
end

function modifier_item_green_orb:IsPurgable()
	return false
end

function modifier_item_green_orb:GetTexture()
	return "../items/upgrader/item_green_orb"
end

function modifier_item_green_orb:OnCreated( kv )
	self.agi = self:GetAbility():GetSpecialValueFor( "agi" )
end

function modifier_item_green_orb:OnRefresh( kv )
	self.agi = self:GetAbility():GetSpecialValueFor( "agi" )
end

function modifier_item_green_orb:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_item_green_orb:GetModifierBonusStats_Agility()
	return self.agi
end