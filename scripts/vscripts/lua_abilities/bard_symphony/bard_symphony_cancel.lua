bard_symphony_cancel = class({})

function bard_symphony_cancel:ProcsMagicStick()
	return false
end

function bard_symphony_cancel:OnSpellStart()
	local caster = self:GetCaster()
	local ability_main_0 = "bard_symphony_cancel"
	local ability_sub_0 = "bard_symphony" 

	if caster:HasModifier("modifier_bard_symphony") == true then
		self:GetCaster():FindModifierByName("modifier_bard_symphony"):Destroy()
	end
	caster:SwapAbilities( ability_main_0, ability_sub_0, false , true )
end