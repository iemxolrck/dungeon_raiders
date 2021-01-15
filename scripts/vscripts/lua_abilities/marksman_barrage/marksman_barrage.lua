marksman_barrage = class({})
LinkLuaModifier( "modifier_marksman_barrage", "lua_abilities/marksman_barrage/modifier_marksman_barrage", LUA_MODIFIER_MOTION_NONE )

marksman_barrage.targets = {}
function marksman_barrage:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetDuration()
	local range = self:GetCastRange( Vector(0,0,0), nil ) + self:GetCaster():GetCastRangeBonus()
	print(range)

	self.targets = {}
	self.count = 0

	self.modifier = caster:AddNewModifier(
		caster,
		self,
		"modifier_marksman_barrage",
		{
			range = range,
			duration = duration,
			x = point.x,
			y = point.y,
			z = point.z,
		}
	)

end

function marksman_barrage:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end
	-- check if already attacked on this wave
	if self.targets[ target ]==data.wave then return false end
	self.targets[ target ] = data.wave

	-- get value
	local damage = self:GetSpecialValueFor( "arrow_damage_pct" )
	local slow = self:GetSpecialValueFor( "arrow_slow_duration" )

	-- check frost arrow ability
	if data.frost==1 then
		local ability = self:GetCaster():FindAbilityByName( "drow_ranger_frost_arrows_lua" )
		target:AddNewModifier(
			self:GetCaster(), -- player source
			ability, -- ability source
			"modifier_drow_ranger_frost_arrows_lua", -- modifier name
			{ duration = slow } -- kv
		)
	end

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetAttackDamage(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
		-- damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)

	-- play effects
	local sound_cast = "Hero_DrowRanger.ProjectileImpact"
	EmitSoundOn( sound_cast, target )
	self.count = self.count + 1
	if self.count>=2 then
		return true
	end
end

function marksman_barrage:OnChannelFinish( bInterrupted )
	-- destroy modifier
	--if not self.modifier:IsNull() then self.modifier:Destroy() end
end