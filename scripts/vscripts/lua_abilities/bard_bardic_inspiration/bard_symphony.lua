bard_symphony = class({})

LinkLuaModifier( "bard_symphony_cancel", "lua_abilities/bard_symphony/bard_symphony_cancel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_symphony", "lua_abilities/bard_symphony/modifier_bard_symphony", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_symphony_flute_aura", "lua_abilities/bard_symphony/modifier_bard_symphony_flute_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_symphony_flute", "lua_abilities/bard_symphony/modifier_bard_symphony_flute", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_symphony_guitar_aura", "lua_abilities/bard_symphony/modifier_bard_symphony_guitar_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_symphony_guitar", "lua_abilities/bard_symphony/modifier_bard_symphony_guitar", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_symphony_lyre_aura", "lua_abilities/bard_symphony/modifier_bard_symphony_lyre_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_symphony_lyre", "lua_abilities/bard_symphony/modifier_bard_symphony_lyre", LUA_MODIFIER_MOTION_NONE )

function bard_symphony:OnSpellStart()
	local caster = self:GetCaster()
	local ability_main_0 = "bard_symphony"
	local ability_sub_0 = "bard_symphony_cancel" 
	local modifier = caster:FindModifierByName("modifier_bard_discord")

	if modifier then
		caster:FindAbilityByName("bard_discord_cancel"):OnSpellStart()
	end
	
	caster:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_bard_symphony",
		nil
		)

	caster:SwapAbilities( ability_main_0, ability_sub_0, false , true )
end