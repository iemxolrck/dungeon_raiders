modifier_engineer_station_bot = class({})

function modifier_engineer_station_bot:IsHidden()
	return self:GetStackCount()<0 
end

function modifier_engineer_station_bot:IsDebuff()
	return false
end

function modifier_engineer_station_bot:IsPurgable()
	return false
end

function modifier_engineer_station_bot:OnCreated()
	if IsServer() then
		self.max_bot = self:GetAbility():GetSpecialValueFor( "max_bot" )
		self.table = self:GetCaster():FindAbilityByName("engineer_station_bot").station_track
		self:StartIntervalThink(0)
	end
end

function modifier_engineer_station_bot:OnDestroy()

end

function modifier_engineer_station_bot:OnIntervalThink()
	self.max_bot = self:GetAbility():GetSpecialValueFor( "max_bot" )
	self.table = self:GetCaster():FindAbilityByName("engineer_station_bot").station_track
	if #self.table>self.max_bot then
		self:SetStackCount(self.max_bot)
	else
		self:SetStackCount(#self.table)
	end
	
end

function modifier_engineer_station_bot:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_engineer_station_bot:OnDeath( event )
	for i=1,#self.table do
		if event.unit == self.table[i] then
			table.remove(self.table, i)
			for i=1, #self.table do
			end
		end
	end
end

function modifier_engineer_station_bot:OnAbilityFullyCast( params )
	if params.unit == self:GetParent() and params.ability:GetName()=="engineer_station_bot" then
		for i=1, #self.table do
		end
		while #self.table>self.max_bot do
			self.table[1]:ForceKill( false )
		end
    end
end