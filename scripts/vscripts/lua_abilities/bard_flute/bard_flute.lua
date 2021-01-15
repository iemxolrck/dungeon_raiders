bard_flute = class({})

LinkLuaModifier("modifier_bard_flute","lua_abilities/bard_flute/modifier_bard_flute",LUA_MODIFIER_MOTION_NONE)

function bard_flute:GetIntrinsicModifierName()
	--return "modifier_bard_flute"
end

function bard_flute:OnSpellStart()

	local caster = self:GetCaster()
	
	local ability_main_0 ="bard_flute"
	local ability_main_1 = "bard_lullaby"
	local ability_main_2 = "bard_song_of_restoration"

	local ability_sub_0 = "bard_guitar"
	local ability_sub_1 = "bard_hypnotize"	
	local ability_sub_2 = "bard_whispers"

	
	if caster:HasModifier("modifier_bard_guitar") then
		caster:FindModifierByName("modifier_bard_guitar"):Destroy()
	end
	if caster:HasModifier("modifier_bard_lyre") then
		caster:FindModifierByName("modifier_bard_lyre"):Destroy()
	end
	caster:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_bard_flute",
		{}
	)

	if caster:FindAbilityByName("bard_lullaby"):IsHidden()==true
		and caster:FindAbilityByName("bard_hypnotize"):IsHidden()==true
		and caster:FindAbilityByName("bard_bewilder"):IsHidden()==true then
			ability_main_1 = "bard_song_of_restoration"
			ability_sub_1 = "bard_whispers"

	end

	if caster:FindAbilityByName("bard_song_of_restoration"):IsHidden()==true
		and caster:FindAbilityByName("bard_whispers"):IsHidden()==true
		and caster:FindAbilityByName("bard_haste"):IsHidden()==true then
			ability_main_1 = "bard_lullaby"
			ability_sub_1 = "bard_hypnotize"
	end

	self:GetCaster():SwapAbilities( ability_main_0, ability_sub_0, false , true )
	self:GetCaster():SwapAbilities( ability_main_1, ability_sub_1, false , true )
	--self:GetCaster():SwapAbilities( ability_main_2, ability_sub_2, false , true )

end

function bard_flute:OnHeroCalculateStatBonus()
	if self:GetLevel()<1 then
        self:SetLevel(self:GetMaxLevel())
    end
end