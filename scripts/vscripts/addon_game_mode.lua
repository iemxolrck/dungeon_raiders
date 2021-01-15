if DungeonRaider == nil then
    DungeonRaider = class({})
    _G.DungeonRaider = DungeonRaider
end

--require( "util" ) 

MAX_LVL = 100

XP_PER_LEVEL_TABLE = {
    0,          --  1
    250,        --  2
    510,        --  3
    780,        --  4
    1060,       --  5
    1350,       --  6
    1650,       --  7
    1960,       --  8
    2280,       --  9
    2610,       --  10
    2970,       --  11
    3360,       --  12
    3780,       --  13
    4230,       --  14
    4710,       --  15
    5220,       --  16
    5760,       --  17
    6330,       --  18
    6930,       --  19
    7560,       --  20
    8210,       --  21
    8910,       --  22
    9660,       --  23
    10460,      --  24
    11310,      --  25
    12210,      --  26
    13160,      --  27
    14160,      --  28
    15210,      --  29
    16310,      --  30
    17510,      --  31
    18810,      --  32
    20210,      --  33
    21710,      --  34
    23710,      --  35
    26010,      --  36
    28610,      --  37
    31510,      --  38
    34510,      --  39
    37510,      --  40
    40510,      --  41
    43810,      --  42
    47410,      --  43
    51310,      --  44
    55310,      --  45
    59510,      --  46
    63910,      --  47
    68510,      --  48
    73310,      --  49
    78310,      --  50
    79310,      --  51
    80410,      --  52
    81610,      --  53
    82910,      --  54
    84310,      --  55
    85810,      --  56
    87410,      --  57
    89110,      --  58
    90910,      --  59
    92810,      --  60
    94810,      --  61
    96910,      --  62
    99110,      --  63
    101410,     --  64
    103810,     --  65
    106310,     --  66
    108910,     --  67
    111610,     --  68
    114410,     --  69
    117310,     --  70
    120310,     --  71
    123460,     --  72
    126760,     --  73
    130210,     --  74
    133810,     --  75
    137560,     --  76
    141460,     --  77
    145510,     --  78
    149710,     --  79
    154060,     --  80
    158560,     --  81
    163210,     --  82
    168010,     --  83
    172960,     --  84
    178060,     --  85
    183310,     --  86
    188710,     --  87
    194260,     --  88
    199960,     --  89
    205810,     --  90
    211810,     --  91
    217960,     --  92
    224260,     --  93
    230710,     --  94
    237310,     --  95
    244060,     --  96
    250960,     --  97
    258010,     --  98
    265210,     --  99
    272710,     --  100

}

function OnModifierAdded( params1, params2 )
    local name = params2.name_const
    print("OnModifierAddedFilter",name)
    if params2.entindex_parent_const then
        local parent = EntIndexToHScript( params2.entindex_parent_const )
        print("parent",parent:GetUnitName())
    end
    if params2.entindex_caster_const then
        local caster = EntIndexToHScript( params2.entindex_caster_const )
        print("caster",caster:GetUnitName())
    end
    if params2.entindex_ability_const then
        local ability = EntIndexToHScript( params2.entindex_ability_const )
        print("ability",ability:GetAbilityName())
    end

    return true
end

function Precache( context )

    PrecacheResource( "particle", "particles/ui_mouseactions/range_finder_cone.vpcf", context )
    --PrecacheResource( "soundfile", "soundevents/custom_sounds.vsndevts", context )
	
end

function Activate()
    GameRules.AddonTemplate = DungeonRaider()
    GameRules.AddonTemplate:InitGameMode()
    ListenToGameEvent("npc_spawned", function(event) return OnNpcSpawned(event) end, nil)
end

function OnNpcSpawned(event)
    local npc = EntIndexToHScript(event.entindex)
    OnUnitFirstSpawn(npc)
    if npc:IsRealHero() and not npc.bFirstSpawned then
        npc.bFirstSpawned = true
        OnHeroFirstSpawn(npc)
    end
end

function OnHeroFirstSpawn(hero)
    if hero:IsRealHero() then
        hero:AddAbility("out_of_combat_buff")
        local ability = hero:FindAbilityByName("out_of_combat_buff")
        if hero:HasModifier("modifier_out_of_combat_buff")==false then
            hero:AddNewModifier( hero, ability, "modifier_out_of_combat_buff", {})
        end
        local tome = CreateItem("item_tome_of_knowledge", hero, hero)
        local health_potion = CreateItem("item_health_potion", hero, hero)
        local mana_potion = CreateItem("item_mana_potion", hero, hero)
        tome:SetPurchaseTime(0)
        hero:AddItem(tome)
        hero:AddItem(health_potion)
        hero:AddItem(mana_potion)
    end

end

function OnUnitFirstSpawn(unit)
    unit:AddAbility("generic_critical_strike")
    local ability = unit:FindAbilityByName("generic_critical_strike")
    if ability:GetLevel()<=0 then
        ability:SetLevel(1)
    end
    if unit:IsNeutralUnitType()==true then
        unit:AddAbility("neutral_gain")
        unit:FindAbilityByName("neutral_gain"):SetLevel(1)
    end
    --[[if unit:HasModifier("modifier_generic_critical_strike")==false then
        unit:AddNewModifier( unit, ability, "modifier_generic_critical_strike", {})
    end]]
end

function DungeonRaider:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

    require( "scripts/vscripts/libraries/vector_target/vector_target" )
    require( "scripts/vscripts/libraries/filters/filters" )
    FilterManager:Init()
    
    --GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_furion")
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( MAX_LVL )
    GameRules:GetGameModeEntity():SetUseCustomHeroLevels( true )
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
    GameRules:GetGameModeEntity():SetFixedRespawnTime( 5 )
    GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 0 )
    GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride("item_blink")
    GameRules:GetGameModeEntity():SetNeutralStashTeamViewOnlyEnabled(true)
    GameRules:GetGameModeEntity():SetNeutralItemHideUndiscoveredEnabled( true )
    --GameRules:GetGameModeEntity():SetFreeCourierModeEnabled( false )
    GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled( true )
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
    GameRules:GetGameModeEntity():SetMaximumAttackSpeed( 1000 )
    GameRules:GetGameModeEntity():SetMinimumAttackSpeed( 75 )
    GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled( false )
    GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
    GameRules:GetGameModeEntity():SetBotThinkingEnabled( true )
    GameRules:GetGameModeEntity():SetAlwaysShowPlayerNames( true )
    GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1500 )
    GameRules:GetGameModeEntity():SetCustomBackpackSwapCooldown( 0 )

    GameRules:GetGameModeEntity():SetBountyRuneSpawnInterval( 60 )
    GameRules:GetGameModeEntity():SetPowerRuneSpawnInterval( 60 )


    
    GameRules:SetHeroRespawnEnabled( true )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
    GameRules:SetSameHeroSelectionEnabled( true )
    GameRules:SetUseUniversalShopMode( true )
    GameRules:SetPreGameTime( 0 )

    GameRules:EnableCustomGameSetupAutoLaunch( true )
    GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
    GameRules:SetStrategyTime( 0 )
    
    GameRules:SetShowcaseTime( 0 )

    GameRules:SetCustomGameAllowHeroPickMusic( false )
    GameRules:SetCustomGameAllowMusicAtGameStart( false )
    GameRules:SetCustomGameAllowBattleMusic( true )
    
end

function DungeonRaider:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function DungeonRaider:OnEntityKilled(keys)
    local killedUnit = EntIndexToHScript(keys.entindex_killed)
    if killedUnit:IsRealHero() then
        PlayerResource:SetCustomBuybackCooldown(killedUnit:GetPlayerID(), 20)
    end
end