modifier_cleric_blessing_damage = class({})

function modifier_cleric_blessing_damage:IsHidden()
	return false
end

function modifier_cleric_blessing_damage:IsDebuff()
	return false
end

function modifier_cleric_blessing_damage:IsPurgable()
	return true
end

function modifier_cleric_blessing_damage:OnCreated( kv )
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName( "cleric_channel_divinity" )
	self.damage = ability:GetLevelSpecialValueFor( "damage_amp" , ability:GetLevel()-1 )
	self:SetStackCount(self.damage)
	if IsServer() then
		self.sound_cast = "Hero_Omniknight.Repel"
		EmitSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_cleric_blessing_damage:OnRefresh( kv )
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName( "cleric_channel_divinity" )
	self.damage = ability:GetLevelSpecialValueFor( "damage_amp" , ability:GetLevel()-1 )
	self:SetStackCount(self.damage)
	if IsServer() then
		self.sound_cast = "Hero_Omniknight.Repel"
		EmitSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_cleric_blessing_damage:OnDestroy( kv )
	if IsServer() then
		StopSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_cleric_blessing_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_cleric_blessing_damage:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetStackCount()
end

function modifier_cleric_blessing_damage:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf"
end

function modifier_cleric_blessing_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end