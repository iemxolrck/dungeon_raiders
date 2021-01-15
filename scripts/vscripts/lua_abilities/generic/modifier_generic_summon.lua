modifier_generic_summon = class({})

function modifier_generic_summon:IsHidden()
	return false
end

function modifier_generic_summon:IsDebuff()
	return false
end

function modifier_generic_summon:IsPurgable()
	return false
end

function modifier_generic_summon:OnCreated( event )
	--self:GetParent():CreatureLevelUp( 3 )
	if IsServer() then
		local unit_level = self:GetParent():GetLevel()
		self.pathing = false
		--modify health
		local mana_as_health = self:GetAbility():GetSpecialValueFor( "mana_as_health" ) / 100
		local summon_health = self:GetParent():GetBaseMaxHealth()
		mana_as_health = self:GetCaster():GetMaxMana() * mana_as_health
		self:GetParent():SetBaseMaxHealth( summon_health + mana_as_health )
		--modify max damage
		local summon_damage = self:GetAbility():GetSpecialValueFor( "summon_damage" ) / 100
		summon_damage = self:GetCaster():GetIntellect() * summon_damage
		self:GetParent():SetBaseDamageMax(summon_damage)
		--modify treant min damage
		if self:GetParent():GetUnitName()=="npc_dota_druid_treant" then
			self:GetParent():SetCustomHealthLabel( "Treant Warrior", 20, 255, 3 )
			self:GetParent():SetBaseDamageMin(summon_damage)
		end
		--modify golem min damage
		if self:GetParent():GetUnitName()=="npc_dota_druid_golem" then
			self.pathing = true
			self:GetParent():SetCustomHealthLabel( "Rock Golem", 255, 175, 3 )
			self:GetParent():SetBaseDamageMin(summon_damage)
			--self:StartIntervalThink(0)
		end
	end
end

function modifier_generic_summon:OnDestroy()
	
end

function modifier_generic_summon:OnIntervalThink()
	local base_max = self:GetParent():GetBaseDamageMax()
	local base_min = self:GetParent():GetBaseDamageMin()
	if self:GetParent():GetBaseDamageMax()-self:GetParent():GetBaseDamageMin()~=self:GetParent():GetBaseDamageMax() then
		if self:GetParent():GetBaseDamageMax()>self:GetParent():GetBaseDamageMin() then
			self:GetParent():SetBaseDamageMin(self:GetParent():GetBaseDamageMin()-1)
		end
		if self:GetParent():GetBaseDamageMax()<self:GetParent():GetBaseDamageMin() then
			self:GetParent():SetBaseDamageMin(self:GetParent():GetBaseDamageMin()+1)
		end
	end
end