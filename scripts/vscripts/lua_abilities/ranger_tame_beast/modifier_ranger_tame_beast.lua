modifier_ranger_tame_beast = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ranger_tame_beast:IsHidden()
	return false
end

function modifier_ranger_tame_beast:IsDebuff()
	return false
end

function modifier_ranger_tame_beast:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ranger_tame_beast:OnCreated( kv )
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		self.team = parent:GetTeamNumber()

		-- set controllable
		parent:SetTeam( caster:GetTeamNumber() )
		parent:SetOwner( caster )
		parent:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
	end
end

function modifier_ranger_tame_beast:OnRefresh( kv )
	
end

function modifier_ranger_tame_beast:OnDestroy( kv )
	if IsServer() then
		local parent = self:GetParent()
		parent:SetTeam( self.team )
		parent:SetOwner( nil )
		parent:SetForceAttackTarget( self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
-- function modifier_ranger_tame_beast:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_XX,
-- 		MODIFIER_EVENT_YY,
-- 	}

-- 	return funcs
-- end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ranger_tame_beast:CheckState()
	local state = {
		[MODIFIER_STATE_DOMINATED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
-- function modifier_ranger_tame_beast:OnIntervalThink()
-- end

--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_ranger_tame_beast:GetEffectName()
-- 	return "particles/string/here.vpcf"
-- end

-- function modifier_ranger_tame_beast:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end

-- function modifier_ranger_tame_beast:PlayEffects()
-- 	-- Get Resources
-- 	local particle_cast = "string"
-- 	local sound_cast = "string"

-- 	-- Get Data

-- 	-- Create Particle
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
-- 	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
-- 	ParticleManager:SetParticleControlEnt(
-- 		effect_cast,
-- 		iControlPoint,
-- 		hTarget,
-- 		PATTACH_NAME,
-- 		"attach_name",
-- 		vOrigin, -- unknown
-- 		bool -- unknown, true
-- 	)
-- 	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
-- 	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )

-- 	-- buff particle
-- 	self:AddParticle(
-- 		nFXIndex,
-- 		bDestroyImmediately,
-- 		bStatusEffect,
-- 		iPriority,
-- 		bHeroEffect,
-- 		bOverheadEffect
-- 	)

-- 	-- Create Sound
-- 	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
-- 	EmitSoundOn( sound_target, target )
-- end