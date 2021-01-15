modifier_summon_golem_rock_splash = class ({})

function modifier_summon_golem_rock_splash:IsHidden()
	return true
end

function modifier_summon_golem_rock_splash:IsDebuff()
	return false
end

function modifier_summon_golem_rock_splash:IsPurgable()
	return false
end

function modifier_summon_golem_rock_splash:OnCreated( kv )
	self.attack_range = self:GetAbility():GetSpecialValueFor( "attack_range" )
	self.splash_radius = self:GetAbility():GetSpecialValueFor( "splash_radius" )
	self.splash_damage = self:GetAbility():GetSpecialValueFor( "splash_damage" ) / 100
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_summon_golem_rock_splash:OnRefresh( kv )
	self.attack_range = self:GetAbility():GetSpecialValueFor( "attack_range" )
	self.splash_radius = self:GetAbility():GetSpecialValueFor( "splash_radius" )
	self.splash_damage = self:GetAbility():GetSpecialValueFor( "splash_damage" ) / 100
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_summon_golem_rock_splash:OnRemoved( kv )

end

function modifier_summon_golem_rock_splash:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	}

	return funcs
end

function modifier_summon_golem_rock_splash:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() and self:GetAbility():GetAbilityDamageType()==1 and self:GetAbility():IsCooldownReady() then
		local total = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) * self.splash_damage
		if self:RollChance( self.proc_chance ) and params.target:IsMagicImmune()==false then
			params.target:AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_generic_stunned",
				{ duration = self.duration}
			)
			self:GetAbility():UseResources(true, false, true)
			return total
		end
		return 0
	end
end

function modifier_summon_golem_rock_splash:GetModifierProcAttack_BonusDamage_Magical( params )
	if IsServer() and self:GetAbility():GetAbilityDamageType()==2 and self:GetAbility():IsCooldownReady() then
		local total = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) * self.splash_damage
		if self:RollChance( self.proc_chance ) and params.target:IsMagicImmune()==false then
			params.target:AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_generic_stunned",
				{ duration = self.duration}
			)
			self:GetAbility():UseResources(true, false, true)
			return total
		end
		return 0
	end
end

function modifier_summon_golem_rock_splash:GetModifierProcAttack_BonusDamage_Pure( params )
	if IsServer() and self:GetAbility():GetAbilityDamageType()==3 and self:GetAbility():IsCooldownReady() then
		local total = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) * self.splash_damage
		if self:RollChance( self.proc_chance ) and params.target:IsMagicImmune()==false then
			params.target:AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_generic_stunned",
				{ duration = self.duration}
			)
			self:GetAbility():UseResources(true, false, true)
			return total
		end
		return 0
	end
end

function modifier_summon_golem_rock_splash:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

function modifier_summon_golem_rock_splash:OnAttackLanded(params)
	if IsServer() then
		if params.attacker==self:GetParent() then
			local target = params.target
			local total = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())
			local damageTable = {
				attacker = self:GetCaster(),
				damage = 0,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility(),
			}

			local enemies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(),
				target:GetAbsOrigin(),
				nil,
				self.splash_radius,
				self:GetAbility():GetAbilityTargetTeam(),
				self:GetAbility():GetAbilityTargetType(),
				self:GetAbility():GetAbilityTargetFlags(),
				FIND_CLOSEST,
				false
			)
			total = ( total * self.splash_damage ) / (#enemies-1)

			for _, enemy in pairs(enemies) do
				if enemy~=target then
					damageTable.victim = enemy
					damageTable.damage = total
					ApplyDamage( damageTable )
				end
			end
		end
	end
end