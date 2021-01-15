modifier_warrior_iron_will_buff = class({})

function modifier_warrior_iron_will_buff:IsHidden()
	return false
end

function modifier_warrior_iron_will_buff:IsPurgable()
	return false
end

function modifier_warrior_iron_will_buff:OnCreated()
	self.hp_threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold" ) 
	self.max_health = self:GetAbility():GetSpecialValueFor( "max_health" )
	self.lastKill = ""
	self.inflictor = ""
end

function modifier_warrior_iron_will_buff:OnRefresh()
	self.hp_threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold" ) 
	self.max_health = self:GetAbility():GetSpecialValueFor( "max_health" )
	self.lastKill = nil
	self.inflictor = nil
end

function modifier_warrior_iron_will_buff:OnDestroy()
	if IsServer() then
		if self:GetParent():GetHealthPercent()<self.max_health then
			self:GetParent():Kill( self.inflictor ,self.lastKill )
		end
	end
end

function modifier_warrior_iron_will_buff:OnRemoved()
	if IsServer() then
		if self:GetParent():GetHealthPercent()<self.max_health then
			self:GetParent():Kill( self.inflictor ,self.lastKill )
		end
	end
end

function modifier_warrior_iron_will_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
	}

	return funcs
end

function modifier_warrior_iron_will_buff:GetMinHealth()
	return self.hp_threshold
end

function modifier_warrior_iron_will_buff:OnTakeDamageKillCredit( params )
	if not IsServer() then return end
	if params.target==self:GetParent() then
		self.lastKill = params.attacker
		self.inflictor = params.inflictor
	end
end

function modifier_warrior_iron_will_buff:GetEffectName()
	return "particles/units/heroes/hero_mars/mars_arena_of_blood_heal.vpcf"
end

function modifier_warrior_iron_will_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end