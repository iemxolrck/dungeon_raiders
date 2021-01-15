modifier_warrior_iron_will = class({})

function modifier_warrior_iron_will:IsHidden()
	return true
end

function modifier_warrior_iron_will:IsPurgable()
	return false
end

function modifier_warrior_iron_will:RemoveOnDeath()
	return false
end

function modifier_warrior_iron_will:OnCreated( kv )
	self:StartIntervalThink(0)
end

function modifier_warrior_iron_will:OnRefresh( kv )
	
end

function modifier_warrior_iron_will:OnDestroy( kv )

end

function modifier_warrior_iron_will:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsAlive()==true
			and self:GetAbility():IsCooldownReady()
			and self:GetParent():HasModifier("modifier_warrior_iron_will_min")==false then
				self:GetParent():AddNewModifier(
					self:GetParent(),
					self:GetAbility(),
					"modifier_warrior_iron_will_min",
					{ }
				)
		end
	end
end