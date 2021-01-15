modifier_item_basic_spear = class({})

function modifier_item_basic_spear:IsHidden()
	return false
end

function modifier_item_basic_spear:IsDebuff()
	return false
end

function modifier_item_basic_spear:IsPurgable()
	return false
end

function modifier_item_basic_spear:GetTexture()
	return "../items/spear/item_basic_spear"
end

function modifier_item_basic_spear:OnCreated( kv )
		self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attack_range_melee = self:GetAbility():GetSpecialValueFor( "attack_range_melee" )
	self.critrate = self:GetAbility():GetSpecialValueFor( "critrate" )
end

function modifier_item_basic_spear:OnRefresh( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attack_range_melee = self:GetAbility():GetSpecialValueFor( "attack_range_melee" )
	self.critrate = self:GetAbility():GetSpecialValueFor( "critrate" )
end

function modifier_item_basic_spear:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_item_basic_spear:GetModifierPreAttack_BonusDamage()
	return self.physical_damage
end

function modifier_item_basic_spear:GetModifierAttackRangeBonusUnique()
	return self.attack_range_melee
end

function modifier_item_basic_spear:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if params.attacker:GetAttackCapability()~=DOTA_UNIT_CAP_MELEE_ATTACK then return end

	-- cleave
	DoCleaveAttack(
		params.attacker,
		params.target,
		self:GetAbility(),
		50,
		50,
		50,
		500,
		"particles/items_fx/battlefury_cleave.vpcf"
	)
end