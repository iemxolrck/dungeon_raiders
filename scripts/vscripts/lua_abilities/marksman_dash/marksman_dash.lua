marksman_dash = class({})
LinkLuaModifier( "modifier_marksman_dash", "lua_abilities/marksman_dash/modifier_marksman_dash", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_marksman_dash_slow", "lua_abilities/marksman_dash/modifier_marksman_dash_slow", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------
-- Ability Start
function marksman_dash:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local distance = self:GetSpecialValueFor("distance")
	local front = self:GetCaster():GetForwardVector():Normalized()
	local target_pos = self:GetCaster():GetOrigin() + front * distance
	local ability = self:GetCaster():FindAbilityByName( "marksman_triple_shot" )

	-- set direction
	local direction = target_pos-caster:GetOrigin()
	direction = RotatePosition( Vector(0,0,0), QAngle( 0, 180, 0 ), direction )
	direction.z = 0
	direction = direction:Normalized()
	self.direction = direction

	caster:Stop()
    ProjectileManager:ProjectileDodge(caster)

	-- add modifier
	self.modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_marksman_dash", -- modifier name
		{
			x = direction.x,
			y = direction.y,
		} -- kv
	)


	-- Play effects
	local sound_cast = "Hero_Pangolier.Swashbuckle.Cast"
	EmitSoundOn( sound_cast, caster )

end
--------------------------------------------------------------------------------
-- Projectile
function marksman_dash:OnProjectileHitHandle( target, location, iHandle )
	if not IsServer() then return end
	if not target then return end

	-- get data
	local damage = self:GetSpecialValueFor( "damage" )
	local slow_duration = self:GetSpecialValueFor( "slow_duration" )

	-- unit filter
	local filter = UnitFilter(
		target,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
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
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_marksman_dash_slow", -- modifier name
		{ duration = slow_duration } -- kv
	)


end

function marksman_dash:OnHeroCalculateStatBonus()
    if self:GetLevel()<1 then
        self:SetLevel(self:GetMaxLevel())
    end
end
