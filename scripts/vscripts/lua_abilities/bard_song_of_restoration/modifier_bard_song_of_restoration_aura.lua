modifier_bard_song_of_restoration_aura = class({})

function modifier_bard_song_of_restoration_aura:IsHidden()
	return false
end

function modifier_bard_song_of_restoration_aura:IsDebuff()
	return false
end

function modifier_bard_song_of_restoration_aura:IsPurgable()
	return false
end

function modifier_bard_song_of_restoration_aura:OnCreated( kv )
	self.heal = self:GetAbility():GetSpecialValueFor( "heal" )
	self.mana = self:GetAbility():GetSpecialValueFor( "mana" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if IsServer() then
		local interval = self:GetAbility():GetSpecialValueFor( "heal_interval" )
		self:StartIntervalThink(interval)
		self:OnIntervalThink()
	end
end

function modifier_bard_song_of_restoration_aura:OnRefresh( kv )
	self.heal = self:GetAbility():GetSpecialValueFor( "heal" )
	self.mana = self:GetAbility():GetSpecialValueFor( "mana" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if IsServer() then
		local interval = self:GetAbility():GetSpecialValueFor( "heal_interval" )
		self:StartIntervalThink(interval)
		self:OnIntervalThink()
	end
end

function modifier_bard_song_of_restoration_aura:OnRemoved()
	if IsServer() then
		self:StartIntervalThink( -1 )
		StopSoundOn( "Hero_KeeperOfTheLight.Wisp.Active", self:GetCaster() )
		EmitSoundOn( "Hero_KeeperOfTheLight.Wisp.Destroy", self:GetCaster() )
	end
end

function modifier_bard_song_of_restoration_aura:OnDestroy()
	if IsServer() then
		self:StartIntervalThink( -1 )
		StopSoundOn( "Hero_KeeperOfTheLight.Wisp.Active", self:GetCaster() )
		EmitSoundOn( "Hero_KeeperOfTheLight.Wisp.Destroy", self:GetCaster() )
	end
end

function modifier_bard_song_of_restoration_aura:OnIntervalThink()
	if IsServer() then
		local counter = 0
		local allies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self.radius,
			self:GetAbility():GetAbilityTargetTeam(),
			self:GetAbility():GetAbilityTargetType(),
			self:GetAbility():GetAbilityTargetFlags(),
			FIND_CLOSEST,
			false
		)
		EmitSoundOn( "Hero_KeeperOfTheLight.Wisp.Active", self:GetCaster() )
		for _,ally in pairs(allies) do
			ally:Heal( self.heal, self:GetAbility() )
			ally:GiveMana( self.mana )
			ally:Purge( false, true, false, true, false )
			self:PlayEffects(ally)
		end	
	end
end

function modifier_bard_song_of_restoration_aura:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		--MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}

	return funcs
end

function modifier_bard_song_of_restoration_aura:GetOverrideAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function modifier_bard_song_of_restoration_aura:GetOverrideAnimationRate()
	return 10
end

function modifier_bard_song_of_restoration_aura:PlayEffects(target)

	local particle_cast = "particles/generic_gameplay/generic_lifesteal_blue.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
	particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end