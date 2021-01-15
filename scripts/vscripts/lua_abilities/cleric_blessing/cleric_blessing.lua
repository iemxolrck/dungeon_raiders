cleric_blessing = class({})

LinkLuaModifier( "modifier_cleric_blessing", "lua_abilities/cleric_blessing/modifier_cleric_blessing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cleric_blessing_damage", "lua_abilities/cleric_blessing/modifier_cleric_blessing_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cleric_blessing_str", "lua_abilities/cleric_blessing/modifier_cleric_blessing_str", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cleric_blessing_agi", "lua_abilities/cleric_blessing/modifier_cleric_blessing_agi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cleric_blessing_int", "lua_abilities/cleric_blessing/modifier_cleric_blessing_int", LUA_MODIFIER_MOTION_NONE )

function cleric_blessing:GetCooldown(iLevel)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return self:GetSpecialValueFor("cooldown")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function cleric_blessing:GetManaCost(iCost)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return 0
	else
		return self.BaseClass.GetManaCost(self, iCost)
	end
end

function cleric_blessing:OnSpellStart()

    local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")
    local blessing = "modifier_cleric_blessing"
    local count = 0

    if caster:HasModifier("modifier_cleric_channel_divinity") then
    	blessing = "modifier_cleric_blessing_damage"
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

		ally:Purge(false, true, false, false, false)

		ally:AddNewModifier(
	        caster,   
	        self,
	        blessing, 
	        { duration = duration }
	    )

	    self:PlayEffects(ally)

	end
end

function cleric_blessing:PlayEffects(target)
	local sound_cast = "Hero_Omniknight.GuardianAngel"
	EmitSoundOn( sound_cast, self:GetCaster() )

	local particle_target = "particles/econ/events/league_teleport_2014/teleport_start_league_gold.vpcf"
	
	particle_target = "particles/econ/events/ti5/teleport_start_i_ti5.vpcf"
	effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_target,
		0,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	
	ParticleManager:ReleaseParticleIndex( effect_target )end
