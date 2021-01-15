modifier_shaman_protection_from_death_buff = class({})

function modifier_shaman_protection_from_death_buff:IsHidden()
	return false
end

function modifier_shaman_protection_from_death_buff:IsDebuff()
	return false
end

function modifier_shaman_protection_from_death_buff:IsPurgable()
	return true
end

function modifier_shaman_protection_from_death_buff:OnCreated( kv )
	self.max_hit = self:GetAbility():GetSpecialValueFor( "max_hit" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_per_stack" )
	self.radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
	self.hit_count = 0
	self:SetStackCount(self.max_hit)
	self:PlayEffects2()
	if not IsServer() then return end
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self,
	}
end

function modifier_shaman_protection_from_death_buff:OnRefresh( kv )

end

function modifier_shaman_protection_from_death_buff:OnRemoved( kv )
	if not IsServer() then return end
	self.damageTable.damage = self.damage * self.hit_count

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage(self.damageTable)
	end

end

function modifier_shaman_protection_from_death_buff:OnDestroy( kv )
	if not IsServer() then return end
	self.damageTable.damage = self.damage * self.hit_count

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		ApplyDamage(self.damageTable)
	end

end

function modifier_shaman_protection_from_death_buff:OnIntervalThink()

end

function modifier_shaman_protection_from_death_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
		--MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		--MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		--MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		
	}
	return funcs
end

function modifier_shaman_protection_from_death_buff:GetMinHealth()
	return 1
end

function modifier_shaman_protection_from_death_buff:OnTakeDamageKillCredit( params )
	if not IsServer() then return end
	if params.target~=self:GetParent() then return end
	self.hit_count = self.hit_count + 1
	self:DecrementStackCount()
	local health = self:GetStackCount()
	if health<=0 then self:Destroy() end
end

function modifier_shaman_protection_from_death_buff:CheckState()
	local states = {
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
	return states
 end

function modifier_shaman_protection_from_death_buff:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_buff.vpcf"
	local sound_cast = "Hero_VoidSpirit.Pulse.Cast"

	-- Get Data
	local radius = 100

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end