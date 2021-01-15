modifier_ranger_camouflage = class({})

function modifier_ranger_camouflage:IsHidden()
	return true
end

function modifier_ranger_camouflage:IsDebuff()
	return false
end

function modifier_ranger_camouflage:IsPurgable()
	return false
end

function modifier_ranger_camouflage:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self:StartIntervalThink(0)
end

function modifier_ranger_camouflage:OnDestroy()

end

function modifier_ranger_camouflage:OnIntervalThink()
	if IsServer() then
		
		if self:GetParent():HasModifier("modifier_ranger_camouflage_buff")==true then return end
		if not self:GetAbility():IsFullyCastable() then return end
		local origin = self:GetParent():GetAbsOrigin()
		local trees = GridNav:GetAllTreesAroundPoint( origin, self.radius, true )
		local treecount = #trees

		if self:GetParent():GetAbsOrigin().z <= 0.5 then
			self:GetParent():AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_ranger_camouflage_buff",
				{}
			)
			self:GetAbility():UseResources( true, true, true )
			return
		end

		if treecount==0 and
			self:GetParent():HasModifier("modifier_ranger_burrow_trap_int")==false and
			self:GetParent():HasModifier("modifier_ranger_smokescreen_buff")==false then return end
		self:GetParent():AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_ranger_camouflage_buff",
			{}
		)
		self:GetAbility():UseResources( true, true, true )
		return
	end
end