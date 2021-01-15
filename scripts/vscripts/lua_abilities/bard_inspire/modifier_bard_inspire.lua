modifier_bard_inspire = class({})

function modifier_bard_inspire:IsHidden()
	return false
end

function modifier_bard_inspire:IsDebuff()
	return false
end

function modifier_bard_inspire:IsPurgable()
	return true
end

function modifier_bard_inspire:OnCreated( kv )
	local caster = self:GetCaster()

	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )
	--self.attack_speed = self:GetParent():FindModifierByName( "modifier_bard_inspire_attack_speed" ):GetStackCount()
	--self.attack_damage_percent = self:GetParent():FindModifierByName( "modifier_bard_inspire_attack_damage_percent" ):GetStackCount()
	--self.move_speed = self:GetParent():FindModifierByName( "modifier_bard_inspire_move_speed" ):GetStackCount()	
end

function modifier_bard_inspire:OnRefresh( kv )
	local caster = self:GetCaster()
	self.multiplier = self:GetAbility():GetSpecialValueFor( "multiplier" )
	--self.attack_speed = caster:FindModifierByName( "modifier_bard_inspire_attack_speed" ):GetStackCount()
	--self.attack_damage_percent = caster:FindModifierByName( "modifier_bard_inspire_attack_damage_percent" ):GetStackCount()
--	self.move_speed = caster:FindModifierByName( "modifier_bard_inspire_move_speed" ):GetStackCount()	
end

function modifier_bard_inspire:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}

	return funcs
end

function modifier_bard_inspire:OnTooltip()
	return self.multiplier
end

function modifier_bard_inspire:GetOverrideAnimationRate()
	return 0
end

function modifier_bard_inspire:GetEffectName()
	return	"particles/units/heroes/hero_siren/naga_siren_song_debuff_d.vpcf"
end

function modifier_bard_inspire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end