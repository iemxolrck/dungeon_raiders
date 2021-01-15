bard_hypnotize = class({})

LinkLuaModifier( "modifier_bard_hypnotize_slow", "lua_abilities/bard_hypnotize/modifier_bard_hypnotize_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_hypnotize_debuff", "lua_abilities/bard_hypnotize/modifier_bard_hypnotize_debuff", LUA_MODIFIER_MOTION_NONE )

bard_hypnotize.counter = {}
function bard_hypnotize:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = caster:GetOrigin()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local max_targets = self:GetSpecialValueFor("max_targets") + 1
	local duration = self:GetSpecialValueFor("duration")
	local i = 1
	local target = {caster}
	bard_hypnotize.counter = target

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
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)


	-- call
	for _,enemy in pairs(enemies) do
		
		if enemy:HasModifier("modifier_bard_lullaby_lua_debuff")==false
			and enemy:HasModifier("modifier_bard_hypnotize_debuff")==false
			and enemy:HasModifier("modifier_bard_confuse_debuff")==false 
			and enemy:HasModifier("modifier_bard_drowzy_debuff")==false  then
				if i == max_targets then
					print("break")
					break
				else
					enemy:AddNewModifier(
						target[i], -- player source
						self, -- ability source
						"modifier_bard_hypnotize_debuff", -- modifier name
						{ 
							duration = duration,
							target = i,
						} -- kv
					--print(target[i]:GetName())
					)
				end
				i = i + 1
				table.insert( target, enemy )
				bard_hypnotize.counter = target
		end
	end
	
	--[[for i=1, #bard_hypnotize.counter do
		print(bard_hypnotize.counter[i]:GetName())
	end]]

	-- self buff
	--caster:AddNewModifier(
	--	caster, -- player source
	--	self, -- ability source
	--	"modifier_bard_hypnotize_lua", -- modifier name
	--	{ duration = duration } -- kv
	--)

	local sound_cast = "Hero_Enchantress.EnchantCast"
	EmitSoundOn( sound_cast, caster )
	self:PlayEffects()
	--GameRules:SetGameWinner(caster:GetTeam())
end

--------------------------------------------------------------------------------
function bard_hypnotize:PlayEffects()
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
end

--require("lua_abilities/bard_hypnotize/modifier_bard_hypnotize_lua_debuff")