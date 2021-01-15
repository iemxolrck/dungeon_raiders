bard_play_dead = class({})

LinkLuaModifier( "modifier_bard_play_dead", "lua_abilities/bard_play_dead/modifier_bard_play_dead", LUA_MODIFIER_MOTION_NONE )

function bard_play_dead:OnSpellStart()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_bard_discord") == true then
		self:GetCaster():FindAbilityByName("bard_discord_cancel"):OnSpellStart()
	end
	if caster:HasModifier("modifier_bard_symphony") == true then
		self:GetCaster():FindAbilityByName("bard_symphony_cancel"):OnSpellStart()
	end
	caster:Purge(false, true, false, true, false)
	self:EndCooldown()

	-- Add modifier
	self.modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_bard_play_dead", -- modifier name
		{ duration = self:GetChannelTime() } -- kv
	)
end 

function bard_play_dead:OnChannelFinish( bInterrupted )
	if bInterrupted then
		if self.modifier then
			self.modifier:Destroy()
			self.modifier = nil
		end
		self:StartCooldown(self:GetCooldown(self:GetLevel()))
	else
		local ability_main_0 ="bard_play_dead"
		local ability_sub_0 = "bard_dash"
		self:GetCaster():SwapAbilities( ability_main_0, ability_sub_0, false , true )
	end
end

function bard_play_dead:OnHeroCalculateStatBonus()
	if self:GetLevel()<1 then
        self:SetLevel(self:GetMaxLevel())
    end
end