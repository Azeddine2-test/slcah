--------------- SETUP -----------------------------
local packageBlip, packageDeliveryBlip
local restockMarker, packageRestockTimer
local finishMarker
local packageDeliveryMarker, packageDoorMarker
local packageDeliveryStopTimer
local jobState = 1
local packageReady = false
local packageRoutes = false
local currentPackageRoute = false
local currentPackageRouteID = -1
local oldPackageRouteID = false
local oldPackageRoute = -1

local CMD_SKIP_DELIVERY = "skip"

function stopPackageDeliveryJob()
	jobState = 1

	packageRoutes = false
	currentPackageRoute = false
	oldPackageRouteID = false
	packageReady = false
	
	if packageBlip and isElement(packageBlip) then
		destroyElement(packageBlip)
		packageBlip = nil
	end
	
	if packageDeliveryBlip and isElement(packageDeliveryBlip) then
		destroyElement(packageDeliveryBlip)
		packageDeliveryBlip = nil
	end
	
	if restockMarker and isElement(restockMarker) then
		destroyElement(restockMarker)
		restockMarker = nil
	end
	
	if finishMarker and isElement(finishMarker) then
		destroyElement(finishMarker)
		finishMarker = nil
	end
	
	if packageDeliveryMarker and isElement(packageDeliveryMarker) then
		destroyElement(packageDeliveryMarker)
		packageDeliveryMarker = nil
	end
	
	if packageDoorMarker and isElement(packageDoorMarker) then
		destroyElement(packageDoorMarker)
		packageDoorMarker = nil
	end
end
addEventHandler("onClientChangeChar", localPlayer, stopPackageDeliveryJob, false)
addEvent("stopPackageDeliveryJob", true)
addEventHandler("stopPackageDeliveryJob", localPlayer, stopPackageDeliveryJob, false)

local function skipCurrentDeliveryJob(cmd)
	if getElementData(localPlayer, "job") == 1 then
		if not (packageDeliveryMarker and (jobState == 2 or jobState == 3)) then
			return outputChatBox("["..deliveryCompanyName.."] Cette commande sert à abandonner la livraison actuelle et recevoir la suivante.", 255, 100, 100)
		end
		local x,y,z = getElementPosition(localPlayer)
		local mx,my,mz = getElementPosition(packageDeliveryMarker)
		local dist = getDistanceBetweenPoints3D(x,y,z, mx,my,mz)
		if dist > 50 then
			return outputChatBox("["..deliveryCompanyName.."] Vous êtes trop loin de votre livraison. Allez voir s'il est réellement impossible d'y accéder.", 255, 55, 55)
		end
		if isTimer(packageDeliveryStopTimer) then
			killTimer(packageDeliveryStopTimer)
			removeEventHandler("onClientMarkerLeave", packageDoorMarker, checkWaitAtPackageDelivery)
			packageDeliveryStopTimer = nil
		end
		outputChatBox("["..deliveryCompanyName.."] Vous avez abandonné la livraison à '"..currentPackageRoute[4].."'.", 0, 255, 0)
		jobState = 1
		clearPackageDeliveryCheckpoint()
		triggerServerEvent("removePackageBox", localPlayer, localPlayer)
		loadNewCheckpointPackageJob()
	end
end
addCommandHandler(CMD_SKIP_DELIVERY, skipCurrentDeliveryJob, false)

-- triggered by the other trucker job
function displayPackageDeliveryJob()
	jobState = 1
	
	if not isElement(packageBlip) then
		packageBlip = createBlip(437.140625, -1351.5888671875, 14.985871315002, 51, 2, 255, 255, 255)
	end
end
addEvent("displayPackageDeliveryJob", true)
addEventHandler("displayPackageDeliveryJob", localPlayer, displayPackageDeliveryJob, false)

function receivePackageRoutes(routes)
	if routes then
		packageRoutes = routes
		
		checkCurrentPackageDeliveryStatus()
	end
end
addEvent("receivePackageRoutes", true)
addEventHandler("receivePackageRoutes", root, receivePackageRoutes)
--------------- SETUP -----------------------------

function onPackageVehicleEnter(thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 and isPackageVehicle(source, thePlayer) then
		if restockMarker then
			setElementAlpha(restockMarker, 255)
		end
		if finishMarker then
			setElementAlpha(finishMarker, 255)
		end
		
		checkCurrentPackageDeliveryStatus()
	else
		if thePlayer == localPalyer then
			if restockMarker then
				destroyElement(restockMarker)
				restockMarker = nil
			end
			if finishMarker then
				destroyElement(finishMarker)
				finishMarker = nil
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", root, onPackageVehicleEnter)

function onPackageVehicleExit(thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 and isPackageVehicle(source, thePlayer) then
		if restockMarker then
			setElementAlpha(restockMarker, 0)
		end
		if finishMarker then
			setElementAlpha(finishMarker, 0)
		end
		
		if packageReady then
			triggerServerEvent("carryPackageBox", localPlayer, localPlayer, source)
			packageReady = false
		end
	end
end
addEventHandler("onClientVehicleExit", root, onPackageVehicleExit)

local function getNextDeliveryRoute()
	local nextId
	local x,y,z = getElementPosition(localPlayer)
	while true do
		local rand = math.random(1, #packageRoutes)
		local route = packageRoutes[rand]
		local ix,iy,iz = route[1],route[2],route[3]
		if getDistanceBetweenPoints2D(x,y,z, ix,iy,iz) > 80 and rand ~= oldPackageRouteID then
			nextId = rand
			break
		end
	end
	return nextId
end

function checkCurrentPackageDeliveryStatus()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		if getElementData(localPlayer, "job") == 1 and getElementData(vehicle, "job") == 101 then
			local currentPackageCount = getElementData(vehicle, "packagecount")
			if currentPackageCount and currentPackageCount > 0 then
				if jobState == 1 then
					if packageRoutes and #packageRoutes > 0 then
						if currentPackageRoute then
							local x, y, z = currentPackageRoute[1], currentPackageRoute[2], currentPackageRoute[3]
							
							packageDeliveryBlip = createBlip(x, y, z, 0, 2, 255, 200, 0)
							packageDeliveryMarker = createMarker(x, y, z, "checkpoint", 25, 255, 200, 0, 150)
							addEventHandler("onClientMarkerHit", packageDeliveryMarker, arriveAtPackageDelivery)
							addEventHandler("onClientMarkerLeave", packageDeliveryMarker, arriveAtPackageDelivery)
							
							if not oldPackageRouteID then
								outputChatBox("["..deliveryCompanyName.."] Rendez-vous à '"..currentPackageRoute[4].."' pour votre première livraison.", 255, 255, 255, true)
								outputChatBox("["..deliveryCompanyName.."] Vous pouvez utiliser /"..CMD_SKIP_DELIVERY.." si la porte est inaccessible.", 255, 195, 15)
							else
								outputChatBox("["..deliveryCompanyName.."] Rendez-vous à '"..currentPackageRoute[4].."' pour votre prochaine livraison.", 255, 255, 255, true)
							end
							
							jobState = 2
							oldPackageRouteID = currentPackageRouteID
						else
							local nextId = getNextDeliveryRoute()
							currentPackageRouteID = nextId
							currentPackageRoute = packageRoutes[nextId]
							
							checkCurrentPackageDeliveryStatus()
						end
					else
						triggerServerEvent("getPackageDeliveryLocations", localPlayer, localPlayer)
					end
				elseif jobState == 2 then
					outputChatBox("["..deliveryCompanyName.."] N'oubliez pas votre livraison à '"..currentPackageRoute[4].."'.", 255, 255, 255, true)
				end
			else
				outputChatBox("["..deliveryCompanyName.."] Ce véhicule n'a plus de colis et doit être réapprovisionné.", 255, 255, 255)
				outputChatBox("["..deliveryCompanyName.."] Bonne route !", 255, 255, 255)
				createRestockPackagesMarker()
			end
			
			createRemoveFinishPackagesMarker()
		end
	end
end

function createRestockPackagesMarker()
	if jobState > 0 then
		if not restockMarker then
			restockMarker = createMarker(421.70703125, -1360.78125, 12.908522605896, "checkpoint", 5, 255, 200, 0, 150)
			addEventHandler("onClientMarkerHit", restockMarker, restockPackageVehicle)
		end
	end
end

function restockPackageVehicle(thePlayer)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle and localPlayer == thePlayer and isPackageVehicle(vehicle, localPlayer) and  getElementAlpha(source) > 0 then
		packageRestockTimer = setTimer(function()
			if restockMarker and isElement(restockMarker) then destroyElement(restockMarker) end
			restockMarker = false
			
			if vehicle and isElement(vehicle) then
				triggerServerEvent("restockMyPackageVehicle", localPlayer, localPlayer, vehicle)
			end
		end, 5000, 1)
		outputChatBox("["..deliveryCompanyName.."] Attendez un instant pendant que votre véhicule de livraison de colis est réapprovisionné.", 255, 255, 255, true )
		if not isEventHandlerAdded("onClientMarkerLeave", restockMarker, checkWaitAtPackageRestock) then
			addEventHandler("onClientMarkerLeave", restockMarker, checkWaitAtPackageRestock)
		end
	end
end

function checkWaitAtPackageRestock(thePlayer)
	if thePlayer == localPlayer and isTimer(packageRestockTimer) then
		outputChatBox("["..deliveryCompanyName.."] Tu n'as pas attendu au point de réapprovisionnement.", 255, 0, 0)
		killTimer(packageRestockTimer)
		packageRestockTimer = nil
	end
end

function createRemoveFinishPackagesMarker()
	if jobState == 1 then
		if not finishMarker then
			finishMarker = createMarker(406.625, -1369.2978515625, 12.867901802063, "checkpoint", 5, 255, 0, 0, 150)
			setMarkerIcon(finishMarker, "finish")
			addEventHandler("onClientMarkerHit", finishMarker, endPackageDelivery)
		end
	end
end

function endPackageDelivery(thePlayer)
	if thePlayer == localPlayer then
		if jobState > 0 then
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if vehicle and getVehicleController(vehicle) == localPlayer and isPackageVehicle(vehicle, localPlayer) then
				-- add health check for bike here
				stopPackageDeliveryJob()
				triggerServerEvent("finishPackageDelivery", localPlayer, localPlayer, vehicle)
			else
				outputChatBox("["..deliveryCompanyName.."] Vous devez occuper un véhicule de livraison de colis pour compléter la livraison.", 255, 0, 0, true ) -- Wrong vehicle type
			end
		end
	end
end

function arriveAtPackageDelivery(thePlayer)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if thePlayer == localPlayer and vehicle and getVehicleController(vehicle) == localPlayer and isPackageVehicle(vehicle, localPlayer) then		
		if not isEventHandlerAdded("onClientMarkerHit", packageDoorMarker, waitAtPackageDeliveryInterior) then
			outputChatBox("["..deliveryCompanyName.."] Livrez le colis à l'intérieur marqué.", 255, 255, 255, true )
			outputChatBox("["..deliveryCompanyName.."] Vous pouvez utiliser /"..CMD_SKIP_DELIVERY.." si la porte est inaccessible.", 255, 195, 15)
			local x, y, z = currentPackageRoute[1], currentPackageRoute[2], currentPackageRoute[3]
			packageDoorMarker = createMarker(x, y, z, "checkpoint", 1, 0, 0, 255, 150)
			jobState = 3
			addEventHandler("onClientMarkerHit", packageDoorMarker, waitAtPackageDeliveryInterior)
			
			packageReady = true
		end
	end
end

function waitAtPackageDeliveryInterior(thePlayer)
	if packageDoorMarker and thePlayer == localPlayer then
		if getPedOccupiedVehicle(thePlayer) then
			outputChatBox("Vous devez être à pied pour livrer le colis!", 255, 0, 0)
		else
			packageDeliveryStopTimer = setTimer(nextPackageDeliveryCheckpoint, 5000, 1)
			outputChatBox("["..deliveryCompanyName.."] Attendez un instant pour que le client récupère le Colis..", 255, 255, 255, true )
			addEventHandler("onClientMarkerLeave", packageDoorMarker, checkWaitAtPackageDelivery)
		end
	end
end

function checkWaitAtPackageDelivery(thePlayer)
	if thePlayer == localPlayer then
		outputChatBox("["..deliveryCompanyName.."] Vous n'avez pas attendu à la porte pour livrer le colis.", 255, 255, 255)
		if packageDeliveryStopTimer then
			killTimer(packageDeliveryStopTimer)
			packageDeliveryStopTimer = nil
		end
		removeEventHandler("onClientMarkerLeave", source, checkWaitAtPackageDelivery)
	end
end

function clearPackageDeliveryCheckpoint()
	if isElement(packageDeliveryMarker) then
		destroyElement(packageDeliveryMarker)
	end
	packageDeliveryMarker = nil
	
	if isElement(packageDoorMarker) then
		destroyElement(packageDoorMarker)
	end
	packageDoorMarker = nil
	
	if isElement(packageDeliveryBlip) then
		destroyElement(packageDeliveryBlip)
	end
	packageDeliveryBlip = nil
		
	currentPackageRoute = nil
	oldPackageRouteID = currentPackageRouteID
end

function nextPackageDeliveryCheckpoint()
	packageDeliveryStopTimer = nil
	if jobState == 3 then
		clearPackageDeliveryCheckpoint()
		
		jobState = 1
		
		triggerServerEvent("savePackageDeliveryProgress", localPlayer, localPlayer)
	end
end

function loadNewCheckpointPackageJob()	
	checkCurrentPackageDeliveryStatus()
end
addEvent("loadNewCheckpointPackageJob", true)
addEventHandler("loadNewCheckpointPackageJob", root, loadNewCheckpointPackageJob)