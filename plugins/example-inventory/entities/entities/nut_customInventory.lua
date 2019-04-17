ENT.Type = "anim"
ENT.PrintName = "Custom Inventory"
ENT.Category = "NutScript"
ENT.Spawnable = true
ENT.AdminOnly = true

Inventory = FindMetaTable("GridInv") --We want to set up a grid inventory
nut.item.inventories = nut.inventory.instances --Chessnut has yet to fix this, it's sort of necessary at the moment.

if (SERVER) then

--[[-------------------------------------------------------------------------
Purpose: Our custom inventory needs to have some rules. We can use this to decide
what type of items can enter our custom inventory. This is set up to allow any
item to enter and leave. Alternatively, we can make it so that only one kind
of item can enter the inventory. (Only cassette's can enter the cassette players)
---------------------------------------------------------------------------]]
local function ItemCanEnterForEveryone(inventory, action, context)
	if (action == "transfer") then return true end
end

local function CanReplicateItemsForEveryone(inventory, action, context)
	if (action == "repl") then return true end
end

	function ENT:Initialize()
		self:SetModel("models/props_junk/trashdumpster01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.receivers = {}
		local physObject = self:GetPhysicsObject()

		if (IsValid(physObject)) then
			physObject:Wake()
		end

		--[[-------------------------------------------------------------------------
		Purpose: When our entity is initalized we will set up some things for our inventory.

		* (w, h) determine the size of the inventory.
		* addAccessRule to add the rules we made earlier.
		* noBags means that we will not allow bags to enter the inventory.
		---------------------------------------------------------------------------]]
		Inventory:instance({w = 3, h = 3})
			:next(function(inventory)
				self:setInventory(inventory)
				inventory:addAccessRule(ItemCanEnterForEveryone)
				inventory:addAccessRule(CanReplicateItemsForEveryone)
				inventory.noBags = true
				function inventory:onCanTransfer(client, oldX, oldY, x, y, newInvID)
					return hook.Run("StorageCanTransfer", inventory, client, oldX, oldY, newInvID)
				end
			end)
	end

	--[[-------------------------------------------------------------------------
	Purpose: Set up our inventory. You don't need to edit anything here.
	---------------------------------------------------------------------------]]
	function ENT:setInventory(inventory)
		if (inventory) then
			self:setNetVar("id", inventory:getID())

			inventory.onAuthorizeTransfer = function(inventory, client, oldInventory, item)
				if (IsValid(client) and IsValid(self) and self.receivers[client]) then
					return true
				end
			end

			inventory.getReceiver = function(inventory)
				local receivers = {}

				for k, v in pairs(self.receivers) do
					if (IsValid(k)) then
						receivers[#receivers + 1] = k
					end
				end

				return #receivers > 0 and receivers or nil
			end
		end
	end

	--[[-------------------------------------------------------------------------
	Purpose: When we press E on our inventory let's open it.
	---------------------------------------------------------------------------]]
	function ENT:Use(activator)
		local inventory = self:getInv()

		if (inventory and (activator.nutNextOpen or 0) < CurTime()) then
			if (activator:getChar()) then
				activator:setAction("Opening...", 1, function()
					if (activator:GetPos():Distance(self:GetPos()) <= 100) then
						self.receivers[activator] = true
						activator.nutBagEntity = self
						
						inventory:sync(activator)
						netstream.Start(activator, "invOpen", self, inventory:getID())
					end
				end)
			end

			activator.nutNextOpen = CurTime() + 1.5
		end
	end

	--[[-------------------------------------------------------------------------
	Purpose: When we remove our inventory we want to remove it from the data.
	---------------------------------------------------------------------------]]
	function ENT:OnRemove()		
		local index = self:getNetVar("id")

		if (!nut.shuttingDown and !self.nutIsSafe and index) then
			local item = nut.item.inventories[index]

			if (item) then
				nut.item.inventories[index] = nil

				nut.db.query("DELETE FROM nut_items WHERE _invID = "..index)
				nut.db.query("DELETE FROM nut_inventories WHERE _invID = "..index)

				hook.Run("StorageItemRemoved", self, item)
			end
		end
	end

	function ENT:getInv()
		return nut.item.inventories[self:getNetVar("id", 0)]
	end
else
	--[[-------------------------------------------------------------------------
	Purpose: This is how Chessnut makes it so that when you look at an entity it can
	have cool text show up. The storage container's use this to also show if storage
	container's are locked or unlocked.
	---------------------------------------------------------------------------]]
	ENT.DrawEntityInfo = true

	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = nut.util.drawText
	local configGet = nut.config.get

	function ENT:onDrawEntityInfo(alpha)
		local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)))
		local x, y = position.x, position.y

		drawText("Custom Inventory", x, y, colorAlpha(configGet("color"), alpha), 1, 1, nil, alpha * 0.65)
	end
end