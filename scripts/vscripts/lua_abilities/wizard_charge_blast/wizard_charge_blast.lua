wizard_charge_blast = class({})

LinkLuaModifier( "modifier_wizard_charge_blast_charge", "lua_abilities/wizard_charge_blast/modifier_wizard_charge_blast_charge", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_shocked", "lua_abilities/generic/modifier_generic_shocked", LUA_MODIFIER_MOTION_NONE )

function wizard_charge_blast:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function wizard_charge_blast:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function wizard_charge_blast:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	self.point = self:GetCursorPosition()

	caster:AddNewModifier(
		caster, 
		self, 
		"modifier_wizard_charge_blast_charge", 
		{
			x = self.point.x,
			y = self.point.y,
			z = self.point.z,
		} 
	)

	-- Play effects
	local sound_cast = "Hero_Invoker.EMP.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function wizard_charge_blast:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("area_of_effect")
	local damage = self:GetSpecialValueFor("damage")
	local drenched = 1 + ( self:GetSpecialValueFor("drenched_damage") / 100 )
	local manaburn = math.floor( damage * ( self:GetSpecialValueFor("manaburn_per_damage") / 100 ) )
	
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	damage = damage*channel_pct

	if caster:HasModifier("modifier_wizard_charge_blast_charge")==true then
		caster:RemoveModifierByName("modifier_wizard_charge_blast_charge")
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), self.point, radius, 5, false )

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		self.point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	local damageTable = {
		-- victim = target,
		attacker = caster,
		--damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	local burned = 0
	for _,enemy in pairs(enemies) do
		damageTable.damage = damage
		if enemy:GetMana()>0 then
			local mana = enemy:GetMana()
			local burn = math.min( mana, manaburn )
			enemy:ReduceMana(burn)
			damageTable.damage = damage + burn
		end
		damageTable.victim = enemy
		if enemy:HasModifier("modifier_generic_drenched") then
			damageTable.damage = math.floor(damageTable.damage * drenched)
		end 
		print(damageTable.damage)
		ApplyDamage(damageTable)
		if self:RollChance( 50 ) then 
			enemy:AddNewModifier(
				self:GetCaster(),
				self,
				"modifier_generic_shocked",
				{ duration = 10 }
			)
		end

	end

end

function wizard_charge_blast:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end