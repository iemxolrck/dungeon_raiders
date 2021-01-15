paladin_hollowed_ground = class({})

LinkLuaModifier( "modifier_paladin_hollowed_ground", "lua_abilities/paladin_hollowed_ground/modifier_paladin_hollowed_ground", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_paladin_hollowed_ground_protection", "lua_abilities/paladin_hollowed_ground/modifier_paladin_hollowed_ground_protection", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_paladin_hollowed_ground_reduction", "lua_abilities/paladin_hollowed_ground/modifier_paladin_hollowed_ground_reduction", LUA_MODIFIER_MOTION_NONE )

function paladin_hollowed_ground:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = self:GetAbsOrigin()

	local radius = self:GetSpecialValueFor( "radius" )
	local duration = self:GetSpecialValueFor( "duration" )

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_paladin_hollowed_ground", -- modifier name
		{ 	x = origin.x,
			y = origin.y
		}, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_paladin_hollowed_ground_protection", -- modifier name
		{ 	x = origin.x,
			y = origin.y,
			duration = duration
		},
		origin,
		caster:GetTeamNumber(),
		false
	)
	AddFOWViewer( caster:GetTeamNumber(), origin, radius, duration, false )

	EmitSoundOn("Hero_ArcWarden.MagneticField.Cast", self:GetCaster())

end