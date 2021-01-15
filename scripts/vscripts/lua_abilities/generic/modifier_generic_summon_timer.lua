modifier_generic_summon_timer = class({})

function modifier_generic_summon_timer:IsDebuff()
	return false
end

function modifier_generic_summon_timer:IsHidden()
	return false
end

function modifier_generic_summon_timer:IsPurgable()
	return false
end

function modifier_generic_summon_timer:OnCreated()
	self.owner_mana_percent = 0
	self.health_regen = 0
	self:StartIntervalThink(0)
end

function modifier_generic_summon_timer:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill( false )
	end
end

function modifier_generic_summon_timer:OnIntervalThink()
	if IsServer() then
		local owner_mana_percent = self:GetCaster():GetMana() / self:GetCaster():GetMaxMana()
		--print(owner_mana_percent)
		local health_regen = math.floor( self:GetParent():GetMaxHealth() * ( owner_mana_percent * 0.05 ) )
		--print(health_regen)
		self:SetStackCount( health_regen )
	end
end

--------------------------------------------------------------------------------
-- Declare Functions
function modifier_generic_summon_timer:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_HEAL_RECEIVED
	}

	return funcs
end

function modifier_generic_summon_timer:GetModifierConstantHealthRegen()
	return self:GetStackCount()
end

function modifier_generic_summon_timer:GetUnitLifetimeFraction( params )
	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end

function modifier_generic_summon_timer:OnTakeDamage( keys )
	if IsServer() and keys.unit == self:GetParent() and keys.unit:IsSummoned()==true then
		local owner = self:GetParent():GetOwnerEntity()
		self:GetCaster():ReduceMana( keys.damage * 0.25 )
		--print("summon by: ")
		--print(owner)
	end
end

function modifier_generic_summon_timer:OnHealReceived(params)
	--local unit = keys.unit
	--local amount = keys.gain
	--SendOverheadEventMessage( unit, OVERHEAD_ALERT_HEAL , unit, amount, nil )

	if IsServer() then
		local parent = self:GetParent()
		local inflictor = params.inflictor
		local unit = params.unit
		local amount = params.gain
		

		if unit == parent then
			if inflictor and inflictor ~= self:GetAbility() then
			print("Amount: "..amount)
			print("Unit:")
			print(unit:GetName())
			print("Parent:")
			print(parent:GetName())
			print("Inflictor:")
			print(inflictor:GetName())
			print(" ")
				SendOverheadEventMessage( unit, OVERHEAD_ALERT_HEAL , unit, amount, nil )
			end
		end

	end

end