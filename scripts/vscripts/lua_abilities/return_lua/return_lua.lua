return_lua = class({})

LinkLuaModifier( "modifier_heal_received", "lua_abilities/return_lua/modifier_heal_received", LUA_MODIFIER_MOTION_NONE )

	lvlxp ={
		1,	
		2,	
		3,	
		4,	
		5,	
		6,	
		7,	
		8,	
		9,	
		10,	
		11,	
		12,	
		13,	
		14,	
		15,	
		16,	
		18,	
		20,	
		25,	
		30,	
	}

function return_lua:GetIntrinsicModifierName()
    return "modifier_heal_received"
end

function return_lua:OnHeroLevelUp()
	local caster = self:GetCaster()
	local points = caster:GetAbilityPoints()
	local level = caster:GetLevel()
	local add = 1

	for i=0, 19 do
		if lvlxp[i]==level then
			add = 0			
			break
		end
	end

	if add==1 then
		self:PlayEffects()
	end
	
	caster:SetAbilityPoints(points + add)
	caster:Heal(caster:GetMaxHealth(), nil)
	caster:GiveMana(caster:GetMaxMana())
	self:PlayEffects3()
end

function return_lua:OnSpellStart()
	local caster = self:GetCaster()

	local cleric = "modifier_cleric_base"
	local exorcist = "modifier_exorcist_base"
	local paladin = "modifier_paladin_base"
	local priest = "modifier_priest_base"

	local ability_main_0 = ""
	local ability_main_1 = ""
	local ability_main_2 = ""
	local ability_main_3 = "return_lua"
	local ability_main_4 = ""
	local ability_main_5 = ""

	if caster:HasModifier(cleric) then

		ability_main_0 = "cleric_bless"
		ability_main_1 = "cleric_dispel"
		ability_main_2 = "cleric_heal"
		ability_main_5 = "cleric_smite"
	end

	if caster:HasModifier(exorcist) then

		ability_main_0 = "exorcist_banish"
		ability_main_1 = "exorcist_exorcise"
		ability_main_2 = "exorcist_heavens_swords"
		ability_main_4 = "exorcist_repel"
		ability_main_5 = "exorcist_revelation"
	end

	if caster:HasModifier(paladin) then
		print("true")
		ability_main_0 = "paladin_holy_smite"
		ability_main_1 = "paladin_iron_skin"
		ability_main_2 = "paladin_judgment"
		ability_main_4 = "paladin_retribution"
		ability_main_5 = "paladin_sanctuary"
	end

	if caster:HasModifier(priest) then
		print("true")
		ability_main_0 = "priest_blessing"
		ability_main_1 = "priest_divine_protection"
		ability_main_2 = "priest_mass_heal"
		ability_main_4 = "priest_restoration"
		ability_main_5 = "priest_turn_undead"
	end	
	print("true")

	local ability_sub_0 = "cleric_base" 
	local ability_sub_1 = "priest_base" 
	local ability_sub_2 = "paladin_base" 
	local ability_sub_3 = "cleric_empty_0" 
	local ability_sub_4 = "cleric_empty_1" 
	local ability_sub_5 = "exorcist_base" 

	self:GetCaster():SwapAbilities( ability_main_0, ability_sub_0, false , true )
	self:GetCaster():SwapAbilities( ability_main_1, ability_sub_1, false , true )
	self:GetCaster():SwapAbilities( ability_main_2, ability_sub_2, false , true )
	self:GetCaster():SwapAbilities( ability_main_3, ability_sub_3, false , false )
	self:GetCaster():SwapAbilities( ability_main_4, ability_sub_4, false , false )
	self:GetCaster():SwapAbilities( ability_main_5, ability_sub_5, false , true )

	caster:RemoveModifierByName(cleric)
	caster:RemoveModifierByName(exorcist)
	caster:RemoveModifierByName(paladin)
	caster:RemoveModifierByName(priest)
end

function return_lua:PlayEffects()

	local particle_cast = "particles/generic_hero_status/hero_levelup.vpcf"
	local nFXIndex = ParticleManager:CreateParticle( particle_cast , PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

end

function return_lua:PlayEffects2()
	
	local particle_cast_0 = "particles/econ/events/ti8/hero_levelup_ti8_godray.vpcf"
	local nFXIndex0 = ParticleManager:CreateParticle( particle_cast_0 , PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex0, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex0 )

	local particle_cast_1 = "particles/econ/events/ti9/hero_levelup_ti9_godray.vpcf"
	local nFXIndex1 = ParticleManager:CreateParticle( particle_cast_1 , PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex1, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex1 )

end

function return_lua:PlayEffects3()
	local particle_cast_1 = "particles/econ/events/ti6/hero_levelup_ti6_godray.vpcf"
	local nFXIndex1 = ParticleManager:CreateParticle( particle_cast_1 , PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex1, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex1 )

	EmitSoundOn( "General.LevelUp.Bonus", self:GetCaster() )

end

function return_lua:OnHeroCalculateStatBonus()
    if self:GetLevel()<1 then
        self:SetLevel(1)
    end
end