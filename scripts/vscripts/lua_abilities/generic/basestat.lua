	 caster = self:GetCaster()
	 target = self:GetCursorTarget()
	 BaseDamage = caster:GetAttackDamage()
	 skilldamage = self:GetSpecialValueFor("skill_damage")/100
	 damage = skilldamage*BaseDamage