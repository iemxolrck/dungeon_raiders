modifier_engineer_scan = class({})

function modifier_engineer_scan:IsHidden()
	return false
end

function modifier_engineer_scan:IsDebuff()
	return false
end

function modifier_engineer_scan:IsPurgable()
	return false
end

function modifier_engineer_scan:OnCreated( kv )

	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
	self.interval = self:GetAbility():GetSpecialValueFor( "scan_interval" )

	self:ApplyDebuff()
	self:StartIntervalThink( self.interval )

end

function modifier_engineer_scan:OnRefresh( kv )
	
end

function modifier_engineer_scan:OnDestroy( kv )
	
end

function modifier_engineer_scan:OnIntervalThink()
	if not IsServer() then return end
	self:ApplyDebuff()
end

function modifier_engineer_scan:ApplyDebuff()
	if not IsServer() then return end

	self:PlayEffects()
	self:PlayEffects()
	self:PlayEffects()
	self:PlayEffects()
	self:PlayEffects()
	self:PlayEffects()
	
	local sound_cast = "Hero_Tinker.March_of_the_Machines.Cast"
	EmitSoundOnLocationForAllies( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
	        self:GetCaster(),   
	        self:GetAbility(),
	        "modifier_engineer_scan_debuff", 
	        { duration = self.duration }
   		)
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self.radius, self.duration,false )

end

function modifier_engineer_scan:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/items/tinker/tinker_motm_rollermaw/tinker_rollermaw_motm.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
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
		self:GetCaster(),
		PATTACH_ABSORIGIN,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

end