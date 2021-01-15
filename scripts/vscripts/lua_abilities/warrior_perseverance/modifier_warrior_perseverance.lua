modifier_warrior_perseverance = class({})

function modifier_warrior_perseverance:IsHidden()
	return true
end

function modifier_warrior_perseverance:IsPurgable()
	return false
end

function modifier_warrior_perseverance:OnCreated( kv )
	
end

function modifier_warrior_perseverance:OnRefresh( kv )
	
end

function modifier_warrior_perseverance:OnDestroy( kv )

end

function modifier_warrior_perseverance:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_warrior_perseverance:OnAttackLanded( params )
	if IsServer() then
		
	end
end

function modifier_warrior_perseverance:PlayEffects()
end