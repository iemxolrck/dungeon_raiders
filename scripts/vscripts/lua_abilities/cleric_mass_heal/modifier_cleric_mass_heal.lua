modifier_cleric_mass_heal = class({})

function modifier_cleric_mass_heal:IsHidden()
	return false
end

function modifier_cleric_mass_heal:OnCreated(kv)
	self.caster = self:GetCaster()
	--self:SetStackCount(1)
	self:StartIntervalThink(0)
end

function modifier_cleric_mass_heal:OnRefresh(kv)

end

function modifier_cleric_mass_heal:OnIntervalThink(kv)
	if self.caster:HasModifier("modifier_cleric_channel_divinity")~=true then
		self:Destroy()
	end
end

function modifier_cleric_mass_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_cleric_mass_heal:OnAbilityFullyCast( event )
	 if event.ability:GetName() == "cleric_mass_heal"
	 	and self.caster:HasModifier("modifier_cleric_channel_divinity")==true
	 	and event.unit == self:GetCaster() then
			self:IncrementStackCount()
    end
end