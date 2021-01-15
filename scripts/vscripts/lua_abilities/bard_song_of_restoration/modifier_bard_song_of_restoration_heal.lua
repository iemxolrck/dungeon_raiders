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
		self.hasTarget = false
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
				break
			end
		end
		print(" ")
		if counter>0 then
			self.hasTarget = false
			self:FindAllyTarget()
			self:StartIntervalThink(-1)
		else
			self.hasTarget = true
		end
	end
	
end

function modifier_bard_bewilder_debuff:FindAllyTarget()
	if IsServer() then
		self.hasTarget = false
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
				self.attack_target = ally
				self.target_id = ally:GetTeamNumber()
				self:GetParent():SetForceAttackTarget( ally )
				self:GetParent():MoveToTargetToAttack( ally )
				
				if self.target_id==self:GetParent():GetTeamNumber() then
					self:GetParent():SetForceAttackTargetAlly( ally )
				end
				print("target"..self.attack_target:GetName())
				break
			end
		end
		print(" ")
		
	end
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
		self:FindAllyTarget()
	end
end

function modifier_bard_bewilder_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end

function modifier_bard_bewilder_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
		[MODIFIER_STATE_FEARED] = true,
		[MODIFIER_STATE_ROOTED] = self.hasTarget,
		[MODIFIER_STATE_DISARMED] = self.hasTarget,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = not self.hasTarget
	}

	return state
end

function modifier_bard_bewilder_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end
