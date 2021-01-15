modifier_shaman_synchronize = class({})

function modifier_shaman_synchronize:IsHidden()
	return false
end

function modifier_shaman_synchronize:IsDebuff()
	return false
end

function modifier_shaman_synchronize:IsPurgable()
	return false
end

function modifier_shaman_synchronize:OnCreated( kv )

end

function modifier_shaman_synchronize:OnRefresh( kv )
end

function modifier_shaman_synchronize:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_MODIFIER_ADDED,
		--MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function modifier_shaman_synchronize:OnAbilityFullyCast( params )
	if not IsServer() then return end
	--if params.unit~=self:GetParent() then return end
	print("cast")
	print(params.unit)
	print(params.ability)
end

function modifier_shaman_synchronize:OnModifierAdded( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	local source = params.ability
	print("MOD")
	print(params.unit)
	print(params[1])
	print(params[2])
	print(params[3])
	print(params[4])
end