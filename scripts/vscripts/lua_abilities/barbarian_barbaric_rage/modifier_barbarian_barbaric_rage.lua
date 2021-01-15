modifier_barbarian_barbaric_rage = class ({})

function modifier_barbarian_barbaric_rage:IsHidden()
	return self:GetStackCount()==0
end

function modifier_barbarian_barbaric_rage:IsDebuff()
	return false
end

function modifier_barbarian_barbaric_rage:IsStunDebuff()
	return false
end

function modifier_barbarian_barbaric_rage:IsPurgable()
	return false
end

function modifier_barbarian_barbaric_rage:DestroyOnExpire()
	return false
end

function modifier_barbarian_barbaric_rage:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.max_stack = self:GetAbility():GetSpecialValueFor( "max_stack" )
	self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" ) --/ 25
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" ) --/ 25
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" ) --/ 25
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.kill_stack = self:GetAbility():GetSpecialValueFor( "kill_stack" )
	self.miss_stack = self:GetAbility():GetSpecialValueFor( "miss_stack" )

	self.actual_stack = 0
end

function modifier_barbarian_barbaric_rage:OnRefresh( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.max_stack = self:GetAbility():GetSpecialValueFor( "max_stack" )
	self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" ) --/ 25
	self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" ) --/ 25
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" ) --/ 25
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.kill_stack = self:GetAbility():GetSpecialValueFor( "kill_stack" )
	self.miss_stack = self:GetAbility():GetSpecialValueFor( "miss_stack" )
end

function modifier_barbarian_barbaric_rage:OnRemoved()
end

function modifier_barbarian_barbaric_rage:OnDestroy()
end

function modifier_barbarian_barbaric_rage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,

		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_barbarian_barbaric_rage:OnAttackLanded( params )
	if not IsServer() then return end
	if params.target~=self:GetParent() then return end

	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end

	-- add stack
	self:AddStack(1)
end

function modifier_barbarian_barbaric_rage:OnAttackFail( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end

	-- add stack
	self:AddStack( self.miss_stack )
end

function modifier_barbarian_barbaric_rage:OnTakeDamage( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end

	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end

	--chance
	if self:RollChance( 100-self.proc_chance ) then return end
	
	-- add stack
	self:AddStack(1)
end

function modifier_barbarian_barbaric_rage:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

function modifier_barbarian_barbaric_rage:OnDeath( params )
	if not IsServer() then return end

	if params.attacker ~= self:GetCaster() then return end

	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end

	-- add stack
	self:AddStack( self.kill_stack )
end

function modifier_barbarian_barbaric_rage:AddStack( store )
	if not IsServer() then return end
	for x=1,store do
		if self:GetStackCount()==self.max_stack then
			if self:GetParent():HasModifier("modifier_barbarian_barbaric_rage_stack")==true then
				self:GetParent():FindModifierByName("modifier_barbarian_barbaric_rage_stack"):Destroy()
			end
		end
		-- add stack
		self.actual_stack = self.actual_stack + 1
		if self:GetStackCount()<self.max_stack then
			self:IncrementStackCount()
			self:PlayEffects()
		end
		
		-- add stack modifier
		local modifier = self:GetParent():AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_barbarian_barbaric_rage_stack", -- modifier name
			{ duration = self.duration } -- kv
		)
		modifier.parent = self

		-- set duration
		self:SetDuration( self.duration, true )
	end
	print(self.actual_stack)
end

function modifier_barbarian_barbaric_rage:OnHealReceived( params )
	if IsServer() then
		local parent = self:GetParent()
		local inflictor = params.inflictor
		local unit = params.unit

		if unit == parent then
			if inflictor and inflictor ~= self:GetAbility() then
				if self:GetParent():HasModifier("modifier_barbarian_barbaric_rage_stack")==true then
					self:GetParent():FindModifierByName("modifier_barbarian_barbaric_rage_stack"):Destroy()
				end
				print(self.actual_stack)
			end
		end
	end
end

function modifier_barbarian_barbaric_rage:RemoveStack()
	self.actual_stack = self.actual_stack - 1
	if self.actual_stack<=self.max_stack then
		self:SetStackCount( self.actual_stack )
	end
end

function modifier_barbarian_barbaric_rage:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() * self.move_speed
end

function modifier_barbarian_barbaric_rage:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount() * self.attack_damage
end

function modifier_barbarian_barbaric_rage:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * self.attack_speed
end

function modifier_barbarian_barbaric_rage:PlayEffects()

	local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local sound_cast = "Hero_Axe.BerserkersCall.Start"
	EmitSoundOn( sound_cast, self:GetCaster() )
end