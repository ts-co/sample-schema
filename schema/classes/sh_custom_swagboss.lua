CLASS.name = "Swag Boss"
CLASS.desc = "Custom rank/class for a faction."
CLASS.faction = FACTION_CUSTOM

--[[-------------------------------------------------------------------------
Purpose: Who in the faction is allowed to become this class?
---------------------------------------------------------------------------]]
function CLASS:onCanBe(client)
	--If the client has the custom flag P then allow them to become this class.
	if client:getChar():hasFlags("P") then
		return true
	end
end

CLASS_CUSTOM_SWAGBOSS = CLASS.index
