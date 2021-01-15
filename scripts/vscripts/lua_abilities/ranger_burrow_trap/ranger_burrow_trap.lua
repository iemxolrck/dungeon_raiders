ranger_burrow_trap = class({})

LinkLuaModifier( "modifier_ranger_burrow_trap_aura", "lua_abilities/ranger_burrow_trap/modifier_ranger_burrow_trap_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ranger_burrow_trap", "lua_abilities/ranger_burrow_trap/modifier_ranger_burrow_trap", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ranger_burrow_trap_damage", "lua_abilities/ranger_burrow_trap/modifier_ranger_burrow_trap_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ranger_burrow_trap_int", "lua_abilities/ranger_burrow_trap/modifier_ranger_burrow_trap_int", LUA_MODIFIER_MOTION_NONE )

ranger_burrow_trap.trap_track = {}

function ranger_burrow_trap:GetIntrinsicModifierName()
	return "modifier_ranger_burrow_trap"
end

function ranger_burrow_trap:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function ranger_burrow_trap:GetChannelTime()
	local channeltime = self:GetSpecialValueFor( "abilitychanneltime" )
	return channeltime
end

function ranger_burrow_trap:OnChannelFinish( bInterrupted )
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	if not bInterrupted then
		local burrow_trap = CreateUnitByName(
			"npc_dota_ranger_trap",
			point,
			false,
			caster,
			caster:GetOwner(),
			caster:GetTeamNumber()
		)
		burrow_trap:SetControllableByPlayer( caster:GetPlayerID(), false )
		burrow_trap:SetOwner( caster )
		table.insert( ranger_burrow_trap.trap_track, burrow_trap )
		
		burrow_trap:AddNewModifier( 
			caster,
			self,
			"modifier_ranger_burrow_trap_damage",
			{ }
		)
		burrow_trap:AddNewModifier( 
			caster,
			self,
			"modifier_ranger_burrow_trap_aura",
			{ }
		)
	end
end