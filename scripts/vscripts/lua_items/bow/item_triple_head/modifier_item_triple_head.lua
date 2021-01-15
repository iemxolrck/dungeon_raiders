modifier_item_triple_head = class({})

function modifier_item_triple_head:IsHidden()
	return true
end

function modifier_item_triple_head:IsDebuff()
	return false
end

function modifier_item_triple_head:IsPurgable()
	return false
end

function modifier_item_triple_head:GetTexture()
	return "../items/bow/item_triple_head"
end


function modifier_item_triple_head:OnCreated( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
	self.attackrange = self:GetAbility():GetSpecialValueFor( "attackrange" )
end

function modifier_item_triple_head:OnRefresh( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resist" )
end

function modifier_item_triple_head:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	if self:GetParent():GetName()=="npc_dota_hero_drow_ranger"
		or self:GetParent():GetName()=="npc_dota_hero_windrunner" then 
		return funcs
	end
end

function modifier_item_triple_head:GetModifierMoveSpeedBonus_Percentage_Unique()
	return self.movespeed
end

function modifier_item_triple_head:GetModifierPreAttack_BonusDamage()
	return self.physical_damage
end

function modifier_item_triple_head:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end

function modifier_item_triple_head:GetModifierAttackRangeBonus()
	return self.attackrange
end

function modifier_item_triple_head:OnAttackLanded( params )
	if not IsServer() then return end
	if params.attacker~= self:GetParent() then return end

	if self:GetParent():HasModifier("modifier_item_triple_head_crit")==true then
		local modifier = self:GetParent():FindModifierByName("modifier_item_triple_head_crit")
		if modifier~= nil then modifier:Destroy() end
		return
	end

	local stack = self:GetStackCount()
	if stack>=1 then
		self:GetParent():AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_item_triple_head_crit",
			{}
		)
		self:SetStackCount(0)
	else
		self:IncrementStackCount()
	end
end