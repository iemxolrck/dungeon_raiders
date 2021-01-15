modifier_station_bot_command_prompt = class ({})
modifier_station_bot_command_prompt.skill = nil

function modifier_station_bot_command_prompt:IsHidden()
	return true
end

function modifier_station_bot_command_prompt:IsDebuff()
	return false
end

function modifier_station_bot_command_prompt:IsPurgable()
	return false
end

function modifier_station_bot_command_prompt:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.max_target = self:GetAbility():GetSpecialValueFor( "max_target" )
	end
end

function modifier_station_bot_command_prompt:OnRefresh( kv )

end

function modifier_station_bot_command_prompt:OnRemoved( kv )

end

function modifier_station_bot_command_prompt:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}

	return funcs
end

function modifier_station_bot_command_prompt:GetModifierIgnoreCastAngle()
	return true
end

function modifier_station_bot_command_prompt:GetModifierPercentageCasttime()
	return 100
end

function modifier_station_bot_command_prompt:OnAbilityFullyCast( params )
	if not IsServer() then return end

	local owner = self:GetParent():GetOwnerEntity()
	local sourceAbility = params.ability
	if params.unit ~= owner then return end

	if params.ability:GetName()=="engineer_station_bot" then return end

	-- only spells that have target
	if not params.target then

		local selfAbility = nil
		
		if self:GetParent():HasAbility( sourceAbility:GetAbilityName() )==true then
			selfAbility = self:GetParent():FindAbilityByName( sourceAbility:GetAbilityName() )
			selfAbility:SetLevel( sourceAbility:GetLevel() )
		else
			selfAbility = self:GetParent():AddAbility( sourceAbility:GetAbilityName() )
			selfAbility:SetLevel( sourceAbility:GetLevel() )
			selfAbility:SetStolen( true )
			selfAbility:SetHidden( true )
		end

		self.copy_spell = selfAbility
		selfAbility:CastAbility()
		--print(params.ability:GetName())
		return
	end

	if bit.band( params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then return end
	if bit.band( params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET ) ~= 0 then return end
	
	local selfAbility = nil
	
	if self:GetParent():HasAbility( sourceAbility:GetAbilityName() )==true then
		selfAbility = self:GetParent():FindAbilityByName( sourceAbility:GetAbilityName() )
		selfAbility:SetLevel( sourceAbility:GetLevel() )
	else
		selfAbility = self:GetParent():AddAbility( sourceAbility:GetAbilityName() )
		selfAbility:SetLevel( sourceAbility:GetLevel() )
		selfAbility:SetStolen( true )
		selfAbility:SetHidden( true )
	end
	
	self.copy_spell = selfAbility

	if params.target:GetTeamNumber()==owner:GetTeamNumber() then
		local allies = FindUnitsInRadius(
			owner:GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			self:GetAbility():GetAbilityTargetType(),
			self:GetAbility():GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false
		)

		for _,ally in pairs(allies) do
			self:GetParent():SetCursorCastTarget( ally )
			--print(ally:GetName())
			--print(params.ability:GetName())
			self:GetParent():SetCursorCastTarget( ally )
			selfAbility:CastAbility()
		end
	else
		local enemies = FindUnitsInRadius(
			owner:GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			self:GetAbility():GetAbilityTargetType(),
			self:GetAbility():GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false
		)

		for _,enemy in pairs(enemies) do
			self:GetParent():SetCursorCastTarget( enemy )
			--print(enemy:GetName())
			--print(params.ability:GetName())
			self:GetParent():SetCursorCastTarget( enemy )
			selfAbility:CastAbility()
		end
	end

end