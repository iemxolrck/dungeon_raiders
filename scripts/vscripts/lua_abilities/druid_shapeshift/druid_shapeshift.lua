druid_shapeshift = class({})

LinkLuaModifier( "modifier_druid_shapeshift", "lua_abilities/druid_shapeshift/modifier_druid_shapeshift",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_druid_shapeshift_transformation", "lua_abilities/druid_shapeshift/modifier_druid_shapeshift_transformation",LUA_MODIFIER_MOTION_NONE )

function druid_shapeshift:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local transformation_time = self:GetSpecialValueFor( "transformation_time" )
	
	caster:AddNewModifier( 
		caster,
		self,
		"modifier_druid_shapeshift_transformation",
		{ duration = self:GetCastPoint() }
	)

	return true

end

function druid_shapeshift:OnAbilityPhaseInterrupted()
	self:GetCaster():FindModifierByName( "modifier_druid_shapeshift_transformation" ):Destroy()
end

function druid_shapeshift:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	
	caster:AddNewModifier( 
		caster,
		self,
		"modifier_druid_shapeshift",
		{ duration = duration }
	)

end