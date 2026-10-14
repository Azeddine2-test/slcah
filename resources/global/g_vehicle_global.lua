--MAXIME
local gvn = getVehicleName
function getVehicleName(theVehicle)
	if not theVehicle or (getElementType(theVehicle) ~= "vehicle") then
		return "?"
	end
	local name = gvn(theVehicle)
	local year = getElementData(theVehicle, "year")
	local brand = getElementData(theVehicle, "brand")
	local model = getElementData(theVehicle, "maximemodel")
	if year and brand and model then
		name = tostring(year).." "..tostring(brand).." "..tostring(model)
	end
	return name
end

local CUSTOM_MODELS = {
	-- ID = Name, Vehicle Type
	[448] = {"Trottinette", "BMX"}, -- Pizzaboy
	[6526] = {"PIZZAS", "Automobile"}, 
	[6527] = {"TOWGTAV", "Automobile"}, 
	[6528] = {"MASERATI", "Automobile"}, 
	[6529] = {"ESCALADE", "Automobile"}, 
	[6530] = {"MERCS600", "Automobile"}, 
	[6531] = {"ROVERS", "Automobile"}, 
	[6532] = {"MONTECARLO", "Automobile"}, 
	[6533] = {"CHRYSLER", "Automobile"}, 
	[6534] = {"ZJOURNEY", "Automobile"}, 
	[6535] = {"300SEL", "Automobile"}, 
	[6536] = {"CAYMAN", "Automobile"}, 
	[6537] = {"VHUNTLEY", "Automobile"}, 
	[6538] = {"TOW2", "Automobile"}, 
	[6539] = {"SWATTRUCK", "Automobile"}, 
	[6540] = {"G65AMG", "Automobile"}, 
	[6541] = {"DODGECH", "Automobile"}, 
	[6542] = {"FRAPTOR", "Automobile"}, 
	[6543] = {"THUNDER", "Automobile"}, 
	[6544] = {"MIRADO", "Automobile"}, 
	[6545] = {"RTNXT", "Automobile"}, 
	[6546] = {"SAAB", "Automobile"}, 
	[6547] = {"COPCARSL", "Automobile"}, 
	[6548] = {"MTLBASE", "Automobile"}, 
	[6549] = {"PONTIAC", "Automobile"}, 
	[6550] = {"BODHI", "Automobile"}, 
	[6551] = {"FUTO", "Automobile"}, 
	[6552] = {"AMG2014", "Automobile"}, 
	[6553] = {"AMG2020", "Automobile"}, 
	[6555] = {"BMWE34", "Automobile"}, 
	[6556] = {"RRCULL", "Automobile"}, 
	[6557] = {"GLE350", "Automobile"}, 
	[6558] = {"AUDIQ8", "Automobile"}, 
	[6559] = {"CADIXT6", "Automobile"}, 
	[6560] = {"R129", "Automobile"}, 
	[6561] = {"BMWM4", "Automobile"}, 
	[6562] = {"BMWM8", "Automobile"}, 
	[6563] = {"CORVETTEC3", "Automobile"}, 
	[6564] = {"CHIRON", "Automobile"}, 
	[6565] = {"AUDIR8", "Automobile"}, 
	[6566] = {"RROYS", "Automobile"}, 
	[6567] = {"AUDIA6", "Automobile"}, 
	[6568] = {"MUSTANG", "Automobile"}, 
	[6569] = {"ELDORADO", "Automobile"}, 
	[6570] = {"RROYS2", "Automobile"}, 
	[6571] = {"TAURUS", "Automobile"}, 


	[6651] = {"SKATE", "BMX"},
	[6651] = {"PIZZA", "Bike"},
	
	[500000] = {"FreewayTest", "Bike"},
	[500001] = {"Landstalker98", "Automobile"},
}

_getVehicleType = getVehicleType
function getVehicleType(veh)
	local model
	if (isElement(veh) and getElementType(veh)=="vehicle") then
		model = getElementData(veh, "vehicleID") or getElementModel(veh)
	elseif tonumber(veh) then
		model = tonumber(veh)
	end
	if model then
		local modelInfo = CUSTOM_MODELS[model]
		if modelInfo then
			return modelInfo[2]
		end
	end
	return _getVehicleType(veh)
end

_getVehicleNameFromModel = getVehicleNameFromModel
function getVehicleNameFromModel(model)
	model = tonumber(model)
	if not model then return "?" end
	local modelInfo = CUSTOM_MODELS[model]
	if modelInfo then
		return modelInfo[1]
	end
	return _getVehicleNameFromModel(model)
end

_getVehicleModelFromName = getVehicleModelFromName
function getVehicleModelFromName(name)
	if not name then return end
	local nameL = string.lower(name)
	for id, v in pairs(CUSTOM_MODELS) do
		if string.lower(v[1]) == nameL then
			return id
		end
	end
	return _getVehicleModelFromName(name)
end
