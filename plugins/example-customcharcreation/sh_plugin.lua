PLUGIN.name = "Traits"
PLUGIN.author = "Pilot"
PLUGIN.desc = "Adds extra step for character creation."

-- I hate the way Chessnut makes me add columns
if (SERVER) then
	nut.db.waitForTablesToLoad()
	:next(function()
		nut.db.query("ALTER TABLE nut_characters ADD COLUMN _trait INTEGER")
		:catch(function() end)
	end)
end

nut.char.registerVar("trait", {
	field = "_trait",
	default = "",
	index = 4,
	onValidate = function(value, data, client)
		if (value) then
			if (value >= 1 && value <= 4) then
				return true
			end
		end
	end
})

local randomItem = {
	"potato",
	"water"
}

function PLUGIN:OnCharCreated(client, character)
	local inventory = character:getInv()

	if (inventory) then
		if character:getTrait() == 1 then
			inventory:add(randomItem[math.random(1, table.Count(randomItem))])
		elseif character:getTrait() == 2 then
			inventory:add(randomItem[math.random(1, table.Count(randomItem))])
		elseif character:getTrait() == 3 then
			inventory:add(randomItem[math.random(1, table.Count(randomItem))])
		elseif character:getTrait() == 4 then
			inventory:add(randomItem[math.random(1, table.Count(randomItem))])
		else
			inventory:add(randomItem[math.random(1, table.Count(randomItem))])
		end
	end
end

function PLUGIN:ConfigureCharacterCreationSteps(panel)
	panel:addStep(vgui.Create("nutCharacterTraits"), 99)
end