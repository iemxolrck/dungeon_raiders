engineer_station_bot = class({})

LinkLuaModifier( "modifier_engineer_station_bot", "lua_abilities/engineer_station_bot/modifier_engineer_station_bot",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_summon_bot", "lua_abilities/generic/modifier_generic_summon_bot",LUA_MODIFIER_MOTION_NONE )

engineer_station_bot.station_track = {}

function engineer_station_bot:GetIntrinsicModifierName()
	return "modifier_engineer_station_bot"
end
--[[
function engineer_station_bot:OnInventoryContentsChanged()
	local has_seed = self:GetCaster():HasItemInInventory("item_treant_seed")
	if has_seed then
		self:SetActivated( true )
	else
		self:SetActivated( false )
	end
end
]]

function engineer_station_bot:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function engineer_station_bot:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()

	--caster:FindItemInInventory("item_treant_seed"):SpendCharge()

	if bInterrupted then return end

	self:Summoning( caster, target )
	self:PlayEffects( caster, distance, target )
	
end

function engineer_station_bot:Summoning( caster, target )
	if IsServer() then
		local summon_station = CreateUnitByName( "npc_dota_station_bot", target, true, caster, caster:GetOwner(), caster:GetTeamNumber() )
		summon_station:SetControllableByPlayer( caster:GetPlayerID(), false )
		summon_station:SetOwner( caster )
		table.insert( engineer_station_bot.station_track, summon_station )
		--[[summon_station:AddNewModifier( 
			caster,
			self,
			"modifier_generic_summon_bot",
			{ }
		)]]

		local count = summon_station:GetAbilityCount()
		local ability_level = self:GetLevel()
		for i=0, count-1 do
			if summon_station:GetAbilityByIndex(i)==nil then break end
			summon_station:GetAbilityByIndex(i):SetLevel(ability_level)
		end
	end
end

function engineer_station_bot:PlayEffects( caster , distance, target )

	local origin = self:GetCaster():GetAbsOrigin()
	local particle_effect = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"

	local nFXIndex = ParticleManager:CreateParticle( particle_effect, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_staff_base", caster:GetOrigin(), true )

	ParticleManager:SetParticleControl( nFXIndex, 1, target )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( distance, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOnLocationWithCaster( target, "Hero_Furion.ForceOfNature", caster )
end

function engineer_station_bot:OnHeroCalculateStatBonus()
	if self:GetLevel()>=1 and self:GetCaster():HasModifier("modifier_engineer_station_bot")==false then
       self:GetCaster():AddNewModifier( 
		self:GetCaster(),
		self,
		"modifier_engineer_station_bot",
		{ }
	)
    end
end