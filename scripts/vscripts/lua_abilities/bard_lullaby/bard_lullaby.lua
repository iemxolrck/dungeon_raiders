bard_lullaby = class({})

LinkLuaModifier( "modifier_bard_lullaby_lua_debuff", "lua_abilities/bard_lullaby/modifier_bard_lullaby_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_drowzy_debuff", "lua_abilities/bard_lullaby/modifier_bard_drowzy_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function bard_lullaby:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = caster:GetOrigin()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local max_target = self:GetSpecialValueFor("max_target")

	if caster:HasModifier("modifier_bard_discord") == true then
		self:GetCaster():FindAbilityByName("bard_discord_cancel"):OnSpellStart()
	end
	if caster:HasModifier("modifier_bard_symphony") == true then
		self:GetCaster():FindAbilityByName("bard_symphony_cancel"):OnSpellStart()
	end

	-- find units caught
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- call
	for _,enemy in pairs(enemies) do
		if max_target==0 then
			break
		end
		if enemy:HasModifier("modifier_bard_lullaby_lua_debuff")==false
			and enemy:HasModifier("modifier_bard_hypnotize_debuff")==false
			and enemy:HasModifier("modifier_bard_confuse_debuff")==false 
			and enemy:HasModifier("modifier_bard_drowzy_debuff")==false  then
				enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_bard_lullaby_lua_debuff", -- modifier name
					{ duration = duration } -- kv
				)
				max_target = max_target-1
		end
	end
	
	self:PlayEffects()
end

--------------------------------------------------------------------------------
function bard_lullaby:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "DOTA_Item.FaerieSpark.Activate", self:GetCaster() )
end