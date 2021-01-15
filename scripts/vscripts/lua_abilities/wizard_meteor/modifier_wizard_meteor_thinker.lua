modifier_wizard_meteor_thinker = class({})

function modifier_wizard_meteor_thinker:IsHidden()
	return true
end

function modifier_wizard_meteor_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()

		self.delay = self:GetAbility():GetSpecialValueFor( "land_time" )
		self.inner_radius = self:GetAbility():GetSpecialValueFor( "inner_radius" )
		self.radius = self.inner_radius + kv.radius
		self.vision = self:GetAbility():GetSpecialValueFor( "vision_distance" )
		self.vision_duration = self:GetAbility():GetSpecialValueFor( "vision_duration" )
		self.duration = self:GetAbility():GetSpecialValueFor( "burn_duration" )
		local damage = self:GetAbility():GetAbilityDamage()

		-- variables
		self.fallen = false
		self.damageTable = {
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
		}
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.radius + 100, self.vision_duration, false)

		-- Start interval
		self:StartIntervalThink( self.delay )

		-- play effects
		self:PlayEffects1()
	end
end

function modifier_wizard_meteor_thinker:OnRefresh( kv )
	
end

function modifier_wizard_meteor_thinker:OnDestroy( kv )
	if IsServer() then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl(particle, 3, self.parent_origin)
		ParticleManager:SetParticleControl(particle, 5, Vector(self.radius, 0, 0-self.radius))

		-- Create Sound
		EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )
		EmitSoundOn( sound_loop, self:GetParent() )

		-- add vision
		GridNav:DestroyTreesAroundPoint( self.parent_origin, self.radius, true )
		-- stop effects
		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
	end
end

function modifier_wizard_meteor_thinker:OnIntervalThink()
	if not self.fallen then
		-- meatball has fallen
		self.fallen = true
		self:Burn()
		--self:PlayEffects2()
		self:Destroy()
	end
end

function modifier_wizard_meteor_thinker:Burn()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		0,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		local distance = math.floor( (self.parent_origin-enemy:GetOrigin()):Length2D() )
		if distance<self.inner_radius then
			ApplyDamage( self.damageTable )
			enemy:AddNewModifier(
				self:GetCaster(),
				self:GetAbility(),
				"modifier_generic_stunned",
				{ duration = self.duration/2 }
			)
		else

		end
		ApplyDamage( self.damageTable )
		if enemy:HasModifier("modifier_generic_chilled")==true then
			local modifier = self:GetParent():FindModifierByName("modifier_generic_chilled")
			if modifier~=nil then modifier:Destroy() end
		end
		if enemy:HasModifier("modifier_generic_frozen")==true then
			local modifier = self:GetParent():FindModifierByName("modifier_generic_frozen")
			if modifier~=nil then modifier:Destroy() end
		end
		enemy:AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_generic_burned",
			{ duration = self.duration }
		)
	end
end

function modifier_wizard_meteor_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_wizard_meteor_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
	local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin )

	-- -- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end