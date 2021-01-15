bard_guitar = class({})

LinkLuaModifier("modifier_bard_guitar","lua_abilities/bard_guitar/modifier_bard_guitar",LUA_MODIFIER_MOTION_NONE)

function bard_guitar:GetIntrinsicModifierName()
	--return "modifier_bard_guitar"
end

function bard_guitar:OnSpellStart()

	local caster = self:GetCaster()
	
	local ability_main_0 = "bard_guitar"
	local ability_main_1 = "bard_hypnotize" 
	local ability_main_2 = "bard_whispers"

	local ability_sub_0 = "bard_lyre"
	local ability_sub_1 = "bard_bewilder"
	local ability_sub_2 = "bard_haste"

	
	if caster:HasModifier("modifier_bard_lyre") then
		caster:FindModifierByName("modifier_bard_lyre"):Destroy()
	end
	if caster:HasModifier("modifier_bard_flute") then
		caster:FindModifierByName("modifier_bard_flute"):Destroy()
	end
	caster:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_bard_guitar",
		{}
	)

	if caster:FindAbilityByName("bard_lullaby"):IsHidden()==true
		and caster:FindAbilityByName("bard_hypnotize"):IsHidden()==true
		and caster:FindAbilityByName("bard_bewilder"):IsHidden()==true then
			ability_main_1 = "bard_whispers"
			ability_sub_1 = "bard_haste"

	end

	if caster:FindAbilityByName("bard_song_of_restoration"):IsHidden()==true
		and caster:FindAbilityByName("bard_whispers"):IsHidden()==true
		and caster:FindAbilityByName("bard_haste"):IsHidden()==true then
			ability_main_1 = "bard_hypnotize"
			ability_sub_1 = "bard_bewilder"
	end

	self:GetCaster():SwapAbilities( ability_main_0, ability_sub_0, false , true )
	self:GetCaster():SwapAbilities( ability_main_1, ability_sub_1, false , true )
	--self:GetCaster():SwapAbilities( ability_main_2, ability_sub_2, false , true )

end

function bard_guitar:OnHeroCalculateStatBonus()
	if self:GetLevel()<1 then
        self:SetLevel(self:GetMaxLevel())
    end
end