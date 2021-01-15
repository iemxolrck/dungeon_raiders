modifier_summon_golem_craggy_exterior = class ({})

function modifier_summon_golem_craggy_exterior:IsHidden()
	return true
end

function modifier_summon_golem_craggy_exterior:IsDebuff()
	return false
end

function modifier_summon_golem_craggy_exterior:IsPurgable()
	return false
end

function modifier_summon_golem_craggy_exterior:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.damage_reflected = self:GetAbility():GetSpecialValueFor( "damage_reflected" ) / 100
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function modifier_summon_golem_craggy_exterior:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.damage_reflected = self:GetAbility():GetSpecialValueFor( "damage_reflected" ) / 100
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function modifier_summon_golem_craggy_exterior:OnRemoved( kv )

end

function modifier_summon_golem_craggy_exterior:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_summon_golem_craggy_exterior:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_summon_golem_craggy_exterior:OnAttackLanded(params)
	if IsServer() then
		if params.target==self:GetParent() then
			local target = self:GetParent()
			local attacker = params.attacker
			local distance = (attacker:GetOrigin()-target:GetOrigin()):Length2D()
			local damage = params.damage * self.damage_reflected
			local damageTable = {
				victim = attacker,
				attacker = self:GetCaster(),
				damage = damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility(),
			}
			
			if distance<=self.radius and params.attacker:IsMagicImmune()==false then
				ApplyDamage( damageTable )
				if self:RollChance( self.proc_chance ) and self:GetAbility():IsCooldownReady() then
					params.attacker:AddNewModifier(
						self:GetParent(),
						self:GetAbility(),
						"modifier_generic_stunned",
						{ duration = self.duration}
					)
					self:GetAbility():UseResources(true, false, true)
				end
			end
		end
	end
end

function modifier_summon_golem_craggy_exterior:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end