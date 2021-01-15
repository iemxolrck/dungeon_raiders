modifier_warrior_double_slash_damage = class({})

function modifier_warrior_double_slash_damage:IsHidden()
	return true
end

function modifier_warrior_double_slash_damage:IsDebuff()
	return false
end

function modifier_warrior_double_slash_damage:IsPurgable()
	return false
end

function modifier_warrior_double_slash_damage:OnCreated( kv )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "angle" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_vs_heroes" )
	self.bonus_crit = self:GetAbility():GetSpecialValueFor( "crit_mult" ) + self:GetParent():GetPhysicalArmorValue( false )
end

function modifier_warrior_double_slash_damage:OnRefresh( kv )
end

function modifier_warrior_double_slash_damage:OnRemoved()
end

function modifier_warrior_double_slash_damage:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_warrior_double_slash_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}

	return funcs
end

function modifier_warrior_double_slash_damage:GetModifierPhysical_ConstantBlock( params )
	if IsServer() then
		local parent = params.target
		local attacker = params.attacker
		local reduction = 0

		-- Check target position
		local facing_direction = parent:GetAnglesAsVector().y
		local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
		local attacker_direction = VectorToAngles( attacker_vector ).y
		local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )

		-- calculate damage reduction
		if angle_diff < self.angle_front then
			reduction = 100
		end

		return reduction * params.damage / 100
	end
end

function modifier_warrior_double_slash_damage:GetModifierPreAttack_BonusDamagePostCrit( params )
	if not IsServer() then return end
	return self.bonus_damage + self:GetParent():GetPhysicalArmorValue( false )
	
end
function modifier_warrior_double_slash_damage:GetModifierPreAttack_CriticalStrike( params )
	if self:GetParent():HasModifier("modifier_warrior_counter_stance_animation")==false then
		return self.bonus_crit
	else
		return self.bonus_crit/2
	end
end

function modifier_warrior_double_slash_damage:GetOverrideAnimation()
	return ACT_DOTA_ATTACK
end

function modifier_warrior_double_slash_damage:GetOverrideAnimationRate()
	return 2
end