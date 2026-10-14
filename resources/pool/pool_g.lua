-- Placeholders for this fucking useless resource - Nando 16/03/2023

function allocateElement()
	-- removed, there's absolutely no need for an element allocation system
	return true
end

function getPoolElementsByType(theType)
	return getElementsByType(theType)
end

local idelementdata =
{
	player = "playerid", --Player ID on scoreboard
	interior = "dbid",
	elevator = "dbid",
	vehicle = "dbid",
	team = "id",
	ped = "dbid",
	playerByDbid = "dbid", -- character id in database
	object = 'dbid',
}

-- The only useful function, simplified by Nando :D
function getElement(elementType, id)
	local id = id and tonumber(id)
	if not idelementdata[elementType] then return end
	local elements = getElementsByType(elementType)
	for k=1, #elements do
		local element = elements[k]
		if element and getElementData(element, idelementdata[elementType]) == id then
			return element
		end
	end
end