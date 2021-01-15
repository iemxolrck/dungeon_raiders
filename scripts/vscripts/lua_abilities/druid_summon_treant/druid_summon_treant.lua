druid_summon_treant = class({})

LinkLuaModifier( "modifier_druid_summon_treant", "lua_abilities/druid_summon_treant/modifier_druid_summon_treant",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_summon_timer", "lua_abilities/generic/modifier_generic_summon_timer",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_summon", "lua_abilities/generic/modifier_generic_summon",LUA_MODIFIER_MOTION_NONE )

druid_summon_treant.treant_track = {}

function druid_summon_treant:GetIntrinsicModifierName()
	return "modifier_druid_summon_treant"
end

function druid_summon_treant:OnInventoryContentsChanged()
	local has_seed = self:GetCaster():HasItemInInventory("item_treant_seed")
	if has_seed then
		self:SetActivated( true )
	else
		self:SetActivated( false )
	end
end

function druid_summon_treant:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	local multiplier = (caster:GetLevel()-1)*(0.50-0.01)/(100-1)

	caster:FindItemInInventory("item_treant_seed"):SpendCharge()

	local distance = self:GetSpecialValueFor( "distance" )
	local front = caster:GetForwardVector():Normalized()
	local target = caster:GetOrigin() + front * distance

	self:Summoning( caster, target, duration, multiplier )
	self:PlayEffects( caster, distance, target )
	
end

function druid_summon_treant:Summoning( caster, target, duration, multiplier )
	if IsServer() then
		local summon_treant = CreateUnitByName( "npc_dota_druid_treant", target, true, caster, caster:GetOwner(), caster:GetTeamNumber() )
		--summon_treant:CreatureLevelUp(self:GetCaster():GetLevel() - 1)
		summon_treant:SetControllableByPlayer( caster:GetPlayerID(), false )
		summon_treant:SetOwner( caster )
		summon_treant:SetModelScale(summon_treant:GetModelScale() + multiplier)
		table.insert( druid_summon_treant.treant_track, summon_treant )
		summon_treant:AddNewModifier( 
			caster,
			self,
			"modifier_generic_summon",
			{ }
		)
		summon_treant:AddNewModifier( 
			caster,
			self,
			"modifier_generic_summon_timer",
			{ duration = duration }
		)
		summon_treant:SetModifierStackCount("modifier_generic_summon_timer", self, 1 )
		local count = summon_treant:GetAbilityCount()
		local ability_level = self:GetLevel()
		for i=0, count-1 do
			if summon_treant:GetAbilityByIndex(i)==nil then break end
			summon_treant:GetAbilityByIndex(i):SetLevel(ability_level)
		end
	end
end

function druid_summon_treant:PlayEffects( caster , distance, target )

	local origin = self:GetCaster():GetAbsOrigin()
	local particle_effect = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"

	local nFXIndex = ParticleManager:CreateParticle( particle_effect, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_staff_base", caster:GetOrigin(), true )

	ParticleManager:SetParticleControl( nFXIndex, 1, target )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( distance, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOnLocationWithCaster( target, "Hero_Furion.ForceOfNature", caster )
end

function druid_summon_treant:OnHeroCalculateStatBonus()
	if self:GetLevel()>=1 and self:GetCaster():HasModifier("modifier_druid_summon_treant")==false then
       self:GetCaster():AddNewModifier( 
		self:GetCaster(),
		self,
		"modifier_druid_summon_treant",
		{ }
	)
    end
end