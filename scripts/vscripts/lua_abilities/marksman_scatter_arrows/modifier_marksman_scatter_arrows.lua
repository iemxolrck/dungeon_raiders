modifier_marksman_scatter_arrows = class({})

function modifier_marksman_scatter_arrows:IsHidden()
	return true
end

function modifier_marksman_scatter_arrows:IsDebuff()
	return true
end

function modifier_marksman_scatter_arrows:IsStunDebuff()
	return false
end

function modifier_marksman_scatter_arrows:IsPurgable()
	return false
end

function modifier_marksman_scatter_arrows:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
	self.vision = self:GetAbility():GetSpecialValueFor( "vision_duration" )
end

function modifier_marksman_scatter_arrows:OnRefresh( kv )
	
end

function modifier_marksman_scatter_arrows:OnRemoved()

end

function modifier_marksman_scatter_arrows:OnDestroy()
	if not IsServer() then return end
	AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(),self.radius, self.vision, false )
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetOrigin(),
		nil,
		self.radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false
	)

	for _,enemy in pairs(enemies) do
		self:GetCaster():PerformAttack(
			enemy,
			true,
			true,
			true,
			true,
			false,
			false,
			false
		)
		local sound_cast = "Hero_Windrunner.PowershotDamage"
		EmitSoundOn( sound_cast, enemy )
		print(enemy)
	end
	
	self:PlayEffects()
end

function modifier_marksman_scatter_arrows:PlayEffects()
	local arrows = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl(arrows, 0, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl(arrows, 1, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl(arrows, 3, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl(arrows, 4, Vector(self.radius,0,0) )
	ParticleManager:SetParticleControl(arrows, 5, Vector(self.radius,0,0) )
	ParticleManager:SetParticleControl(arrows, 6, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl(arrows, 7, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl(arrows, 8, self:GetParent():GetOrigin())
	ParticleManager:ReleaseParticleIndex(arrows)

	local sound_cast = "Hero_Windrunner.PowershotDamage"
	EmitSoundOn( sound_cast, self:GetCaster() )
end