modifier_shaman_protection_from_death = class({})

function modifier_shaman_protection_from_death:IsHidden()
	return false
end

function modifier_shaman_protection_from_death:IsDebuff()
	return false
end

function modifier_shaman_protection_from_death:IsPurgable()
	return false
end

function modifier_shaman_protection_from_death:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

end

function modifier_shaman_protection_from_death:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_shaman_protection_from_death:OnIntervalThink()
	if not IsServer() then return end
	if self:GetAbility():IsCooldownReady()==false then return end 
	local allies = FindUnitsInRadius(
		self:GetParent():GetTeam(),
		self:GetParent():GetAbsOrigin(),
		nil, 
		self.radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false
	)

	for _, ally in pairs(allies) do
		if ally==nil then break end
		local health = ally:GetHealth()
		if health~=1 then return end
		ally:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_shaman_protection_from_death_buff",
			{ duration = self.duration }
		)
		self:GetAbility():UseResources(true, true, true)
		break
	end

end

function modifier_shaman_protection_from_death:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
	}

	return funcs
end

function modifier_shaman_protection_from_death:OnTakeDamageKillCredit(params)
	if not IsServer() then return end
	if self:GetAbility():IsCooldownReady()==false then return end
	print("Off Cooldown")
	if params.target==self:GetParent() then return end
	if params.target:HasModifier("modifier_shaman_protection_from_death_buff")==true then return end
	if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then return end
	if not params.target:IsRealHero() then return end
	print("Valid Target")
	local distance = math.floor( (self:GetParent():GetOrigin()-params.target:GetOrigin()):Length2D() )
	print("Distance: "..distance)
	if distance>self.radius then return end
	print("Near Enough")
	
	if params.damage<params.target:GetHealth() then return end
	print("Target low health")
	params.target:AddNewModifier(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_shaman_protection_from_death_buff",
		{ duration = self.duration }
	)
	self:GetAbility():UseResources(true, true, true)
	print("Done!")
	return
end