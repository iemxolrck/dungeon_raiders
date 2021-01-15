modifier_dragon_knight_breathe_fire_shoot = class({})

function modifier_dragon_knight_breathe_fire_shoot:IsHidden()
	return false
end

function modifier_dragon_knight_breathe_fire_shoot:IsDebuff()
	return false
end

function modifier_dragon_knight_breathe_fire_shoot:IsStunDebuff()
	return false
end

function modifier_dragon_knight_breathe_fire_shoot:IsPurgable()
	return true
end

function modifier_dragon_knight_breathe_fire_shoot:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dragon_knight_breathe_fire_shoot:OnCreated( kv )
	if not IsServer() then return end
	-- load data
	self.caster = self:GetParent()
	self.ability = EntIndexToHScript( kv.ability )
	self.target = self:GetAbility():GetCursorTarget()
	self.point = self:GetAbility():GetCursorPosition()
	self.multicast = kv.multicast
	self.delay = kv.delay
	--self.single = kv.single==1
	self.buffer_range = 300

	-- set stack count
	self:SetStackCount( self.multicast )

	-- init multicast
	self.casts = 0
	if self.multicast==1 then
		-- no multicast if just 1
		self:Destroy()
		return
	end

	-- keep a table of targeted units
	self.targets = {}
	self.targets[self.target] = true

	-- get cast range
	self.radius = self.ability:GetCastRange( self.target:GetOrigin(), self.target ) + self.buffer_range

	-- get unit filters
	-- only target the same team as original target, even if the ability can cast on both team
	self.target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	if self.target:GetTeamNumber()~=self.caster:GetTeamNumber() then
		self.target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	end

	-- if custom, findunitsinradius won't work
	self.target_type = self.ability:GetAbilityTargetType()
	if self.target_type==DOTA_UNIT_TARGET_CUSTOM then
		self.target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end

	-- only check for magic immunity piercing abilities
	self.target_flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
	if bit.band( self.ability:GetAbilityTargetFlags(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ) ~= 0 then
		self.target_flags = self.target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	
	-- play effects
	self:PlayEffects( self.casts )

	-- Start interval
	self:StartIntervalThink( self.delay )
end

function modifier_dragon_knight_breathe_fire_shoot:OnRefresh( kv )
	
end

function modifier_dragon_knight_breathe_fire_shoot:OnRemoved()
end

function modifier_dragon_knight_breathe_fire_shoot:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dragon_knight_breathe_fire_shoot:OnIntervalThink()
	local current_target = nil

	if self.single then
		current_target = self.target
	else
		-- find valid targets
		local units = FindUnitsInRadius(
			self.caster:GetTeamNumber(),	-- int, your team number
			self.caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			self.target_team,	-- int, team filter
			self.target_type,	-- int, type filter
			self.target_flags,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- select valid target
		for _,unit in pairs(units) do
			-- not already a multicast target
			if not self.targets[unit] then

				-- check filter
				local filter = false
				if self.ability.CastFilterResultTarget then -- for customs
					filter = self.ability:CastFilterResultTarget( unit ) == UF_SUCCESS
				else
					filter = true
				end

				if filter then
					-- register unit
					self.targets[unit] = true
					current_target = unit

					break
				end
			end
		end

		-- if no one there, break multicast
		if not current_target then
			self:StartIntervalThink( -1 )
			self:Destroy()
			return
		end
	end

	-- cast to target
	self.caster:SetCursorCastTarget( current_target )
	self.ability:OnSpellStart()

	-- increment count
	self.casts = self.casts + 1
	if self.casts>=(self.multicast-1) then
		self:StartIntervalThink( -1 )
		self:Destroy()
	end

	-- play effects
	self:PlayEffects( self.casts )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dragon_knight_breathe_fire_shoot:PlayEffects( value )
	value = value + 1

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf"

	-- get data
	local counter_speed = 2
	if value==self.multicast then
		counter_speed = 1
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( value, counter_speed, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound = math.min( value-1, 3 )
	local sound_cast = "Hero_OgreMagi.Fireblast.x" .. sound
	if sound>0 then
		EmitSoundOn( sound_cast, self.caster )
	end
end