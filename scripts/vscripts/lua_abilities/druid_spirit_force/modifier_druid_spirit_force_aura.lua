modifier_druid_spirit_force_aura = class({})

function modifier_druid_spirit_force_aura:IsHidden()
	return false
end

function modifier_druid_spirit_force_aura:IsDebuff()
	return false
end

function modifier_druid_spirit_force_aura:IsPurgable()
	return false
end

function modifier_druid_spirit_force_aura:OnCreated()
	self.mana_as_attack_damage = self:GetAbility():GetSpecialValueFor( "mana_as_attack_damage" ) / 100
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_druid_spirit_force_aura:OnRefresh()
	self.mana_as_attack_damage = self:GetAbility():GetSpecialValueFor( "mana_as_attack_damage" ) / 100
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_druid_spirit_force_aura:OnRemoved()
	
end

function modifier_druid_spirit_force_aura:OnDestroy()
	
end

function modifier_druid_spirit_force_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_SPELLS_REQUIRE_HP
	}

	return funcs
end

function modifier_druid_spirit_force_aura:GetModifierPreAttack_BonusDamage()
	if self:GetParent():HasModifier("modifier_druid_shapeshift")==true then
		local total = math.floor( self:GetCaster():GetMaxMana() * self.mana_as_attack_damage )
		return total
	else
		return 0
	end
end

function modifier_druid_spirit_force_aura:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():HasModifier("modifier_druid_shapeshift")==true then
		return self.attack_speed
	else
		return 0
	end
end


function modifier_druid_spirit_force_aura:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end

function modifier_druid_spirit_force_aura:GetModifierSpellsRequireHP()
	return 1
end

function modifier_druid_spirit_force_aura:IsAura()
	return true
end

function modifier_druid_spirit_force_aura:GetModifierAura()
	return "modifier_druid_spirit_force_bonus"
end

function modifier_druid_spirit_force_aura:GetAuraRadius()
	return self.radius
end

function modifier_druid_spirit_force_aura:GetAuraDuration()
	return 0.5
end

function modifier_druid_spirit_force_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_druid_spirit_force_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_druid_spirit_force_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_druid_spirit_force_aura:GetAuraEntityReject(hEntity)
	if IsServer() then
		local caster = self:GetCaster()
		if hEntity:IsSummoned()==true then
			if hEntity:GetOwner()==caster then
				return false
			else
				return true
			end
		else
			return true
		end
	end
end