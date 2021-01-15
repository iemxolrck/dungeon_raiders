modifier_generic_heal = class({})
require("lua_abilities/player_resource/modifier_player_healing")

function modifier_generic_heal:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_heal:IsHidden()
	return true
end

function modifier_generic_heal:IsPurgable()
	return false
end

function modifier_generic_heal:OnCreated(kv)
	local ability 	= self:GetAbility()
	local parent 	= self:GetParent()
	local caster	= self:GetCaster()
	local heal_amount = kv.heal

	--if parent~=caster then
		heal_amount = math.max( kv.heal * (1+(caster:FindModifierByName("modifier_player_healing").heal_amplify/100)) )
	--end
	--print(modifier.heal_amplify)
	parent:Heal(heal_amount, ability)
	self:Destroy()
end