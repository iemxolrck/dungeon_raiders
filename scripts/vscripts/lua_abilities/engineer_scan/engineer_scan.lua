engineer_scan = class({})

LinkLuaModifier( "modifier_engineer_scan", "lua_abilities/engineer_scan/modifier_engineer_scan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_engineer_scan_debuff", "lua_abilities/engineer_scan/modifier_engineer_scan_debuff", LUA_MODIFIER_MOTION_NONE )

function engineer_scan:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("scan_duration")

	caster:AddNewModifier(
        caster,   
        self,
        "modifier_engineer_scan", 
        { duration = duration }
    )

end