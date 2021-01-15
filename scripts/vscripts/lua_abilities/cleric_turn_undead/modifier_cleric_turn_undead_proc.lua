modifier_cleric_turn_undead_proc = class ({})

function modifier_cleric_turn_undead_proc:IsHidden()
	return true
end

function modifier_cleric_turn_undead_proc:IsDebuff()
	return false
end

function modifier_cleric_turn_undead_proc:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_cleric_turn_undead_proc:OnCreated( kv )
	self.buffer_range = 300
	self.caster = self:GetCaster()
	local ability = self.caster:FindAbilityByName( "cleric_channel_divinity" )
	self.casts = ability:GetLevelSpecialValueFor( "damage_instance" , ability:GetLevel()-1 )
	self.count = 0

end

function modifier_cleric_turn_undead_proc:OnRefresh( kv )
	self.buffer_range = 300
	self.caster = self:GetCaster()
	local ability = self.caster:FindAbilityByName( "cleric_channel_divinity" )
	self.casts = ability:GetLevelSpecialValueFor( "damage_instance" , ability:GetLevel()-1 )
	self.count = 0
end

function modifier_cleric_turn_undead_proc:OnRemoved()
end

function modifier_cleric_turn_undead_proc:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_cleric_turn_undead_proc:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_cleric_turn_undead_proc:OnAbilityFullyCast( event )
	 if event.ability:GetName() == "cleric_turn_undead"
	 	and self.caster:HasModifier("modifier_cleric_channel_divinity")==true
	 	and event.unit == self:GetCaster() then
	 	
	 	self.target = self:GetAbility():GetCursorTarget()
		self.point = self:GetAbility():GetCursorPosition()
		print(self.casts)
		self:StartIntervalThink(0.01)
		--print("start")
    end
end

function modifier_cleric_turn_undead_proc:OnIntervalThink()
	--print("trying to start")

	-- cast to target
	self.caster:SetCursorPosition( self.point )
	self:GetAbility():OnSpellStart()

	if self.count == 0 then
		local sound_cast = "Hero_DragonKnight.BreathFire"
		EmitSoundOn( sound_cast, self.caster )
		self:PlayEffects()
	end

	-- increment count
	self.count = self.count + 1
	--print("cast"..self.casts)
	if self.count>=self.casts then
		self.count = 0
		self:StartIntervalThink( -1 )
		--print("end")
		--self:Destroy()
	end

	-- play effects
	--self:PlayEffects( self.casts )
end

function modifier_cleric_turn_undead_proc:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end