modifier_marksman_sniper = class({})

function modifier_marksman_sniper:IsHidden()
	return false
end

function modifier_marksman_sniper:IsDebuff()
	return false
end

function modifier_marksman_sniper:IsPurgable()
	return false
end

function modifier_marksman_sniper:OnCreated( kv )
	self.attack_range = self:GetAbility():GetSpecialValueFor( "attack_range" )
	self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
	self.damage_percent = self:GetAbility():GetSpecialValueFor( "damage_per_distance" )
	self.min_range = 500
end

function modifier_marksman_sniper:OnRefresh( kv )
	self.attack_range = self:GetAbility():GetSpecialValueFor( "attack_range" )
	self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
	self.damage_percent = self:GetAbility():GetSpecialValueFor( "damage_per_distance" )
	self.min_range = 500
end

function modifier_marksman_sniper:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_marksman_sniper:GetModifierAttackRangeBonus()
	return self.attack_range
end

function modifier_marksman_sniper:GetModifierCastRangeBonusStacking()
	return self.cast_range
end

function modifier_marksman_sniper:GetModifierTotalDamageOutgoing_Percentage( params )
	if not IsServer() then return end
	local target = params.target
	local parent = self:GetParent()
	local distance = math.floor( (parent:GetOrigin()-target:GetOrigin()):Length2D() )
	if distance<=self.min_range then return end
	local percent = math.floor(( distance - self.min_range ) / 7.5)
	local damage = percent * self.damage_percent
	--print(target:GetName())
	--print(distance)
	
	if params.inflictor==nil then 
		damage = damage / 2
	end
	--print(damage)
	return damage
end