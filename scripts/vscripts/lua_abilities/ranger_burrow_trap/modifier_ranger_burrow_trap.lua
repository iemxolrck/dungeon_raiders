modifier_ranger_burrow_trap = class({})

function modifier_ranger_burrow_trap:IsHidden()
	if self:GetStackCount()<=0 then
		return true
	else
		return false
	end
end

function modifier_ranger_burrow_trap:IsDebuff()
	return false
end

function modifier_ranger_burrow_trap:IsPurgable()
	return false
end

function modifier_ranger_burrow_trap:OnCreated()
	if IsServer() then
		self.max_traps = self:GetAbility():GetSpecialValueFor( "max_traps" )
		self.table = self:GetCaster():FindAbilityByName("ranger_burrow_trap").trap_track
		self:StartIntervalThink(0)
	end
end

function modifier_ranger_burrow_trap:OnDestroy()

end

function modifier_ranger_burrow_trap:OnIntervalThink()
	if IsServer() then
		local ability = self:GetCaster():FindAbilityByName("ranger_burrow_trap")
		self.max_traps = self:GetAbility():GetSpecialValueFor( "max_traps" )
		self.table = ability.trap_track
		local traps = math.min( self.max_traps , #self.table )
		self:SetStackCount(traps)
		if #self.table==self.max_traps then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
	end
end

function modifier_ranger_burrow_trap:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_END_CHANNEL,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_ranger_burrow_trap:OnDeath( event )
	if IsServer() then
		for i=1,#self.table do
			if event.unit == self.table[i] then
				table.remove(self.table, i)
				for i=1, #self.table do
				end
			end
		end
	end
end

function modifier_ranger_burrow_trap:OnAbilityEndChannel( params )
	if IsServer() then
		if params.unit == self:GetParent() and params.ability:GetName()=="ranger_burrow_trap" then
			for i=1, #self.table do
			end
			while #self.table>self.max_traps do
				self.table[1]:ForceKill( false )
			end
	    end
	end
end