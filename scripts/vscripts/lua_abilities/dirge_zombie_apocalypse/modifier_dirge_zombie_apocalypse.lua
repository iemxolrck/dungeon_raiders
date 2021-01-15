modifier_dirge_zombie_apocalypse = class({})

function modifier_dirge_zombie_apocalypse:IsHidden()
	return true
end

function modifier_dirge_zombie_apocalypse:OnCreated( kv )
	self.spawn_interval = self:GetAbility():GetSpecialValueFor( "spawn_interval" )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self:StartIntervalThink( self.spawn_interval )
end

function modifier_dirge_zombie_apocalypse:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
end

function modifier_dirge_zombie_apocalypse:OnDestroy( kv )

end

function modifier_dirge_zombie_apocalypse:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetParent():IsAlive() then return end
	if self:GetParent():PassivesDisabled() then return end

	local targets = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self.radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		0,
		false
	)

	for _,target in pairs(targets) do
		if self:RollChance( self.proc_chance ) then
			local summon_zombie = CreateUnitByName( "npc_dota_greater_zombie", target:GetOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber() )
			summon_zombie:SetOwner( self:GetCaster() )

			summon_zombie:SetForceAttackTarget( target )
			summon_zombie:MoveToTargetToAttack( target )
			summon_zombie:AddNewModifier(
				self:GetCaster(),
				self:GetAbility(),
				"modifier_summon_zombie",
				{ duration = self.duration }
			)
		else
			local summon_zombie = CreateUnitByName( "npc_dota_lesser_zombie", target:GetOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber() )
			summon_zombie:SetOwner( self:GetCaster() )

			summon_zombie:SetForceAttackTarget( target )
			summon_zombie:MoveToTargetToAttack( target )
			summon_zombie:AddNewModifier(
				self:GetCaster(),
				self:GetAbility(),
				"modifier_summon_zombie",
				{ duration = self.duration }
			)
		end
	end

end

function modifier_dirge_zombie_apocalypse:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

function modifier_dirge_zombie_apocalypse:PlayEffects()
	
end