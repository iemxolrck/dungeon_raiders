cleric_turn_undead = class({})

LinkLuaModifier( "modifier_cleric_turn_undead_proc", "lua_abilities/cleric_turn_undead/modifier_cleric_turn_undead_proc", LUA_MODIFIER_MOTION_NONE )

function cleric_turn_undead:GetIntrinsicModifierName()
	return "modifier_cleric_turn_undead_proc"
end

function cleric_turn_undead:GetCooldown(iLevel)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return self:GetSpecialValueFor("cooldown")
	else
		return self.BaseClass.GetCooldown(self, iLevel)
	end
end

function cleric_turn_undead:GetManaCost(iCost)
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_cleric_channel_divinity") then
		return 0
	else
		return self.BaseClass.GetManaCost(self, iCost)
	end
end

function cleric_turn_undead:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	local cast = 0
	if caster:HasModifier("modifier_cleric_channel_divinity")==true then
		cast = 1
	end
		
	-- unit target just indicates point
	if target then point = target:GetOrigin() end

	local sound_cast = "Hero_DragonKnight.BreathFire"
	
	local projectile_name = "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "range" )
	local projectile_start_radius = self:GetSpecialValueFor( "start_radius" )
	local projectile_end_radius = self:GetSpecialValueFor( "end_radius" )
	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local projectile_direction = point - caster:GetOrigin()
	local origin = caster:GetAbsOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = origin,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetType = self:GetAbilityTargetType(),

	    bProvidesVision = true,
	    iVisionRadius = 300,
	    iVisionTeamNumber = caster:GetTeamNumber(),
	    --fExpireTime = 20,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}

	ProjectileManager:CreateLinearProjectile(info)

	local info1 = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin() + caster:GetRightVector():Normalized() * 350,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetType = self:GetAbilityTargetType(),

	    bProvidesVision = true,
	    iVisionRadius = 300,
	    iVisionTeamNumber = caster:GetTeamNumber(),
	    --fExpireTime = 20,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}
	if cast==0 then
		ProjectileManager:CreateLinearProjectile(info1)
	end

	local info2 = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin() + caster:GetRightVector():Normalized() * -350,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetType = self:GetAbilityTargetType(),

	    bProvidesVision = true,
	    iVisionRadius = 300,
	    iVisionTeamNumber = caster:GetTeamNumber(),
	    --fExpireTime = 20,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}

	

	if cast==0 then
		ProjectileManager:CreateLinearProjectile(info2)
		EmitSoundOn( sound_cast, caster )
		self:PlayEffects()
	end

end



function cleric_turn_undead:OnProjectileHitHandle( target, location, iHandle )
	if not IsServer() then return end
	if not target then return end

	-- load data
	local damage = self:GetAbilityDamage()
	local duration = self:GetSpecialValueFor( "duration" )

	local filter = UnitFilter(
		target,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		self:GetCaster():GetTeamNumber()
	)
	if filter~=UF_SUCCESS then
		-- nothing happened
		return false
	end

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	target:Purge(true, false, false, false, false)
	--ApplyDamage(damageTable)
	self:DamageCalculation(target, damageTable)
	-- debuff
	--target:AddNewModifier(
--		self:GetCaster(), -- player source
	--	self, -- ability source
	--	"modifier_cleric_turn_undead", -- modifier name
	--	{ duration = duration } -- kv
	--)
end

function cleric_turn_undead:DamageCalculation(target, damageTable)
    local caster = self:GetCaster()
    local damage = (self:GetSpecialValueFor("skill_damage")/100) or 0
    local bonus_damage = 1 + (self:GetSpecialValueFor( "damage_increase" )/100)
    local critrate = 25
    local critdamage = (100+125)/100

    local BaseDamage
    local maxdamage
    local mindamage
    local averagedamage

    averagedamage = caster:GetAverageTrueAttackDamage(caster)
    BaseDamage = caster:GetAttackDamage()
    maxdamage = caster:GetBaseDamageMax()
    mindamage = caster:GetBaseDamageMin()

    maxdamage = maxdamage - mindamage
    averagedamage = averagedamage - (maxdamage/2)
    averagedamage = averagedamage - mindamage
    BaseDamage = BaseDamage + averagedamage

    damageTable.damage = damage*BaseDamage
    ApplyDamage( damageTable )

    if target:HasModifier("demon_type")
    	or target:HasModifier("ghost_type")
    	or target:HasModifier("undead_type") then
    		damageTable.damage = damageTable.damage * bonus_damage
    end

    caster:PerformAttack (
            target,
            false,
            true,
            true,
            false,
            false,
            true,
            true
            )
   
    if RandomInt(1,100) >= critrate then
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damageTable.damage, nil)
        ApplyDamage( damageTable )
    else
        damageTable.damage = damageTable.damage * critdamage
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL , target, damageTable.damage, nil)
        ApplyDamage( damageTable )
    end
end

function cleric_turn_undead:PlayEffects()
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