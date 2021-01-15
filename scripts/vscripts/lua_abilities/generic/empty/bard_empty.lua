bard_empty = class({})

function bard_empty:OnHeroCalculateStatBonus()

    if self:GetLevel()<1 then
        self:SetLevel(1)
    end

end