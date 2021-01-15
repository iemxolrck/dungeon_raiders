paladin_judgment = class({})

--require("lua_abilities/generic/basestat")
LinkLuaModifier( "modifier_paladin_judgment", "lua_abilities/paladin_judgment/modifier_paladin_judgment", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "lua_abilities/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

function paladin_judgment:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function paladin_judgment:GetCastRange(vLocation, vTarget)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return 999999
	else
		return self.BaseClass.GetCastRange(self, Vector(0,0,0), nil)
	end
end

function paladin_judgment:GetCooldown(iLevel)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return 3
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function paladin_judgment:GetManaCost(iCost)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return 0
	else
		return self.BaseClass.GetManaCost(self, iCost)
	end
end

function paladin_judgment:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()
	--FindClearSpaceForUnit( caster, point, false )

	local critrate = 25
	local critdamage = (100+125)/100
	--local restore = self:GetChargeRestoreTime()
	--print(restore)

	local BaseDamage
	local maxdamage
	local mindamage
	local averagedamage

	-- load data
	local damage = (self:GetSpecialValueFor("skill_damage")/100)
	local radius = self:GetSpecialValueFor("radius")

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- Apply Damage	 
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
	}

	for _,enemy in pairs(enemies) do
		averagedamage = caster:GetAverageTrueAttackDamage(caster)
		BaseDamage = caster:GetAttackDamage()
		maxdamage = caster:GetBaseDamageMax()
		mindamage = caster:GetBaseDamageMin()
	
		maxdamage = maxdamage - mindamage
		averagedamage = averagedamage - (maxdamage/2)
		averagedamage = averagedamage - mindamage
		BaseDamage = BaseDamage + averagedamage

		damageTable.damage = damage*BaseDamage
		damageTable.victim = enemy
	
		if caster:HasModifier("modifier_cleric_channel_divinity") then
			
			enemy:AddNewModifier(
				caster,
				self,
				"modifier_generic_stunned_lua",
				{ duration = 0.75 }
			)

			enemy:AddNewModifier(
				caster,
				self,
				"modifier_paladin_judgment",
				{ duration = 6 }
			)

		else
			self:GetCaster():PerformAttack (
			enemy,
			false,
			true,
			true,
			false,
			false,
			true,
			true
			)

			if RandomInt(1,100) >= critrate then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damageTable.damage, nil)
				ApplyDamage(damageTable)
			else
				damageTable.damage = damageTable.damage * critdamage
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL , enemy, damageTable.damage, nil)
				ApplyDamage(damageTable)
			end
		end

		self:PlayEffects2( target, enemy )
	end
	self:PlayEffects()

end

--------------------------------------------------------------------------------
-- Ability Considerations
function paladin_judgment:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end

function paladin_judgment:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--------------------------------------------------------------------------------
function paladin_judgment:PlayEffects1( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	local sound_target = "Hero_Omniknight.Purification"

	-- Create Target Effects
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_target )
	EmitSoundOn( sound_target, target )

	-- Create Caster Effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function paladin_judgment:PlayEffects2( origin, target )
	local particle_target = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf"
	local sound_cast = "Hero_Zuus.GodsWrath.Target"
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_target,
		0,
		origin,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		origin:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_target,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_target )

	EmitSoundOn( sound_cast, target )
end