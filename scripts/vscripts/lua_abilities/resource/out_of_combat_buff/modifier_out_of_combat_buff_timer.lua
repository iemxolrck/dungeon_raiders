modifier_out_of_combat_buff_timer = class({})

function modifier_out_of_combat_buff_timer:IsHidden()
	return false
end

function modifier_out_of_combat_buff_timer:IsDebuff()
	return false
end

function modifier_out_of_combat_buff_timer:IsPurgable()
	return false
end

function modifier_out_of_combat_buff_timer:RemoveOnDeath()
	return false
end

function modifier_out_of_combat_buff_timer:OnCreated()
	self.timer = self:GetAbility():GetSpecialValueFor( "timer" )
end

function modifier_out_of_combat_buff_timer:OnRefresh()
	self.timer = self:GetAbility():GetSpecialValueFor( "timer" )
end

function modifier_out_of_combat_buff_timer:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_out_of_combat_buff",
			{}
		)
	end
end

function modifier_out_of_combat_buff_timer:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end
function modifier_out_of_combat_buff_timer:OnTakeDamage( keys )
	if IsServer() and keys.unit == self:GetParent() then
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

function modifier_out_of_combat_buff_timer:OnAttackStart( params )
	if IsServer() and params.attacker == self:GetParent() then
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

function modifier_out_of_combat_buff_timer:OnAbilityFullyCast( params )
	if IsServer() and params.unit == self:GetParent() then
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