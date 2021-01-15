modifier_ranger_smokescreen_buff = class({})

function modifier_ranger_smokescreen_buff:IsHidden()
	return false
end

function modifier_ranger_smokescreen_buff:IsDebuff()
	return false
end

function modifier_ranger_smokescreen_buff:IsStunDebuff()
	return false
end

function modifier_ranger_smokescreen_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ranger_smokescreen_buff:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )

	self.thinker = kv.isProvidedByAura~=1

	self.invis = 1
	self.isInvis = true

	if self:GetParent():HasModifier("modifier_out_of_combat_buff_timer") then
		self:GetParent():FindModifierByName("modifier_out_of_combat_buff_timer"):Destroy()
	end
	if not IsServer() then return end
	if not self.thinker then return end

	self:PlayEffects()
end

function modifier_ranger_smokescreen_buff:OnRefresh( kv )
	self.invis = 1
	self.isInvis = true
end

function modifier_ranger_smokescreen_buff:OnRemoved()

end

function modifier_ranger_smokescreen_buff:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end

function modifier_ranger_smokescreen_buff:OnIntervalThink()
	if IsServer() then
		self.invis = 1
		self.isInvis = true
		self:StartIntervalThink(-1)
	end
end

function modifier_ranger_smokescreen_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function modifier_ranger_smokescreen_buff:GetModifierInvisibilityLevel()
	return self.invis
end

function modifier_ranger_smokescreen_buff:OnAttackStart( params )
	if IsServer() then
		if params.attacker~=self:GetParent() then return end
		local parent = params.target
		local attacker = params.attacker
		self.invis = -1
		self.isInvis = false
		self:StartIntervalThink(1)
		return 
	end
end

function modifier_ranger_smokescreen_buff:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit~=self:GetParent() then return end
		if params.ability==self:GetAbility() then 
			if self:GetParent():HasModifier("modifier_out_of_combat_buff_timer") then
				self:GetParent():FindModifierByName("modifier_out_of_combat_buff_timer"):Destroy()
			end
		end
		self.invis = -1
		self.isInvis = false
		self:StartIntervalThink(1)
		return 
	end
end

function modifier_ranger_smokescreen_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		--[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}

	return state
end


function modifier_ranger_smokescreen_buff:IsAura()
	return self.thinker
end

function modifier_ranger_smokescreen_buff:GetModifierAura()
	return "modifier_ranger_smokescreen_buff"
end

function modifier_ranger_smokescreen_buff:GetAuraRadius()
	return self.radius
end

function modifier_ranger_smokescreen_buff:GetAuraDuration()
	return 1
end

function modifier_ranger_smokescreen_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_ranger_smokescreen_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ranger_smokescreen_buff:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ranger_smokescreen_buff:GetEffectName()
	return "particles/items2_fx/smoke_of_deceit_buff.vpcf"
end

function modifier_ranger_smokescreen_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ranger_smokescreen_buff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/items2_fx/smoke_of_deceit.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 500, 250, 250 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end