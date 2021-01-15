modifier_druid_natures_call = class({})

function modifier_druid_natures_call:IsPurgable()
	return false
end

function modifier_druid_natures_call:OnCreated( kv )
	if IsServer() then
		self.vStartPos = self:GetParent():GetOrigin()
		self.vEndPos = Vector( kv["target_x"], kv["target_y"], kv["target_y"] )
		self.target = kv["target_unit"]

		self:GetParent():StartGesture( ACT_DOTA_TELEPORT )
		self:StartIntervalThink( self:GetAbility():GetChannelTime() - 0.25 )

		EmitSoundOnLocationWithCaster( self.vStartPos, "Hero_Furion.Teleport_Grow", self:GetCaster() )
		EmitSoundOnLocationWithCaster( self.vEndPos, "Hero_Furion.Teleport_Grow", self:GetCaster() )
	end
end

function modifier_druid_natures_call:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Furion.Teleport_Grow", self:GetCaster() )
		StopSoundOn( "Hero_Furion.Teleport_Grow", self:GetCaster() )

		self:GetParent():RemoveGesture( ACT_DOTA_TELEPORT )
	end
end

function modifier_druid_natures_call:OnIntervalThink()
	if IsServer() then
		StopSoundOn( "Hero_Furion.Teleport_Grow", self:GetCaster() )
		StopSoundOn( "Hero_Furion.Teleport_Grow", self:GetCaster() )

		self:StartIntervalThink( 1.5 )

		EmitSoundOnLocationWithCaster( self.vStartPos, "Hero_Furion.Teleport_Disappear", self:GetCaster() )
		EmitSoundOnLocationWithCaster( self.vEndPos, "Hero_Furion.Teleport_Appear", self:GetCaster() )
	end
end

function modifier_druid_natures_call:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_druid_natures_call:OnDeath( event )
	if event.unit == self.target then
		print("end channel")
	end
end