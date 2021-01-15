druid_summon_golem = class({})

LinkLuaModifier( "modifier_druid_summon_golem", "lua_abilities/druid_summon_golem/modifier_druid_summon_golem",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_summon_timer", "lua_abilities/generic/modifier_generic_summon_timer",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_summon", "lua_abilities/generic/modifier_generic_summon",LUA_MODIFIER_MOTION_NONE )

druid_summon_golem.golem_track = {}

function druid_summon_golem:GetIntrinsicModifierName()
	return "modifier_druid_summon_golem"
end

function druid_summon_golem:OnInventoryContentsChanged()
	local has_seed = self:GetCaster():HasItemInInventory("item_golem_core")
	if has_seed then
		self:SetActivated( true )
	else
		self:SetActivated( false )
	end
end

function druid_summon_golem:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	local multiplier = (caster:GetLevel()-1)*(0.50-0.01)/(100-1)

	caster:FindItemInInventory("item_golem_core"):SpendCharge()

	local distance = self:GetSpecialValueFor( "distance" )
	local front = caster:GetForwardVector():Normalized()
	local target = caster:GetOrigin() + front * distance

	self:Summoning( caster, target, duration, multiplier )
	self:PlayEffects( caster, distance, target )
	
end

function druid_summon_golem:Summoning( caster, target, duration, multiplier )
	local summon_golem = CreateUnitByName( "npc_dota_druid_golem", target, true, caster, caster:GetOwner(), caster:GetTeamNumber() )

	summon_golem:SetControllableByPlayer( caster:GetPlayerID(), false )
	summon_golem:SetOwner( caster )
	summon_golem:SetModelScale(summon_golem:GetModelScale() + multiplier)
	table.insert( druid_summon_golem.golem_track, summon_golem )
	summon_golem:AddNewModifier( 
		caster,
		self,
		"modifier_generic_summon",
		{ }
	)
	summon_golem:AddNewModifier( 
		caster,
		self,
		"modifier_generic_summon_timer",
		{ duration = duration }
	)
	summon_golem:SetModifierStackCount("modifier_generic_summon_timer", self, 1 )
	local count = summon_golem:GetAbilityCount()
		local ability_level = self:GetLevel()
		for i=0, count-1 do
			if summon_golem:GetAbilityByIndex(i)==nil then break end
			summon_golem:GetAbilityByIndex(i):SetLevel(ability_level)
		end

end

function druid_summon_golem:PlayEffects( caster , distance, target )

	local origin = self:GetCaster():GetAbsOrigin()
	local particle_effect = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"

	local nFXIndex = ParticleManager:CreateParticle( particle_effect, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_staff_base", caster:GetOrigin(), true )

	ParticleManager:SetParticleControl( nFXIndex, 1, target )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( distance, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOnLocationWithCaster( target, "Hero_Furion.ForceOfNature", caster )
end

function druid_summon_golem:OnHeroCalculateStatBonus()
	if self:GetLevel()>=1 and self:GetCaster():HasModifier("modifier_druid_summon_golem")==false then
       self:GetCaster():AddNewModifier( 
		self:GetCaster(),
		self,
		"modifier_druid_summon_golem",
		{ }
	)
    end
end