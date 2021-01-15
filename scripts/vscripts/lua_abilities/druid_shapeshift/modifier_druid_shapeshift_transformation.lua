modifier_druid_shapeshift_transformation = class({})

function modifier_druid_shapeshift_transformation:IsHidden()
	return false
end

function modifier_druid_shapeshift_transformation:IsDebuff()
	return false
end

function modifier_druid_shapeshift_transformation:IsPurgable()
	return false
end

function modifier_druid_shapeshift_transformation:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	EmitSoundOn( "Hero_LoneDruid.TrueForm.Cast", self:GetParent() )
	local particle_effects = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_true_form.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle_effects, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_effects, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_effects)
end

function modifier_druid_shapeshift_transformation:OnRefresh()
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end