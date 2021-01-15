modifier_warrior_counter_stance = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_warrior_counter_stance:IsHidden()
	return true
end

function modifier_warrior_counter_stance:IsPurgable()
	return false
end

function modifier_warrior_counter_stance:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.reduction_front = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" )/2
end

function modifier_warrior_counter_stance:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.reduction_front = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" )/2
end

function modifier_warrior_counter_stance:OnDestroy( kv )

end

function modifier_warrior_counter_stance:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}

	return funcs
end

function modifier_warrior_counter_stance:GetModifierPhysical_ConstantBlock( params )
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

function modifier_warrior_counter_stance:OnIntervalThink()
	if IsServer() then
		local bash = self:GetParent():FindAbilityByName("warrior_shield_strike")
		--self:GetParent():CastAbilityImmediately(bash, self:GetParent():GetPlayerOwnerID())
		bash:OnSpellStart()
		self:GetAbility():UseResources( false, false, true )
		self:StartIntervalThink(-1)
	end
end

function modifier_warrior_counter_stance:PlayEffects2( front )

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