modifier_shaman_resurrecting_light = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_shaman_resurrecting_light:IsHidden()
	return true
end

function modifier_shaman_resurrecting_light:OnCreated( kv )
	-- references
	self.resurrect_radius = self:GetAbility():GetSpecialValueFor( "resurrect_radius" )
	self.reincarnate_time = self:GetAbility():GetSpecialValueFor( "reincarnate_time" )
	self.resurrect_chance = self:GetAbility():GetSpecialValueFor( "resurrect_chance" )
	self.ally_chance = self:GetAbility():GetSpecialValueFor( "ally_chance" )
	self.bonus_chance = self:GetAbility():GetSpecialValueFor( "bonus_chance" )
end

function modifier_shaman_resurrecting_light:OnRefresh( kv )
	-- references
	self.resurrect_radius = self:GetAbility():GetSpecialValueFor( "resurrect_radius" )
	self.reincarnate_time = self:GetAbility():GetSpecialValueFor( "reincarnate_time" )
	self.resurrect_chance = self:GetAbility():GetSpecialValueFor( "resurrect_chance" )
	self.ally_chance = self:GetAbility():GetSpecialValueFor( "ally_chance" )
	self.bonus_chance = self:GetAbility():GetSpecialValueFor( "bonus_chance" )
end

function modifier_shaman_resurrecting_light:OnDestroy( kv )

end

function modifier_shaman_resurrecting_light:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REINCARNATION
	}
	return funcs
end

function modifier_shaman_resurrecting_light:ReincarnateTime( params )
	if not IsServer() then return end
	if not self:GetAbility():IsFullyCastable() then return end
	local allies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.resurrect_radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		0,
		false
	)
	local roll_chance = self.resurrect_chance + ( self.bonus_chance * (#allies-1) )
	print(roll_chance.."% chance to resurrect.")
	if not self:RollChance( roll_chance ) then return end
	self:Reincarnate()
	return self.reincarnate_time
	
end

function modifier_shaman_resurrecting_light:Reincarnate()
	if not IsServer() then return end
	self:GetAbility():UseResources(true, false, true)
	self:StartIntervalThink( self.reincarnate_time )
	self:PlayEffects()
end

function modifier_shaman_resurrecting_light:OnIntervalThink()
	if not IsServer() then return end
	

	local allies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.resurrect_radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		0,
		false
	)
	--print(#allies.." allies around")

	for _,ally in pairs(allies) do
		if self:RollChance( self.ally_chance ) and not ally:IsAlive() and ally~=self:GetCaster() then
			ally:SetRespawnPosition(ally:GetOrigin())
		 	ally:RespawnHero(false, false)
		end
	end

	self:StartIntervalThink(-1)

end

function modifier_shaman_resurrecting_light:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

function modifier_shaman_resurrecting_light:PlayEffects()
	-- get resources
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	local sound_cast = "Hero_SkeletonKing.Reincarnate"

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.reincarnate_time, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end