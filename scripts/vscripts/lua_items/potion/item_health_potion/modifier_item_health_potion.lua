modifier_item_health_potion = class({})

function modifier_item_health_potion:IsHidden()
	return false
end

function modifier_item_health_potion:IsDebuff()
	return false
end

function modifier_item_health_potion:IsPurgable()
	return true
end

function modifier_item_health_potion:GetTexture()
	return "../items/potion/item_health_potion"
end

function modifier_item_health_potion:OnCreated( kv )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	EmitSoundOn( "DOTA_Item.HealingSalve.Activate", self:GetCaster() )
end

function modifier_item_health_potion:OnRefresh( kv )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	EmitSoundOn( "DOTA_Item.HealingSalve.Activate", self:GetCaster() )
end

function modifier_item_health_potion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}

	return funcs
end

function modifier_item_health_potion:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_item_health_potion:GetEffectName()
	return "particles/items_fx/healing_flask.vpcf"
end

function modifier_item_health_potion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end