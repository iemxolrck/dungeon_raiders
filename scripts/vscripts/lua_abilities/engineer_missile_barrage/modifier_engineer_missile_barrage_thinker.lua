modifier_engineer_missile_barrage_thinker = class({})

function modifier_engineer_missile_barrage_thinker:IsHidden()
	return true
end

function modifier_engineer_missile_barrage_thinker:IsDebuff()
	return false
end

function modifier_engineer_missile_barrage_thinker:IsPurgable()
	return false
end

function modifier_engineer_missile_barrage_thinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_engineer_missile_barrage_thinker:OnCreated( kv )
	local caster = self:GetCaster()

	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")	
	self.targets = self:GetAbility():GetSpecialValueFor("targets")
	--self.attach = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack3" ) )

	if caster:HasScepter() then
		self.targets = self:GetAbility():GetSpecialValueFor("targets_scepter")
	end
	local projectile_name = "particles/units/heroes/hero_tinker/tinker_missile.vpcf"
	local projectile_speed = self:GetAbility():GetSpecialValueFor("speed")

	-- find enemies
	if not IsServer() then return end
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		FIND_ANY_ORDER ,	-- int, order filter
		false
	)

	-- create projectile for each enemy
	local info = {
		Source = caster,
		-- Target = target,
		Ability = self:GetAbility(),
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_3,
		extraData = { damage = self.damage }
	}
	for i=1,math.min(self.targets,#enemies) do
		info.Target = enemies[i]
		ProjectileManager:CreateTrackingProjectile( info )
		print("launch")
	end

	-- effects
	if #enemies<1 then
		self:PlayEffects2()
	else
		local sound_cast = "Hero_Tinker.Heat-Seeking_Missile"
		EmitSoundOn( sound_cast, caster )
	end

end

function modifier_engineer_missile_barrage_thinker:OnRefresh( kv )

end

function modifier_engineer_missile_barrage_thinker:OnDestroy( kv )
	
end

function modifier_engineer_missile_barrage_thinker:DeclareFunctions()
	local funcs = {

	}

	return funcs
end

function modifier_engineer_missile_barrage_thinker:PlayEffects2()
	local particle_cast = "particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf"
	local sound_cast = "Hero_Tinker.Heat-Seeking_Missile_Dud"

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.attach )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self:GetCaster():GetForwardVector() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetCaster() )
end