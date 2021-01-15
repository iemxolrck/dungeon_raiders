druid_natures_call = class({})

LinkLuaModifier( "modifier_druid_natures_call", "lua_abilities/druid_natures_call/modifier_druid_natures_call", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_druid_natures_call_stop", "lua_abilities/druid_natures_call/modifier_druid_natures_call_stop", LUA_MODIFIER_MOTION_NONE )

function druid_natures_call:OnAbilityPhaseStart()
	self.vTargetPosition = self:GetCursorPosition()
	self.target = self:GetCursorTarget()
	local duration = self:GetCastPoint()
	local nTeam = self:GetCaster():GetTeamNumber()
	local nEnemyTeam = nil
	if nTeam == DOTA_TEAM_GOODGUYS then
		nEnemyTeam = DOTA_TEAM_BADGUYS
	else
		nEnemyTeam = DOTA_TEAM_GOODGUYS
	end

	

	self.nFXIndexStart = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_teleport.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( self.nFXIndexStart, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( self.nFXIndexStart, 2, Vector( 1, 0, 0 ) )

	self.nFXIndexEnd = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_furion/furion_teleport_end.vpcf", PATTACH_CUSTOMORIGIN, nil, nEnemyTeam )
	ParticleManager:SetParticleControl( self.nFXIndexEnd, 1, self.vTargetPosition )
	ParticleManager:SetParticleControl( self.nFXIndexEnd, 2, Vector ( 1, 0, 0 ) )

	self.nFXIndexEndTeam = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_furion/furion_teleport_end_team.vpcf", PATTACH_CUSTOMORIGIN, nil, nTeam )
	ParticleManager:SetParticleControl( self.nFXIndexEndTeam, 1, self.vTargetPosition )
	ParticleManager:SetParticleControl( self.nFXIndexEndTeam, 2, Vector ( 1, 0, 0 ) )

	MinimapEvent( nTeam, self:GetCaster(), self.vTargetPosition.x, self.vTargetPosition.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, self:GetCastPoint() )

	local kv = {
		duration = self:GetCastPoint(),
		target_x = self.vTargetPosition.x,
		target_y = self.vTargetPosition.y,
		target_z = self.vTargetPosition.z,
		target_unit = self.target
	}
	self.target:AddNewModifier( self:GetCaster(), self, "modifier_druid_natures_call_stop", kv )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_druid_natures_call", kv )


	return true;
end

--------------------------------------------------------------------------------

function druid_natures_call:OnAbilityPhaseInterrupted()
	ParticleManager:SetParticleControl( self.nFXIndexStart, 2, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControl( self.nFXIndexEnd, 2, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControl( self.nFXIndexEndTeam, 2, Vector( 0, 0, 0 ) )

	ParticleManager:DestroyParticle( self.nFXIndexStart, false )
	ParticleManager:DestroyParticle( self.nFXIndexEnd, false )
	ParticleManager:DestroyParticle( self.nFXIndexEndTeam, false )

	self:GetCaster():RemoveModifierByName( "modifier_druid_natures_call" )
	self.target:RemoveModifierByName( "modifier_druid_natures_call_stop" )

	MinimapEvent( self:GetCaster():GetTeamNumber(), self:GetCaster(), 0, 0, DOTA_MINIMAP_EVENT_CANCEL_TELEPORTING, 0 )
end

--------------------------------------------------------------------------------

function druid_natures_call:OnSpellStart()
	local origin = self:GetCaster():GetOrigin()
	ProjectileManager:ProjectileDodge( self:GetCaster() )
	ProjectileManager:ProjectileDodge( self.target )
	FindClearSpaceForUnit( self.target, origin, true )
	FindClearSpaceForUnit( self:GetCaster(), self.vTargetPosition, true )
	self:GetCaster():StartGesture( ACT_DOTA_TELEPORT_END )

	ParticleManager:DestroyParticle( self.nFXIndexStart, false )
	ParticleManager:DestroyParticle( self.nFXIndexEnd, false )
	ParticleManager:DestroyParticle( self.nFXIndexEndTeam, false )
end