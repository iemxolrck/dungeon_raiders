modifier_player_healing = class ({})

modifier_player_healing.heal_amplify = 0

function modifier_player_healing:IsHidden()
    return false
end

function modifier_player_healing:IsDebuff()
    return false
end

function modifier_player_healing:IsPurgable()
    return false
end

function modifier_player_healing:OnCreated( kv )
	self.healing = 1
	self:OnIntervalThink()
	self:StartIntervalThink(1)
end

function modifier_player_healing:OnRefresh( kv )

end

function modifier_player_healing:OnDestroy( kv )

end

function modifier_player_healing:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local int_as_heal = 0--self:GetParent():GetIntellect()*0.25
		local mod_count = parent:GetModifierCount()
		local total_heal = 0
		local debuff_count = 0
		--print(mod_count)

		for i=0, mod_count-1 do
			local modifier = parent:FindModifierByName(parent:GetModifierNameByIndex(i))
			--[[if modifier==nil then
				--print("break")
				break
			end]]
			if modifier:HasFunction(41)==true then
				local has_heal = modifier:GetAbility():GetSpecialValueFor("heal_amp")
				if has_heal~=nil then
					total_heal =  math.floor( total_heal + has_heal )
				end
			end
			if modifier:HasFunction(42)==true then
				local has_heal = modifier:GetAbility():GetSpecialValueFor("int_as_heal")
				if has_heal~=nil then
					int_as_heal =  math.floor( self:GetParent():GetIntellect() * (has_heal/100) )
				end
			end
		end
		modifier_player_healing.heal_amplify =  math.floor(total_heal + int_as_heal)
		--self:SetModifierStackCount()
		--print(modifier_player_healing.heal_amplify)
	end

end

function modifier_player_healing:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_MODIFIER_ADDED
    }
    return funcs
end


function modifier_player_healing:OnModifierAdded()
	return 0
end

function modifier_player_healing:ForDebuffCount()
	local parent = self:GetParent()
	local int_as_heal = self:GetParent():GetIntellect()*7
	local modifier
	--print(self:IsDebuff())

	local mod_count = self:GetCaster():GetModifierCount()
	local debuff_count = 0
	--print(mod_count)

	for i=0, mod_count-1 do
		modifier = parent:FindModifierByName(parent:GetModifierNameByIndex(i))
		if modifier:IsDebuff()==true then
			debuff_count = debuff_count + 1
		end
	--self:SetModifierStackCount()
	end
	--print(debuff_count)

end