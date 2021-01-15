statpoints_lua = class({})

function statpoints_lua:OnHeroLevelUp()
	local caster = self:GetCaster()
	caster:SetAbilityPoints(1)
end

function statpoints_lua:OnHeroCalculateStatBonus()
    if self:GetLevel()<1 then
        self:SetLevel(1)
    end
end