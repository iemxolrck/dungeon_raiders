modifier_generic_channel_protection = class({})

function modifier_generic_channel_protection:IsHidden()
	return false
end

function modifier_generic_channel_protection:IsDebuff()
	return false
end

function modifier_generic_channel_protection:IsStunDebuff()
	return false
end

function modifier_generic_channel_protection:IsPurgable()
	return false
end

function modifier_generic_channel_protection:GetTexture()
	return "status/modifier_generic_channel_protection"
end

function modifier_generic_channel_protection:OnCreated( kv )
	self.channelprotection = -self:GetAbility():GetSpecialValueFor( "channelprotection" )
	self:PlayEffects()
end

function modifier_generic_channel_protection:OnRefresh( kv )
	self.channelprotection = -self:GetAbility():GetSpecialValueFor( "channelprotection" )
end

function modifier_generic_channel_protection:OnRemoved()
end

function modifier_generic_channel_protection:OnDestroy()
end

function modifier_generic_channel_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_ABILITY_END_CHANNEL,
	}
	return funcs
end

function modifier_generic_channel_protection:GetModifierIncomingDamage_Percentage( params )
	if self:GetParent():IsChanneling() then
		return self.channelprotection
	end
end

function modifier_generic_channel_protection:OnTooltip()
	return self.channelprotection
end

function modifier_generic_channel_protection:OnAbilityEndChannel( params )
	if params.unit~=self:GetParent() then return end
	self:Destroy()
end

function modifier_generic_channel_protection:PlayEffects()
	-- destroy previous
	if self.effect_cast then
		ParticleManager:DestroyParticle( self.effect_cast, false )
	end

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
	-- local sound_cast = "string"

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(10,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.channelprotection, 0, 0 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	
	self.effect_cast = effect_cast
end