modifier_ranger_burrow_trap_damage = class({})

function modifier_ranger_burrow_trap_damage:IsHidden()
	return false
end

function modifier_ranger_burrow_trap_damage:IsDebuff()
	return false
end

function modifier_ranger_burrow_trap_damage:IsStunDebuff()
	return false
end

function modifier_ranger_burrow_trap_damage:IsPurgable()
	return false
end

function modifier_ranger_burrow_trap_damage:OnCreated( kv )
	
	self.radius = self:GetAbility():GetSpecialValueFor( "detonate_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "explode_damage" )
	self.area = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
	

	if IsServer() then
		self.damageTable = {
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self,
		}
		self:StartIntervalThink(0)
	end

	self:PlayEffects()
end

function modifier_ranger_burrow_trap_damage:OnRefresh( kv )

end

function modifier_ranger_burrow_trap_damage:OnRemoved()

end

function modifier_ranger_burrow_trap_damage:OnDestroy()
	if IsServer() then
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self.area,
			self:GetAbility():GetAbilityTargetTeam(),
			self:GetAbility():GetAbilityTargetType(),
			self:GetAbility():GetAbilityTargetFlags(),
			0,
			false
		)
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(
				self:GetCaster(),
				self:GetAbility(),
				"modifier_ranger_burrow_trap_slow",
				{ duration = self.slow_duration }
			)
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )

		end
		self:GetParent():ForceKill( false )
	end
end

function modifier_ranger_burrow_trap_damage:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),
			self:GetParent():GetOrigin(),
			nil,
			self.radius,
			self:GetAbility():GetAbilityTargetTeam(),
			self:GetAbility():GetAbilityTargetType(),
			self:GetAbility():GetAbilityTargetFlags(),
			0,
			false
		)
		if #enemies > 0 then
			self:Destroy()
			self:StartIntervalThink( -1 )
		end
	end
end

function modifier_ranger_burrow_trap_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_EVENT_ON_ATTACK_ALLIED,
	}

	return funcs
end

function modifier_ranger_burrow_trap_damage:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_ranger_burrow_trap_damage:OnAttackAllied( params )
	if IsServer() then
		if params.target~=self:GetParent() then return end
		local target = params.target
		local ally = params.attacker
		print(target:GetUnitName())
		print(ally:GetUnitName())
		
		--if params.attacker~=self:GetCaster() then return end
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		ally:MoveToPosition( target:GetOrigin() )
		
	end
end

function modifier_ranger_burrow_trap_damage:CheckState()
	local state = {
		--[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

function modifier_ranger_burrow_trap_damage:GetEffectName()
	return "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_inground.vpcf"
end

function modifier_ranger_burrow_trap_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ranger_burrow_trap_damage:PlayEffects()

end