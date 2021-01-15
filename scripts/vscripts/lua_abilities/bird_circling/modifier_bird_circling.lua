modifier_bird_circling = class({})

function modifier_bird_circling:IsHidden()
	return false
end

function modifier_bird_circling:IsDebuff()
	return false
end

function modifier_bird_circling:IsPurgable()
	return false
end

function modifier_bird_circling:OnCreated( kv )
	self.parent = self:GetParent():GetOwner()
	self.wisp = self:GetParent()
	self.zero = Vector(0,0,0)

	-- references
	self.revolution = self:GetAbility():GetSpecialValueFor( "roaming_seconds_per_rotation" )
	self.rotate_radius = self:GetAbility():GetSpecialValueFor( "roaming_radius" )

	if not IsServer() then return end

	-- init data
	self.interval = 0.01
	self.base_facing = Vector(0,1,0)
	self.relative_pos = Vector( -self.rotate_radius, 0, 0 )
	self.rotate_delta = 360/self.revolution * self.interval

	-- set init location
	self.position = self.parent:GetOrigin() + self.relative_pos
	self.rotation = 0
	self.facing = self.base_facing

	-- create wisp
	
	self.wisp:SetForwardVector( self.facing )
	self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_wisp_ambient", -- modifier name
		{} -- kv
	)

	-- Start interval
	self:StartIntervalThink( self.interval )

	-- deactivate ability
	local ability = self:GetCaster():FindAbilityByName( "dark_willow_terrorize_lua" )
	if ability then ability:SetActivated( false ) end

	-- play effects
	self:PlayEffects()
end

function modifier_bird_circling:OnRefresh( kv )
	-- refresh references
	self.revolution = self:GetAbility():GetSpecialValueFor( "roaming_seconds_per_rotation" )
	self.rotate_radius = self:GetAbility():GetSpecialValueFor( "roaming_radius" )

	if not IsServer() then return end

	self.relative_pos = Vector( -self.rotate_radius, 0, 0 )
	self.rotate_delta = 360/self.revolution * self.interval

	-- refresh attack modifier
	self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_bird_circling_attack", -- modifier name
		{ duration = kv.duration } -- kv
	)
end

function modifier_bird_circling:OnRemoved()
	if IsServer() then
		self:GetParent():MoveToNPC( self.parent )
	end
end

function modifier_bird_circling:OnDestroy()
	if IsServer() then
		self:GetParent():MoveToNPC( self.parent )
	end
end

function modifier_bird_circling:OnIntervalThink()
	-- update position
	self.rotation = self.rotation + self.rotate_delta
	local origin = self.parent:GetOrigin()
	self.position = RotatePosition( origin, QAngle( 0, -self.rotation, 0 ), origin + self.relative_pos )
	self.facing = RotatePosition( self.zero, QAngle( 0, -self.rotation, 0 ), self.base_facing )

	-- update wisp
	self.wisp:SetOrigin( self.position )
	self.wisp:SetForwardVector( self.facing )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_bird_circling:PlayEffects()
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