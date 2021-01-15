modifier_ranger_camouflage_buff = class({})

function modifier_ranger_camouflage_buff:IsHidden()
	return false
end

function modifier_ranger_camouflage_buff:IsDebuff()
	return false
end

function modifier_ranger_camouflage_buff:IsPurgable()
	return false
end

function modifier_ranger_camouflage_buff:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self:StartIntervalThink( 0.5 )
end

function modifier_ranger_camouflage_buff:OnRefresh( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_ranger_camouflage_buff:OnRemoved()
	if not IsServer() then return end
	self:GetAbility():UseResources( false, false, true )
end

function modifier_ranger_camouflage_buff:OnDestroy()
	if not IsServer() then return end
	self:GetAbility():UseResources( false, false, true )
end

function modifier_ranger_camouflage_buff:OnIntervalThink()
	if not IsServer() then return end
	local origin = self:GetParent():GetAbsOrigin()
	local trees = GridNav:GetAllTreesAroundPoint( origin, self.radius, true )
	local treecount = #trees
	local vision = self:GetParent():GetCurrentVisionRange()
	local inRiver = self:GetParent():GetAbsOrigin().z > 0.5 
	AddFOWViewer( self:GetParent():GetTeamNumber(), origin, vision/2, 1, false )

	if ( treecount==0 and self:GetParent():HasModifier("modifier_ranger_burrow_trap_int")==false and self:GetParent():HasModifier("modifier_ranger_smokescreen_buff")==false) and inRiver then self:Destroy() end
end

function modifier_ranger_camouflage_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_ranger_camouflage_buff:GetModifierInvisibilityLevel()
	return 1
end

function modifier_ranger_camouflage_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

function modifier_ranger_camouflage_buff:OnAttackLanded( params )
	if not IsServer() then return end
	if params.attacker==self:GetParent() then self:Destroy() end
	if params.target==self:GetParent() then self:Destroy() end
	
end

function modifier_ranger_camouflage_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}

	return state
end