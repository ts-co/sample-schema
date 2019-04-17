local PANEL = {}

local traits = {}
traits[1] = {"Trait 1", "First trait."}
traits[2] = {"Trait 2", "Second trait."}
traits[3] = {"Trait 3", "Third trait."}
traits[4] = {"trait 4", "Fourth trait."}

function PANEL:Init()
	self.title = self:addLabel("Select a trait")

	self.faction = self:Add("DComboBox")
	self.faction:SetFont("nutCharButtonFont")
	self.faction:Dock(TOP)
	self.faction:DockMargin(0, 4, 0, 0)
	self.faction:SetTall(40)
	self.faction.Paint = function(faction, w, h)
		nut.util.drawBlur(faction)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)
	end
	self.faction:SetTextColor(color_white)
	self.faction.OnSelect = function(faction, index, value, id)
		self:onTraitSelected(index)
	end

	self.desc = self:addLabel("desc")
	self.desc:DockMargin(0, 8, 0, 0)
	self.desc:SetFont("nutCharSubTitleFont")
	self.desc:SetWrap(true)
	self.desc:SetAutoStretchVertical(true)
	self.desc:SetText("")

	for index, trait in pairs(traits) do
		self.faction:AddChoice(trait[1])
	end
end

function PANEL:onTraitSelected(trait)
	for k, v in pairs(traits) do
		if k == trait then
			self.desc:SetText(v[2])
			self:setContext("trait", trait)
		end
	end
	nut.gui.character:clickSound()
end

vgui.Register("nutCharacterTraits", PANEL, "nutCharacterCreateStep")
