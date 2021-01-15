modifier_generic_critical_strike = class({})

function modifier_generic_critical_strike:IsHidden()
	return true
end

function modifier_generic_critical_strike:IsDebuff()
	return false
end

function modifier_generic_critical_strike:IsPurgable()
	return false
end

function modifier_generic_critical_strike:OnCreated()
	self.modifier_critrate = { "modifier_bard_symphony_lyre", "modifier_bard_discord_lyre", "modifier_bard_finesse", "modifier_ranger_heighten_senses", "modifier_item_basic_spear", "modifier_item_basic_dagger" }
	self.crit_chance = 10
	self.crit_bonus = 200
	self:StartIntervalThink(0)
end

function modifier_generic_critical_strike:OnDestroy()
	
end

function modifier_generic_critical_strike:OnIntervalThink()
	if IsServer() then
		self.crit_chance = 10
		self.crit_bonus = 200
		local parent = self:GetParent()
		local buff_count = self.modifier_critrate
		local total_crit_damage = 0
		local total_critrate = 0

		if parent:HasModifier("modifier_bard_inspire_critrate")==true then
			local critrate = 1 + ( parent:FindModifierByName("modifier_bard_inspire_critrate"):GetStackCount() / 100 )
			if critrate~=nil then
				if critrate>=1 then
					self.crit_chance =  math.floor( self.crit_chance * critrate )
				else
					critrate = ( 1 - critrate ) + 1
					self.crit_chance =  math.floor( self.crit_chance / critrate )
				end
			end
		end
		if self.crit_chance<0 then
			self.crit_chance = 0
		end
		if self.crit_chance>75 then
			self.crit_chance = 75
		end

		for i=1, #buff_count do
			if parent:HasModifier(buff_count[i])==true then
				local modifier = parent:FindModifierByName(buff_count[i])
				local critrate = 1 + ( modifier:GetAbility():GetSpecialValueFor("critrate") / 100)
				if critrate~=nil then
					if critrate>=1 then
						self.crit_chance =  math.floor( self.crit_chance * critrate )
					else
						critrate = ( 1 - critrate ) + 1
						self.crit_chance =  math.floor( self.crit_chance / critrate )
					end
				end
			end
		end
		--self.crit_chance =  math.floor(self.crit_chance + total_critrate)
	end
	--[[if self:GetParent():IsRealHero()==true then
		print(self:GetParent():GetName())
		print(self.crit_chance)
	end]]
end

function modifier_generic_critical_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}

	return funcs
end

function modifier_generic_critical_strike:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if self:RollChance( self.crit_chance ) then
			local final = self.crit_bonus
			if self:GetParent():HasModifier("modifier_item_triple_head_crit")==true then 
				final = final * 2
			end
			self.record = params.record
			return final
		end
	end
end

function modifier_generic_critical_strike:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end

function modifier_generic_critical_strike:RollChance( chance )
	local rand = math.random()
	if self:GetParent():HasModifier("modifier_item_triple_head_crit")==true then return true end
	if rand<chance/100 then
		return true
	end
	return false
end

function modifier_generic_critical_strike:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinda_slow.vpcf"
	local sound_cast = "DOTA_Item.Daedelus.Crit"
	--local sound_cast = "Hero_BountyHunter.Jinada"

	-- Create Particle
	--[[local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	]]
	EmitSoundOn( sound_cast, target )
end