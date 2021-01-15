level_plus = class({})

LinkLuaModifier( "modifier_level_plus", LUA_MODIFIER_MOTION_NONE )

function level_plus:GetIntrinsicModifierName()
	--if self:GetCaster():GetName()=="npc_dota_roam" then
	return "modifier_level_plus"
end

function level_plus:OnHeroCalculateStatBonus()
	if self:GetLevel()==0 then
		self:SetLevel(self:GetMaxLevel())
	end
	if self:GetCaster():FindAbilityByName("phoenix_icarus_dive"):GetLevel()==0 then
		self:GetCaster():FindAbilityByName("phoenix_icarus_dive"):SetLevel(self:GetMaxLevel())
	end
end