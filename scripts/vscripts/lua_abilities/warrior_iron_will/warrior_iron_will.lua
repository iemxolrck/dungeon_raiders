warrior_iron_will = class({})

LinkLuaModifier( "modifier_warrior_iron_will", "lua_abilities/warrior_iron_will/modifier_warrior_iron_will", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warrior_iron_will_min", "lua_abilities/warrior_iron_will/modifier_warrior_iron_will_min", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warrior_iron_will_buff", "lua_abilities/warrior_iron_will/modifier_warrior_iron_will_buff", LUA_MODIFIER_MOTION_NONE )

function warrior_iron_will:GetIntrinsicModifierName()
	return "modifier_warrior_iron_will"
end 

function warrior_iron_will:OnUpgrade()
	if self:GetLevel()==1 then
		self:GetCaster():AddNewModifier(
				self:GetCaster(),
				self,
				"modifier_warrior_iron_will_min",
				{ }
			)
	end
end 