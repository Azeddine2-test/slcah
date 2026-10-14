
-- Nando 13/09/2023 -----------------------------------------------------------------------------------
-- taken from newmodels_engine

local resources = {}
local isClientFile = isElement(localPlayer)
_createVehicle = createVehicle

function setElementResource(element, theResource)
	if isElement(element) then
		theResource = theResource or resource
		if type(resources[theResource]) ~= "table" then
			resources[theResource] = {}
		end
		table.insert(resources[theResource], element)
		setElementParent(element, getResourceDynamicElementRoot(theResource) )
	end
end



function handleResourceStop(stoppedRes)
	if resources[stoppedRes] then
		for i=1,#resources[stoppedRes] do
			local element = resources[stoppedRes][i]
			if isElement(element) then
				destroyElement(element)
			end
		end
	end
end

if isClientFile then
	addEventHandler("onClientResourceStop", root, handleResourceStop)
else
	addEventHandler("onResourceStop", root, handleResourceStop)
end

local function outputCustomError(errorCode, id, elementType)
	if errorCode == "INVALID_MODEL" then
		outputDebugString("[vehicle_load] ID "..id.." doesn't exist", 4, 255,200,0)
	elseif errorCode == "WRONG_MOD" then
		outputDebugString("[vehicle_load] Mod ID "..id.." is not a "..elementType.." model", 4, 255,200,0)
	else
		outputDebugString("[vehicle_load] Unknown error", 4, 255,200,0)
	end
end

local function createElementWithModel(elementType, modelid, ...)
	if elementType == "vehicle" then
		return _createVehicle(modelid, ...)
	end
	return false
end

local function createElementSafe(elementType, id, ...)

	local baseModel, isCustom, dataName, baseDataName = exports["newmodels"]:checkModelID(id, elementType)
	if tonumber(baseModel) then
		
		local element = createElementWithModel(elementType, baseModel, ...)
		if not isElement(element) then
			return false
		end

		if isCustom then
			setElementData(element, dataName, id, not isClientFile)
			setElementData(element, baseDataName, baseModel, not isClientFile)
		end
		
		return element
	end

	outputCustomError(baseModel, id, elementType)
	return false
end

-- EXPORTED
function createVehicle(id, ...)
	assert(type(id)=="number", "Invalid model ID passed: "..tostring(id))
	local vehicle = createElementSafe("vehicle", id, ...)
	setElementResource(vehicle, sourceResource)
	return vehicle
end

----------------------------------------------------------------------------------------------------------------------
