modifier_item_basic_slippers = class({})

function modifier_item_basic_slippers:IsHidden()
	return true
end

function modifier_item_basic_slippers:IsDebuff()
	return false
end

function modifier_item_basic_slippers:IsPurgable()
	return false
end

function modifier_item_basic_slippers:GetTexture()
	return "../items/boots/item_basic_slippers"
end

function modifier_item_basic_slippers:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
end

function modifier_item_basic_slippers:OnRefresh( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
end

function modifier_item_basic_slippers:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
	}

	return funcs
end

function modifier_item_basic_slippers:GetModifierMoveSpeedBonus_Percentage_Unique()
	return self.movespeed
end

function modifier_item_basic_slippers:GetModifierMoveSpeedBonus_Special_Boots()
	return self.movespeed
end