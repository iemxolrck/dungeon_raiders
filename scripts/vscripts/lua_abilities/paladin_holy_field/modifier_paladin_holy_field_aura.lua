modifier_paladin_holy_field_aura = class({})

function modifier_paladin_holy_field_aura:IsHidden()
	return false
end

function modifier_paladin_holy_field_aura:IsDebuff()
	return false
end

function modifier_paladin_holy_field_aura:IsPurgable()
	return false
end

function modifier_paladin_holy_field_aura:OnCreated()
	self.mana_as_attack_damage = self:GetAbility():GetSpecialValueFor( "mana_as_attack_damage" ) / 100
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if not IsServer() then return end
	self.effect_cast = ParticleManager:CreateParticle( "particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW , self:GetParent() )
	--ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	--self:PlayEffect()
end

function modifier_paladin_holy_field_aura:OnRefresh()
	self.mana_as_attack_damage = self:GetAbility():GetSpecialValueFor( "mana_as_attack_damage" ) / 100
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	--self:PlayEffect()
end

function modifier_paladin_holy_field_aura:OnRemoved()

end

function modifier_paladin_holy_field_aura:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle( self.effect_cast, false )
end

function modifier_paladin_holy_field_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_paladin_holy_field_aura:GetModifierPreAttack_BonusDamage()
	if self:GetParent():HasModifier("modifier_druid_shapeshift")==true then
		local total = math.floor( self:GetCaster():GetMaxMana() * self.mana_as_attack_damage )
		return total
	else
		return 0
	end
end

function modifier_paladin_holy_field_aura:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():HasModifier("modifier_druid_shapeshift")==true then
		return self.attack_speed
	else
		return 0
	end
end


function modifier_paladin_holy_field_aura:GetModifierMoveSpeedBonus_Percentage()
		return self.move_speed
end

function modifier_paladin_holy_field_aura:IsAura()
	return true
end

function modifier_paladin_holy_field_aura:GetModifierAura()
	return "modifier_paladin_holy_field_bonus"
end

function modifier_paladin_holy_field_aura:GetAuraRadius()
	return self.radius
end

function modifier_paladin_holy_field_aura:GetAuraDuration()
	return 0.5
end

function modifier_paladin_holy_field_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_paladin_holy_field_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_paladin_holy_field_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_paladin_holy_field_aura:GetAuraEntityReject(hEntity)
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

function modifier_paladin_holy_field_aura:PlayEffect()
	local particle_cast = "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"
	local sound_cast = "Hero_VoidSpirit.Pulse.Cast"

	-- Get Data
	local radius = self.radius

	-- Create Particle
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end