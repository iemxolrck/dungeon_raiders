modifier_druid_shapeshift = class({})

function modifier_druid_shapeshift:IsHidden()
	return false
end

function modifier_druid_shapeshift:IsDebuff()
	return false
end

function modifier_druid_shapeshift:IsPurgable()
	return false
end

function modifier_druid_shapeshift:OnCreated()
	self.attackCapability = DOTA_UNIT_CAP_RANGED_ATTACK
	self.primaryAttribute = DOTA_ATTRIBUTE_AGILITY
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	self.base_attack_time = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.attack_range = self:GetAbility():GetSpecialValueFor( "attack_range" )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	if IsServer() then
		self.primary_attribute = self:GetParent():GetPrimaryAttribute()
		self.attack_capacity = self:GetParent():GetAttackCapability()
		self:GetParent():SetPrimaryAttribute(0)
		self:GetParent():SetAttackCapability(1)
	end
end

function modifier_druid_shapeshift:OnRefresh()
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	self.base_attack_time = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.attack_range = self:GetAbility():GetSpecialValueFor( "attack_range" )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
end

function modifier_druid_shapeshift:OnRemoved()
	if IsServer() then
		self:GetParent():SetPrimaryAttribute(self.primary_attribute)
		self:GetParent():SetAttackCapability(self.attack_capacity)
	end
end

function modifier_druid_shapeshift:OnDestroy()
	if IsServer() then
		self:GetParent():SetPrimaryAttribute(self.primary_attribute)
		self:GetParent():SetAttackCapability(self.attack_capacity)
	end
end

function modifier_druid_shapeshift:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		 MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

function modifier_druid_shapeshift:GetModifierModelChange()
	return "models/heroes/lone_druid/true_form.vmdl"
end

function modifier_druid_shapeshift:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_druid_shapeshift:GetModifierHealthBonus()
	return self.bonus_hp
end

function modifier_druid_shapeshift:GetModifierBaseAttackTimeConstant()
	return self.base_attack_time
end

function modifier_druid_shapeshift:GetModifierAttackRangeOverride()
	return self.attack_range
end

function modifier_druid_shapeshift:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_move_speed
end

function modifier_druid_shapeshift:GetModifierModelScale()
	return (self:GetParent():GetLevel()-1)*(50-1)/(100-1) 
end

function modifier_druid_shapeshift:GetAttackSound()
	return "Hero_LoneDruid.TrueForm.Attack"
end