modifier_paladin_hollowed_ground_protection = class({})

function modifier_paladin_hollowed_ground_protection:IsHidden()
	return false
end

function modifier_paladin_hollowed_ground_protection:IsDebuff()
	return false
end

function modifier_paladin_hollowed_ground_protection:IsPurgable()
	return true
end

function modifier_paladin_hollowed_ground_protection:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_paladin_hollowed_ground_protection:OnCreated( kv )
	if not IsServer() then return end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.origin = Vector( kv.x, kv.y, 0 )
	self.owner = kv.isProvidedByAura~=1
	self:StartIntervalThink(0)

end

function modifier_paladin_hollowed_ground_protection:OnRefresh( kv )
	
end

function modifier_paladin_hollowed_ground_protection:OnRemoved()
	if not IsServer() then return end
	self.owner = false
end

function modifier_paladin_hollowed_ground_protection:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_paladin_hollowed_ground_protection:OnIntervalThink()
	if not IsServer() then return end
	local distance = math.floor( (self:GetCaster():GetAbsOrigin()-self.origin):Length2D() )
	if self.radius<distance then
		self:Destroy()
	end
end

function modifier_paladin_hollowed_ground_protection:IsAura()
	return self.owner
end

function modifier_paladin_hollowed_ground_protection:GetModifierAura()
	return "modifier_paladin_hollowed_ground_reduction"
end

function modifier_paladin_hollowed_ground_protection:GetAuraRadius()
	return self.radius
end

function modifier_paladin_hollowed_ground_protection:GetAuraDuration()
	return 0.3
end

function modifier_paladin_hollowed_ground_protection:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_paladin_hollowed_ground_protection:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_paladin_hollowed_ground_protection:GetAuraSearchFlags()
	return 0
end

function modifier_paladin_hollowed_ground_protection:GetAuraEntityReject( hEntity )
	--if not IsServer() then return end
	--if hEntity==self:GetCaster() then return true end
end