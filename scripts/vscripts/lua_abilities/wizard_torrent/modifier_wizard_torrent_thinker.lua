modifier_wizard_torrent_thinker = class({})

function modifier_wizard_torrent_thinker:OnCreated( kv )
	
	self.torrent_delay = self:GetAbility():GetSpecialValueFor( "delay" )
	self.torrent_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.torrent_damage = self:GetAbility():GetSpecialValueFor( "torrent_damage" )
	self.drenched_duration = self:GetAbility():GetSpecialValueFor( "drenched_duration" )
	
	self:PlayEffects()

	if not IsServer() then return end

	self.damageTable = {
		attacker = self:GetCaster(),
		damage = self.torrent_damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
	}

	self:StartIntervalThink( self.torrent_delay )
	
end

function modifier_wizard_torrent_thinker:OnIntervalThink()
	if not IsServer() then return end
	
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.torrent_radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		FIND_CLOSEST,
		false
	)

	for _, enemy in pairs( enemies ) do
		if enemy:HasModifier("modifier_generic_burned")==true then
			local modifier = enemy:FindModifierByName("modifier_generic_burned")
			modifier:Destroy()
		end
		if enemy ~= nil and enemy:IsInvulnerable() == false then
			self.damageTable.victim = enemy 
			ApplyDamage( self.damageTable )
		end
		enemy:AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			"modifier_generic_drenched",
			{ duration = self.drenched_duration }
		)
		if enemy:HasModifier("modifier_generic_airborne")==false
			and enemy:HasModifier("modifier_generic_frozen")==false then
			enemy:AddNewModifier(
				self:GetCaster(),
				self:GetAbility(),
				"modifier_generic_airborne",
				{
					duration = 1.5,
					height = 550,
					damage = self.torrent_damage / 2
				}
			)
		end
	end

	self:PlayEffects2()

	AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.torrent_radius + 100, 3,false )

	UTIL_Remove( self:GetParent() )

end

function modifier_wizard_torrent_thinker:PlayEffects()
	local particles = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf"
	local nFXIndex = ParticleManager:CreateParticle( particles, PATTACH_ABSORIGIN, self:GetParent() )
	self:AddParticle( nFXIndex, false, false, -1, false, false )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	local sound_cast = "Ability.Pre.Torrent"
	EmitSoundOn( sound_cast, self:GetParent() )

end

function modifier_wizard_torrent_thinker:PlayEffects2()
	local particles = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
	local sound_cast = "Ability.Torrent"

	local nFXIndex = ParticleManager:CreateParticle( particles, PATTACH_POINT, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( sound_cast, self:GetParent() )

end