modifier_wizard_charge_blast_charge = class({})

function modifier_wizard_charge_blast_charge:IsHidden()
	return false
end

function modifier_wizard_charge_blast_charge:IsPurgable()
	return false
end

function modifier_wizard_charge_blast_charge:OnCreated( kv )
	if not IsServer() then return end
	self.origin = Vector( kv.x, kv.y, kv.z )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self:PlayEffects1()
end

function modifier_wizard_charge_blast_charge:OnDestroy( kv )
	if not IsServer() then return end
	self:PlayEffects2()
end

function modifier_wizard_charge_blast_charge:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_emp.vpcf"
	local sound_cast = "Hero_Invoker.EMP.Charge"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self.origin )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.origin, sound_cast, self:GetCaster() )
end

function modifier_wizard_charge_blast_charge:PlayEffects2()
	-- Get Resources
	local sound_cast = "Hero_Invoker.EMP.Discharge"

	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.origin, sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self.origin, sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self.origin, sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self.origin, sound_cast, self:GetCaster() )
end