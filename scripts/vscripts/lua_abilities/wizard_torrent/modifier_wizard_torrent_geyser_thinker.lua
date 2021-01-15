modifier_wizard_torrent_geyser_thinker = class({})

function modifier_wizard_torrent_geyser_thinker:OnCreated( kv )
	if not IsServer() then return end
	self.instance = self:GetAbility():GetSpecialValueFor( "geyser_instance" )
	self.count = self:GetAbility():GetSpecialValueFor( "geyser" ) - 1
	self.origin = Vector( kv.x, kv.y, kv.z )

	self:StartIntervalThink( self.instance )

end

function modifier_wizard_torrent_geyser_thinker:OnIntervalThink()
	if not IsServer() then return end
	if self.count == 0 then self:Destroy() end
	CreateModifierThinker(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_wizard_torrent_thinker",
		{ duration = 3 },
		self.origin,
		self:GetCaster():GetTeamNumber(),
		false
	)
	self.count = self.count - 1
end