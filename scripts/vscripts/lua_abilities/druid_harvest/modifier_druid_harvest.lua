modifier_druid_harvest = class ({})

function modifier_druid_harvest:IsHidden()
	return true
end

function modifier_druid_harvest:IsDebuff()
	return false
end

function modifier_druid_harvest:IsPurgable()
	return false
end

function modifier_druid_harvest:OnCreated( kv )
	if IsServer() then
		self.self_mana_steel = self:GetAbility():GetSpecialValueFor( "self_mana_steel" ) / 100
		self.mana_per_hit = self:GetAbility():GetSpecialValueFor( "mana_per_hit" ) / 100
		self.shapeshift_lifesteal = self:GetAbility():GetSpecialValueFor( "shapeshift_lifesteal" ) / 100
		self.radius = self:GetAbility():GetCastRange( self:GetParent():GetAbsOrigin(), nil )
	end
end

function modifier_druid_harvest:OnRefresh( kv )

end

function modifier_druid_harvest:OnRemoved( kv )

end

function modifier_druid_harvest:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_druid_harvest:OnTakeDamage( keys )
	if IsServer() then
		if keys.attacker:IsSummoned()==true then
			if  keys.attacker:GetOwnerEntity()==self:GetParent() then
				local mana = keys.damage * self.mana_per_hit
				self:GetParent():GiveMana( mana )
				self:PlayEffects( mana )
				self:GetAbility():UseResources(true, false, true)
			end
		else
			if keys.attacker==self:GetParent() and self:GetParent():HasModifier("modifier_druid_shapeshift")==false then
				local mana = keys.damage * self.self_mana_steel
				self:GetParent():GiveMana( mana )
				self:PlayEffects( mana )
				self:GetAbility():UseResources(true, false, true)
			end
		end
	end
end

function modifier_druid_harvest:OnAttackLanded(params)
	if IsServer() then
		if params.attacker==self:GetParent() then
			local heal = params.damage * self.shapeshift_lifesteal
			if self:GetParent():HasModifier("modifier_druid_shapeshift")==true then
				self:GetParent():Heal( heal, self:GetAbility())
				self:PlayEffects2()
			end
		end
	end
end

function modifier_druid_harvest:PlayEffects( mana )
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self:GetParent(), mana, nil)
	local particle_cast = "particles/generic_gameplay/generic_lifesteal_blue.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_druid_harvest:PlayEffects2()
	local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end