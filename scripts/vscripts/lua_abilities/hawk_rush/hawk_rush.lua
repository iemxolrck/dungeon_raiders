hawk_rush = class({})

LinkLuaModifier( "modifier_hawk_rush", "lua_abilities/hawk_rush/modifier_hawk_rush", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hawk_rush_slow", "lua_abilities/hawk_rush/modifier_hawk_rush_slow", LUA_MODIFIER_MOTION_HORIZONTAL )

function hawk_rush:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local distance = self:GetSpecialValueFor("distance")
	local front = self:GetCaster():GetForwardVector():Normalized()
	local target_pos = self:GetCaster():GetOrigin() + front * distance

	-- set direction
	local direction = target_pos-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	self.direction = direction

	-- add modifier
	self.modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_hawk_rush", -- modifier name
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
function hawk_rush:OnProjectileHitHandle( target, location, iHandle )
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
		"modifier_hawk_rush_slow", -- modifier name
		{ duration = slow_duration } -- kv
	)


end

function hawk_rush:OnHeroCalculateStatBonus()
    if self:GetLevel()<1 then
        self:SetLevel(self:GetMaxLevel())
    end
end
