cleric_channel_divinity = class({})

LinkLuaModifier( "modifier_cleric_channel_divinity", "lua_abilities/cleric_channel_divinity/modifier_cleric_channel_divinity", LUA_MODIFIER_MOTION_NONE )

function cleric_channel_divinity:GetManaCost()
	if self:GetLevel()>0 then
		return self:GetCaster():GetMana()
	else
		return 0
	end
end

function cleric_channel_divinity:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local buffDuration = self:GetSpecialValueFor("duration")

	for i=0,caster:GetAbilityCount()-1 do
		local ability = caster:GetAbilityByIndex( i )
		if ability and ability:GetAbilityType()~=DOTA_ABILITY_TYPE_ATTRIBUTES
			and ability~=caster:FindAbilityByName( "cleric_channel_divinity")
			and ability:IsPassive()~=true then
			ability:RefreshCharges()
			ability:EndCooldown()
		end
	end

	caster:AddNewModifier(
		caster,
		self,
		"modifier_cleric_channel_divinity",
		{ duration = buffDuration }
	)

	local sound_cast = "Hero_Omniknight.GuardianAngel.Cast"
	EmitSoundOn( sound_cast, caster )
	
end

