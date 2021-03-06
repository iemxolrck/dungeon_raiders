modifier_bard_symphony = class({})

function modifier_bard_symphony:IsHidden()
    return false
end

function modifier_bard_symphony:IsDebuff()
    return false
end

function modifier_bard_symphony:IsPurgable()
    return false
end

function modifier_bard_symphony:OnCreated( kv )
	self.count = 0
	self.active_movespeed = self:GetAbility():GetSpecialValueFor( "active_movespeed" )
	self.modifier = ""
	self.store = ""
	self:SymphonyStart()
end

function modifier_bard_symphony:OnRefresh( kv )
	self.active_movespeed = self:GetAbility():GetSpecialValueFor( "active_movespeed" )
end

function modifier_bard_symphony:OnDestroy( kv )
	if self:GetCaster():HasModifier("modifier_bard_symphony_flute_aura") == true then
		self:GetCaster():FindModifierByName("modifier_bard_symphony_flute_aura"):Destroy()
	end
	if self:GetCaster():HasModifier("modifier_bard_symphony_guitar_aura") == true then
		self:GetCaster():FindModifierByName("modifier_bard_symphony_guitar_aura"):Destroy()
	end
	if self:GetCaster():HasModifier("modifier_bard_symphony_lyre_aura") == true then
		self:GetCaster():FindModifierByName("modifier_bard_symphony_lyre_aura"):Destroy()
	end
end

function modifier_bard_symphony:SymphonyStart()
	local modifier = ""
	if self:GetCaster():HasModifier("modifier_bard_flute") == true then
		modifier = "modifier_bard_symphony_flute_aura"
		if self.count~=0 then
			--self:GetCaster():FindModifierByName("modifier_bard_symphony_guitar_aura"):Destroy()
			self:GetCaster():FindModifierByName("modifier_bard_symphony_lyre_aura"):Destroy()
		end
	end
	if self:GetCaster():HasModifier("modifier_bard_guitar") == true then
		modifier = "modifier_bard_symphony_guitar_aura"
		if self.count~=0 then
			--self:GetCaster():FindModifierByName("modifier_bard_symphony_lyre_aura"):Destroy()
			self:GetCaster():FindModifierByName("modifier_bard_symphony_flute_aura"):Destroy()
		end
		
	end
	if self:GetCaster():HasModifier("modifier_bard_lyre") == true then
		modifier = "modifier_bard_symphony_lyre_aura"
		if self.count~=0 then
			--self:GetCaster():FindModifierByName("modifier_bard_symphony_flute_aura"):Destroy()
			self:GetCaster():FindModifierByName("modifier_bard_symphony_guitar_aura"):Destroy()
		end
		
	end
	print(modifier)
	self:GetParent():AddNewModifier(
		self:GetParent(),
		self:GetAbility(),
		modifier,
		nil
	)
	self.count = 1
end

function modifier_bard_symphony:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		--MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE 
	}

	return funcs
end

function modifier_bard_symphony:GetModifierMoveSpeed_Absolute()
	return self.active_movespeed
end

function modifier_bard_symphony:OnDeath( event )
	if event.unit == self:GetCaster() then
		self:GetCaster():FindAbilityByName("bard_symphony_cancel"):OnSpellStart()
	end
end

function modifier_bard_symphony:OnAbilityFullyCast( event )
	if (event.ability:GetName() == "bard_flute"
	 	or event.ability:GetName() == "bard_guitar"
	 	or event.ability:GetName() == "bard_lyre")
	 	and event.unit == self:GetCaster() then
			self:SymphonyStart()
    end
end

function modifier_bard_symphony:GetOverrideAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function modifier_bard_symphony:GetOverrideAnimationRate()
	return 10
end

function modifier_bard_symphony:CheckState()
    local state = {
        [ MODIFIER_STATE_DISARMED ] = true
    }

    return state
end