modifier_bard_bewilder_debuff = class({})

function modifier_bard_bewilder_debuff:IsHidden()
	return false
end

function modifier_bard_bewilder_debuff:IsDebuff()
	return true
end

function modifier_bard_bewilder_debuff:IsStunDebuff()
	return false
end

function modifier_bard_bewilder_debuff:IsPurgable()
	return true
end

function modifier_bard_bewilder_debuff:OnCreated( kv )
	if IsServer() then
		self.confused_duration = self:GetAbility():GetSpecialValueFor( "confused_duration" )
		self.duration_per_kill = self:GetAbility():GetSpecialValueFor( "duration_per_kill" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.count_kill = 0
		self.attack_target = ""
		self.target_id = ""
		self:StartIntervalThink(0.15)
	end
end

function modifier_bard_bewilder_debuff:OnRefresh( kv )
	if IsServer() then
		self.confused_duration = self:GetAbility():GetSpecialValueFor( "confused_duration" )
		self.duration_per_kill = self:GetAbility():GetSpecialValueFor( "duration_per_kill" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	end
end

function modifier_bard_bewilder_debuff:OnRemoved()
	if IsServer() then
			self:GetParent():SetForceAttackTarget( nil )
			self:GetParent():MoveToTargetToAttack( nil )
			self:GetParent():SetForceAttackTargetAlly( nil )
			self:GetParent():MoveToPosition( self:GetParent():GetAbsOrigin() )
		if self.target_id==self:GetParent():GetTeamNumber() then
						
		end
		
		local duration = self.confused_duration + ( self.duration_per_kill * self.count_kill )
		self:GetParent():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_bard_confuse_debuff", -- modifier name
			{ duration = duration } -- kv
		)
	end
end

function modifier_bard_bewilder_debuff:OnDestroy()
	
end

function modifier_bard_bewilder_debuff:OnIntervalThink()
	if IsServer() then
		local counter = 0
		local allies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,
			false
		)
		print("attacker"..self:GetParent():GetName())
		for _,ally in pairs(allies) do
			if ally~=self:GetParent() and ally:HasModifier("modifier_bard_bewilder_debuff")==true then
				counter = counter + 1
				self.attack_target = ally
				self.target_id = ally:GetTeamNumber()
				
				if self.target_id==self:GetParent():GetTeamNumber() then
					self:GetParent():SetForceAttackTargetAlly( ally )
					print("6")
				end
				self:GetParent():SetForceAttackTarget( ally )
				self:GetParent():MoveToTargetToAttack( ally )
				print("target"..self.attack_target:GetName())
				break
			end
		end
		print(" ")
		print(counter)
		if counter>0 then
			self:GetParent():SetForceAttackTarget( nil )
			self:GetParent():MoveToTargetToAttack( nil )
			self:GetParent():SetAggroTarget( nil )
			self:StartIntervalThink(-1)
		end
		
	end	
end

function modifier_bard_bewilder_debuff:FindAllyTarget()

end

function modifier_bard_bewilder_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_bard_bewilder_debuff:GetModifierProvidesFOWVision()
	return 1
end

function modifier_bard_bewilder_debuff:OnDeath(event)
	if event.unit == self.attack_target then
		self.count_kill = self.count_kill + 1 
		self:StartIntervalThink(0)
	end
end

function modifier_bard_bewilder_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end

function modifier_bard_bewilder_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_FEARED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
	}

	return state
end

function modifier_bard_bewilder_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end
