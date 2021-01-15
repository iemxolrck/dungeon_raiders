modifier_summon_zombie = class({})

function modifier_summon_zombie:IsHidden()
	return false
end

function modifier_summon_zombie:IsDebuff()
	return false
end

function modifier_summon_zombie:IsPurgable()
	return false
end

function modifier_summon_zombie:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.target = nil
	self:StartIntervalThink(0.5)
end

function modifier_summon_zombie:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_summon_zombie:OnRemoved( kv )
	--if not IsServer() then return end
	--self:GetParent():ForceKill( false )
end

function modifier_summon_zombie:OnDestroy( kv )
	if not IsServer() then return end
	self:GetParent():ForceKill( false )
end

function modifier_summon_zombie:OnIntervalThink()
	if not IsServer() then return end
	local distance = math.floor( (self:GetCaster():GetAbsOrigin()-self:GetParent():GetAbsOrigin()):Length2D() )
	if distance>self.radius then
		local health = self:GetParent():GetHealth()
		if health==1 then
			self:GetParent():ForceKill( false )
		else
			self:GetParent():SetHealth( health - 1 )
		end
		return
	end
	if self.target==nil then return end
	if self.target:IsAlive()==false then
		self:GetParent():ForceKill( false )
	end
end

function modifier_summon_zombie:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		--MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
	}

	return funcs
end

function modifier_summon_zombie:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_summon_zombie:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_summon_zombie:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_summon_zombie:OnAttacked( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	self.target = params.target
	self:GetParent():AddNewModifier(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_summon_zombie",
		{ duration = self.duration }
	)
end

function modifier_summon_zombie:OnAttackStart( params )
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	self.target = params.target
	self:GetParent():AddNewModifier(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_summon_zombie",
		{ duration = self.duration }
	)
	--print(self.target)
end

function modifier_summon_zombie:OnDeath( params )
	if not IsServer() then return end
	if params.unit==self:GetCaster() then self:GetParent():ForceKill( false ) return end
	if self.target~=params.unit then return end
	self:GetParent():ForceKill( false )
end

function modifier_summon_zombie:OnTakeDamageKillCredit( params )
	if not IsServer() then return end
	if params.target~=self:GetParent() then return end
	local health = self:GetParent():GetHealth()
	if health==1 then
		self:GetParent():Kill( params.attacker, params.inflictor )
	else
		self:GetParent():SetHealth( health - 1 )
	end
	
end

function modifier_summon_zombie:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_UNSLOWABLE ] = true,
		[MODIFIER_STATE_TAUNTED] = true
	}

	return state
end