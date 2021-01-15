modifier_neutral_gain = class({})

function modifier_neutral_gain:IsHidden()
	return false
end

function modifier_neutral_gain:IsDebuff()
	return false
end

function modifier_neutral_gain:IsPurgable()
	return false
end

function modifier_neutral_gain:OnCreated()
	self.counter = 0
	self.base_health = 1
	self.base_attack = 1
	self.base_armor = 1
	self.base_attack_damage_gain = 0.10
	self.base_health_gain = 8
	self.health = 0
	self.base_physical_armor_gain = 1
	self.base_magic_resist_gain = 1.5
	if IsServer() then
		self.base_health = self:GetParent():GetBaseMaxHealth()
		self.base_attack = ( self:GetParent():GetBaseDamageMax() + self:GetParent():GetBaseDamageMin() ) / 2
		self.base_armor = self:GetParent():GetPhysicalArmorBaseValue()
	end
	self:StartIntervalThink(0)
end

function modifier_neutral_gain:OnDestroy()
	
end

function modifier_neutral_gain:OnIntervalThink()
	if IsServer() then
		--print(self.base_health)
		local time = GameRules:GetDOTATime(false, false) - 1
		time = math.floor(time/120)
		time = math.min(time-1,120)
		self:SetStackCount(time)
		local armor = self.base_armor + ( self.base_physical_armor_gain * self:GetStackCount() )
		self:GetParent():SetPhysicalArmorBaseValue( math.min( armor , 50 ) )
		--[[if self:GetStackCount()>0 then
			if self.counter<self:GetStackCount() then
				local health_gain = 1 + ( ( self.base_health_gain * self:GetStackCount() ) / 100 )
				self.health = math.floor( self.base_health * health_gain )
				--print(self.health)
				local heal = self.health - self:GetParent():GetMaxHealth()
				self:GetParent():SetMaxHealth( self.health )
				--self:GetParent():SetHealth( self:GetParent():GetHealth() +  heal )
				
				--print(self.health)
				self.counter = self:GetStackCount()
			end
		end]]
	end
end

function modifier_neutral_gain:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_neutral_gain:GetModifierExtraHealthBonus()
	return 75 * self:GetStackCount()
end

function modifier_neutral_gain:GetModifierBaseAttack_BonusDamage()
	return math.floor( ( self.base_attack * self.base_attack_damage_gain ) * self:GetStackCount() )
end

function modifier_neutral_gain:GetModifierMagicalResistanceBonus()
	return math.min( self.base_magic_resist_gain * self:GetStackCount(), 75 )
end