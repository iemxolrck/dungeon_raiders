modifier_paladin_iron_skin = class({})

function modifier_paladin_iron_skin:IsHidden()
	return false
end

function modifier_paladin_iron_skin:IsDebuff()
	return false
end

function modifier_paladin_iron_skin:IsPurgable()
	return true
end

function modifier_paladin_iron_skin:OnCreated( kv )
	self.damage_resistance = -self:GetAbility():GetSpecialValueFor( "damage_resistance" )
	self.reduction = self:GetAbility():GetSpecialValueFor( "reduction" ) / 100
	if IsServer() then
		self.sound_cast = "Hero_Omniknight.Repel"
		EmitSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_paladin_iron_skin:OnRefresh( kv )
	self:OnCreated( kv )
	
end

function modifier_paladin_iron_skin:OnDestroy( kv )
	if IsServer() then
		StopSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_paladin_iron_skin:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_paladin_iron_skin:GetModifierIncomingDamage_Percentage( params )
	if not IsServer() then return end
	if params.damage_type==DAMAGE_TYPE_MAGICAL then
		return self.damage_resistance
	else
		return self.damage_resistance / self.reduction
	end
end

function modifier_paladin_iron_skin:GetModifierMoveSpeedBonus_Percentage()
	local bonus = 5
	if self:GetParent():GetAbsOrigin().z <= 0.5 then
		bonus = bonus + 100
	end
	return bonus
end

function modifier_paladin_iron_skin:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf"
end

function modifier_paladin_iron_skin:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end