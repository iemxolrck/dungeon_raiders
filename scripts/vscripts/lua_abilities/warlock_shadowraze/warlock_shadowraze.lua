warlock_shadowraze = class({})

LinkLuaModifier( "modifier_warlock_shadowraze", "lua_abilities/warlock_shadowraze/modifier_warlock_shadowraze", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warlock_shadowraze_stack", "lua_abilities/warlock_shadowraze/modifier_warlock_shadowraze_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warlock_shadowraze_thinker", "lua_abilities/warlock_shadowraze/modifier_warlock_shadowraze_thinker", LUA_MODIFIER_MOTION_NONE )

function warlock_shadowraze:GetIntrinsicModifierName()
	return "modifier_warlock_shadowraze"
end 

function warlock_shadowraze:OnSpellStart()
	-- get references
	local caster = self:GetCaster()
	local distance = self:GetSpecialValueFor("shadowraze_range")
	local front = self:GetCaster():GetForwardVector():Normalized()
	local origin = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector():Normalized()
	local target_pos = caster:GetOrigin() + front * distance
	local target_radius = self:GetSpecialValueFor("shadowraze_radius")
	local base_damage = self:GetSpecialValueFor("shadowraze_damage")
	local stack_damage = self:GetSpecialValueFor("stack_bonus_damage")
	local stack_duration = self:GetSpecialValueFor("duration")
	local interval = 0.2
	local count = 0

	for i=1,5 do
		local point = caster:GetOrigin() + front * ( distance * i )
		--point = point + point:GetUpVector():Normalized()
		CreateModifierThinker(
			caster,
			self,
			"modifier_warlock_shadowraze_thinker",
			{
				duration = interval * ( i - 1) ,
				x = point.x,
				y = point.y,
				z = point.z,
			},
			point,
			caster:GetTeamNumber(),
			false
		)
	end

end

function warlock_shadowraze:PlayEffects( position, radius )
	-- get resources
	local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local sound_cast = "Hero_Nevermore.Shadowraze"

	-- create particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	--local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, position )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
	-- create sound
	EmitSoundOnLocationWithCaster( position, sound_cast, self:GetCaster() )
end