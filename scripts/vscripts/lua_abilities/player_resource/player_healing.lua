player_healing = class ({})

LinkLuaModifier( "modifier_player_healing", "lua_abilities/player_resource/modifier_player_healing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_player_healing_overhead", "lua_abilities/player_resource/modifier_player_healing_overhead", LUA_MODIFIER_MOTION_NONE )

function player_healing:GetIntrinsicModifierName()
	return "modifier_player_healing"
end

function player_healing:OnHeroCalculateStatBonus()
	if self:GetLevel()<1 then
        self:SetLevel(1)
    end
end

function player_healing:OnUpgrade()
   --[[self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_player_healing_overhead",
		{}
	)]]
end
