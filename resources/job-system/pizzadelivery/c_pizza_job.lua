math.randomseed(os.time())

local pizzaDeliveryBlip
local restockMarker, pizzaRestockTimer
local finishMarker
local pizzaDeliveryMarker, pizzaDoorMarker
local pizzaDeliveryStopTimer
local jobState = 1
local pizzaReady = false
local pizzaRoutes = false
local currentPizzaRoute = false
local currentPizzaRouteID = -1
local oldPizzaRouteID = false
local oldPizzaRoute = -1

local CMD_SKIP_DELIVERY = "skip"

function stopPizzaDeliveryJob()
	jobState = 1
	
	pizzaRoutes = false
	currentPizzaRoute = false
	oldPizzaRouteID = false
	pizzaReady = false
	
	if pizzaDeliveryBlip and isElement(pizzaDeliveryBlip) then
		destroyElement(pizzaDeliveryBlip)
		pizzaDeliveryBlip = nil
	end
	
	if restockMarker and isElement(restockMarker) then
		destroyElement(restockMarker)
		restockMarker = nil
	end
	
	if finishMarker and isElement(finishMarker) then
		destroyElement(finishMarker)
		finishMarker = nil
	end
	
	if pizzaDeliveryMarker and isElement(pizzaDeliveryMarker) then
		destroyElement(pizzaDeliveryMarker)
		pizzaDeliveryMarker = nil
	end
	
	if pizzaDoorMarker and isElement(pizzaDoorMarker) then
		destroyElement(pizzaDoorMarker)
		pizzaDoorMarker = nil
	end
end
addEventHandler("onClientChangeChar", localPlayer, stopPizzaDeliveryJob, false)

local function skipCurrentPizzaJob(cmd)
	if getElementData(localPlayer, "job") == 9 then
		if not (pizzaDeliveryMarker and (jobState == 2 or jobState == 3)) then
			return outputChatBox("["..pizzaCompany.."] Cette commande sert à abandonner la livraison de pizza actuelle et recevoir la suivante.", 255, 100, 100)
		end
		local x,y,z = getElementPosition(localPlayer)
		local mx,my,mz = getElementPosition(pizzaDeliveryMarker)
		local dist = getDistanceBetweenPoints3D(x,y,z, mx,my,mz)
		if dist > 50 then
			return outputChatBox("["..pizzaCompany.."] Vous êtes trop loin de votre livraison. Allez voir s'il est réellement impossible d'y accéder.", 255, 55, 55)
		end
		if isTimer(pizzaDeliveryStopTimer) then
			killTimer(pizzaDeliveryStopTimer)
			removeEventHandler("onClientMarkerLeave", pizzaDoorMarker, checkWaitAtPizzaDelivery)
		end
		outputChatBox("["..pizzaCompany.."] Vous avez abandonné la livraison à '"..currentPizzaRoute[4].."'.", 0, 255, 0)
		jobState = 1
		clearPizzaDoorCheckpoint()
		triggerServerEvent("removePizzaBox", localPlayer, localPlayer)
		loadNewCheckpointPizzaJob()
	end
end
addCommandHandler(CMD_SKIP_DELIVERY, skipCurrentPizzaJob, false)


function displayPizzaDeliveryJob(notext)
	jobState = 1
	if not notext then
		exports.hud:sendBottomNotification(localPlayer, "Livreur de Pizza", "Rendez-vous à la Pizzeria (icone pizza sur la map F11) sur votre radar et montez dans un véhicule pour commencer votre travail.")
	end
end

function receivePizzaRoutes(routes)
	if routes then
		pizzaRoutes = routes
		
		checkCurrentPizzaDeliveryStatus()
	end
end
addEvent("receivePizzaRoutes", true)
addEventHandler("receivePizzaRoutes", root, receivePizzaRoutes)
--------------- SETUP -----------------------------

function onPizzaBikeEnter(thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 and isPizzaVehicle(source, thePlayer) then
		checkCurrentPizzaDeliveryStatus()
	end
end
addEventHandler("onClientVehicleEnter", root, onPizzaBikeEnter)

function onPizzaBikeExit(thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 and isPizzaVehicle(source, thePlayer) then
		if pizzaReady then
			triggerServerEvent("carryPizzaBox", localPlayer, localPlayer, source)
			pizzaReady = false
		end
	end
end
addEventHandler("onClientVehicleExit", root, onPizzaBikeExit)

local function getNextPizzaRoute()
	local nextId
	local x,y,z = getElementPosition(localPlayer)
	while true do
		local rand = math.random(1, #pizzaRoutes)
		local route = pizzaRoutes[rand]
		local ix,iy,iz = route[1],route[2],route[3]
		if getDistanceBetweenPoints2D(x,y,z, ix,iy,iz) > 80 and rand ~= oldPizzaRouteID then
			nextId = rand
			break
		end
	end
	return nextId
end

function checkCurrentPizzaDeliveryStatus()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		if getElementData(localPlayer, "job") == 9 then
			local currentPizzaCount = getElementData(vehicle, "pizzacount")
			if currentPizzaCount and currentPizzaCount > 0 then
				if jobState == 1 then
					if pizzaRoutes and #pizzaRoutes > 0 then
						if currentPizzaRoute then
							local x, y, z = currentPizzaRoute[1], currentPizzaRoute[2], currentPizzaRoute[3]
							
							pizzaDeliveryBlip = createBlip(x, y, z, 0, 2, 255, 200, 0, 255, 0, 99999)
							pizzaDeliveryMarker = createMarker(x, y, z-5, "checkpoint", 30, 255, 200, 0, 50)
							addEventHandler("onClientMarkerHit", pizzaDeliveryMarker, arriveAtPizzaDelivery)
							addEventHandler("onClientMarkerLeave", pizzaDeliveryMarker, arriveAtPizzaDelivery)
							
							if not oldPizzaRouteID then
								outputChatBox("["..pizzaCompany.."] Rendez-vous à '"..currentPizzaRoute[4].."' pour votre première livraison.", 255, 255, 255, true)
								outputChatBox("["..pizzaCompany.."] Vous pouvez utiliser /"..CMD_SKIP_DELIVERY.." si la porte est inaccessible.", 255, 195, 15)
							else
								outputChatBox("["..pizzaCompany.."] Rendez-vous à '"..currentPizzaRoute[4].."' pour votre prochaine livraison.", 255, 255, 255, true)
							end
							
							jobState = 2
							oldPizzaRouteID = currentPizzaRouteID
						else

							local nextPizzaRoute = getNextPizzaRoute()
							currentPizzaRouteID = nextPizzaRoute
							currentPizzaRoute = pizzaRoutes[nextPizzaRoute]
							
							checkCurrentPizzaDeliveryStatus()
						end
					else
						triggerServerEvent("getPizzaDeliveryLocations", localPlayer, localPlayer)
					end
				elseif jobState == 2 then
					outputChatBox("["..pizzaCompany.."] N'oubliez pas votre livraison à '"..currentPizzaRoute[4].."'.", 255, 255, 255, true)
				end
			else
				outputChatBox("["..pizzaCompany.."] Ce véhicule n'a plus de Pizzas et doit être réapprovisionné!", 255, 255, 255)
				createRestockPizzasMarker()
			end
			
			createRemoveFinishPizzasMarker()
		end
	end
end

function createRestockPizzasMarker()
	if jobState > 0 then
		if not restockMarker then
			restockMarker = createMarker(2107.6865234375, -1823.4697265625, 13.1, "checkpoint", 3, 255, 200, 0, 50)
			addEventHandler("onClientMarkerHit", restockMarker, restockPizzaBike)
		end
	end
end

function restockPizzaBike(thePlayer)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle and localPlayer == thePlayer and isPizzaVehicle(vehicle, localPlayer) and  getElementAlpha(source) > 0 then
		pizzaRestockTimer = setTimer(function()
			if restockMarker and isElement(restockMarker) then destroyElement(restockMarker) end
			restockMarker = false
			
			if vehicle and isElement(vehicle) then
				triggerServerEvent("restockMyPizzaBike", localPlayer, localPlayer, vehicle)
			end
		end, 5000, 1)
		outputChatBox("["..pizzaCompany.."] Attendez pendant que votre véhicule de livraison est réapprovisionné.", 255, 255, 255, true )
		if not isEventHandlerAdded("onClientMarkerLeave", restockMarker, checkWaitAtPizzaRestock) then
			addEventHandler("onClientMarkerLeave", restockMarker, checkWaitAtPizzaRestock)
		end
	end
end

function checkWaitAtPizzaRestock(thePlayer)
	if thePlayer == localPlayer and isTimer(pizzaRestockTimer) then
		outputChatBox("["..pizzaCompany.."] Tu n'as pas attendu au point de réapprovisionnement.", 255, 0, 0)
		killTimer(pizzaRestockTimer)
		pizzaRestockTimer = nil
	end
end

function createRemoveFinishPizzasMarker()
	if jobState == 1 then
		if not finishMarker then
			finishMarker = createMarker(2119.1162109375, -1825.1591796875, 13.5, "checkpoint", 3, 255, 0, 0, 50)
			setMarkerIcon(finishMarker, "finish")
			addEventHandler("onClientMarkerHit", finishMarker, endPizzaDelivery)
		end
	end
end

function endPizzaDelivery(thePlayer)
	if thePlayer == localPlayer then
		if jobState > 0 then
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if vehicle and getVehicleController(vehicle) == localPlayer and isPizzaVehicle(vehicle, localPlayer) then
				-- add health check for bike here
				triggerServerEvent("finishPizzaDelivery", localPlayer, localPlayer, vehicle)
				stopPizzaDeliveryJob()
			else			
				outputChatBox("["..pizzaCompany.."] Vous devez occuper un véhicule de livraison de pizza pour compléter votre livraison.", 255, 0, 0, true ) -- Wrong vehicle type
			end
		end
	end
end

function arriveAtPizzaDelivery(thePlayer)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if thePlayer == localPlayer and vehicle and getVehicleController(vehicle) == localPlayer and isPizzaVehicle(vehicle, localPlayer) then		
		if not isEventHandlerAdded("onClientMarkerHit", pizzaDoorMarker, waitAtPizzaDeliveryInterior) then
			outputChatBox("["..pizzaCompany.."] Livrez la pizza à la porte marquée.", 255, 255, 255, true )
			outputChatBox("["..pizzaCompany.."] Vous pouvez utiliser /"..CMD_SKIP_DELIVERY.." si la porte est inaccessible.", 255, 195, 15)

			local x, y, z = currentPizzaRoute[1], currentPizzaRoute[2], currentPizzaRoute[3]
			pizzaDoorMarker = createMarker(x, y, z - 1, "cylinder", 0.8, 0, 0, 255, 100)
			jobState = 3
			addEventHandler("onClientMarkerHit", pizzaDoorMarker, waitAtPizzaDeliveryInterior)
			
			pizzaReady = true
		end
	end
end

function waitAtPizzaDeliveryInterior(thePlayer)
	if pizzaDoorMarker and thePlayer == localPlayer then
		if getPedOccupiedVehicle(thePlayer) then
			outputChatBox("["..pizzaCompany.."] Vous devez être à pied pour livrer la pizza!", 255, 0, 0)
		else
			pizzaDeliveryStopTimer = setTimer(nextPizzaDeliveryCheckpoint, 5000, 1)
			outputChatBox("["..pizzaCompany.."] Attendez un instant pour que le client récupère la Pizza.", 255, 255, 255, true )
			addEventHandler("onClientMarkerLeave", pizzaDoorMarker, checkWaitAtPizzaDelivery)
		end
	end
end

function checkWaitAtPizzaDelivery(thePlayer)
	if thePlayer == localPlayer and isTimer(pizzaDeliveryStopTimer) then
		outputChatBox("["..pizzaCompany.."] Vous n'avez pas attendu à la porte pour livrer la pizza.", 255, 255, 255)
		killTimer(pizzaDeliveryStopTimer)
		pizzaDeliveryStopTimer = nil
		removeEventHandler("onClientMarkerLeave", source, checkWaitAtPizzaDelivery)
	end
end

function clearPizzaDoorCheckpoint()
	if isElement(pizzaDeliveryMarker) then
		destroyElement(pizzaDeliveryMarker)
	end
	pizzaDeliveryMarker = nil
	
	if isElement(pizzaDoorMarker) then
		destroyElement(pizzaDoorMarker)
	end
	pizzaDoorMarker = nil
	
	if isElement(pizzaDeliveryBlip) then
		destroyElement(pizzaDeliveryBlip)
	end
	pizzaDeliveryBlip = nil
		
	currentPizzaRoute = nil
	oldPizzaRouteID = currentPizzaRouteID
end

function nextPizzaDeliveryCheckpoint()
	pizzaDeliveryStopTimer = nil
	if jobState == 3 then
		clearPizzaDoorCheckpoint()

		local pay = math.random(30, 125) -- random amount for pizza between 40 and 80
		local tipAmount = 0
		local chanceOfTip = math.random(1, 5) -- 1/5 chance of tip
		if chanceOfTip == 1 then
			tipAmount = math.random(5, 20)
		end
		triggerServerEvent("savePizzaDeliveryProgress", localPlayer, localPlayer, pay, tipAmount)
		
		jobState = 1
	end
end

function loadNewCheckpointPizzaJob()
	checkCurrentPizzaDeliveryStatus()
end
addEvent("loadNewCheckpointPizzaJob", true)
addEventHandler("loadNewCheckpointPizzaJob", root, loadNewCheckpointPizzaJob)