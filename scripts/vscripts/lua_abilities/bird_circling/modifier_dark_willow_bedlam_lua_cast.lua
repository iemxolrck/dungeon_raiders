modifier_dark_willow_bedlam_lua_cast = class({})

function modifier_dark_willow_bedlam_lua_cast:IsHidden()
	return false
end

function modifier_dark_willow_bedlam_lua_cast:IsDebuff()
	return false
end

function modifier_dark_willow_bedlam_lua_cast:IsPurgable()
	return false
end

function modifier_dark_willow_bedlam_lua_cast:OnCreated( kv )
	self.parent = self:GetParent():GetOwner()
	self.zero = Vector(0,0,0)

	-- references
	self.revolution = self:GetAbility():GetSpecialValueFor( "roaming_seconds_per_rotation" )
	self.duration = self:GetAbility():GetSpecialValueFor( "roaming_duration" )
	self.rotate_radius = self:GetAbility():GetSpecialValueFor( "roaming_radius" )

	if not IsServer() then return end

	-- init data
	self.interval = 0.03
	self.base_facing = Vector(0,1,0)
	self.relative_pos = Vector( -self.rotate_radius, 0, 0 )
	self.rotate_delta = 360/self.revolution * self.interval

	-- set init location
	self.position = self.parent:GetAbsOrigin() + self.relative_pos
	self.move = self.position
	self.rotation = 0
	self.facing = self.base_facing

	--[[self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_dark_willow_bedlam_lua_cast_attack", -- modifier name
		{ duration = kv.duration } -- kv
	)]]
	

	-- Start interval
	self:StartIntervalThink( self.interval )


end

function modifier_dark_willow_bedlam_lua_cast:OnRefresh( kv )
	
end

function modifier_dark_willow_bedlam_lua_cast:OnRemoved()
	
end

function modifier_dark_willow_bedlam_lua_cast:OnDestroy()
	if not IsServer() then return end
	self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_bird_circling", -- modifier name
		{ duration = self.duration } -- kv
	) 
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dark_willow_bedlam_lua_cast:OnIntervalThink()
	-- update position
	if not IsServer() then return end
	print(self:GetParent():GetAbsOrigin())
	print(self.position)
	if self:GetParent():GetAbsOrigin()==self.position then
		self:GetParent():MoveToPosition( self.position )
		self:GetParent():SetForwardVector( self.facing )
		print("moving")
			
		--self:GetParent():SetOrigin( self.position )
		--self:GetParent():SetForwardVector( self.facing )
	else
		--self:Destroy()

	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dark_willow_bedlam_lua_cast:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_aoe_cast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	--local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.rotate_radius, self.rotate_radius, self.rotate_radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end