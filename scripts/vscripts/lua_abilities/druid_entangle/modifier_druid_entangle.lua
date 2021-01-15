modifier_druid_entangle = class ({})

function modifier_druid_entangle:IsHidden()
	return true
end

function modifier_druid_entangle:IsDebuff()
	return false
end

function modifier_druid_entangle:IsPurgable()
	return false
end

function modifier_druid_entangle:OnCreated( kv )
	if IsServer() then
		self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
		self.shapeshift_proc = self:GetAbility():GetSpecialValueFor( "shapeshift_proc" )
		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	end
end

function modifier_druid_entangle:OnRefresh( kv )

end

function modifier_druid_entangle:OnRemoved( kv )

end

function modifier_druid_entangle:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}

	return funcs
end

function modifier_druid_entangle:GetModifierProcAttack_BonusDamage_Magical( params )
	if IsServer() then
		if self:GetParent():HasModifier("modifier_lone_druid_true_form")==true
			or self:GetParent():HasModifier("")==true then
			self.proc_chance = self:GetAbility():GetSpecialValueFor( "shapeshift_proc" )
		else
			self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
		end 
		if self:RollChance( self.proc_chance ) and params.target:IsMagicImmune()==false then
			print(self:GetAbility():GetAbilityTargetFlags())
			params.target:AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_druid_entangle_root",
				{ duration = self.duration}
			)
			self:GetAbility():UseResources(true, false, true)
			return self.damage_per_second
		end
		return 0
	end
end

function modifier_druid_entangle:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end