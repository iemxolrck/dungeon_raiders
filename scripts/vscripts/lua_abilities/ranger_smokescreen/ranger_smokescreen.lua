ranger_smokescreen = class({})

LinkLuaModifier( "modifier_ranger_smokescreen_buff", "lua_abilities/ranger_smokescreen/modifier_ranger_smokescreen_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ranger_smokescreen_debuff", "lua_abilities/ranger_smokescreen/modifier_ranger_smokescreen_debuff", LUA_MODIFIER_MOTION_NONE )

function ranger_smokescreen:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function ranger_smokescreen:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "area_of_effect" )

	
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_ranger_smokescreen_buff", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_ranger_smokescreen_debuff", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		point,
		nil,
		radius,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false
	)

	for _,enemy in pairs(enemies) do
		self:GetCaster():PerformAttack(
			enemy,
			true,
			true,
			true,
			true,
			true,
			false,
			false
		)
	end

	--FindClearSpaceForUnit( caster, point, true )

end