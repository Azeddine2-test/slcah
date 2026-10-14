local blip

function resetTaxiJob()
	if (isElement(blip)) then
		destroyElement(blip)
		removeEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
	end
end
addEventHandler("onClientChangeChar", localPlayer, resetTaxiJob, false)

function displayTaxiJob(notext)
	if not isElement(blip) then
		blip = createBlip(1549.185546875, -2218.611328125, 13.546875, 0, 4, 255, 255, 0) --Unity station blip 1787.1259765625 -1903.591796875 13.394536972046
		addEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
		if not notext then
			exports.hud:sendBottomNotification(localPlayer, "Taxi Driver", "Rendez-vous au marqueur jaune sur votre radar et entrez un taxi pour démarrer votre travail.") --Text upon job selection and spawn
		end
	end
end

function startTaxiJob(thePlayer)
	if (thePlayer==localPlayer) then
		if (getElementModel(source)==438 or getElementModel(source)==420) then
			removeEventHandler("onClientVehicleEnter", getRootElement(), startTaxiJob)
			exports.hud:sendBottomNotification(localPlayer, "Taxi Driver", "Vous serez alerté lorsque quelqu'un aura commandé un taxi. Utilisez M pour intéragir avec le taximètre") --When a taxi driver enters a taxi
			if (isElement(blip)) then
				destroyElement(blip)
			end
		end
	end
end
--[[
-- taxi drivers occupied light
local keytime = 0
local function checkTaxiLights( key, state )
	local vehicle = getPedOccupiedVehicle( getLocalPlayer( ) )
	if getVehicleOccupant( vehicle ) == getLocalPlayer( ) and ( getElementModel( vehicle ) == 438 or getElementModel( vehicle ) == 420 ) then
		if state == "down" then
			keytime = getTickCount()
		elseif state == "up" and keytime ~= 0 then
			local delay = getTickCount() - keytime
			keytime = 0
			
			if delay < 200 then
				triggerServerEvent("toggleTaxiLights", getLocalPlayer( ), vehicle )
			end
		end
	else
		keytime = 0
	end
end
bindKey("horn", "both", checkTaxiLights)]]