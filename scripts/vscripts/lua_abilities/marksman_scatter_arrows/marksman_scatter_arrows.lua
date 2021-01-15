marksman_scatter_arrows = class({})

--LinkLuaModifier( "modifier_marksman_scatter_arrows_buff", "lua_abilities/marksman_scatter_arrows/modifier_marksman_scatter_arrows_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marksman_scatter_arrows", "lua_abilities/marksman_scatter_arrows/modifier_marksman_scatter_arrows", LUA_MODIFIER_MOTION_NONE )

function marksman_scatter_arrows:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function marksman_scatter_arrows:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	local radius = self:GetSpecialValueFor( "area_of_effect" )
	local delay = self:GetSpecialValueFor( "delay" )

	for i=1,10 do
		self:PlayEffects( caster, origin )
	end
	
	local sound_cast = "Ability.Powershot"
	EmitSoundOn( sound_cast, caster )

	CreateModifierThinker(
		caster,
		self,
		"modifier_marksman_scatter_arrows",
		{ duration = delay },
		point,
		caster:GetTeamNumber(),
		false
	)

end

function marksman_scatter_arrows:PlayEffects( caster, origin )
	local shoot = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_moonray_arrow.vpcf", PATTACH_ABSORIGIN , caster)
	ParticleManager:SetParticleControl(shoot, 0, origin)
	ParticleManager:SetParticleControl(shoot, 1, origin)
	ParticleManager:ReleaseParticleIndex(shoot)

end