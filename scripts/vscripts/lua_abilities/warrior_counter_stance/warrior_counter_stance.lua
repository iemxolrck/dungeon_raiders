warrior_counter_stance = class({})

LinkLuaModifier( "modifier_warrior_counter_stance", "lua_abilities/warrior_counter_stance/modifier_warrior_counter_stance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warrior_counter_stance_strike", "lua_abilities/warrior_counter_stance/modifier_warrior_counter_stance_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warrior_counter_stance_animation", "lua_abilities/warrior_counter_stance/modifier_warrior_counter_stance_animation", LUA_MODIFIER_MOTION_NONE )

function warrior_counter_stance:GetIntrinsicModifierName()
	return "modifier_warrior_counter_stance"
end

function warrior_counter_stance:OnToggle()
	if self:GetToggleState() then
		self.modifier = self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_warrior_counter_stance_strike",
			{}
		)
	else
		if self.modifier then
			self.modifier:Destroy()
			self.modifier = nil
		end
	end
end

function warrior_counter_stance:OnUpgrade()
	if self.modifier then
		self.modifier:ForceRefresh()
	end
end