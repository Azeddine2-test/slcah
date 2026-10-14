local closeCooldown = false

function replaceModels()	
	jetwashGunTXD = engineLoadTXD("files/pumpgun.txd")
	engineImportTXD(jetwashGunTXD, fuelPumpGunID)

	jetwashGunDFF = engineLoadDFF("files/pumpgun.dff", fuelPumpGunID)
	engineReplaceModel(jetwashGunDFF, fuelPumpGunID)
	
	jetwashGunCOL = engineLoadCOL("files/pumpgun.col", fuelPumpGunID)
	engineReplaceCOL(jetwashGunCOL, fuelPumpGunID)
end
addEventHandler("onClientResourceStart", resourceRoot, replaceModels)

DGS = exports["dgs"]

pumpGui = {
	window = {},
	button = {},
}

local pumpGUIOpen = false

function clickPump(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == 'left' and state == 'down' and clickedElement then
        if getElementModel(clickedElement) == 3465 then
			if getElementData(clickedElement, "pump:fuelpump") == true then
				if getPedOccupiedVehicle(localPlayer) then
					outputChatBox("Vous ne pouvez pas atteindre la pompe à carburant!", 255, 0, 0)
					return
				end
				
				local pumpType = getElementData(clickedElement, "type")
				local px, py, pz = getElementPosition(localPlayer)
				local tx, ty, tz = getElementPosition(clickedElement)
				local distance = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)
				if distance <= 4 then
					if not closeCooldown then
						openFuelPump(clickedElement)
					end
				end
			end
        end
    end
end
addEventHandler('onClientClick', root, clickPump)

function openFuelPump(fuelPump)
	if pumpGUIOpen == false then
		showCursor(true)
		pumpGUIOpen = true
		
		local screenW, screenH = guiGetScreenSize()
		local windowW, windowH = 200, 120
		pumpGui.window[1] = DGS:dgsCreateWindow((screenW - windowW) / 2, (screenH - windowH) / 2, windowW, windowH, "Pompe à carburant", false)
		DGS:dgsWindowSetCloseButtonEnabled(pumpGui.window[1], false)
		DGS:dgsWindowSetSizable(pumpGui.window[1], false)
		
		local startY = 10
		if not getElementData(localPlayer, "player:fuelpump") then
			pumpGui.button["takefuelpump"] = DGS:dgsCreateButton(10, startY, 180, 35, "Prendre Pistolet", false, pumpGui.window[1])
			addEventHandler("onDgsMouseClickDown", pumpGui.button["takefuelpump"], function()
				if source == pumpGui.button["takefuelpump"] then					
					triggerServerEvent("takeFuelPump", localPlayer, localPlayer, fuelPump)
					closeFuelPumpWindow()
				end
			end)
		elseif getElementData(localPlayer, "player:fuelpump") == fuelPump then
			pumpGui.button["putpumpback"] = DGS:dgsCreateButton(10, startY, 180, 35, "Poser Pistolet", false, pumpGui.window[1])
			addEventHandler("onDgsMouseClickDown", pumpGui.button["putpumpback"], function()
				if source == pumpGui.button["putpumpback"] then					
					triggerServerEvent("putBackFuelPump", localPlayer, localPlayer, fuelPump) 
					closeFuelPumpWindow()
					stopPumping()
				end
			end)
		else
			pumpGui.button["wrongpump"] = DGS:dgsCreateButton(10, startY, 180, 35, "Mauvaise pompe", false, pumpGui.window[1])
			DGS:dgsSetEnabled(pumpGui.button["wrongpump"], false)
		end
		
		local startY = startY + 40
		pumpGui.button["close"] = DGS:dgsCreateButton(10, startY, 180, 35, "Fermer", false, pumpGui.window[1])
		addEventHandler("onDgsMouseClickDown", pumpGui.button["close"], function()
			if source == pumpGui.button["close"] then
				closeFuelPumpWindow()
				stopPumping()
			end
		end)
	end
end

function closeFuelPumpWindow()
	closeCooldown = true
	pumpGUIOpen = false
	
	if isCursorShowing() then
		executeCommandHandler("togglecursor")
	end
	showCursor(false)
	DGS:dgsCloseWindow(pumpGui.window[1])
	
	setTimer(function()
		closeCooldown = false
	end, 1000, 1)
end

function updateInvisiblePumpsCollisions()
	local px, py, pz = getElementPosition(localPlayer)
	local dimension = getElementDimension(localPlayer)
	local state = isCursorShowing()
	
	for i, v in pairs(getElementsByType("object")) do
		if getElementDimension(v) == dimension and getElementData(v, "pump:fuelpump") and getElementData(v, "pump:invisible") then
			local x, y, z = getElementPosition (v)
			local distance = getDistanceBetweenPoints3D (px, py, pz, x, y, z)
			
			if distance < 11 then
				setElementCollisionsEnabled(v, state)
			end
		end
	end
end

local cursorState = isCursorShowing()

addEventHandler("onClientRender", root,
	function()
		if cursorState ~= isCursorShowing() then
			cursorState = isCursorShowing()

			updateInvisiblePumpsCollisions()
		end
	end
)

updateInvisiblePumpsCollisions()