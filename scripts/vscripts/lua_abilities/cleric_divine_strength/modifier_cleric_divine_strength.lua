modifier_cleric_divine_strength = class({})

function modifier_cleric_divine_strength:IsHidden()
    return false
end

function modifier_cleric_divine_strength:IsDebuff()
    return false
end

function modifier_cleric_divine_strength:IsPurgable()
    return false
end

function modifier_cleric_divine_strength:OnCreated( kv )
    self.int = self:GetAbility():GetSpecialValueFor( "str_as_int" )/100
    self.int_as_heal = self:GetAbility():GetSpecialValueFor( "int_as_heal" )/100
end

function modifier_cleric_divine_strength:OnRefresh( kv )
    self:OnCreated( kv )
end

function modifier_cleric_divine_strength:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_cleric_divine_strength:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_cleric_divine_strength:GetModifierBonusStats_Intellect()
    local total = math.floor( self:GetParent():GetStrength()*self.int )
    return total
end

function modifier_cleric_divine_strength:OnTooltip()
    local total = math.floor( self:GetParent():GetIntellect()*self.int_as_heal )
    return total
end