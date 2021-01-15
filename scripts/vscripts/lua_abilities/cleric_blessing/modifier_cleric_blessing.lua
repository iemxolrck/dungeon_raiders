modifier_cleric_blessing = class({})

function modifier_cleric_blessing:IsHidden()
	return false
end

function modifier_cleric_blessing:IsDebuff()
	return false
end

function modifier_cleric_blessing:IsPurgable()
	return true
end

function modifier_cleric_blessing:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_per_attack" )
	self:StartIntervalThink(0)
end

function modifier_cleric_blessing:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_per_attack" )
end

function modifier_cleric_blessing:OnDestroy( kv )
	if IsServer() then
		if self:GetParent():HasModifier("modifier_cleric_blessing_str") then
			self:GetParent():FindModifierByName("modifier_cleric_blessing_str"):Destroy()
		end
		if self:GetParent():HasModifier("modifier_cleric_blessing_agi") then
			self:GetParent():FindModifierByName("modifier_cleric_blessing_agi"):Destroy()
		end
		if self:GetParent():HasModifier("modifier_cleric_blessing_int") then
			self:GetParent():FindModifierByName("modifier_cleric_blessing_int"):Destroy()
		end
		StopSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_cleric_blessing:OnIntervalThink()
	if IsServer() then
		local ally = self:GetParent()
		local caster = self:GetCaster()
		local primary = 0
		local count = 0
		
		if ally==caster and ally:HasModifier("modifier_cleric_channel_divinity") then
	 		count = 1
	 	else
	 		count = 0
	 	end

		if ally:IsRealHero()==true then
			primary = ally:GetPrimaryAttribute()
			if ( primary==0 or count==1 ) and ally:HasModifier("modifier_cleric_blessing_str")==false then
				self:RemoveBonus( ally, primary, count )
				ally:AddNewModifier(
			        caster,   
			        self:GetAbility(),
			        "modifier_cleric_blessing_str", 
			        { }
	        	)
			end
			if ( primary==1 or count==1 ) and ally:HasModifier("modifier_cleric_blessing_agi")==false then
				self:RemoveBonus( ally, primary, count )
				ally:AddNewModifier(
			        caster,   
			        self:GetAbility(),
			        "modifier_cleric_blessing_agi", 
			        { }
	        	)
			end
			if ( primary==2 or count==1 ) and ally:HasModifier("modifier_cleric_blessing_int")==false then
				self:RemoveBonus( ally, primary, count )
				ally:AddNewModifier(
			        caster,   
			        self:GetAbility(),
			        "modifier_cleric_blessing_int", 
			        { }
	        	)
			end
		end
	end
end

function modifier_cleric_blessing:RemoveBonus( ally, primary, count )
	if count==0 then
		if primary==0 then
			if ally:HasModifier("modifier_cleric_blessing_agi") then
				ally:FindModifierByName("modifier_cleric_blessing_agi"):Destroy()
			end
			if ally:HasModifier("modifier_cleric_blessing_int") then
				ally:FindModifierByName("modifier_cleric_blessing_int"):Destroy()
			end
		end
		if primary==1 then
			if ally:HasModifier("modifier_cleric_blessing_str") then
				ally:FindModifierByName("modifier_cleric_blessing_str"):Destroy()
			end
			if ally:HasModifier("modifier_cleric_blessing_int") then
				ally:FindModifierByName("modifier_cleric_blessing_int"):Destroy()
			end
		end
		if primary==2 then
			if ally:HasModifier("modifier_cleric_blessing_str") then
				ally:FindModifierByName("modifier_cleric_blessing_str"):Destroy()
			end
			if ally:HasModifier("modifier_cleric_blessing_agi") then
				ally:FindModifierByName("modifier_cleric_blessing_agi"):Destroy()
			end
		end
	end
end

function modifier_cleric_blessing:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_cleric_blessing:GetModifierProcAttack_BonusDamage_Magical( params, keys )
	if IsServer() then
		local target = params.target
		local result = UnitFilter(
			target,	-- Target Filter
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- Team Filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- Unit Filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- Unit Flag
			self:GetParent():GetTeamNumber()	-- Team reference
		)
	
		if result == UF_SUCCESS then
			local total_damage = self:GetCaster():GetMaxMana()*(self.damage/100)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, total_damage, nil)
			return total_damage
		end

	end
end

function modifier_cleric_blessing:OnTooltip()
	local total_damage = self:GetCaster():GetMaxMana()*(self.damage/100)
	return total_damage
end

function modifier_cleric_blessing:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_beam.vpcf"
end

function modifier_cleric_blessing:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end