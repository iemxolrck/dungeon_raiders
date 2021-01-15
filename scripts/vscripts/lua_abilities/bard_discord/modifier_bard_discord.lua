modifier_bard_discord = class({})

function modifier_bard_discord:IsHidden()
    return false
end

function modifier_bard_discord:IsDebuff()
    return false
end

function modifier_bard_discord:IsPurgable()
    return false
end

function modifier_bard_discord:OnCreated( kv )
	self.count = 0
	self.active_movespeed = self:GetAbility():GetSpecialValueFor( "active_movespeed" )
	self:StartIntervalThink(0.01)
end

function modifier_bard_discord:OnRefresh( kv )
	self.active_movespeed = self:GetAbility():GetSpecialValueFor( "active_movespeed" )
end

function modifier_bard_discord:OnDestroy( kv )
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_bard_discord_flute_aura") == true then
			self:GetCaster():FindModifierByName("modifier_bard_discord_flute_aura"):Destroy()
		end
		if self:GetCaster():HasModifier("modifier_bard_discord_guitar_aura") == true then
			self:GetCaster():FindModifierByName("modifier_bard_discord_guitar_aura"):Destroy()
		end
		if self:GetCaster():HasModifier("modifier_bard_discord_lyre_aura") == true then
			self:GetCaster():FindModifierByName("modifier_bard_discord_lyre_aura"):Destroy()
		end
	end
end

function modifier_bard_discord:OnIntervalThink()
	if IsServer() then
		local modifier = ""
		if self:GetCaster():HasModifier("modifier_bard_flute") == true then
			modifier = "modifier_bard_discord_flute_aura"
			if self.count~=0 and self:GetCaster():IsAlive()==true then
				--self:GetCaster():FindModifierByName("modifier_bard_discord_guitar_aura"):Destroy()
				self:GetCaster():FindModifierByName("modifier_bard_discord_lyre_aura"):Destroy()
			end
		end
		if self:GetCaster():HasModifier("modifier_bard_guitar") == true then
			modifier = "modifier_bard_discord_guitar_aura"
			if self.count~=0 and self:GetCaster():IsAlive()==true then
				--self:GetCaster():FindModifierByName("modifier_bard_discord_lyre_aura"):Destroy()
				self:GetCaster():FindModifierByName("modifier_bard_discord_flute_aura"):Destroy()
			end
			
		end
		if self:GetCaster():HasModifier("modifier_bard_lyre") == true then
			modifier = "modifier_bard_discord_lyre_aura"
			if self.count~=0 and self:GetCaster():IsAlive()==true then
				--self:GetCaster():FindModifierByName("modifier_bard_discord_flute_aura"):Destroy()
				self:GetCaster():FindModifierByName("modifier_bard_discord_guitar_aura"):Destroy()
			end
			
		end

		self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			modifier,
			nil
		)
		self.count = 1
		self:StartIntervalThink(-1)
	end
end

function modifier_bard_discord:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		--MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}

	return funcs
end

function modifier_bard_discord:GetModifierMoveSpeed_Absolute()
	if self:GetParent():HasModifier("modifier_bard_tuning")==true then
		local ability = ''
		local movespeed = 0
		if self:GetCaster():HasAbility("bard_tuning")==true then
			local ability = self:GetCaster():FindAbilityByName( "bard_tuning" ):GetLevel()
			if ability==1 then
				return 200
			end
			if ability==2 then
				return 250
			end
			if ability==3 then
				return 300
			end
		end
	else
		return self.active_movespeed
	end
end

function modifier_bard_discord:OnDeath( event )
	if event.unit == self:GetCaster() then
		self:GetCaster():FindAbilityByName("bard_discord_cancel"):OnSpellStart()
	end
end

function modifier_bard_discord:OnAbilityFullyCast( event )
	if IsServer() then
		if (event.ability:GetName() == "bard_flute"
		 	or event.ability:GetName() == "bard_guitar"
		 	or event.ability:GetName() == "bard_lyre")
		 	and event.unit == self:GetCaster() then
				self:StartIntervalThink(0.01)
	    end
	end
end

function modifier_bard_discord:GetOverrideAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function modifier_bard_discord:GetOverrideAnimationRate()
	return 10
end

function modifier_bard_discord:CheckState()
    local state = {
        [ MODIFIER_STATE_DISARMED ] = true
    }

    return state
end