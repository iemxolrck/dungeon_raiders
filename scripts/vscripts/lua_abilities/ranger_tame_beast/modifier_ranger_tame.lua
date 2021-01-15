modifier_ranger_tame = class({})

function modifier_ranger_tame:IsHidden()
	if self:GetStackCount()<=0 then
		return true
	else
		return false
	end
end

function modifier_ranger_tame:IsDebuff()
	return false
end

function modifier_ranger_tame:IsPurgable()
	return false
end

function modifier_ranger_tame:OnCreated()
	if IsServer() then
		self.max_beast = self:GetAbility():GetSpecialValueFor( "max_beast" )
		self.table = self:GetCaster():FindAbilityByName("ranger_tame_beast").beast_track
		self:StartIntervalThink(0)
	end
end

function modifier_ranger_tame:OnDestroy()

end

function modifier_ranger_tame:OnIntervalThink()
	if IsServer() then
		local ability = self:GetCaster():FindAbilityByName("ranger_tame_beast")
		self.max_beast = self:GetAbility():GetSpecialValueFor( "max_beast" )
		self.table = ability.beast_track
		local traps = math.min( self.max_beast , #self.table )
		self:SetStackCount(traps)
		if #self.table==self.max_beast then
			ability:SetActivated(false)
		else
			ability:SetActivated(true)
		end
	end
end

function modifier_ranger_tame:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_ranger_tame:OnDeath( event )
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

function modifier_ranger_tame:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit == self:GetParent() and params.ability:GetName()=="ranger_tame_beast" then
			for i=1, #self.table do
			end
			while #self.table>self.max_beast do
				self.table[1]:ForceKill( false )
			end
	    end
	end
end