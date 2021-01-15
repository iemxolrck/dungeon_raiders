modifier_ranger_latent_venom = class({})

function modifier_ranger_latent_venom:IsHidden()
	return false
end

function modifier_ranger_latent_venom:IsDebuff()
	return true
end

function modifier_ranger_latent_venom:IsStunDebuff()
	return false
end

function modifier_ranger_latent_venom:IsPurgable()
	return true
end

function modifier_ranger_latent_venom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ranger_latent_venom:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
	self.radius = self:GetAbility():GetSpecialValueFor( "infect_radius" )
	self.reduction = self:GetAbility():GetSpecialValueFor( "duration_reduction" ) / 100
	self.damage_increase = self:GetAbility():GetSpecialValueFor( "increase_per_sec" ) / 100 + 1
	self.armor = -self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	local damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
	

	if IsServer() then
		self.target_team = 	self:GetAbility():GetAbilityTargetTeam()
		self.target_type = 	self:GetAbility():GetAbilityTargetType()
		self.target_flag = 	self:GetAbility():GetAbilityTargetFlags()
		self:GetParent():AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_ranger_latent_venom_armor",
			{ duration = self:GetDuration() }
		)
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self,
		}
		ApplyDamage( self.damageTable )
		self.damageTable.damage = self.damageTable.damage * self.damage_increase

		self.total_duration = self:GetRemainingTime()

		self:StartIntervalThink( self.interval )

		self:PlayEffects()
	end
end

function modifier_ranger_latent_venom:OnRefresh( kv )
	
end

function modifier_ranger_latent_venom:OnDestroy()
	if IsServer() then
		if self:GetParent():IsAlive()==true then return end
		if RandomInt(1,100)>self.chance*2 then return end
		self:SpreadPoison()
	end
end

function modifier_ranger_latent_venom:OnRemoved()
	if IsServer() then
		if self:GetParent():IsAlive()==true then return end
		if RandomInt(1,100)>self.chance*2 then return end
		self:SpreadPoison()
	end
end

function modifier_ranger_latent_venom:OnIntervalThink()
	if IsServer() then
		ApplyDamage( self.damageTable )
		self.damageTable.damage = self.damageTable.damage * self.damage_increase
	end
end

function modifier_ranger_latent_venom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_ranger_latent_venom:OnAttackLanded( params )
	if IsServer() then
		if params.target~=self:GetParent() then return end
		
		local parent = params.target
		local attacker = params.attacker
		local chance = self.chance

		if params.attacker~=self:GetCaster() then
			chance = chance / 2
		end

		if parent:HasModifier("modifier_ranger_latent_venom")==false then return end

		if RandomInt(1,100)>self.chance then return end

		self:SpreadPoison()
	end
end

function modifier_ranger_latent_venom:OnDeath( params )
	if IsServer() then
		if params.unit~=self:GetParent() then return end
		local chance = self.chance * 2
		if params.attacker~=self:GetCaster() then
			chance = self.chance
		end
		if RandomInt(1,100)>chance then return end
		self:SpreadPoison()
	end
end

function modifier_ranger_latent_venom:SpreadPoison( target )
	if IsServer() then
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self.radius,
			self.target_team,
			self.target_type,
			self.target_flag,
			0,
			false
		)

		for _,enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_ranger_latent_venom")==false then
				enemy:AddNewModifier(
					self:GetCaster(),
					self:GetAbility(),
					"modifier_ranger_latent_venom",
					{ duration = self:GetDuration() * self.reduction }
				)
			
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				self:AddParticle( nFXIndex, false, false, -1, false, false )
			end
		end
		self:PlayEffects2()
		self:PlayEffects2()	
		self:PlayEffects2()
	end
end

function modifier_ranger_latent_venom:CheckState()
	local state = {
		
	}

	return state
end

function modifier_ranger_latent_venom:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(),
		true
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

function modifier_ranger_latent_venom:PlayEffects2()
	--EmitSoundOn( "Hero_Pudge.Rot", self:GetParent() )
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot_body_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, self.radius ) )
	self:AddParticle( nFXIndex, false, false, -1, false, false )

end