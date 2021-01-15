modifier_item_triple_head_crit = class({})

function modifier_item_triple_head_crit:IsHidden()
	return false
end

function modifier_item_triple_head_crit:IsDebuff()
	return false
end

function modifier_item_triple_head_crit:IsPurgable()
	return false
end

function modifier_item_triple_head_crit:GetTexture()
	return "../items/bow/item_triple_head"
end


function modifier_item_triple_head_crit:OnCreated( kv )
	self.attackrange = self:GetAbility():GetSpecialValueFor( "attackrange" )
end

function modifier_item_triple_head_crit:OnRefresh( kv )
	self.attackrange = self:GetAbility():GetSpecialValueFor( "attackrange" )
end

function modifier_item_triple_head_crit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
	}
	if self:GetParent():GetName()=="npc_dota_hero_drow_ranger" then 
		return funcs
	end
end

function modifier_item_triple_head_crit:GetModifierAttackRangeBonus()
	return self.attackrange
end

function modifier_item_triple_head_crit:GetModifierIgnorePhysicalArmor()
	return 1
end

function modifier_item_triple_head_crit:GetModifierMagicalResistanceDirectModification()
	return 0
end

function modifier_item_triple_head_crit:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end