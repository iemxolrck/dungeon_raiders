cleric_divine_protection = class({})

LinkLuaModifier( "modifier_cleric_divine_protection_min_health", "lua_abilities/cleric_divine_protection/modifier_cleric_divine_protection_min_health", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cleric_divine_protection_invincible", "lua_abilities/cleric_divine_protection/modifier_cleric_divine_protection_invincible", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cleric_divine_protection_regen", "lua_abilities/cleric_divine_protection/modifier_cleric_divine_protection_regen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cleric_divine_protection_resist", "lua_abilities/cleric_divine_protection/modifier_cleric_divine_protection_resist", LUA_MODIFIER_MOTION_NONE )

function cleric_divine_protection:GetCooldown(iLevel)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return self:GetSpecialValueFor("cooldown")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function cleric_divine_protection:GetManaCost(iCost)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return 0
	else
		return self.BaseClass.GetManaCost(self, iCost)
	end
end

function cleric_divine_protection:OnSpellStart()

    local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")
    local protection = "modifier_cleric_divine_protection_min_health"

    if caster:HasModifier("modifier_cleric_channel_divinity") then
    	protection = "modifier_cleric_divine_protection_resist"
    	duration = 10
    end

    local allies = FindUnitsInRadius(
		self:GetCaster():GetTeam(),
		self:GetCaster():GetAbsOrigin(),
		nil, 
		radius,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false
		)

	for _, ally in pairs(allies) do
		ally:AddNewModifier(
	        caster,   
	        self,
	        protection, 
	        { duration = duration }
	    )
	    self:PlayEffects(ally)
	end
	
	local sound_cast = "Hero_Chen.HolyPersuasionEnemy"
	EmitSoundOn( sound_cast, self:GetCaster() )
	sound_cast = "Hero_Omniknight.Repel"
	EmitSoundOn( sound_cast, self:GetCaster() )
	
end

function cleric_divine_protection:PlayEffects( target )
	local particle_target = "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf"
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_target,
		0,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_target,
		1,
		self:GetCaster(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetAbsOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_target )

end