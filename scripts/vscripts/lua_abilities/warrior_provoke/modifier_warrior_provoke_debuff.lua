modifier_warrior_provoke_debuff = class({})

function modifier_warrior_provoke_debuff:IsHidden()
	return false
end

function modifier_warrior_provoke_debuff:IsDebuff()
	return true
end

function modifier_warrior_provoke_debuff:IsStunDebuff()
	return false
end

function modifier_warrior_provoke_debuff:IsPurgable()
	return false
end

function modifier_warrior_provoke_debuff:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	if IsServer() then
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) -- for creeps
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) -- for heroes
	end
end

function modifier_warrior_provoke_debuff:OnRefresh( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	if IsServer() then
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) -- for creeps
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) -- for heroes
	end
end

function modifier_warrior_provoke_debuff:OnRemoved()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )
	end
end

function modifier_warrior_provoke_debuff:OnDestroy()
end

function modifier_warrior_provoke_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_warrior_provoke_debuff:OnAttackLanded( params )
	if IsServer() then
		if params.target~=self:GetParent() then return end
		if params.attacker~=self:GetCaster() then return end
		if self:GetCaster():FindAbilityByName("warrior_provoke"):GetLevel()==0 then return end
		if params.attacker:IsOther() or params.attacker:IsBuilding() then return end

		local parent = params.target
		local attacker = params.attacker

		if RandomInt(1,100)>self.chance then return end

		self:GetParent():AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_warrior_provoke_debuff",
			{ duration = self.duration }
		)	
		
	end
end

function modifier_warrior_provoke_debuff:OnDeath( event )
	if IsServer() then
		if event.unit == self:GetCaster() then
			self:Destroy()
		end
	end
end

function modifier_warrior_provoke_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_TAUNTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function modifier_warrior_provoke_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end
