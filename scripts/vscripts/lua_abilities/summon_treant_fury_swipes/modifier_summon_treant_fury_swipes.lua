modifier_summon_treant_fury_swipes = class({})

--------------------------------------------------------------------------------

function modifier_summon_treant_fury_swipes:IsHidden()
	return true
end

function modifier_summon_treant_fury_swipes:IsDebuff()
	return false
end

function modifier_summon_treant_fury_swipes:IsPurgable()
	return false
end

function modifier_summon_treant_fury_swipes:OnCreated( kv )
	if IsServer() then
		-- get reference
		self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
		self.bonus_reset_time = self:GetAbility():GetSpecialValueFor("bonus_reset_time")
	end
end

function modifier_summon_treant_fury_swipes:OnRefresh( kv )
	if IsServer() then
		-- get reference
		self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
		self.bonus_reset_time = self:GetAbility():GetSpecialValueFor("bonus_reset_time")
	end
end

function modifier_summon_treant_fury_swipes:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	}

	return funcs
end

function modifier_summon_treant_fury_swipes:GetModifierProcAttack_BonusDamage_Magical( params )
	if IsServer() then
		-- get target
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end

		--target:IsMagicImmune()==false
		local stack = 0
		local modifier = target:FindModifierByName("modifier_summon_treant_fury_swipes_debuff")

		-- add stack if not
		if target:IsMagicImmune()==false then
			if modifier==nil then
				-- if does not have break
				if not self:GetParent():PassivesDisabled() then
					local stack_duration = self.bonus_reset_time
					-- add modifier
					target:AddNewModifier(
						self:GetAbility():GetCaster(),
						self:GetAbility(),
						"modifier_summon_treant_fury_swipes_debuff",
						{ duration = stack_duration }
					)

					-- get stack number
					stack = 1
				end
			else
				-- increase stack
				modifier:IncrementStackCount()
				modifier:ForceRefresh()

				-- get stack number
				stack = modifier:GetStackCount()
			end

			-- return damage bonus
			return stack * self.damage_per_stack
		end
	else
		return 0
	end
end
