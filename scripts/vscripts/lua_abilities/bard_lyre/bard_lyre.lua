bard_lyre = class({})

LinkLuaModifier("modifier_bard_lyre","lua_abilities/bard_lyre/modifier_bard_lyre",LUA_MODIFIER_MOTION_NONE)

function bard_lyre:GetIntrinsicModifierName()
	return "modifier_bard_lyre"
end

function bard_lyre:OnSpellStart()
	
	local caster = self:GetCaster()
	
	local ability_main_0 ="bard_lyre"
	local ability_main_1 ="bard_bewilder"
	local ability_main_2 ="bard_haste"

	local ability_sub_0 = "bard_flute"
	local ability_sub_1 = "bard_lullaby"
	local ability_sub_2 = "bard_song_of_restoration"

	
	if caster:HasModifier("modifier_bard_flute") then	
		caster:FindModifierByName("modifier_bard_flute"):Destroy()
	end
	if caster:HasModifier("modifier_bard_guitar") then
		caster:FindModifierByName("modifier_bard_guitar"):Destroy()
	end
	 caster:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_bard_lyre",
		{}
	)

	if caster:FindAbilityByName("bard_lullaby"):IsHidden()==true
		and caster:FindAbilityByName("bard_hypnotize"):IsHidden()==true
		and caster:FindAbilityByName("bard_bewilder"):IsHidden()==true then
			ability_main_1 = "bard_haste"
			ability_sub_1 = "bard_song_of_restoration"

	end

	if caster:FindAbilityByName("bard_song_of_restoration"):IsHidden()==true
		and caster:FindAbilityByName("bard_whispers"):IsHidden()==true
		and caster:FindAbilityByName("bard_haste"):IsHidden()==true then
			ability_main_1 = "bard_bewilder"
			ability_sub_1 = "bard_lullaby"
	end

	self:GetCaster():SwapAbilities( ability_main_0, ability_sub_0, false , true )
	self:GetCaster():SwapAbilities( ability_main_1, ability_sub_1, false , true )
	--self:GetCaster():SwapAbilities( ability_main_2, ability_sub_2, false , true )

end

function bard_lyre:OnHeroCalculateStatBonus()
	if self:GetLevel()<1 then
        self:SetLevel(self:GetMaxLevel())
    end
end