druid_energy_bolt = class({})

LinkLuaModifier( "modifier_druid_energy_bolt", "lua_abilities/druid_energy_bolt/modifier_druid_energy_bolt", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function druid_energy_bolt:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- references
	self.radius = self:GetSpecialValueFor( "damage_radius" )
	self.bounce_distance = self:GetSpecialValueFor( "bounce_distance" )
	local jumps = self:GetSpecialValueFor( "number_of_bounce" )
	self.heal = self:GetSpecialValueFor( "heal" )
	self.heal_increase = 1 + ( self:GetSpecialValueFor( "heal_increase" ) / 100 )

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = caster,
		damage = self.heal,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	-- unit groups
	self.healedUnits = {}
	table.insert( self.healedUnits, caster )

	-- Jump
	self:Jump( jumps, caster, target )

	-- Play effects
	local sound_cast = "Hero_Dazzle.Shadow_Wave"
	EmitSoundOn( sound_cast, caster )
end


function druid_energy_bolt:Jump( jumps, caster, target )
	-- Heal
	local total_heal = self.heal
	if caster:IsSummoned()==true then
		if caster:GetOwner()==self:GetCaster() then
			total_heal = self.heal * 2
		end
	end
	caster:Heal( total_heal, self )
	print(self.heal)

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		self:GetAbilityTargetFlags(),
		0,
		false
	)

	-- Damage
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = total_heal/2
		ApplyDamage( self.damageTable )

		self:PlayEffects2( enemy )
	end

	-- counter
	local jump = jumps-1
	if jump <0 then
		return
	end

	-- next target
	local nextTarget = nil
	if target and target~=caster then
		nextTarget = target
	else
		-- Find ally nearby
		local allies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			caster:GetOrigin(),
			nil,
			self.bounce_distance,
			self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			0,
			FIND_CLOSEST,
			false	
		)
		
		for _,ally in pairs(allies) do
			local pass = false
			for _,unit in pairs(self.healedUnits) do
				if ally==unit then
					pass = true
				end
			end

			if not pass then
				self.heal = self.heal * self.heal_increase
				nextTarget = ally
				break
			end
		end
	end

	if nextTarget then
		table.insert( self.healedUnits, nextTarget )
		self:Jump( jump, nextTarget )
	end

	-- Play effects
	self:PlayEffects1( caster, nextTarget )

end

--------------------------------------------------------------------------------
function druid_energy_bolt:PlayEffects1( caster, target )
	-- Get Resource
	local particle_cast = "particles/units/heroes/hero_rubick/rubick_fade_bolt.vpcf"
	local particle_target = "particles/items3_fx/fish_bones_active_ring.vpcf"

	if not target then
		target = caster
	end

	-- Create Particle
	 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	effect_cast = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function druid_energy_bolt:PlayEffects2( target )
	-- Get Resource
	local particle_cast = "particles/units/heroes/hero_rubick/rubick_fade_bolt_energy.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end