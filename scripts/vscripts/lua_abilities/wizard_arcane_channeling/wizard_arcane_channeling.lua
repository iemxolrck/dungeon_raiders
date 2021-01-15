wizard_arcane_channeling = class({})

LinkLuaModifier( "modifier_wizard_arcane_channeling", "lua_abilities/wizard_arcane_channeling/modifier_wizard_arcane_channeling", LUA_MODIFIER_MOTION_NONE )

function wizard_arcane_channeling:GetIntrinsicModifierName()
	--return	"modifier_wizard_arcane_channeling"
end

function wizard_arcane_channeling:ProcsMagicStick()
	return false
end

function wizard_arcane_channeling:OnToggle()
	if self:GetToggleState() then
		self.modifier = self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_wizard_arcane_channeling",
			{}
		)
	else
		if self.modifier then
			self.modifier:Destroy()
			self.modifier = nil
		end
	end
end

function wizard_arcane_channeling:OnUpgrade()
	if self.modifier then
		self.modifier:ForceRefresh()
	end
end