bard_discord_cancel = class({})

function bard_discord_cancel:ProcsMagicStick()
	return false
end

function bard_discord_cancel:OnSpellStart()
	local caster = self:GetCaster()
	local ability_main_0 = "bard_discord_cancel"
	local ability_sub_0 = "bard_discord" 

	if caster:HasModifier("modifier_bard_discord") == true then
		self:GetCaster():FindModifierByName("modifier_bard_discord"):Destroy()
	end

	caster:SwapAbilities( ability_main_0, ability_sub_0, false , true )
end