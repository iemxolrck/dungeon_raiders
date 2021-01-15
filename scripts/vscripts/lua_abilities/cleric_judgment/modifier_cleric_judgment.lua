modifier_cleric_judgment = class({})

function modifier_cleric_judgment:IsHidden()
	return false
end

function modifier_cleric_judgment:IsDebuff()
	return true
end

function modifier_cleric_judgment:IsStunDebuff()
	return false
end

function modifier_cleric_judgment:IsPurgable()
	return true
end

function modifier_cleric_judgment:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_cleric_judgment:OnCreated( kv )
	-- references
	local tick_rate = 2
	self.stun = self:GetAbility():GetSpecialValueFor( "stun_duration" )

	if IsServer() then
		-- precache damage
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}
		-- ApplyDamage(damageTable)

		-- Start interval
		self:StartIntervalThink(2)
		self:OnIntervalThink(2)
	end
end

function modifier_cleric_judgment:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_cleric_judgment:OnRemoved()
end

function modifier_cleric_judgment:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_cleric_judgment:OnIntervalThink()
	-- stun
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 0.75 } -- kv
	)
	-- damage
	self:DamageCalculation()
	

	-- effect
	self:PlayEffects2()
end

function modifier_cleric_judgment:DamageCalculation()
    local caster = self:GetCaster()
    local enemy = self:GetParent()
    local damage = (self:GetAbility():GetSpecialValueFor("skill_damage")/100)
    local critrate = 25
    local critdamage = (100+125)/100

    local BaseDamage
    local maxdamage
    local mindamage
    local averagedamage

    averagedamage = caster:GetAverageTrueAttackDamage(caster)
    BaseDamage = caster:GetAttackDamage()
    maxdamage = caster:GetBaseDamageMax()
    mindamage = caster:GetBaseDamageMin()

    maxdamage = maxdamage - mindamage
    averagedamage = averagedamage - (maxdamage/2)
    averagedamage = averagedamage - mindamage
    BaseDamage = BaseDamage + averagedamage

    self.damageTable.damage = damage*BaseDamage
    ApplyDamage( self.damageTable )

    caster:PerformAttack (
            enemy,
            false,
            true,
            true,
            false,
            false,
            true,
            true
            )

    if RandomInt(1,100) >= critrate then
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, self.damageTable.damage, nil)
            ApplyDamage( self.damageTable )
        else
            self.damageTable.damage = self.damageTable.damage * critdamage
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL , enemy, self.damageTable.damage, nil)
            ApplyDamage( self.damageTable )
        end
end

function modifier_cleric_judgment:PlayEffects2( origin, target )
	local particle_target = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf"
	local sound_cast = "Hero_Zuus.GodsWrath.Target"
	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	ParticleManager:SetParticleControlEnt(
		effect_target,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_target )

	EmitSoundOn( sound_cast, self:GetParent() )
end