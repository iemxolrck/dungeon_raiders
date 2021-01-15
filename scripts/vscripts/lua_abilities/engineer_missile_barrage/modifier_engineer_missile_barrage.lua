modifier_engineer_missile_barrage = class({})

function modifier_engineer_missile_barrage:IsHidden()
	return true
end

function modifier_engineer_missile_barrage:IsDebuff()
	return false
end

function modifier_engineer_missile_barrage:IsPurgable()
	return false
end

function modifier_engineer_missile_barrage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_engineer_missile_barrage:OnCreated( kv )

	self.duration = 0.5--self:GetAbility():GetSpecialValueFor(  )
	self.interval = 0.2--self:GetAbility():GetSpecialValueFor(  )
	self.count = 0

	self:LaunchMissile()
	self:StartIntervalThink( self.interval )

end

function modifier_engineer_missile_barrage:OnRefresh( kv )
	
end

function modifier_engineer_missile_barrage:OnDestroy( kv )
	
end

function modifier_engineer_missile_barrage:OnIntervalThink()
	if not IsServer() then return end
	self:LaunchMissile()
	self.count = self.count + 1
	if self.count>=4 then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

function modifier_engineer_missile_barrage:LaunchMissile()
	if not IsServer() then return end

	self:GetCaster():AddNewModifier(
        self:GetCaster(),   
        self:GetAbility(),
        "modifier_engineer_missile_barrage_thinker", 
        { duration = self.duration }
    )
end