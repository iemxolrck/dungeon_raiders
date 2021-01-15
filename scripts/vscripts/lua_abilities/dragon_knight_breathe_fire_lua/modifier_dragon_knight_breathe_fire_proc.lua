modifier_dragon_knight_breathe_fire_proc = class ({})


function modifier_dragon_knight_breathe_fire_proc:IsHidden()
	return false
end

function modifier_dragon_knight_breathe_fire_proc:IsDebuff()
	return false
end

function modifier_dragon_knight_breathe_fire_proc:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dragon_knight_breathe_fire_proc:OnCreated( kv )
	self.buffer_range = 300
	self.caster = self:GetCaster()
	self.casts = 0

end

function modifier_dragon_knight_breathe_fire_proc:OnRefresh( kv )
	-- references
end

function modifier_dragon_knight_breathe_fire_proc:OnRemoved()
end

function modifier_dragon_knight_breathe_fire_proc:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dragon_knight_breathe_fire_proc:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_dragon_knight_breathe_fire_proc:OnAbilityFullyCast( event )
	 if event.ability:GetName() == "dragon_knight_breathe_fire_lua" and self.caster:HasModifier("modifier_cleric_channel_divinity")==true then
	 	
	 	self.target = self:GetAbility():GetCursorTarget()
		self.point = self:GetAbility():GetCursorPosition()
		self:StartIntervalThink(0.1)
		self:OnIntervalThink(0.1)
		print("start")
    end
end

function modifier_dragon_knight_breathe_fire_proc:OnIntervalThink()
	print("trying to start")

	-- cast to target
	self.caster:SetCursorPosition( self.point )
	self:GetAbility():OnSpellStart()

	-- increment count
	self.casts = self.casts + 1
	print("cast"..self.casts)
	if self.casts>=3 then
		self.casts = 0
		self:StartIntervalThink( -1 )
		print("end")
		--self:Destroy()
	end

	-- play effects
	--self:PlayEffects( self.casts )
end