modifier_warlock_soulbind = class({})

function modifier_warlock_soulbind:IsHidden()
	return true
end

function modifier_warlock_soulbind:IsDebuff()
	return false
end

function modifier_warlock_soulbind:IsStunDebuff()
	return false
end

function modifier_warlock_soulbind:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_warlock_soulbind:OnCreated( kv )
	self.angle = 180
end

function modifier_warlock_soulbind:OnRefresh( kv )
	
end

function modifier_warlock_soulbind:OnRemoved()
	
end

function modifier_warlock_soulbind:OnDestroy( kv )
	
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_warlock_soulbind:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK
	}

	return funcs
end
function modifier_warlock_soulbind:OnAttack( params )
	if not IsServer() then return end
	if params.attacker~=self:GetCaster() then return end
	if self.split_shot then return end
	self:SplitShot( params.target )
end

function modifier_warlock_soulbind:SplitShot( target )
	if not IsServer() then return end

	local radius = self:GetCaster():Script_GetAttackRange()
	local front = VectorToAngles( (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized() ).y

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		radius,
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST,
		false
	)

	for _,enemy in pairs(enemies) do
		if enemy~=target and enemy:HasModifier( "modifier_warlock_soulbind_target" )==true then
			local enemy_direction = (enemy:GetOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
			local enemy_angle = VectorToAngles( enemy_direction ).y
			local angle_diff = math.abs( AngleDiff( front, enemy_angle ) )
			if angle_diff<=self.angle then
				self.split_shot = true
				self:GetCaster():PerformAttack(
					enemy,
					true,
					true,
					true,
					true,
					true,
					false,
					false
				)
				self.split_shot = false
			end

		end
	end
end