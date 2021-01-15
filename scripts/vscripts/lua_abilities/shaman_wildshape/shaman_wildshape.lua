shaman_wildshape = class({})

LinkLuaModifier( "modifier_shaman_wildshape", "lua_abilities/shaman_wildshape/modifier_shaman_wildshape",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shaman_wildshape_transformation", "lua_abilities/shaman_wildshape/modifier_shaman_wildshape_transformation",LUA_MODIFIER_MOTION_NONE )

function shaman_wildshape:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	
	caster:AddNewModifier( 
		caster,
		self,
		"modifier_shaman_wildshape",
		{ duration = duration }
	)

end