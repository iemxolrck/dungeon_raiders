modifier_cleric_channel_divinity = class({})

function modifier_cleric_channel_divinity:IsHidden()
	return false
end

function modifier_cleric_channel_divinity:IsDebuff()
	return false
end

function modifier_cleric_channel_divinity:IsPurgable()
	return false
end

function modifier_cleric_channel_divinity:OnCreated( kv )
	if IsServer() then
		self.tracker = {
			{ "cleric_mass_heal", 0 },
			{ "cleric_divine_protection", 0 },
			{ "cleric_blessing", 0 },
			{ "cleric_turn_undead", 0 },
			{ "cleric_resurrection", 0 }
		}

		self.base_cooldown = self:GetAbility():GetSpecialValueFor( "cooldown_penalty" )
		self.add_cooldown = self:GetAbility():GetSpecialValueFor( "cooldown_per_cast" )
		self.max_stack = self:GetAbility():GetSpecialValueFor( "max_stack" )
		self.heal_amp = self:GetAbility():GetSpecialValueFor( "heal_amp" )
		self.status_resist = self:GetAbility():GetSpecialValueFor( "status_resist" )
		self:SetStackCount(self.max_stack)
		self:PlayEffects()

		local sound_cast = "Hero_Omniknight.GuardianAngel"
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end

function modifier_cleric_channel_divinity:OnRefresh( kv )
	if IsServer() then
		self.base_cooldown = self:GetAbility():GetSpecialValueFor( "cooldown_penalty" )
		self.add_cooldown = self:GetAbility():GetSpecialValueFor( "cooldown_per_cast" )
		self.max_stack = self:GetAbility():GetSpecialValueFor( "max_stack" )
		self.heal_amp = self:GetAbility():GetSpecialValueFor( "heal_amp" )
		self.status_resist = self:GetAbility():GetSpecialValueFor( "status_resist" )
		self:SetStackCount(self.max_stack)
		self:PlayEffects()

		local sound_cast = "Hero_Omniknight.GuardianAngel"
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end

function modifier_cleric_channel_divinity:OnRemoved( kv )
	if IsServer() then
		if self:GetParent():HasModifier("modifier_cleric_blessing_str") then
			self:GetParent():FindModifierByName("modifier_cleric_blessing_str"):Destroy()
		end
		if self:GetParent():HasModifier("modifier_cleric_blessing_agi") then
			self:GetParent():FindModifierByName("modifier_cleric_blessing_agi"):Destroy()
		end
		if self:GetParent():HasModifier("modifier_cleric_blessing_int") then
			self:GetParent():FindModifierByName("modifier_cleric_blessing_int"):Destroy()
		end
		local cd_penalty = 0

		--[[for i=1, #self.tracker do
			print(self.tracker[i][1])
			print(self.tracker[i][2])
		end]]

		for i=1,#self.tracker do
			cd_penalty = ( self.tracker[i][2] * self.add_cooldown )+ self.base_cooldown
			self:GetParent():FindAbilityByName(self.tracker[i][1]):StartCooldown(cd_penalty)
		end
	end
end

function modifier_cleric_channel_divinity:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,

	}

	return funcs
end

function modifier_cleric_channel_divinity:GetModifierStatusResistance()
	return self.status_resist
end

function modifier_cleric_channel_divinity:OnAbilityFullyCast( event )
	local ability = event.ability:GetName()

	for i=1,#self.tracker do
		if  ability~=self:GetAbility():GetName()
			and event.unit == self:GetParent()
			and ability==self.tracker[i][1] then
				self.tracker[i][2] = self.tracker[i][2] + 1
		        self:Decrementation()
    	end
	end

end

function modifier_cleric_channel_divinity:Decrementation()
	self:DecrementStackCount()
	if self:GetStackCount() == 0 then
		self:StartIntervalThink(0.2)
	end

end

function modifier_cleric_channel_divinity:OnIntervalThink()
	if self:GetStackCount() == 0 then
		self:Destroy()
	end

end

function modifier_cleric_channel_divinity:PlayEffects()

	local sound_cast = "Hero_Omniknight.GuardianAngel"
	EmitSoundOn( sound_cast, self:GetParent() )

	particle_cast = "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(),
		true -- unknown, true
	)

	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

end