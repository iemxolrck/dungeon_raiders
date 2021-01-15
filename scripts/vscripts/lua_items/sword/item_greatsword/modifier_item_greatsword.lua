modifier_item_greatsword = class({})

function modifier_item_greatsword:IsHidden()
	return false
end

function modifier_item_greatsword:IsDebuff()
	return false
end

function modifier_item_greatsword:IsPurgable()
	return false
end

function modifier_item_greatsword:GetTexture()
	return "../items/sword/item_greatsword"
end

function modifier_item_greatsword:OnCreated( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attack_range_melee = self:GetAbility():GetSpecialValueFor( "attack_range_melee" )
	self.cleave_damage = self:GetAbility():GetSpecialValueFor( "cleave_damage" )
	self.cleave_radius = self:GetAbility():GetSpecialValueFor( "cleave_radius" )
end

function modifier_item_greatsword:OnRefresh( kv )
	self.physical_damage = self:GetAbility():GetSpecialValueFor( "physical_damage" )
	self.attack_range_melee = self:GetAbility():GetSpecialValueFor( "attack_range_melee" )
	self.cleave_damage = self:GetAbility():GetSpecialValueFor( "cleave_damage" )
	self.cleave_radius = self:GetAbility():GetSpecialValueFor( "cleave_radius" )
end

function modifier_item_greatsword:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_item_greatsword:GetModifierPreAttack_BonusDamage()
	return self.physical_damage
end

function modifier_item_greatsword:GetModifierAttackRangeBonusUnique()
	return self.attack_range_melee
end

function modifier_item_greatsword:GetModifierProcAttack_Feedback( params )
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
		"particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf"
	)
end