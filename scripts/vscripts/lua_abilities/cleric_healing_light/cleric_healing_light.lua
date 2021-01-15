cleric_healing_light = class({})

LinkLuaModifier( "modifier_cleric_healing_light", "lua_abilities/cleric_healing_light/modifier_cleric_healing_light", LUA_MODIFIER_MOTION_NONE )

function cleric_healing_light:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function cleric_healing_light:OnAbilityPhaseInterrupted()

end

function cleric_healing_light:OnAbilityPhaseStart()
	--self:PlayEffects1()
	return true
end

function cleric_healing_light:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local heal = self:GetSpecialValueFor("base_heal")
	local bonus_heal = self:GetSpecialValueFor("bonus_heal")
	bonus_heal = ( target:GetMaxHealth() - target:GetHealth() ) * ( bonus_heal / 100 )
	heal = math.floor( heal + bonus_heal )
	print(heal)

	target:Heal(heal, self)

	self:PlayEffects2( target )

end

function cleric_healing_light:HealCalculate( caster, allies, heal, stack )
	local int_as_heal = 0
	local mod_count = caster:GetModifierCount()
	local total_heal = 0

	for i=0, mod_count-1 do
		local modifier = caster:FindModifierByName(caster:GetModifierNameByIndex(i))
		if modifier:HasFunction(41)==true then
			local has_heal = modifier:GetAbility():GetSpecialValueFor("heal_amp")
			if has_heal~=nil then
				total_heal = total_heal + has_heal
			end
		end
		if modifier:HasFunction(42)==true then
			local has_heal = modifier:GetAbility():GetSpecialValueFor("int_as_heal")
			if has_heal~=nil then
				int_as_heal = caster:GetIntellect() * (has_heal/100)
			end
		end
	end
	heal_amplify = total_heal + int_as_heal
	heal = math.floor ( heal * ( 1 + ( heal_amplify/100 ) ) )

	for _, ally in pairs(allies) do
		ally:Heal(heal, self)
		self:PlayEffects2( caster, ally )
	end
end

function cleric_healing_light:PlayEffects1( caster, radius )
	
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_target = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
	local sound_target = "Hero_Omniknight.Purification"

	local effect_target = ParticleManager:CreateParticle( particle_target, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_target )
	EmitSoundOn( sound_target, caster )

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), 
		true 
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function cleric_healing_light:PlayEffects2( target )
	local particle_cast = "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_impact_moonfall_gold.vpcf"
	local sound_cast = "Hero_Luna.LucentBeam.Cast"
	local sound_target = "Hero_Luna.LucentBeam.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 5, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 6, target:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end