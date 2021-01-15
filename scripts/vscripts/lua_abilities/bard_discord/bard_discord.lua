bard_discord = class({})

LinkLuaModifier( "bard_discord_cancel", "lua_abilities/bard_discord/bard_discord_cancel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_discord", "lua_abilities/bard_discord/modifier_bard_discord", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_discord_flute_aura", "lua_abilities/bard_discord/modifier_bard_discord_flute_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_discord_flute", "lua_abilities/bard_discord/modifier_bard_discord_flute", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_discord_guitar_aura", "lua_abilities/bard_discord/modifier_bard_discord_guitar_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_discord_guitar", "lua_abilities/bard_discord/modifier_bard_discord_guitar", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_discord_lyre_aura", "lua_abilities/bard_discord/modifier_bard_discord_lyre_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bard_discord_lyre", "lua_abilities/bard_discord/modifier_bard_discord_lyre", LUA_MODIFIER_MOTION_NONE )

function bard_discord:OnSpellStart()
	local caster = self:GetCaster()
	local ability_main_0 = "bard_discord"
	local ability_sub_0 = "bard_discord_cancel"

	local ability_buff = ""
	local ability_debuff = ""

	local modifier = caster:FindModifierByName("modifier_bard_symphony")

	if modifier then
		caster:FindAbilityByName("bard_symphony_cancel"):OnSpellStart()
	end

	caster:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_bard_discord",
		nil
		)

	if caster:HasModifier("modifier_bard_lyre") then
		ability_buff = "bard_lullaby"
		ability_debuff = "bard_song_of_restoration"
	end
	if caster:HasModifier("modifier_bard_flute") then
		ability_buff = "bard_hypnotize"
		ability_debuff = "bard_whispers"
	end
	if caster:HasModifier("modifier_bard_guitar") then
		ability_buff = "bard_bewilder"
		ability_debuff = "bard_haste"
	end

	caster:SwapAbilities( ability_main_0, ability_sub_0, false , true )
	if not caster:FindAbilityByName("bard_song_of_restoration"):IsHidden()==true
		or not caster:FindAbilityByName("bard_whispers"):IsHidden()==true
		or not caster:FindAbilityByName("bard_haste"):IsHidden()==true then
			caster:SwapAbilities( ability_debuff, ability_buff, false , true )
	end
end