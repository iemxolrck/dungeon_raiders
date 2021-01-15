modifier_generic_burned = class({})

function modifier_generic_burned:IsHidden()
	return false
end

function modifier_generic_burned:IsDebuff()
	return true
end

function modifier_generic_burned:IsStunDebuff()
	return false
end

function modifier_generic_burned:IsPurgable()
	return true
end

function modifier_generic_burned:GetTexture()
	return "status/modifier_generic_burned"
end

function modifier_generic_burned:OnCreated( kv )
	-- references
	self.slow = 20
	local damage = 100

	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_generic_chilled")==true then
		local modifier = self:GetParent():FindModifierByName("modifier_generic_chilled")
		if modifier~=nil then modifier:Destroy() end
	end
	if self:GetParent():HasModifier("modifier_generic_frozen")==true then
		local modifier = self:GetParent():FindModifierByName("modifier_generic_frozen")
		if modifier~=nil then modifier:Destroy() end
	end

	local interval = 1

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )
end

function modifier_generic_burned:OnRefresh( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed_pct" )
	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_generic_chilled")==true then
		local modifier = self:GetParent():FindModifierByName("modifier_generic_chilled")
		if modifier~=nil then modifier:Destroy() end
	end
	if self:GetParent():HasModifier("modifier_generic_frozen")==true then
		local modifier = self:GetParent():FindModifierByName("modifier_generic_frozen")
		if modifier~=nil then modifier:Destroy() end
	end
	-- update damage
	self.damageTable.damage = damage
end

function modifier_generic_burned:OnRemoved()
end

function modifier_generic_burned:OnDestroy()
end

function modifier_generic_burned:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_generic_burned:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_generic_burned:OnIntervalThink()
	-- apply damage
	ApplyDamage( self.damageTable )

	-- play effects
	local sound_cast = "Hero_OgreMagi.Ignite.Damage"
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_generic_burned:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf"
end

function modifier_generic_burned:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end