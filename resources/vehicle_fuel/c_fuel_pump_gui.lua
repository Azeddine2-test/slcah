local playersRefuelling = {}

-- FUEL CABLE START
function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

local puttingBack = false
local puttingBackTimer = nil

function drawFuelPumpCable()
	for v, _ in pairs(playersRefuelling) do
		if isElementStreamedIn(v) then
			local fuelPump = getElementData(v, "player:fuelpump")
			
			local attachedObjects = exports['pAttach']:getAttacheds(v)
			rhx, rhy, rhz = nil, nil, nil
			if attachedObjects then
				for _, v2 in pairs(attachedObjects) do
					if getElementData(v2, "pumpgun") == true then
						rhx, rhy, rhz = getPositionFromElementOffset(v2, 0, 0, 0)
					end
				end
				
				if fuelPump then
					tx, ty, tz = getPositionFromElementOffset(fuelPump, 0, 0, -0.4)
					
					if tx and ty and tz and rhx and rhy and rhz then
						if tonumber(rhx) then
							dxDrawLine3D(tx, ty, tz, rhx, rhy, rhz, tocolor ( 0, 0, 0, 255 ), 4)
						end
						
						if v == localPlayer then
							local distance = getDistanceBetweenPoints3D(tx, ty, tz, rhx, rhy, rhz)
							if distance then
								if distance > 9 and distance < 900 then
									if puttingBack == false then
										puttingBack = true
										triggerServerEvent("putBackFuelPump", localPlayer, localPlayer, fuelPump)
										stopPumping()
										
										puttingBackTimer = setTimer(function()
											puttingBack = false
										end, 500, 1)
									end
								end
								
								if getPedOccupiedVehicle(localPlayer) then
									if puttingBack == false then
										puttingBack = true
										triggerServerEvent("putBackFuelPump", localPlayer, localPlayer, fuelPump)
										stopPumping()
										
										puttingBackTimer = setTimer(function()
											puttingBack = false
										end, 500, 1)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, drawFuelPumpCable)
-- FUEL CABLE END

local currentlyFilled = 0
local currentlyFilledPrice = 0

local sx, sy = guiGetScreenSize()
local selectedElement = nil

local currentlyFueling = false
local fuelTimer = nil
local pumpGuiShowing = false
local fuelTypeName = nil

function clickPump(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if not currentlyFueling then
		if button == 'left' and state == 'down' and clickedElement then
			if getElementType(clickedElement) == "vehicle" then
				local px, py, pz = getElementPosition(localPlayer)
				local tx, ty, tz = getElementPosition(clickedElement)
				local distance = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)
				if distance <= 3 then
					if getElementModel(clickedElement) == 448 then return end
					
					setTimer(function()
						local handling = getVehicleHandling(clickedElement)
						if handling["engineType"] == "petrol" then
							fuelTypeName = "Petrol"
						elseif handling["engineType"] == "diesel" then
							fuelTypeName = "Diesel"
						else
							fuelTypeName = "Electric"
						end
						
						selectedElement = clickedElement
					end, 500, 1)
				end
			elseif getElementType(clickedElement) == "object" and getElementModel(clickedElement) == 1650 then
				local px, py, pz = getElementPosition(localPlayer)
				local tx, ty, tz = getElementPosition(clickedElement)
				local distance = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)
				if distance <= 3 then
					setTimer(function()
						fuelTypeName = "Fuel"
						selectedElement = clickedElement
					end, 500, 1)
				end
			end
		end
	end
end
addEventHandler('onClientClick', root, clickPump)

function drawRefuelling()
	local titleHeight = 30
	local boxHeight = 120
	
	if currentlyFueling then
		local boxHeight = 60
		dxDrawRectangle(sx-265, sy-300, 250, titleHeight, tocolor(49, 56, 120, 230), false) -- BACKGROUND
		dxDrawRectangle(sx-265, sy-270, 250, boxHeight, tocolor(30, 30, 30, 230)) -- BACKGROUND
		dxDrawText("Reçu:", sx-255, sy-290, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold")
		
		dxDrawText("Prix:", sx-255, sy-260, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold")
		dxDrawText(currentlyFilled.." litre(s) - $"..currentlyFilledPrice, sx-255, sy-240, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold")
	end
	
	dxDrawRectangle(sx-265, sy-180, 250, titleHeight, tocolor(49, 56, 120, 230), false) -- BACKGROUND
	dxDrawRectangle(sx-265, sy-150, 250, boxHeight, tocolor(30, 30, 30, 230)) -- BACKGROUND
	dxDrawText("Commandes:", sx-255, sy-170, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold")
	if not selectedElement then
		dxDrawText("M - Sélectionner un élément à remplir.", sx-255, sy-140, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
	else
		if not currentlyFueling then
			dxDrawText("Clique Gauche - Commencer.", sx-255, sy-140, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
		else
			dxDrawText("Clique Droit - Stopper.", sx-255, sy-140, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
		end
	end
	--dxDrawText("MOUSE 2 - Click right mouse button when\nrefuelling to stop.", sx-255, sy-100, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
	
	dxDrawText("Selected:", sx-255, sy-120, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold")
	
	if not selectedElement then
		dxDrawText("None", sx-255, sy-100, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
	else
		--[[local x, y, z = getElementPosition(localPlayer)
		local ex, ey, ez = getElementPosition(selectedElement)
		if getDistanceBetweenPoints2D(x, y, ex, ey) > 3 then
			selectedElement = nil
		end]]
		
		if selectedElement and getElementType(selectedElement) == "vehicle" then
			dxDrawText(getVehicleName(selectedElement), sx-255, sy-100, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
		elseif selectedElement then
			dxDrawText("Jerrican", sx-255, sy-100, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
		end
	end
	
	dxDrawText("Type:", sx-255, sy-80, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold")
	if selectedElement and getElementType(selectedElement) == "vehicle" then
		dxDrawText(fuelTypeName, sx-255, sy-60, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
	elseif selectedElement and getElementType(selectedElement) == "object" then
		dxDrawText(fuelTypeName, sx-255, sy-60, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
	else
		dxDrawText("None", sx-255, sy-60, 100, 40, tocolor ( 255, 255, 255, 255 ), 1, 1, "default-bold-small")
	end
	
	if selectedElement then
		if not currentlyFueling then
			if getKeyState("mouse1") and not isCursorShowing() then
				if not getElementData(selectedElement, "beingrefuelled") then
					currentlyFueling = true
					triggerServerEvent("setPumpingAnimation", localPlayer, localPlayer, selectedElement)
					
					fuelTimer = setTimer(function()
						fillVehicle()
					end, 4000, 0)
				end
			end
		else
			local px, py, pz = getElementPosition(localPlayer)
			local tx, ty, tz = getElementPosition(selectedElement)
			local distance = getDistanceBetweenPoints2D(px, py, tx, ty)
			if distance > 8 then
				stopPumping()
			end
			
			if getKeyState("mouse2") and not isCursorShowing() and currentlyFueling then
				stopPumping()
			end
		end
	end
end

function fillVehicle()
	if selectedElement then
		local fuelPump = getElementData(localPlayer, "player:fuelpump")
		local currentFuelPrice = getElementData(fuelPump, "pump:fuelPrice")

		if getElementType(selectedElement) == "vehicle" then
			if exports["global"]:hasMoney(localPlayer, currentFuelPrice) then
				local MAX_FUEL = getMaxFuel(getElementModel(selectedElement))
				local currFuel = tonumber(getElementData(selectedElement, "fuel"))
				
				if currFuel + 2 > MAX_FUEL then
					stopPumping()
					outputChatBox("Le véhicule est plein.")
				else
					currentlyFilled = currentlyFilled + 2
					currentlyFilledPrice = currentlyFilledPrice + currentFuelPrice
					triggerServerEvent("addFuelToVehicle", localPlayer, localPlayer, selectedElement, currentFuelPrice)
				end
			else
				outputChatBox("Tu n'as pas assez d'argent.")
				stopPumping()
			end
		elseif getElementType(selectedElement) == "object" then
			if exports["global"]:hasMoney(localPlayer, currentFuelPrice) then
				local MAX_FUEL = jerryCanMaxFuel
				local currFuel = getElementData(selectedElement, "itemValue")
				
				if tonumber(currFuel) and currFuel + 2 > MAX_FUEL then
					stopPumping()
					outputChatBox("Ce jerrican est plein.")
				elseif tonumber(currFuel) then
					currentlyFilled = currentlyFilled + 2
					currentlyFilledPrice = currentlyFilledPrice + currentFuelPrice
					triggerServerEvent("addFuelToVehicle", localPlayer, localPlayer, selectedElement, currentFuelPrice)
				else
					outputChatBox("Wtf?")
				end
			else
				outputChatBox("Tu n'as pas assez d'argent.")
				stopPumping()
			end
		end
	end
end

function stopPumping()
	if currentlyFueling == true then
		triggerServerEvent("stopPumpingAnimation", localPlayer, localPlayer, selectedElement)
	end
	
	currentlyFueling = false
	selectedElement = nil
	fuelTypeName = nil
	currentlyFilled = 0
	currentlyFilledPrice = 0
	
	if isTimer(fuelTimer) then
		killTimer(fuelTimer) 
		fuelTimer = nil
	end
end

function checkForHUDState(theKey, oldValue, newValue)
    if (getElementType(source) == "player") and (theKey == "player:refuelling") then
    	if source == localPlayer then
	        if newValue == true then
				addEventHandler("onClientRender", root, drawRefuelling)
			else
				removeEventHandler("onClientRender", root, drawRefuelling)
			end
		end
		playersRefuelling[source] = (newvalue == true)
    end
end
addEventHandler("onClientElementDataChange", root, checkForHUDState)

addEventHandler("onClientPlayerQuit", root, function()
	playersRefuelling[source] = nil
end)