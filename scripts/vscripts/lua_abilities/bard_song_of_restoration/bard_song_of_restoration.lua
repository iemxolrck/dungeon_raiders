bard_song_of_restoration = class({})	

LinkLuaModifier( "modifier_bard_song_of_restoration_aura", "lua_abilities/bard_song_of_restoration/modifier_bard_song_of_restoration_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_song_of_restoration_heal", "lua_abilities/bard_song_of_restoration/modifier_bard_song_of_restoration_heal", LUA_MODIFIER_MOTION_NONE )

function bard_song_of_restoration:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(
		caster,
		self,
		"modifier_bard_song_of_restoration_aura",
		{ duration = self:GetChannelTime() }
	)
end

function bard_song_of_restoration:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():StopAnimation()
		if ( self:GetCaster():HasModifier("modifier_bard_song_of_restoration_aura")==true or bInterrupted ) and self:GetCaster():IsAlive()==true then
			self:GetCaster():FindModifierByName("modifier_bard_song_of_restoration_aura"):Destroy()
		end
	end
end

function bard_song_of_restoration:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end