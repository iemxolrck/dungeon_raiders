modifier_item_basic_axe = class({})

function modifier_item_basic_axe:IsHidden()
	return false
end

function modifier_item_basic_axe:IsDebuff()
	return false
end

function modifier_item_basic_axe:IsPurgable()
	return false
end

function modifier_item_basic_axe:GetTexture()
	return "../items/axe/item_basic_axe"
end

function modifier_item_basic_axe:OnCreated( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
	self.cleave_damage = self:GetAbility():GetSpecialValueFor( "cleave_damage" )
	self.cleave_radius = self:GetAbility():GetSpecialValueFor( "cleave_radius" )
end

function modifier_item_basic_axe:OnRefresh( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" )
	self.cleave_damage = self:GetAbility():GetSpecialValueFor( "cleave_damage" )
	self.cleave_radius = self:GetAbility():GetSpecialValueFor( "cleave_radius" )
end

function modifier_item_basic_axe:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_item_basic_axe:GetModifierPreAttack_BonusDamage()
	return self.physical_damage
end

function modifier_item_basic_axe:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end

function modifier_item_basic_axe:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if params.attacker:GetAttackCapability()~=DOTA_UNIT_CAP_MELEE_ATTACK then return end

	-- cleave
	DoCleaveAttack(
		params.attacker,
		params.target,
		self:GetAbility(),
		self.cleave_damage,
		150,
		self.cleave_radius,
		600,
		"particles/items_fx/battlefury_cleave.vpcf"
	)
end