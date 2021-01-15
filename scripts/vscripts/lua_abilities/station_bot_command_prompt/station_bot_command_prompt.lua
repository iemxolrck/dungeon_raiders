station_bot_command_prompt = class({})

LinkLuaModifier("modifier_station_bot_command_prompt", "lua_abilities/station_bot_command_prompt/modifier_station_bot_command_prompt", LUA_MODIFIER_MOTION_NONE)

function station_bot_command_prompt:GetIntrinsicModifierName()
	return "modifier_station_bot_command_prompt"
end