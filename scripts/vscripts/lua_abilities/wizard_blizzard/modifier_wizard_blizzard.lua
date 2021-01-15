modifier_wizard_blizzard = class({})

function modifier_wizard_blizzard:IsHidden()
	return true
end

function modifier_wizard_blizzard:IsDebuff()
	return false
end

function modifier_wizard_blizzard:IsPurgable()
	return false
end

function modifier_wizard_blizzard:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
	self.explosion_radius = self:GetAbility():GetSpecialValueFor( "explosion_radius" )
	self.explosion_interval = self:GetAbility():GetSpecialValueFor( "explosion_interval" )
	self.explosion_min_dist = self:GetAbility():GetSpecialValueFor( "explosion_min_dist" )
	self.explosion_max_dist = self.radius - self.explosion_radius

	-- generate data
	self.quartal = -1

	if not IsServer() then return end
	self.origin = Vector( kv.x, kv.y, 0 )
	local explosion_damage = self:GetAbility():GetAbilityDamage()
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = explosion_damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()

		-- Play Effects
		self:PlayEffects1()
end

function modifier_wizard_blizzard:OnRefresh( kv )

end

function modifier_wizard_blizzard:OnDestroy( kv )
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:StopEffects1()
	end
end

function modifier_wizard_blizzard:OnIntervalThink()

	AddFOWViewer( self:GetCaster():GetTeamNumber(), self.origin, self.radius, 1, false )
	-- Set explosion quartal
	self.quartal = self.quartal+1
	if self.quartal>3 then self.quartal = 0 end

	-- determine explosion relative position
	local a = RandomInt( 0, 90 ) + self.quartal*90
	local r = RandomInt( 0, self.explosion_max_dist )
	local point = Vector( math.cos(a), math.sin(a), 0 ):Normalized() * r

	-- actual position
	point = self.origin + point

	-- Explode at point
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		point,
		nil,
		self.explosion_radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		0,
		0,
		false
	)

	-- damage units
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		if enemy:HasModifier("modifier_generic_chilled")==false
			and enemy:HasModifier("modifier_generic_frozen")==false
			and enemy:HasModifier("modifier_generic_burned")==false then
				enemy:AddNewModifier(
					self:GetCaster(),
					self:GetAbility(),
					"modifier_generic_chilled",
					{ duration = self.slow_duration }
				)
		end
	end

	self:PlayEffects2( point )
end

--------------------------------------------------------------------------------
-- Effects
function modifier_wizard_blizzard:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf"
	self.sound_cast = "hero_Crystal.freezingField.wind"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self.origin )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, 1 ) )
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Play sound
	EmitSoundOn( self.sound_cast, self:GetCaster() )
end

function modifier_wizard_blizzard:PlayEffects2( point )
	-- Play particles
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"

	-- Create particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )

	-- Play sound
	local sound_cast = "hero_Crystal.freezingField.explosion"
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

function modifier_wizard_blizzard:StopEffects1()
	StopSoundOn( self.sound_cast, self:GetCaster() )
end