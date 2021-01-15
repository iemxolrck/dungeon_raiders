wizard_frost_prison = class({})

function wizard_frost_prison:IsStealable()
    return true
end

function wizard_frost_prison:IsHiddenWhenStolen()
    return false
end

function wizard_frost_prison:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    local direction = (point - caster:GetAbsOrigin()):Normalized()
    local distance = ( point - caster:GetAbsOrigin()):Length2D()
    local speed = self:GetSpecialValueFor("speed")
    local radius = self:GetSpecialValueFor("radius")
    self.sound_origin = caster:GetAbsOrigin()

    self.damageTable = {
		attacker = caster,
		damage = self:GetSpecialValueFor("damage"),
		damage_type = self:GetAbilityDamageType(),
		inflictor = self
	}

    local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "particles/econ/items/tuskarr/tusk_ti5_immortal/tusk_ice_shards_projectile_stout.vpcf",
	    fDistance = distance,
	    fStartRadius = radius,
	    fEndRadius = radius,
		vVelocity = direction * speed,
	
		bProvidesVision = false,
		iVisionRadius = radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

    EmitSoundOn( "Hero_Tusk.IceShards.Cast", caster )

    self.dummy = CreateUnitByName(
    	"npc_dota_dummy",
    	caster:GetAbsOrigin(),
    	true,
    	caster,
    	caster,
    	caster:GetTeamNumber()
    )

    EmitSoundOn( "Hero_Tusk.IceShards.Projectile", self.dummy )
end

function wizard_frost_prison:OnProjectileThink(vLocation)
    self.dummy:SetAbsOrigin(vLocation)
    --self.sound_origin = vLocation
end

function wizard_frost_prison:OnProjectileHit(hTarget, vLocation)
    local caster = self:GetCaster()
    local hitEnemy = {}

    if hTarget ~= nil and not hTarget:TriggerSpellAbsorb( self ) then
        self.damageTable.victim = hTarget
        ApplyDamage(self.damageTable)
        table.insert(hitEnemy, hTarget)
    else
        local deleteTable = {}
        local direction = (vLocation - caster:GetAbsOrigin()):Length2D()
        local duration = self:GetSpecialValueFor("duration")
        local vision_range = self:GetSpecialValueFor("radius")
        local shard = 7
        local radius = self:GetSpecialValueFor("radius")
        local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_shards.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())

        ParticleManager:SetParticleControl(nfx, 0, Vector(duration, 0, 0))
        
        EmitSoundOnLocationWithCaster(vLocation, "Hero_Tusk.IceShards", caster)

		if self.dummy then
			StopSoundOn("Hero_Tusk.IceShards.Projectile", self.dummy)
			self.dummy:ForceKill(false)
		end

        --Center
        local position = vLocation + direction * radius
        ParticleManager:SetParticleControl(nfx, 1, position)
        local pso = SpawnEntityFromTableSynchronous('point_simple_obstruction', {origin = position})
        table.insert(deleteTable, pso)
        --[[
        local angle = self:GetSpecialValueFor("angle")
        --left
        local left_QAngle = QAngle(0, angle, 0)
        for i=2,4 do
            local left_spawn_point = RotatePosition(vLocation, left_QAngle, position)
            ParticleManager:SetParticleControl(nfx, i, left_spawn_point)
            local pso = SpawnEntityFromTableSynchronous('point_simple_obstruction', {origin = left_spawn_point})
            table.insert(deleteTable, pso)
            left_QAngle = left_QAngle + QAngle(0, angle, 0)
        end
        
        --right           
        local right_QAngle = QAngle(0, -angle, 0)
        for i=5,7 do
            local right_spawn_point = RotatePosition(vLocation, right_QAngle, position)
            ParticleManager:SetParticleControl(nfx, i, right_spawn_point)
            local pso = SpawnEntityFromTableSynchronous('point_simple_obstruction', {origin = right_spawn_point})
            table.insert(deleteTable, pso)
            right_QAngle = right_QAngle + QAngle(0, -angle, 0)
        end
        ]]

        --[[Timers:CreateTimer(self:GetSpecialValueFor("duration"), function()
            for _,entity in pairs(deleteTable) do
                if not entity:IsNull() then UTIL_Remove(entity) end
            end
        end)]]
        local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			vLocation,
			nil,
			self:GetSpecialValueFor("radius"),
			self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			0,
			false
		)
        for _,enemy in pairs(enemies) do
            for _,hTarget in pairs(hitEnemy) do
                if enemy ~= hTarget and not enemy:TriggerSpellAbsorb( self ) then
                    self.damageTable.victim = enemy
        			ApplyDamage(self.damageTable)
                end
            end
        end
    end
end