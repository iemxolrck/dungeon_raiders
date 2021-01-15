modifier_shaman_mystic_snake = class({})

function modifier_shaman_mystic_snake:IsHidden()
	return self:GetStackCount()<=0
end

function modifier_shaman_mystic_snake:IsDebuff()
	return false
end

function modifier_shaman_mystic_snake:IsPurgable()
	return false
end

function modifier_shaman_mystic_snake:OnCreated( kv )
	self.block = 0
	self:StartIntervalThink(0)
	if not IsServer() then return end
	local block = kv.block
	self:SetStackCount(block)
	self.block = block
end

function modifier_shaman_mystic_snake:OnRefresh( kv )
	self.block = 0
	self:StartIntervalThink(0)
	if not IsServer() then return end
	local block = kv.block
	self:SetStackCount(self:GetStackCount() + block)
	self.block = block
end

function modifier_shaman_mystic_snake:OnRemoved()

end

function modifier_shaman_mystic_snake:OnDestroy()

end

function modifier_shaman_mystic_snake:OnIntervalThink()
	if not IsServer() then return end
	if self:GetStackCount()<=0 then
		self:Destroy()
	end
end

function modifier_shaman_mystic_snake:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		--MODIFIER_EVENT_ON_TAKEDAMAGE
		--MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		--MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_shaman_mystic_snake:GetModifierIncomingDamage_Percentage( params )
	--[[if not IsServer() then return end
	self:PlayEffects()
	print("Damage: ")
	print(params.damage)
	if params.damage>self:GetStackCount() then
		local block = params.damage - self:GetStackCount()
		self:SetStackCount( self:GetStackCount()-params.damage )
		return block
	else
		self:SetStackCount( self:GetStackCount()-params.damage )
		return params.damage
	end]]
end

function modifier_shaman_mystic_snake:GetModifierTotal_ConstantBlock( params )
	if not IsServer() then return end
	self:PlayEffects()
	print("Damage: ")
	print(params.damage)
	if params.damage>self:GetStackCount() then
		local block = params.damage - self:GetStackCount()
		self:SetStackCount( self:GetStackCount()-params.damage )
		return block
	else
		self:SetStackCount( self:GetStackCount()-params.damage )
		return params.damage
	end
end

function modifier_shaman_mystic_snake:GetModifierPhysicalArmorBonus()
	--return  self.bonus_armor
end

function modifier_shaman_mystic_snake:GetModifierMagicalResistanceBonus()
	--return  self.magic_resistance
end

function modifier_shaman_mystic_snake:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end

function modifier_shaman_mystic_snake:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_shaman_mystic_snake:PlayEffects( damage )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf"
	local sound_cast = "Hero_Medusa.ManaShield.Proc"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( damage, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end