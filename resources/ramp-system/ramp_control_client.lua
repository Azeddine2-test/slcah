rampControl = {
    button = {},
    window = {},
    scrollbar = {}
}

DGS = exports["dgs"]

function rampControlGUI(ID, remote)
	--[[if remote and not useVGItem then
		return
	end]]
	
	if not rampControl.window[1] then
		
		local currentZ = nil
		local ramp = nil
		if tonumber(ID) then
			for _, obj in pairs(getElementsByType("object"), localPlayer, true) do
				if getElementData(obj, "dbidl") == tonumber(ID) then
					maxHeight = getElementData(obj, "maxHeight")
					lowHeight = getElementData(obj, "lowHeight")
					currentX, currentY, currentZ = getElementPosition(obj)
					ramp = obj
					break
				end
			end
			
			
			if ramp then
				showCursor(true)
				local x, y, z = getElementPosition(localPlayer)
				local distance = getDistanceBetweenPoints2D(x, y, currentX, currentY)
				
				local screenW, screenH = DGS:dgsGetScreenSize()
				
				rampControl.window[1] = DGS:dgsCreateWindow((screenW - 286) / 2, (screenH - 100) / 2, 286, 100, "Lift Control - #"..ID.."", false)
				DGS:dgsWindowSetCloseButtonEnabled(rampControl.window[1], false)
				DGS:dgsWindowSetSizable(rampControl.window[1], false)

				rampControl.scrollbar[1] = DGS:dgsCreateScrollBar(10, 10, 266, 17, true, false, rampControl.window[1])
				DGS:dgsSetProperty(rampControl.scrollbar[1], "DocumentSize", maxHeight)
				DGS:dgsSetProperty(rampControl.scrollbar[1], "PageSize", lowHeight)
				--DGS:dgsSetProperty(rampControl.scrollbar[1], "StepSize", 0.1)
				
				DGS:dgsSetProperty(rampControl.scrollbar[1], "ScrollPosition", currentZ - lowHeight)
				newHeight = lowHeight - DGS:dgsScrollBarGetScrollPosition(rampControl.scrollbar[1]) / 50

				local biggestHeight = DGS:dgsGetProperty(rampControl.scrollbar[1], "DocumentSize")
				local lowestHeight = DGS:dgsGetProperty(rampControl.scrollbar[1], "PageSize")
				
				addEventHandler( "onDgsElementScroll", rampControl.scrollbar[1], function()
					if source == rampControl.scrollbar[1] then
						newHeight = DGS:dgsScrollBarGetScrollPosition(source) / 50
						
						triggerServerEvent("rampControlS", localPlayer, ramp, lowHeight, newHeight)
					end
				end)
				
				rampControl.button[1] = DGS:dgsCreateButton(70, 40, 147, 29, "Close", false, rampControl.window[1])   
				addEventHandler("onDgsMouseClickDown", rampControl.button[1], function()
					if source == rampControl.button[1] then
						showCursor(false)
						newHeight = DGS:dgsScrollBarGetScrollPosition(rampControl.scrollbar[1]) / 50
						
						destroyElement(rampControl.window[1]) 
						rampControl = {
							button = {},
							window = {},
							scrollbar = {}
						}
						toggleAllControls(true)
						triggerEvent("onClientPlayerWeaponCheck", localPlayer)

						triggerServerEvent("saveRamp", localPlayer, ID, newHeight)
					end
				end
				)
				if distance > 10 then
					DGS:dgsSetEnabled(rampControl.scrollbar[1], false)
					DGS:dgsSetText(rampControl.window[1], "Lift Control - #"..ID.." - Out of Range")
				end
			end
		end
	end
end
addEvent("rampControlGUI", true)
addEventHandler("rampControlGUI",getLocalPlayer(), rampControlGUI)


local stoodInCol = false
local stoodInColID = nil

--COL SHAPE CONTROLS
function onClientColShapeHit(theElement, matchingDimension)
    if (theElement == localPlayer) and matchingDimension then
        if getElementData(source, "vehicleramp") then
			local rampID = getElementData(source, "vehiclerampID")
			stoodInCol = true
			stoodInColID = rampID
		end
    end
end
addEventHandler("onClientColShapeHit", root, onClientColShapeHit)

--COL SHAPE CONTROLS
function onClientColShapeLeave(theElement, matchingDimension)
    if (theElement == localPlayer) and matchingDimension then
        if getElementData(source, "vehicleramp") then
			stoodInCol = false
			stoodInColID = nil
		end
    end
end
addEventHandler("onClientColShapeLeave", root, onClientColShapeLeave)

function playerPressedKey(button, press)
    if (press) and button == "e" then -- Only output when they press it down
		if not isChatBoxInputActive() then
			if stoodInCol then
				triggerEvent("rampControlGUI", localPlayer, stoodInColID)
			end
		end
    end
end
addEventHandler("onClientKey", root, playerPressedKey)