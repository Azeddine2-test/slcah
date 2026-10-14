returnMarker = nil
leftMarker = false
disconnecting = false

local sx, sy = guiGetScreenSize()
local scanlineOffset = 0
local scanLineDirection = false
local distance = 0

local cameraForwardOffset = 0
local cameraZoomOffset = 0
local defaultFOV = getCameraFieldOfView("player")

function replaceDroneModels()
	local txd = engineLoadTXD ("mods/droneremote.txd")
	engineImportTXD (txd, droneRemoteObjectModelID)
	local dff = engineLoadDFF("mods/droneremote.dff")
	engineReplaceModel(dff, droneRemoteObjectModelID, true)
	local col = engineLoadCOL("mods/droneremote.col")
	engineReplaceCOL(col, droneRemoteObjectModelID)
	
	local txd = engineLoadTXD ("mods/drone.txd")
	engineImportTXD (txd, droneObjectModelID)
	local dff = engineLoadDFF("mods/drone.dff")
	engineReplaceModel(dff, droneObjectModelID, true)
	local col = engineLoadCOL("mods/drone.col")
	engineReplaceCOL(col, droneObjectModelID)
	
	local txd = engineLoadTXD ("mods/dronevehicle.txd")
	engineImportTXD (txd, 501)
	local dff = engineLoadDFF("mods/dronevehicle.dff")
	engineReplaceModel(dff, 501, true)
end
addEventHandler("onClientResourceStart", resourceRoot, replaceDroneModels)

function checkForDroneHUDState(theKey, oldValue, newValue)
    if (source == localPlayer and theKey == "piloting:drone") then
        if newValue == true then
			addEventHandler("onClientRender", root, drawDroneCameraAndHUD)
			attachElements( getCamera(), getPedOccupiedVehicle( localPlayer ), 0, 0, -0.2, 0, 0, 0 );
			setElementAlpha(getPedOccupiedVehicle( localPlayer ), 0)
			createDroneReturnMarker()
			scanlineOffset = 0
			scanLineDirection = false
			showChat(false)
			disconnecting = false
			
			setElementData(localPlayer, "exclusiveGUI", true, false)
		else
			if not getCameraTarget(localPlayer) then
				setCameraTarget(localPlayer)
			end
			removeEventHandler("onClientRender", root, drawDroneCameraAndHUD)
			
			setElementData(localPlayer, "exclusiveGUI", false, false)
			showChat(true)
			
			cameraForwardOffset = 0
		end
    end
end
addEventHandler("onClientElementDataChange", root, checkForDroneHUDState)

function createDroneReturnMarker()
	local x, y, z = getElementPosition(localPlayer)
	leftMarker = false
	
	returnMarker = createMarker(x, y, z-0.9, "cylinder", 0.8, 255, 255, 255, 150)
end

function hitReturnMarker(hitPlayer, matchingDimension)
	if source == returnMarker and matchingDimension then
		if hitPlayer == localPlayer then
			if leftMarker then
				if isElement(returnMarker) then
					destroyElement(returnMarker)
				end
				
				returnMarker = nil
				triggerServerEvent("stopUsingDrone", localPlayer, localPlayer, true)
				toggleControl("enter_exit", true)
			end
		end
	end
end
addEventHandler("onClientMarkerHit", getRootElement(), hitReturnMarker)

function leaveReturnMarker(hitPlayer, matchingDimension)
	if source == returnMarker then
		if hitPlayer == localPlayer and matchingDimension then
			if not leftMarker then
				leftMarker = true
			end
		end
	end
end
addEventHandler("onClientMarkerLeave", getRootElement(), leaveReturnMarker)

function round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

local currentCount = 0
local systemUpTime = getTickCount()

function drawDroneCameraAndHUD()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if theVehicle then
		local battery = getElementData(theVehicle, "battery")
		if battery then
			if isControlEnabled("enter_exit") then
				toggleControl("enter_exit", false)
			end
			
			if scanLineDirection then
				scanlineOffset = scanlineOffset - 2
				if scanlineOffset < 2 then
					scanLineDirection = false
				end
			else
				scanlineOffset = scanlineOffset + 2 
				if scanlineOffset > 256 then
					scanLineDirection = true
				end
			end
			
			if isElement(returnMarker) then
				currentCount = getTickCount()
				
				local x, y, z = getElementPosition(localPlayer)
				local gz = getGroundPosition(Vector3(getElementPosition(localPlayer)))
				local distance = getDistanceBetweenPoints3D(x, y, z, Vector3(getElementPosition(returnMarker)))
				local scanlineAlpha = 60
				
				local batteryTimer = currentCount - systemUpTime
				if batteryTimer > 12500 then
					systemUpTime = getTickCount()
					setElementData(theVehicle, "battery", battery - 1, true)
				end
				
				if not disconnecting then	
					if battery < 1 then
						disconnecting = true
						destroyElement(returnMarker)
						returnMarker = nil
						
						local x, y, z = getElementPosition(localPlayer)
						local gz = getGroundPosition(x, y, z)
					
						triggerServerEvent("disconnectPlayerFromDrone", localPlayer, localPlayer, "battery", gz)
						return
					elseif round(round(distance, 2)/0.33, 2) > 454 then
						disconnecting = true
						destroyElement(returnMarker)
						returnMarker = nil
						
						local x, y, z = getElementPosition(localPlayer)
						local gz = getGroundPosition(x, y, z)
					
						triggerServerEvent("disconnectPlayerFromDrone", localPlayer, localPlayer, "disconnect", gz)
						return
					end
				end
				
				scanlineAlpha = scanlineAlpha + (distance / 1)
				
				if scanlineAlpha > 255 then
					scanlineAlpha = 255
				end
				
				dxDrawImage(0-sx, 0-sy - scanlineOffset, sx*4, sy*4, "files/scanlines.png", 0, 0, 0, tocolor(255, 255, 255, scanlineAlpha))
				
				dxDrawRectangle(0, 0, sx, 120, tocolor(0, 0, 0))
				dxDrawRectangle(0, sy, sx, -120, tocolor(0, 0, 0))
				
				dxDrawText("Controle degré caméra: X / C", 10, 10, 0, 0, nil, 2, "default-bold")
				
				dxDrawText("Batterie: "..battery.."%", 10, sy-50, 0, 0, nil, 2, "default-bold")
				dxDrawText("Altitude: ".. round(round(z - gz, 2)/0.33, 2) .."pieds", 10, sy-80, 0, 0, nil, 2, "default-bold")
				dxDrawText("Portée: "..round(round(distance, 2)/0.33, 2).."/"..round(round(droneRange, 2)/0.33, 2).."pieds", 10, sy-110, 0, 0, nil, 2, "default-bold")
				
				dxDrawText("Degrés: "..cameraForwardOffset.."°", 200, sy-50, 0, 0, nil, 2, "default-bold")
				
				if getKeyState("c") then
					if (cameraForwardOffset - 1) > -91 and cameraForwardOffset - 1 < 1 then
						cameraForwardOffset = cameraForwardOffset - 1
						
						setElementAttachedOffsets( getCamera(), 0, 0, -0.2, cameraForwardOffset, 0, 0 )
					end
				end
				
				if getKeyState("x") then
					if cameraForwardOffset + 1 > -91 and cameraForwardOffset + 1 < 1 then
						cameraForwardOffset = cameraForwardOffset + 1
						
						setElementAttachedOffsets( getCamera(), 0, 0, -0.2, cameraForwardOffset, 0, 0 )
					end
				end
			end
		end
	end
end

function setDroneControlAnim(player)
	setElementBoneRotation(player, 21, 64.858123779297, -123.92811584473, 82.103370666504)
	setElementBoneRotation(player, 22, -2.8814418315887, -34.277278900146, -76.424827575684)
	setElementBoneRotation(player, 23, -5.6212894605778e-07, -67.04566192627, 9.9999990463257)
	setElementBoneRotation(player, 24, 136.05712890625, 6.4960160255432, 19.948587417603)
	setElementBoneRotation(player, 25, 0.42805814743042, 69.017868041992, -2.0940234661102)
	setElementBoneRotation(player, 26, 0, 89.109565734863, -0)
	setElementBoneRotation(player, 31, -60.900897979736, -128.61506652832, -74.504234313965)
	setElementBoneRotation(player, 32, 29.129758834839, -1.7157807350159, 70.245803833008)
	setElementBoneRotation(player, 33, -40, -74.698501586914, -10.000001907349)
	setElementBoneRotation(player, 34, -87.124046325684, -8.828462600708, 2.5043661594391)
	setElementBoneRotation(player, 35, -4.9371123313904, 37.068176269531, 0.94729298353195)
	setElementBoneRotation(player, 36, 0, 16.141500473022, -0)
    
    updateElementRpHAnim(player)
end

local dronePeds = {}
local animating = false

local function updateCustomAnimPlayers()
    for ped, v in pairs(dronePeds) do
		if isElementStreamedIn(ped) then
			setDroneControlAnim(ped)
		end
	end
end

local function receiveSync(dronePeds_)
	dronePeds = dronePeds_

	for ped, v in pairs(dronePeds) do
		if not animating then
			animating = true
			addEventHandler ("onClientPedsProcessed", root, updateCustomAnimPlayers)
		end
		return
	end

	animating = false
	removeEventHandler ("onClientPedsProcessed", root, updateCustomAnimPlayers)
end
addEvent("drones:sync", true)
addEventHandler("drones:sync", localPlayer, receiveSync, false)
