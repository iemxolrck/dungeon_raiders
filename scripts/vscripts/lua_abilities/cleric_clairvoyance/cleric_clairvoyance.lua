cleric_clairvoyance = class({})

LinkLuaModifier("modifier_cleric_clairvoyance", "lua_abilities/cleric_clairvoyance/modifier_cleric_clairvoyance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleric_clairvoyance_buff", "lua_abilities/cleric_clairvoyance/modifier_cleric_clairvoyance_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleric_clairvoyance_aura", "lua_abilities/cleric_clairvoyance/modifier_cleric_clairvoyance_aura", LUA_MODIFIER_MOTION_NONE)

function cleric_clairvoyance:GetIntrinsicModifierName()
	return "modifier_cleric_clairvoyance"
end

function cleric_clairvoyance:OnUpgrade()
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_cleric_clairvoyance_buff",
		{}
	)
end