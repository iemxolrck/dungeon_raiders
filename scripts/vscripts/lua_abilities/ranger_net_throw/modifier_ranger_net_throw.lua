modifier_ranger_net_throw = class({})

function modifier_ranger_net_throw:IsHidden()
	return false
end

function modifier_ranger_net_throw:IsDebuff()
	return true
end

function modifier_ranger_net_throw:IsStunDebuff()
	return false
end

function modifier_ranger_net_throw:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ranger_net_throw:OnCreated( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed_pct" )
	self.movement = self:GetParent():HasFlyMovementCapability()
	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )

	if not IsServer() then return end

	local interval = 1

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	if IsServer() then
		if self.movement==true then
			self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		end
	end

end

function modifier_ranger_net_throw:OnRefresh( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed_pct" )
	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	
	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = damage
end

function modifier_ranger_net_throw:OnRemoved()
	if not IsServer() then return end
	if self.movement==true then
		self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	end
end

function modifier_ranger_net_throw:OnDestroy()
	if not IsServer() then return end
	if self.movement==true then
		self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ranger_net_throw:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_ranger_net_throw:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ranger_net_throw:OnIntervalThink()
	--ApplyDamage( self.damageTable )
end

function modifier_ranger_net_throw.CheckState(self)
    local funcs = {
    	[MODIFIER_STATE_INVISIBLE] = false,
    	[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED ] = true,
		[MODIFIER_STATE_FLYING] = false,
	}
    return funcs
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ranger_net_throw:GetEffectName()
	return "particles/units/heroes/hero_meepo/meepo_earthbind.vpcf"
end

function modifier_ranger_net_throw:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end