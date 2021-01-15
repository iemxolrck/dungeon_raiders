ranger_tame_beast = class({})

LinkLuaModifier( "modifier_ranger_tame_beast", "lua_abilities/ranger_tame_beast/modifier_ranger_tame_beast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ranger_tame", "lua_abilities/ranger_tame_beast/modifier_ranger_tame", LUA_MODIFIER_MOTION_NONE )

ranger_tame_beast.beast_track = {}

function ranger_tame_beast:GetIntrinsicModifierName()
	return "modifier_ranger_tame"
end

function ranger_tame_beast:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor("dominate_duration")

	if not target:IsRealHero() then

		table.insert( ranger_tame_beast.beast_track, target )

		target:AddNewModifier(
			caster,
			self,
			"modifier_ranger_tame_beast",
			{ }
		)

		target:Purge( false, true, false, false, false )

		if target:HasAbility("bird_circling")==true then
			target:FindAbilityByName("bird_circling"):SetLevel(1)
		end

		local sound_cast = "Hero_Enchantress.EnchantCreep"
		EmitSoundOn( sound_cast, target )
	end

	local sound_cast = "Hero_Enchantress.EnchantCast"
	EmitSoundOn( sound_cast, caster )
end