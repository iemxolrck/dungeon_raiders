marksman_multishot = class({})

function marksman_multishot:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()
	local angle = 33.33

	if not caster:HasAbility( "marksman_multishot_first_arrow" ) then
		local ability = caster:AddAbility("marksman_multishot_first_arrow")
		ability:SetLevel( self:GetLevel() )
	end
	if not caster:HasAbility( "marksman_multishot_second_arrow" ) then
		local ability = caster:AddAbility("marksman_multishot_second_arrow")
		ability:SetLevel( self:GetLevel() )
	end
	if not caster:HasAbility( "marksman_multishot_forth_arrow" ) then
		local ability = caster:AddAbility("marksman_multishot_forth_arrow")
		ability:SetLevel( self:GetLevel() )
	end
	if not caster:HasAbility( "marksman_multishot_fifth_arrow" ) then
		local ability = caster:AddAbility("marksman_multishot_fifth_arrow")
		ability:SetLevel( self:GetLevel() )
	end

	local direction = point-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	self.count = 0

	-- load data
	local projectile_name = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
	local projectile_speed = self:GetSpecialValueFor("arrow_speed")
	local projectile_distance = self:GetCastRange( Vector(0,0,0), nil ) + self:GetCaster():GetCastRangeBonus()
	local projectile_start_radius = self:GetSpecialValueFor("arrow_width")
	local projectile_end_radius = self:GetSpecialValueFor("arrow_width")
	local projectile_vision = self:GetSpecialValueFor("arrow_vision")

	local min_damage = self:GetAbilityDamage()
	local bonus_damage = self:GetSpecialValueFor( "arrow_bonus_damage" )
	local min_stun = self:GetSpecialValueFor( "arrow_min_stun" )
	local max_stun = self:GetSpecialValueFor( "arrow_max_stun" )
	local max_distance = self:GetSpecialValueFor( "arrow_max_stunrange" )

	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()

	local bonus_speed = 0
	local ability = self:GetCaster():FindAbilityByName( "marksman_piercing" )
	if ability and ability:GetLevel()>0 then
		bonus_speed = ability:GetLevelSpecialValueFor( "projectile_speed", ability:GetLevel()-1 ) -- zero-based
		projectile_speed = projectile_speed + bonus_speed
	end

	-- logic
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),

		ExtraData = {
			originX = origin.x,
			originY = origin.y,
			originZ = origin.z,

			max_distance = max_distance,
			min_stun = min_stun,
			max_stun = max_stun,

			min_damage = min_damage,
			bonus_damage = bonus_damage,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	if caster:HasAbility( "marksman_multishot_first_arrow" )==true then
		local selfAbility = self:GetCaster():FindAbilityByName( "marksman_multishot_first_arrow" )
		selfAbility:CastAbility()
	end
	if caster:HasAbility( "marksman_multishot_second_arrow" )==true then
		local selfAbility = self:GetCaster():FindAbilityByName( "marksman_multishot_second_arrow" )
		selfAbility:CastAbility()
	end
	if caster:HasAbility( "marksman_multishot_forth_arrow" )==true then
		local selfAbility = self:GetCaster():FindAbilityByName( "marksman_multishot_forth_arrow" )
		selfAbility:CastAbility()
	end
	if caster:HasAbility( "marksman_multishot_fifth_arrow" )==true then
		local selfAbility = self:GetCaster():FindAbilityByName( "marksman_multishot_fifth_arrow" )
		selfAbility:CastAbility()
	end
	-- Effects
	local sound_cast = "Hero_Mirana.ArrowCast"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Projectile
function marksman_multishot:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	if hTarget==nil then return end

	-- calculate distance percentage
	local origin = Vector( extraData.originX, extraData.originY, extraData.originZ )
	local distance = (vLocation-origin):Length2D()
	local bonus_pct = math.min(1,distance/extraData.max_distance)

	local damageTable = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = extraData.min_damage + extraData.bonus_damage*bonus_pct,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, 500, 3, false )

	-- effects
	local sound_cast = "Hero_Mirana.ArrowImpact"
	EmitSoundOn( sound_cast, hTarget )

end