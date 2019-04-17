ITEM.name = "Consumables Base"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.desc = "Tasty food, or tasy drink."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables"
ITEM.health = 0
ITEM.action = "consume"

--[[-------------------------------------------------------------------------
Purpose: Create a function that these items will use. ITEM.health and ITEM.action
were parameters that I created.
---------------------------------------------------------------------------]]
ITEM.functions.use = {
	name = "Consume", --Name of the function, if this doesn't exist it'll use "use"
	tip = "Consume the item.", --Tip when hovering over the function
	icon = "icon16/cup.png", --Icon for the function
	onRun = function(item, data)
		item.player:EmitSound("items/battery_pickup.wav") --Play a cool sound
		item.player:SetHealth(item.player:Health() + item.health) --Give health to player when they consume
		item.player:notifyLocalized("You "..string.lower(item.action).." "..string.lower(item.name).." for "..item.health.." health.") --Send message to player
	end
}
