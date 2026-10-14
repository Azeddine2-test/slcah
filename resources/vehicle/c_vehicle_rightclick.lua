-- Nando 08/03/2023

local vehicle = nil
local ax, ay = 0, 0
function requestInventory(button)
	if button=="left" and not getElementData(localPlayer, "exclusiveGUI") then
		if isVehicleLocked(vehicle) and vehicle ~= getPedOccupiedVehicle(localPlayer) then
			triggerServerEvent("onVehicleRemoteAlarm", vehicle)
			outputChatBox("Ce véhicule est verrouillé.", 255, 0, 0)
		elseif type(getElementData(vehicle, "Impounded")) == "number" and isVehicleImpounded(vehicle) and not exports.global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) then
			outputChatBox("Vous avez besoin des clés pour rechercher ce véhicule.", 255, 0, 0)
		else
			triggerServerEvent( "openFreakinInventory", localPlayer, vehicle, ax, ay )
		end
	end
end

function clickVehicle(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if (element) and (getElementType(element)=="vehicle") and (button=="right") and (state=="down") then
		local x, y, z = getElementPosition(localPlayer)
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=3) then
			ax = absX
			ay = absY
			vehicle = element
			triggerServerEvent("vehicle:rightclick:fetch_data", vehicle)
		end
	end
end
addEventHandler("onClientClick", root, clickVehicle, true)

addEvent("vehicle:rightclick:data", true)
addEventHandler("vehicle:rightclick:data", root, function(...) if vehicle == source then showVehicleMenu(...) end end)

--Needs to be redone to run better
function isNotAllowedV(theVehicle)
	--[[local vmodel = getElementModel(theVehicle)
	if (exports.global:getVehicleType(vmodel) == "Plane") then
		return true
	end
	if (exports.global:getVehicleType(vmodel) == "Helicopter") then
		return true
	end
	if (exports.global:getVehicleType(vmodel) == "Boat") then
		return true
	end
	if (exports.global:getVehicleType(vmodel) == "Train") then
		return true
	end
	if (exports.global:getVehicleType(vmodel) == "Trailer") then
		return true
	end]]
	return false
end

function showVehicleMenu(hasRamp)
	local rightclick = exports.rightclick
	--Name
	local vName = exports.global:getVehicleName(vehicle)

	local row = {}
	local rcMenu = rightclick:create(vName)

	local isLocked = isVehicleLocked(vehicle)
	local inCar = ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle ) or false

	if exports.vehicle:hasVehiclePlates(vehicle) and getElementData(vehicle, "show_plate") ~= 0 then -- Addded no plates support
		row.plate = rightclick:addRow(getVehiclePlateText(vehicle), true)
	end

	if (isVehicleImpounded(vehicle)) then
		local days = getRealTime().yearday-getElementData(vehicle, "Impounded")
		row.impounded = rightclick:addRow("Saisi: "..days.." jours", false, true)
	end

	if (hasVehicleWindows(vehicle)) then
		local windowState = isVehicleWindowUp(vehicle, true) and "Up" or "Down"
		row.window = rightclick:addRow("Fenêtres: "..windowState, false, true)
	end

	if not getPedOccupiedVehicle(localPlayer) and isLocked and not getElementData(vehicle, "doorForced", false) then
		row.forceDoor = rightclick:addRow("Forcer la porte")
		addEventHandler("onClientGUIClick", row.forceDoor, forceDoor, false)
	end

	if getPedOccupiedVehicle(localPlayer) == vehicle and getPedOccupiedVehicleSeat(localPlayer) == 0 and not getVehicleEngineState(vehicle) then
		row.breakIgnition = rightclick:addRow("Utiliser Boîtier électronique")
		addEventHandler("onClientGUIClick", row.breakIgnition, breakIgnition, false)
	end

	if getElementData(vehicle, "doorForced", false) and exports.integration:isPlayerAdmin(localPlayer, true) then
		row.changeLockAdmin = rightclick:addRow("(Admin) Réparer la sérrure")
		addEventHandler("onClientGUIClick", row.changeLockAdmin, changeLockAdmin, false)
	end

	--y = y + lineH

	--if --[[ ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle ) and  *]](exports.global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) or exports.factions:isPlayerInFaction(localPlayer, getElementData(vehicle, "faction"))) then
	if ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle ) or (exports.global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) or exports.factions:isPlayerInFaction(localPlayer, getElementData(vehicle, "faction"))) or not isLocked then

		local lockText
		if isLocked then
			lockText = "Déverrouiller"
		else
			lockText = "Verrouiller"
		end
		row.lock = rightclick:addRow(lockText)
		addEventHandler("onClientGUIClick", row.lock, lockUnlock, false)

		if not isLocked or inCar then --if vehicle is not locked or if player is inside vehicle
			if not getElementData(vehicle, "tempVehicle") then
				local allow = true

				if getElementData(vehicle, "faction") > 0 and not exports.factions:isPlayerInFaction(localPlayer, getElementData(vehicle, "faction")) then
					allow = false
				end

				if allow then
					row.inventory = rightclick:addRow("Inventaire")
					addEventHandler("onClientGUIClick", row.inventory, requestInventory, false)
				end
			end

			-- Cabriolet (Exciter)
			if isCabriolet(vehicle) then
				row.cabriolet = rightclick:addRow("Décapotable")
				addEventHandler("onClientGUIClick", row.cabriolet, cabrioletToggleRoof, false)
			end

			if hasRamp and getPedOccupiedVehicle(localPlayer) == vehicle then
				row.ramp = rightclick:addRow("Déployer Rampe")
				addEventHandler("onClientGUIClick", row.ramp, toggleRamp, false)
			end
		end
	end

	--[[ if exports["job-system"]:canMechanicJob(localPlayer) then -- Mechanic
		row.fix = rightclick:addRow("Menu Mécano")
		addEventHandler("onClientGUIClick", row.fix, openMechanicWindow, false)
	end *]]
	
	local vx,vy,vz = getElementVelocity(vehicle)
	if vx < 0.05 and vy < 0.05 and vz < 0.05 then
		local vdbid = tonumber(getElementData(vehicle, "dbid")) or 0

		if not getPedOccupiedVehicle(localPlayer) then
			if getElementData(vehicle, "clamped") and getElementData(vehicle, "clamped") > 0  then
				if exports["factions"]:isInFactionType(localPlayer, 8) and getElementData(vehicle, "owner") ~= vdbid then
					row.unclamp = rightclick:addRow("Retirer sabot")
					addEventHandler("onClientGUIClick", row.unclamp, function()
						triggerServerEvent("setVehicleClampState", localPlayer, localPlayer, vehicle)
					end)
				else
					row.unclamp = rightclick:addRow("Retirer sabot - $250")
					addEventHandler("onClientGUIClick", row.unclamp, function()
						triggerServerEvent("payForClampRemoval", localPlayer, localPlayer, vehicle)
					end)
				end
			else
				if exports["item-system"]:hasItem(localPlayer, 285) and exports["factions"]:isInFactionType(localPlayer, 8) then
					row.clamp = rightclick:addRow("Poser Sabot")
					addEventHandler("onClientGUIClick", row.clamp, function()
						triggerServerEvent("setVehicleClampState", localPlayer, localPlayer, vehicle)

					end)
				end
			end
			
			if getElementModel(vehicle) == 448 and #getVehicleOccupants(vehicle) == 0 and vdbid > 0 then
				row.foldscooter = rightclick:addRow("Plier")
				addEventHandler("onClientGUIClick", row.foldscooter, function()
					triggerServerEvent("escooter:despawn", root, localPlayer, vehicle, vdbid)
				end)
			end
		end
	end

	if not isLocked then
		if vx < 0.05 and vy < 0.05 and vz < 0.05 and not getPedOccupiedVehicle(localPlayer) and not isVehicleLocked(vehicle) then -- completely stopped
			local trailers = { [606] = true, [607] = true, [610] = true, [590] = true, [569] = true, [611] = true, [584] = true, [608] = true, [435] = true, [450] = true, [591] = true }
			if trailers[ getElementModel( vehicle ) ] then
				row.park = rightclick:addRow("Garer")
				addEventHandler("onClientGUIClick", row.park, parkTrailer, false)
			else
				if exports.global:hasItem(localPlayer, 57) then -- FUEL CAN
					row.fill = rightclick:addRow("Remplir Réservoir")
					addEventHandler("onClientGUIClick", row.fill, fillFuelTank, false)
				end
			end
		end
	end

	if (getElementModel(vehicle)==497) or (getElementModel(vehicle)==469) then -- HELICOPTER
		local players = getElementData(vehicle, "players")
		local found = false

		if (players) then
			for key, value in ipairs(players) do
				if (value==localPlayer) then
					found = true
				end
			end
		end

		if not (found) then
			row.sit = rightclick:addRow("Sit")
			addEventHandler("onClientGUIClick", row.sit, sitInHelicopter, false)
		else
			row.sit = rightclick:addRow("Stand Up")
			addEventHandler("onClientGUIClick", row.sit, unsitInHelicopter, false)
		end
	end

	local entrance = getElementData( vehicle, "entrance" )
	if entrance then
		if not isPedInVehicle(localPlayer) then
			row.enter = rightclick:addRow("Entrer Interieur")
			addEventHandler("onClientGUIClick", row.enter, enterInterior, false)

			row.knock = rightclick:addRow("Frapper à la porte")
			addEventHandler("onClientGUIClick", row.knock, knockVehicle, false)
		elseif getElementModel(vehicle) == 435 then
			row.enter = rightclick:addRow("Entrer Interieur (Vehicule)")
			addEventHandler("onClientGUIClick", row.enter, enterInterior, false)
		end
	end

	local seat = -1
	if vehicle == getPedOccupiedVehicle(localPlayer) then
		for i = 0, (getVehicleMaxPassengers(vehicle) or 0) do
			if getVehicleOccupant(vehicle, i) == localPlayer then
				seat = i
				break
			end
		end
	end
	if #getDoorsFor(getElementModel(vehicle), seat) > 0 then -- Now showing this outside of the check because people were abusing it to get away from the alarm.
		row.doorControl = rightclick:addRow("Portes")
		addEventHandler("onClientGUIClick", row.doorControl, function(button, state) fDoorControl(button, state, isLocked) end, false)
	end

	if not isLocked then
		local vModel = getElementModel(vehicle)
		if (exports.global:getVehicleType(vehicle) == "Trailer" or vModel==608) then -- this is a trailer, zomg. But exports.global:getVehicleType returns "" CLIENT-SIDE. Fine on the server.
			row.handbrake = rightclick:addRow("Frein à main")
			addEventHandler("onClientGUIClick", row.handbrake, handbrakeVehicle, false)
		end

		if ((vModel == 416 or vModel == 417 or vModel == 487 or vModel == 442) and getElementData(vehicle, "faction") == 2 and exports.factions:isPlayerInFaction(localPlayer, 2) and getElementData(localPlayer, "duty") > 0) then
			row.stretcher = rightclick:addRow("Brancard")
			addEventHandler("onClientGUIClick", row.stretcher, fStretcher, false)

			if not getElementData(localPlayer, "morgue.isCarryingBodyBag") then
				row.bodyBag = rightclick:addRow("Sac mortuaire")
				addEventHandler("onClientGUIClick", row.bodyBag, fBodyBag, false)
			end

			if getElementData(localPlayer, "morgue.isCarryingBodyInABag") then
				row.depositBody = rightclick:addRow("Déposer le corps")
				addEventHandler("onClientGUIClick", row.depositBody, fDepositBody, false)
			elseif getElementData(localPlayer, "morgue.isCarryingBodyBag") then
				row.depositBodyBag = rightclick:addRow("Déposer le sac mortuaire")
				addEventHandler("onClientGUIClick", row.depositBodyBag, fDespositBodyBag, false)
			elseif getElementData(vehicle, "morgue.carriedCorpses") then
				row.depositBodyBag = rightclick:addRow("Prendre corps")
				addEventHandler("onClientGUIClick", row.depositBodyBag, fTakeBody, false)
			end
		end

		if ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle ) then
			if (getElementData(vehicle, "dbid") > 0 ) then
				row.look = rightclick:addRow("Edit Description")
				addEventHandler("onClientGUIClick", row.look, fLook, false)
			end
		end
	end

	if (exports.integration:isPlayerAdmin(localPlayer, true) or exports.integration:isPlayerScripter(localPlayer)) then

		row.respawn = rightclick:addRow("ADM: Respawn")
		addEventHandler("onClientGUIClick", row.respawn, fRespawn, false)

	-- 	row.textures = rightclick:addRow("ADM: Textures")
	-- 	addEventHandler("onClientGUIClick", row.textures, fTextures, false)
	end

	-- row.textures = rightclick:addRow("Preview Texture")
	-- addEventHandler("onClientGUIClick", row.textures, pTextures, false)
	
	if (getElementModel(vehicle) == 544) and not getPedOccupiedVehicle(localPlayer) then
		row.ladderTruck = rightclick:addRow("Monter sur l'échelle")
		addEventHandler("onClientGUIClick", row.ladderTruck, fLadder, false)
	end

	if (exports.factions:isPlayerInFaction(localPlayer, 4) or exports.factions:isPlayerInFaction(localPlayer, 10)) then
		if getElementData(vehicle, "gluedToVehicle", false) then
			row.glue = rightclick:addRow("Unglue")
			addEventHandler("onClientGUIClick", row.glue, fUnglue, false)
		elseif isVehicleOnVehicle(vehicle, 578) then
			row.glue = rightclick:addRow("Glue")
			addEventHandler("onClientGUIClick", row.glue, fGlue, false)
		end
	end
end

function forceDoor(button)
	if (button=="left") then
		triggerServerEvent("carjacking.onPlayerStartForceVehicle", localPlayer, vehicle)
	end
end

function breakIgnition(button)
	if (button=="left") then
		triggerServerEvent("carjacking.onPlayerStartBreakVehicleIgnition", localPlayer, vehicle)
	end
end

function changeLockAdmin(button)
	if (button=="left") then
		triggerServerEvent("carjacking.onPlayerChangeVehicleLockAdmin", localPlayer, vehicle)
	end
end

function lockUnlock(button, state)
	if (button=="left") then
		if getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle then
			triggerServerEvent("lockUnlockInsideVehicle", localPlayer, vehicle)
		elseif exports.global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) or (exports.factions:isPlayerInFaction(localPlayer, getElementData(vehicle, "faction"))) then
			triggerServerEvent("lockUnlockOutsideVehicle", localPlayer, vehicle)
		end
	end
end

function fStretcher(button, state)
	if (button=="left") then
		if not (isVehicleLocked(vehicle)) then
			triggerServerEvent("stretcher:createStretcher", root, vehicle)
		end
	end
end

function fBodyBag(button, state)
	if (button=="left") then
		triggerServerEvent("client.morgue.onPlayerRequestTakeBodyBag", localPlayer, vehicle)
	end
end

function fDepositBody(button, state)
	if (button=="left") then
		triggerServerEvent("client.morgue.onPlayerRequestDepositBody", localPlayer, vehicle)
	end
end

function fDespositBodyBag(button, state)
	if (button=="left") then
		triggerServerEvent("client.morgue.onPlayerRequestDepositBodyBag", localPlayer)
	end
end

function fTakeBody(button, state)
	if (button=="left") then
		local vehicleCarriedCorpses = getElementData(vehicle, "morgue.carriedCorpses")

		if vehicleCarriedCorpses then
			triggerServerEvent("client.morgue.onPlayerRequestTakeBodyFromVehicle", localPlayer, vehicle, #vehicleCarriedCorpses)
		end
	end
end

function fLook(button, state)
	if (button=="left") then
		triggerEvent("editdescription", getLocalPlayer())
	end
end

function fDoorControl(button, state, locked)
	if (button=="left") and (not locked) then
		openVehicleDoorGUI( vehicle )
	elseif locked then
		outputChatBox("Ce véhicule est verrouillé.", 255, 0, 0)
	end
end

function parkTrailer(button, state)
	if (button=="left") then
		-- TODO
	end
end

function fillFuelTank(button, state)
	if (button=="left") then
		local _,_, value = exports.global:hasItem(localPlayer, 57)
		if value > 0 then
			triggerServerEvent("fillFuelTankVehicle", localPlayer, vehicle)
		else
			outputChatBox("Ce jerrican est vide..", 255, 0, 0)
		end
	end
end

function openMechanicWindow(button, state)
	if (button=="left") then
		triggerEvent("openMechanicFixWindow", localPlayer, vehicle)
	end
end

function toggleRamp(button)
	if (button=="left") then
		triggerServerEvent("vehicle:control:ramp", localPlayer, vehicle)
	end
end

function sitInHelicopter(button, state)
	if (button=="left") then
		triggerServerEvent("sitInHelicopter", localPlayer, vehicle)
	end
end

function unsitInHelicopter(button, state)
	if (button=="left") then
		triggerServerEvent("unsitInHelicopter", localPlayer, vehicle)
	end
end

function enterInterior()
	triggerServerEvent( "enterVehicleInterior", getLocalPlayer(), vehicle )
end

function knockVehicle()
	triggerServerEvent("onVehicleKnocking", getLocalPlayer(), vehicle)
end

function handbrakeVehicle()
	triggerServerEvent("vehicle:handbrake", vehicle)
end

function cabrioletToggleRoof()
	triggerServerEvent("vehicle:toggleRoof", getLocalPlayer(), vehicle)
end

function fRespawn()
	triggerServerEvent("vehicle-manager:respawn", getLocalPlayer(), vehicle)
end

function fTextures()
	triggerEvent("item-texture:vehtex", localPlayer, vehicle)
end

function pTextures()
    triggerEvent("item-texture:previewVehTex", localPlayer, vehicle) 
end

function fLadder(button, state)
	if (button=="left") then
		local vx, vy, vz = getElementPosition(vehicle)
		setElementPosition(localPlayer, vx, vy-4, vz+1.55)
	end
end

function fUnglue(button, state)
	local otherVehicle = getElementData(vehicle, "gluedToVehicle", false)

	if isElement(otherVehicle) then
		detachElements(vehicle, otherVehicle)
		setElementData(vehicle, "gluedToVehicle", false)
	end
end

function fGlue(button, state)
	local isOnVehicle, otherVehicle = isVehicleOnVehicle(vehicle, 578)

	if isOnVehicle then
		attachRotationAdjusted(vehicle, otherVehicle)
		setElementData(vehicle, "gluedToVehicle", otherVehicle)
	end
end

function isVehicleOnVehicle(vehicle, model)
	local x1, y1, z1 = getElementPosition(vehicle)
	local x2, y2, z2 = x1, y1, z1 - getElementDistanceFromCentreOfMassToBaseOfModel(vehicle) - 1

	local line = {processLineOfSight(x1, y1, z1, x2, y2, z2, false, true, false, false, false, true, true, true, vehicle, false, false)}
	return line[1] and getElementModel(line[5]) == model, line[5]
end

function attachRotationAdjusted ( from, to )
    -- Note: Objects being attached to ('to') should have at least two of their rotations set to zero
    --       Objects being attached ('from') should have at least one of their rotations set to zero
    -- Otherwise it will look all funny

    local frPosX, frPosY, frPosZ = getElementPosition( from )
    local frRotX, frRotY, frRotZ = getElementRotation( from )
    local toPosX, toPosY, toPosZ = getElementPosition( to )
    local toRotX, toRotY, toRotZ = getElementRotation( to )
    local offsetPosX = frPosX - toPosX
    local offsetPosY = frPosY - toPosY
    local offsetPosZ = frPosZ - toPosZ
    local offsetRotX = frRotX - toRotX
    local offsetRotY = frRotY - toRotY
    local offsetRotZ = frRotZ - toRotZ

    offsetPosX, offsetPosY, offsetPosZ = applyInverseRotation ( offsetPosX, offsetPosY, offsetPosZ, toRotX, toRotY, toRotZ )

    attachElements( from, to, offsetPosX, offsetPosY, offsetPosZ, offsetRotX, offsetRotY, offsetRotZ )
end


function applyInverseRotation ( x,y,z, rx,ry,rz )
    -- Degress to radians
    local DEG2RAD = (math.pi * 2) / 360
    rx = rx * DEG2RAD
    ry = ry * DEG2RAD
    rz = rz * DEG2RAD

    -- unrotate each axis
    local tempY = y
    y =  math.cos ( rx ) * tempY + math.sin ( rx ) * z
    z = -math.sin ( rx ) * tempY + math.cos ( rx ) * z

    local tempX = x
    x =  math.cos ( ry ) * tempX - math.sin ( ry ) * z
    z =  math.sin ( ry ) * tempX + math.cos ( ry ) * z

    tempX = x
    x =  math.cos ( rz ) * tempX + math.sin ( rz ) * y
    y = -math.sin ( rz ) * tempX + math.cos ( rz ) * y

    return x, y, z
end

setCameraClip(true, false)