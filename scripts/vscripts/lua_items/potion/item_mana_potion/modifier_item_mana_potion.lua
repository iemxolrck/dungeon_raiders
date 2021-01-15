modifier_item_mana_potion = class({})

function modifier_item_mana_potion:IsHidden()
	return false
end

function modifier_item_mana_potion:IsDebuff()
	return false
end

function modifier_item_mana_potion:IsPurgable()
	return true
end

function modifier_item_mana_potion:GetTexture()
	return "../items/potion/item_mana_potion"
end

function modifier_item_mana_potion:OnCreated( kv )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
	EmitSoundOn( "DOTA_Item.ClarityPotion.Activate", self:GetCaster() )
end

function modifier_item_mana_potion:OnRefresh( kv )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
	EmitSoundOn( "DOTA_Item.ClarityPotion.Activate", self:GetCaster() )
end

function modifier_item_mana_potion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}

	return funcs
end

function modifier_item_mana_potion:GetModifierConstantManaRegen()
	return self.mana_regen
end

function modifier_item_mana_potion:GetEffectName()
	return "particles/items_fx/healing_clarity.vpcf"
end

function modifier_item_mana_potion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end