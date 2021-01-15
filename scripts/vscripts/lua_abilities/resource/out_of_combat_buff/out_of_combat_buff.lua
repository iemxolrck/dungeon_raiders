out_of_combat_buff = class({})

LinkLuaModifier( "modifier_out_of_combat_buff", "lua_abilities/resource/out_of_combat_buff/modifier_out_of_combat_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_out_of_combat_buff_timer", "lua_abilities/resource/out_of_combat_buff/modifier_out_of_combat_buff_timer", LUA_MODIFIER_MOTION_NONE )

function out_of_combat_buff:GetIntrinsicModifierName()
	return "modifier_out_of_combat_buff"
end

function out_of_combat_buff:OnHeroCalculateStatBonus()
	if self:GetLevel()<1 then
        self:SetLevel(self:GetMaxLevel())
    end
end