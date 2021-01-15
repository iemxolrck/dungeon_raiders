function CDOTA_BaseNPC:HasTalent(talentname)
    local unit = self
    if self:GetParentUnit() then
        unit = self:GetParentUnit()
    end
    if unit:HasAbility(talentname) then
        if unit:FindAbilityByName(talentname):GetLevel() > 0 then return true end
    end
    return false
end

function CDOTA_BaseNPC:FindTalentValue(talentname)
    local unit = self
    if self:GetParentUnit() then
        unit = self:GetParentUnit()
    end
    if unit:HasAbility(talentname) then
        if unit:FindAbilityByName(talentname):GetSpecialValueFor( "value" )
    end
    return 0
end