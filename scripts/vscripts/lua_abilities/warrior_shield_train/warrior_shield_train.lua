warrior_shield_train = class({})

LinkLuaModifier( "modifier_warrior_shield_train", "lua_abilities/warrior_shield_train/modifier_warrior_shield_train", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_warrior_shield_train_slow", "lua_abilities/warrior_shield_train/modifier_warrior_shield_train_slow", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_generic_stunned", "lua_abilities/generic/modifier_generic_stunned", LUA_MODIFIER_MOTION_BOTH )

function warrior_shield_train:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local distance = self:GetSpecialValueFor("distance")
	local front = self:GetCaster():GetForwardVector():Normalized()
	local target_pos = self:GetCaster():GetOrigin() + front * distance

	local direction = target_pos-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	self.direction = direction

	self.modifier = caster:AddNewModifier(
		caster,
		self,
		"modifier_warrior_shield_train",
		{
			x = direction.x,
			y = direction.y,
		}
	)

	self:PlayEffects()
	self:PlayEffects()
	self:PlayEffects()

	local sound_cast = "Hero_Pangolier.Swashbuckle.Cast"
	EmitSoundOn( sound_cast, caster )
end

function warrior_shield_train:OnProjectileHitHandle( target, location, iHandle )
	if not IsServer() then return end
	if not target then return end

	GridNav:DestroyTreesAroundPoint( self:GetCaster():GetAbsOrigin(), 50, true )

	local damage = self:GetSpecialValueFor( "damage" )
	local slow_duration = self:GetSpecialValueFor( "slow_duration" )

	local filter = UnitFilter(
		target,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		self:GetCaster():GetTeamNumber()
	)
	if filter~=UF_SUCCESS then
		return false
	end

	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
	}
	ApplyDamage(damageTable)

	target:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_warrior_shield_train_slow",
		{ duration = slow_duration }
	)
	if target:IsAlive() then
		target:AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_generic_stunned",
			{ duration = 1 }
		)
		if self.modifier and (not self.modifier:IsNull()) then
			self.modifier:End( self:GetCaster():GetOrigin() )
			self.modifier = nil
		end
		--self:GetCaster():SetOrigin( target:GetOrigin() + self.direction*80 )
	end
end

function warrior_shield_train:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"
	local sound_cast = "Hero_Mars.Shield.Block"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end