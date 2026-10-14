-- RULES GUI ETC
local bmxInfoPickupsParent
local bmxRulesGUI = nil
DGS = exports["dgs"]

function bmxRules()
	if isElement(bmxRulesGUI) then
		destroyElement(bmxRulesGUI)
	end
	local width, height = 375, 600
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth / 2 - (width / 2)
	local y = scrHeight / 2 - (height / 2)
	bmxRulesGUI = DGS:dgsCreateWindow(x, y, width, height, "Skatepark - Règles", false)
	DGS:dgsWindowSetSizable(bmxRulesGUI, false)
	DGS:dgsWindowSetCloseButtonEnabled(bmxRulesGUI, false)
	local memoRules = DGS:dgsCreateMemo(15, 15, 345, 500, infoPickupText, false, bmxRulesGUI)
	DGS:dgsMemoSetReadOnly(memoRules, true)
	DGS:dgsMemoSetWordWrapState(memoRules, 2)
	local close = DGS:dgsCreateButton(15, 525, 345, 35, "Fermer", false, bmxRulesGUI)
	addEventHandler("onDgsMouseClickUp", close, function()
		destroyElement(bmxRulesGUI)
		bmxRulesGUI = nil
		showCursor(false)
	end, false)
	showCursor(true)
end

function createSpMarkers()
	if infoPickupsEnabled then
		bmxInfoPickupsParent = createElement("bmxInfoPickupsParent")
		for i = 1, #infoPickupLocations do
			local pickup = createPickup(infoPickupLocations[i][1], infoPickupLocations[i][2], infoPickupLocations[i][3], 3, 1239)
			setElementParent(pickup, bmxInfoPickupsParent)
		end
		addEventHandler("onClientPickupHit", bmxInfoPickupsParent, function(hitPlayer, matchingDimension)
			if hitPlayer == localPlayer and matchingDimension then
				bmxRules()
			end
		end, true)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, createSpMarkers)

local controlsActive = false
local minus = false
local plus = false
local left = false
local right = false
local forwardKey = false
local backKey = false
local lookLeftControlEnabled = isControlEnabled("vehicle_look_left")
local lookRightControlEnabled = isControlEnabled("vehicle_look_right")

function startBMXControls()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if theVehicle and not isVehicleOnGround(theVehicle) and bikeIDs[getElementData(theVehicle, "vehicleBaseID") or getElementModel(theVehicle)] and isElementWithinColShape(localPlayer, bmxCol) then
		if lookLeftControlEnabled then
			toggleControl("vehicle_look_left", false)
		end
		if lookRightControlEnabled then
			toggleControl("vehicle_look_right", false)
		end

		local rx, ry, rz = getElementRotation(theVehicle)
		if getKeyState(forwardKey) == true or getKeyState(backKey) == true then -- is doing a flip, pulling back or leaning forward
			if getKeyState(backKey) then
				setElementRotation(theVehicle, rx + 1.5, 0, rz)
			else
				setElementRotation(theVehicle, rx - 1.5, 0, rz)
			end
		end

		if getKeyState("a") or getKeyState("e") then
			if getKeyState("a") then
				setElementAngularVelocity(theVehicle, 0, 0, 0.075)
			else
				setElementAngularVelocity(theVehicle, 0, 0, -0.075)
			end
		end
	end
end

addEventHandler("onClientColShapeHit", bmxCol, function(thePlayer)
	if thePlayer == localPlayer then
		if not controlsActive then
			local forwardKeys = getBoundKeys("steer_forward") or {}
			local backKeys = getBoundKeys("steer_back") or {}

			for keyName, state in pairs(forwardKeys) do
				forwardKey = keyName
				break
			end

			for keyName, state in pairs(backKeys) do
				backKey = keyName
				break
			end
			if not forwardKey or not backKey then return end
			
			controlsActive = true
			setPedCanBeKnockedOffBike(localPlayer, false)
			triggerServerEvent("setPedBikeStatEv", localPlayer, localPlayer, true)
			
			addEventHandler("onClientRender", root, startBMXControls)
		end
	end
end, false)

addEventHandler("onClientColShapeLeave", bmxCol, function(thePlayer)
	if thePlayer == localPlayer then
		if controlsActive then
			removeEventHandler("onClientRender", root, startBMXControls)
			controlsActive = false 

			setPedCanBeKnockedOffBike(localPlayer, true)
			triggerServerEvent("setPedBikeStatEv", localPlayer, localPlayer, false)

			if lookLeftControlEnabled then
				toggleControl("vehicle_look_left", true)
			end
			if lookRightControlEnabled then
				toggleControl("vehicle_look_right", true)
			end

			forwardKey = false
			backKey = false
		end
	end
end, false)
