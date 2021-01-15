modifier_warlock_shadowraze_thinker = class({})

function modifier_warlock_shadowraze_thinker:IsHidden()
	return false
end

function modifier_warlock_shadowraze_thinker:IsDebuff()
	return false
end

function modifier_warlock_shadowraze_thinker:IsPurgable()
	return false
end

function modifier_warlock_shadowraze_thinker:OnCreated( kv )
	
	self.radius = self:GetAbility():GetSpecialValueFor( "shadowraze_radius" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "shadowraze_damage" )
	self.stack_damage = self:GetAbility():GetSpecialValueFor( "stack_bonus_damage" )
	self.stack_duration = self:GetAbility():GetSpecialValueFor( "duration" )
	
	if not IsServer() then return end
	self.origin = Vector( kv.x, kv.y, kv.z )
		-- Apply damage
		self.damageTable = {
			attacker = self:GetCaster(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			--damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
			ability = self:GetAbility(),
		}

		
end

function modifier_warlock_shadowraze_thinker:OnDestroy( kv )
	if not IsServer() then return end

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self.origin,
		nil,
		self.radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false
	)

	for _,enemy in pairs(enemies) do
		-- Get Stack
		local modifier = enemy:FindModifierByNameAndCaster("modifier_warlock_shadowraze_stack", self:GetCaster())
		local stack = 0
		if modifier~=nil then
			stack = modifier:GetStackCount()
		end

		self.damageTable.victim = enemy
		self.damageTable.damage = self.base_damage + stack * self.stack_damage

		ApplyDamage( self.damageTable )

		-- Add stack
		if modifier==nil then
			enemy:AddNewModifier(
				self:GetCaster(),
				self:GetAbility(),
				"modifier_warlock_shadowraze_stack",
				{ duration = self.stack_duration }
			)
		else
			modifier:IncrementStackCount()
			modifier:ForceRefresh()
		end
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), self.origin, self.radius, 0.5, false )

	self:PlayEffects()

end

function modifier_warlock_shadowraze_thinker:PlayEffects()
	-- get resources
	local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local sound_cast = "Hero_Nevermore.Shadowraze"

	-- create particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self.origin )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
	
	-- create sound
	EmitSoundOnLocationWithCaster( self.origin, sound_cast, self:GetCaster() )
end