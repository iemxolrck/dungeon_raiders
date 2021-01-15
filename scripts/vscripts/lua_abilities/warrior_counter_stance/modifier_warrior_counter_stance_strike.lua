modifier_warrior_counter_stance_strike = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_warrior_counter_stance_strike:IsHidden()
	return true
end

function modifier_warrior_counter_stance_strike:IsPurgable()
	return false
end

function modifier_warrior_counter_stance_strike:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.reduction_front = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" )/2
end

function modifier_warrior_counter_stance_strike:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.reduction_front = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" )/2
end

function modifier_warrior_counter_stance_strike:OnDestroy( kv )

end

function modifier_warrior_counter_stance_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_warrior_counter_stance_strike:OnAttackLanded( params )
	if IsServer() then
		if not self:GetAbility():IsToggle() then return end
		if not self:GetAbility():IsCooldownReady() then return end
		if self:GetCaster():FindAbilityByName("warrior_shield_strike"):GetLevel()==0 then return end
		if params.target~=self:GetCaster() then return end
		if self:GetCaster():PassivesDisabled() then return end
		if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end
		if params.attacker:IsOther() or params.attacker:IsBuilding() then return end

		local parent = params.target
		local attacker = params.attacker

		local facing_direction = parent:GetAnglesAsVector().y
		local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
		local attacker_direction = VectorToAngles( attacker_vector ).y
		local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )
		local distance = (parent:GetOrigin()-attacker:GetOrigin()):Length2D()

		if angle_diff>self.angle_front then return end
		if distance > self.radius then return end
		if RandomInt(1,100)>self.chance then return end

		self:GetParent():AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_warrior_counter_stance_animation",
			{ duration = 0.5 }
		)
		self:StartIntervalThink(0.2)	
		
	end
end

function modifier_warrior_counter_stance_strike:GetModifierPhysical_ConstantBlock( params )
	-- cancel if from ability
	if params.inflictor then return 0 end

	-- cancel if break
	if params.target:PassivesDisabled() then return 0 end

	-- get data
	local parent = params.target
	local attacker = params.attacker
	local reduction = 0

	-- Check target position
	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )

	-- calculate damage reduction
	if angle_diff < self.angle_front then
		reduction = self.reduction_front
		if self:GetParent():HasModifier("modifier_warrior_shield_strike_block")==true then
			reduction = 100
		end
		self:PlayEffects2( true, attacker_vector )
	end

	return reduction * params.damage / 100
end

function modifier_warrior_counter_stance_strike:OnIntervalThink()
	if IsServer() then
		local bash = self:GetParent():FindAbilityByName("warrior_shield_strike")
		--self:GetParent():CastAbilityImmediately(bash, self:GetParent():GetPlayerOwnerID())
		bash:OnSpellStart()
		self:GetAbility():UseResources( false, false, true )
		self:StartIntervalThink(-1)
	end
end

function modifier_warrior_counter_stance_strike:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_counterhelix.vpcf"
	local sound_cast = "Hero_Axe.CounterHelix"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_warrior_counter_stance_strike:PlayEffects2( front )

	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf"
	local sound_cast = "Hero_Mars.Shield.BlockSmall"

	local distance = -200
	local front = self:GetParent():GetForwardVector():Normalized()
	local target_pos = self:GetCaster():GetOrigin() + front * distance

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, target_pos )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end