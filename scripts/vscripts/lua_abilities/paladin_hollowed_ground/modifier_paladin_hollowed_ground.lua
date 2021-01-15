modifier_paladin_hollowed_ground = class({})

function modifier_paladin_hollowed_ground:IsHidden()
	return false
end

function modifier_paladin_hollowed_ground:IsDebuff()
	return true
end

function modifier_paladin_hollowed_ground:IsPurgable()
	return true
end

function modifier_paladin_hollowed_ground:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_paladin_hollowed_ground:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.particles_0 = ""
	self.origin = Vector( kv.x, kv.y, 0 )
	self.owner = kv.isProvidedByAura~=1

	if self.owner then
		self:SetDuration( self.duration, false )
		self:StartIntervalThink( 0 )
		self.formed = true

		-- play effects
		self.particles_0 = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.particles_0, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.particles_0, 1, Vector( self.radius, 0, 0 ) )

		self.sound_loop = "Hero_ArcWarden.MagneticField"
		EmitSoundOn( self.sound_loop, self:GetParent() )
	else
		-- aura references
		self.aura_origin = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
		self.parent = self:GetParent()
		self.width = 150
		self.max_speed = 550
		self.min_speed = 0.1
		self.max_min = self.max_speed-self.min_speed

		-- check inside/outside
		self.inside = (self.parent:GetOrigin()-self.aura_origin):Length2D() < self.radius
	end
end

function modifier_paladin_hollowed_ground:OnRefresh( kv )
	
end

function modifier_paladin_hollowed_ground:OnRemoved()
end

function modifier_paladin_hollowed_ground:OnDestroy()
	if not IsServer() then return end
	if self.owner then
		-- stop sound
		StopSoundOn( self.sound_loop, self:GetParent() )
		local sound_end = "Hero_Disruptor.KineticField.End"
		EmitSoundOn( sound_end, self:GetParent() )
		ParticleManager:DestroyParticle( self.particles_0, false)

		-- remove thinker
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_paladin_hollowed_ground:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_paladin_hollowed_ground:GetModifierMoveSpeed_Limit( params )
	if not IsServer() then return end
	-- do nothing if thinker
	if self.owner then return 0 end

	-- get data
	local parent_vector = self.parent:GetOrigin()-self.aura_origin
	local parent_direction = parent_vector:Normalized()

	-- check inside/outside
	local actual_distance = parent_vector:Length2D()
	local wall_distance = actual_distance-self.radius
	local over_walls = false
	if self.inside ~= (wall_distance<0) then
		-- moved to other side, check buffer
		if math.abs( wall_distance )>self.width then
			-- flip
			self.inside = not self.inside
		else
			over_walls = true
		end
	end	

	-- no limit if outside width
	wall_distance = math.abs(wall_distance)
	if wall_distance>self.width then return 0 end

	-- calculate facing angle
	local parent_angle = 0
	if self.inside then
		parent_angle = VectorToAngles(parent_direction).y
	else
		parent_angle = VectorToAngles(-parent_direction).y
	end
	local unit_angle = self:GetParent():GetAnglesAsVector().y
	local wall_angle = math.abs( AngleDiff( parent_angle, unit_angle ) )

	-- calculate movespeed limit
	local limit = 0
	if wall_angle<=100 then
		-- facing and touching wall
		if over_walls then
			limit = self.min_speed
			self:RemoveMotions()
		else
			-- interpolate
			limit = (wall_distance/self.width)*self.max_min + self.min_speed
		end
	else
		-- no limit if facing away
		limit = 0
	end

	return limit
end

function modifier_paladin_hollowed_ground:RemoveMotions()
	local modifiers = self.parent:FindAllModifiers(  )

	for _,modifier in pairs(modifiers) do
		-- print("modifier:",modifier,modifier:GetName())
	end
end

function modifier_paladin_hollowed_ground:OnIntervalThink()
	if not IsServer() then return end
	local distance = math.floor( (self:GetCaster():GetAbsOrigin()-self.origin):Length2D() )
	if self.radius<distance then
		self:Destroy()
	end
end

function modifier_paladin_hollowed_ground:IsAura()
	return self.owner and self.formed
end

function modifier_paladin_hollowed_ground:GetModifierAura()
	return "modifier_paladin_hollowed_ground"
end

function modifier_paladin_hollowed_ground:GetAuraRadius()
	return self.radius
end

function modifier_paladin_hollowed_ground:GetAuraDuration()
	return 0.3
end

function modifier_paladin_hollowed_ground:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_paladin_hollowed_ground:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_paladin_hollowed_ground:GetAuraSearchFlags()
	return 0
end

function modifier_paladin_hollowed_ground:PlayEffects2()
	-- Get Resources
	
end