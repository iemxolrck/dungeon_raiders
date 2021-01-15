modifier_out_of_combat_buff = class({})

function modifier_out_of_combat_buff:IsHidden()
	return false
end

function modifier_out_of_combat_buff:IsDebuff()
	return false
end

function modifier_out_of_combat_buff:IsPurgable()
	return false
end

function modifier_out_of_combat_buff:RemoveOnDeath()
	return false
end

function modifier_out_of_combat_buff:OnCreated()
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.timer = self:GetAbility():GetSpecialValueFor( "timer" )
end

function modifier_out_of_combat_buff:OnRefresh()
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.timer = self:GetAbility():GetSpecialValueFor( "timer" )
end

function modifier_out_of_combat_buff:OnDestroy()
	if IsServer() then
		local timer = self.timer
		if self:GetParent():HasModifier("modifier_ranger_smokescreen_buff")==true then
			timer = 1
		end
		if self:GetParent():HasModifier("modifier_ranger_camouflage_buff")==true then
			timer = 1
		end
		if self:GetParent():HasModifier("modifier_warrior_perseverance_buff")==true then
			local ability = self:GetParent():FindAbilityByName( "warrior_perseverance" )
			timer = ability:GetLevelSpecialValueFor( "timer_reduction", ability:GetLevel()-1 ) / 100
			timer = ( 1 - timer ) * self.timer
		end
		
		self:GetParent():AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_out_of_combat_buff_timer",
			{ duration = timer }
		)
	end
end

function modifier_out_of_combat_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function modifier_out_of_combat_buff:GetModifierHealthRegenPercentage()
	return self.health_regen
end

function modifier_out_of_combat_buff:GetModifierTotalPercentageManaRegen()
	return self.mana_regen
end

function modifier_out_of_combat_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end

function modifier_out_of_combat_buff:OnTakeDamage( keys )
	if IsServer() and keys.unit == self:GetParent() then
		self:Destroy()
	end
end

function modifier_out_of_combat_buff:OnAttackStart( params )
	if IsServer() and params.attacker == self:GetParent() then
		self:Destroy()
	end
end

function modifier_out_of_combat_buff:OnAbilityFullyCast( params )
	if IsServer() and params.unit == self:GetParent() then
		self:Destroy()
	end
end

function modifier_out_of_combat_buff:GetEffectName()
	return "particles/items_fx/bottle.vpcf"
end

function modifier_out_of_combat_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end