-- Nando 05/04/2023

function updateClientTime(hour, minute)
	-- print("New time "..hour..":"..minute)
	setTime(hour, minute)
end
addEvent ( "updateClientTime", true )
addEventHandler ( "updateClientTime", getRootElement(), updateClientTime )
