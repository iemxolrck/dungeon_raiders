modifier_bard_hypnotize_debuff = class({})
require("lua_abilities/bard_hypnotize/bard_hypnotize")

function modifier_bard_hypnotize_debuff:IsHidden()
	return false
end

function modifier_bard_hypnotize_debuff:IsDebuff()
	return true
end

function modifier_bard_hypnotize_debuff:IsStunDebuff()
	return false
end

function modifier_bard_hypnotize_debuff:IsPurgable()
	return false
end

function modifier_bard_hypnotize_debuff:OnCreated( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.attack_range = 75
	
	if IsServer() then
		--[[local target = kv.target
		local attack_target = self:GetCaster():FindAbilityByName("bard_hypnotize").counter[target]]
		--print(attack_target:GetName())

		--print(self:GetParent():GetName())
		--print(target)
		if self:GetParent():GetTeam()==self:GetCaster():GetTeam() then
			if self:GetParent():IsRealHero()==true then
				self:StartIntervalThink(0)
			else
				self:GetParent():SetForceAttackTargetAlly( self:GetCaster() )
				--self:GetParent():MoveToTargetToAttack( self:GetCaster() )
			end
			--self:GetParent():MoveToTargetToAttack( self:GetCaster() )
		else
			if self:GetParent():IsRealHero()==true then
				self:StartIntervalThink(0)
			else
				self:GetParent():SetForceAttackTarget( self:GetCaster() )
				self:GetParent():MoveToTargetToAttack( self:GetCaster() )
			end
		end
	end
end

function modifier_bard_hypnotize_debuff:OnRefresh( kv )
end

function modifier_bard_hypnotize_debuff:OnRemoved()
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
	if IsServer() then
		if self:GetParent():GetTeam()==self:GetCaster():GetTeam() then
			if self:GetParent():IsRealHero()~=true then
				self:GetParent():SetForceAttackTargetAlly( nil )
			end
		else
			self:GetParent():SetForceAttackTarget( nil )
			self:GetParent():MoveToTargetToAttack( nil )
		end
		self:GetParent():AddNewModifier(
				self:GetCaster(), -- player source
				self:GetAbility(), -- ability source
				"modifier_bard_hypnotize_slow", -- modifier name
				{ 
					duration =  self.slow_duration
				}
			)
	end
end

function modifier_bard_hypnotize_debuff:OnDestroy()

end

function modifier_bard_hypnotize_debuff:OnIntervalThink()
	--self:GetParent():MoveToTargetToAttack( self:GetCaster() )
	self:GetParent():MoveToPosition( self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * -self.attack_range )
end

function modifier_bard_hypnotize_debuff:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

function modifier_bard_hypnotize_debuff:GetModifierAttackRangeOverride()
	if self:GetParent():IsRealHero()~=true then
		return self.attack_range
	else
		return
	end
end

function modifier_bard_hypnotize_debuff:GetModifierProvidesFOWVision()
	return 1
end

function modifier_bard_hypnotize_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end

function modifier_bard_hypnotize_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		[MODIFIER_STATE_DISARMED] = true,
		--[MODIFIER_STATE_SILENCED] = true,
		--[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		--[MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
	}

	return state
end

function modifier_bard_hypnotize_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end
