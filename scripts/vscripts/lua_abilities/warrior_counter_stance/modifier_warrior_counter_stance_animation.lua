modifier_warrior_counter_stance_animation = class({})

function modifier_warrior_counter_stance_animation:IsHidden()
	return false
end

function modifier_warrior_counter_stance_animation:IsPurgable()
	return false
end

function modifier_warrior_counter_stance_animation:OnCreated( kv )

end

function modifier_warrior_counter_stance_animation:OnRefresh( kv )

end

function modifier_warrior_counter_stance_animation:OnDestroy( kv )

end

function modifier_warrior_counter_stance_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}

	return funcs
end


function modifier_warrior_counter_stance_animation:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end