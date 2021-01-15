modifier_druid_summon_treant = class({})

function modifier_druid_summon_treant:IsHidden()
	if self:GetStackCount()<=0 then
		return true
	else
		return false
	end
end

function modifier_druid_summon_treant:IsDebuff()
	return false
end

function modifier_druid_summon_treant:IsPurgable()
	return false
end

function modifier_druid_summon_treant:OnCreated()
	if IsServer() then
		self.max_summons = self:GetAbility():GetSpecialValueFor( "max_summons" )
		self.table = self:GetCaster():FindAbilityByName("druid_summon_treant").treant_track
		self:StartIntervalThink(0)
	end
end

function modifier_druid_summon_treant:OnDestroy()

end

function modifier_druid_summon_treant:OnIntervalThink()
	self.max_summons = self:GetAbility():GetSpecialValueFor( "max_summons" )
	self.table = self:GetCaster():FindAbilityByName("druid_summon_treant").treant_track
	if #self.table>self.max_summons then
		self:SetStackCount(self.max_summons)
	else
		self:SetStackCount(#self.table)
	end
	
end

function modifier_druid_summon_treant:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_druid_summon_treant:OnDeath( event )
	for i=1,#self.table do
		if event.unit == self.table[i] then
			table.remove(self.table, i)
			for i=1, #self.table do
			end
		end
	end
end

function modifier_druid_summon_treant:OnAbilityFullyCast( params )
	if params.unit == self:GetParent() and params.ability:GetName()=="druid_summon_treant" then
		for i=1, #self.table do
		end
		while #self.table>self.max_summons do
			self.table[1]:ForceKill( false )
		end
    end
end