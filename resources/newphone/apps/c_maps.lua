--IAN

local mW, mH = 3000, 3000
local sX, sY = guiGetScreenSize()

--IAN CUSTOM FUNCTIONS (JK, STOLEN FROM WIKI LOL)
function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

imports = {
	dxCreateRenderTarget = dxCreateRenderTarget,
	dxSetRenderTarget = dxSetRenderTarget,
	dxDrawImage = dxDrawImage,
	getElementPosition = getElementPosition,
	getElementRotation = getElementRotation,
	dxGetMaterialSize = dxGetMaterialSize,
	getKeyState = getKeyState,
	dxDrawRectangle = dxDrawRectangle,
	dxDrawText = dxDrawText
}

local isOverMap = nil
local playerInside = false

local phone = {
	x = sx-417*scaleRatio-25, y = sy-840*scaleRatio+-25, w = 369*scaleRatio, h = 337
}

local map = {
	x = phone.x+10, y = phone.y+72, w = 369*scaleRatio, h = 337,
	zoom = 1, maxZoom = 5, zoomValue = 0.1, minZoom = 0.5,
	blipSize = 12
}

local offset = {
	x = 0,
	y = 0
}

function getPlayerPosOnMap()
	if getElementDimension(localPlayer) ~= 0 or getElementInterior(localPlayer) ~= 0 then
		playerInside = true
	else
		playerInside = false
	end
	
	if playerInside then
		local dimension = getElementDimension(localPlayer)
		local theInterior = exports["interior-system"]:findParent(localPlayer, dimension)
		if theInterior then
			local interiorEntrance = getElementData(theInterior, "entrance")
			if interiorEntrance then
				local playerPos = Vector3(tonumber(interiorEntrance[1]), tonumber(interiorEntrance[2]), tonumber(interiorEntrance[3]))
				local mapX = map.w/2 -(playerPos.x/(6000/(mW)))
				local mapY =  map.h/2 + (playerPos.y/(6000/(mW)))
				return Vector2(mapX, mapY)
			end
		end
	else
		local playerPos = Vector3(getElementPosition(localPlayer))
		local mapX = map.w/2 -(playerPos.x/(6000/(mW)))
		local mapY =  map.h/2 + (playerPos.y/(6000/(mW)))
		return Vector2(mapX, mapY)
	end
end

function getBlipPosOnMap(blip)
	local dimension = getElementDimension(blip)
	if dimension ~= 0 then
		local theInterior = exports["interior-system"]:findParent(blip, dimension)
		if theInterior then
			local interiorEntrance = getElementData(theInterior, "entrance")
			if interiorEntrance then
				local playerPos = Vector3(tonumber(interiorEntrance[1]), tonumber(interiorEntrance[2]), tonumber(interiorEntrance[3]))
				local mapX = map.w/2 -(playerPos.x/(6000/(mW)))
				local mapY =  map.h/2 + (playerPos.y/(6000/(mW)))
				return Vector2(mapX, mapY)
			end
		end
	else
		local blipPos = Vector3(getElementPosition(blip))
		local mapX =  (blipPos.x/(6000/(mW)))
		local mapY =  -(blipPos.y/(6000/(mW)))
		
		return Vector2(mapX, mapY)
	end
end

local mouse = {
	x = 0,
	y = 0,
	clicked = false,
}

function phoneAppMaps()
	setupPhoneApp("maps")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 30, dxGetTextWidth(mapsTitleText, 0.8, phoneBigBoldFont), 10, mapsTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.image["seperator"] = dgsCreateImage(0, 60, 369*scaleRatio, 5*scaleRatio, ":newphone/files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	--
		--DO MAP STUFF HERE
		mapRT = imports.dxCreateRenderTarget(369*scaleRatio, 337)
		
		playerPos = getPlayerPosOnMap()
		offset.x = playerPos.x
		offset.y = playerPos.y
		
		addEventHandler("onClientRender", root, drawDXMap)
		
		phoneGUI.image["phonemap"] = dgsCreateImage(0, 62, 369*scaleRatio, 337, mapRT, false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	--
	
	phoneGUI.image["seperator"] = dgsCreateImage(0, 400, 369*scaleRatio, 5*scaleRatio, ":newphone/files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
end

--[[addEventHandler( "onClientKey", root,
    function ( key, press )
        if(key == "mouse_wheel_up") and press then
			if(map.zoom <= map.maxZoom) then
				map.zoom = map.zoom + map.zoomValue
			end
		elseif(key == "mouse_wheel_down") and press then
			if(map.zoom >= map.minZoom) then
				map.zoom = map.zoom - map.zoomValue
			end
		end
    end
)]] -- temp disabled zoom

function drawDXMap()
	--mW, mH = 3000 * map.zoom, 3000 * map.zoom -- temp disable zoom
	mW, mH = 3000, 3000

 	mapX, mapY = offset.x - mW/2, offset.y- mH/2
	isOverMap = isMouseInPosition(map.x, map.y, map.w, map.h) or false

	if mapX <= -mW + map.w + 5 then
		--print("I SHOULD SET THE POSITION TO THE DIASDISADIAS")
		--print("OFFX: " .. offset.x .. " MAPX: " .. mapX)

		mapX = -mW + map.w + 5
		offset.x = (-mW/2 + map.w + 5)
	end

	if mapY <= -mW + map.h + 5 then
		--print("I SHOULD SET THE POSITION TO THE DIASDISADIAS")

		offset.y = (-mW/2 + map.h + 5)
	end

	--HANDLING MOUSE SHIT
	if getKeyState("mouse1") and isOverMap then
		local cx, cy = getCursorPosition()
		if (mapX <= -5 * map.zoom or (mouse.x - cx*sX)/20 > 0) and (mapX >= -mW + map.w + 5 or (mouse.x - cx*sX)/20 < 0) then 
			offset.x = (offset.x - (mouse.x - cx*sX)/20)
		end

		if (mapY <= -5 * map.zoom or (mouse.y - cy*sY)/20 > 0) and (mapY >= -mW + map.h + 5 or (mouse.y - cy*sY)/20 < 0) then
			offset.y = (offset.y - (mouse.y - cy*sY)/20)
		end
	end
	
	-- LITTLE OPTIMISATION LOL
	imports.dxSetRenderTarget(mapRT, true)

	local playerPosition = getPlayerPosOnMap()
	imports.dxDrawImage(mapX, mapY, mW, mW, "files/map.png", 0, 0, 0)

	local player_pos = getBlipPosOnMap(localPlayer)
	local goodPlayerPos = Vector2(mapX + mW/2 + player_pos.x - (map.blipSize*2.5)/2, mapY + mW/2 + player_pos.y - (map.blipSize*2.5)/2)

	imports.dxDrawImage(goodPlayerPos.x, goodPlayerPos.y, map.blipSize*2.5, map.blipSize*2.5, "files/location.png", 0, 0, 0, tocolor(255, 0, 0))
	
	local rB, lB, tB, bB = map.x + map.w, map.x, map.y, map.y + map.h
	local cX, cY = (rB+lB)/2, (tB+bB)/2
	local toLeft, toTop, toRight, toBottom = cX-lB, cY-tB, rB-cX, bB-cY
	
	local displayingBlip = false
	
	for _, blip in ipairs(getElementsByType("blip")) do
		local blipPos = getBlipPosOnMap(blip)

		if getElementDimension(blip) == getElementDimension(localPlayer) and getElementInterior(localPlayer) == getElementInterior(blip) then
			local r, g, b = nil
			if getBlipIcon(blip) == 0 or getBlipIcon(blip) == 1 then
				r, g, b, a = getBlipColor(blip)
			end

			local goodPosition = Vector2(mapX + mW/2 + blipPos.x - (map.blipSize * getBlipSize(blip))/2, mapY + mW/2 + blipPos.y - (map.blipSize * getBlipSize(blip))/2)

			imports.dxDrawImage(goodPosition.x, goodPosition.y, map.blipSize * getBlipSize(blip), map.blipSize * getBlipSize(blip), "files/blips/" .. getBlipIcon(blip) .. ".png", 0, 0, 0, tocolor(r or 255, g or 255, b or 255, a or 255))
			if isMouseInPosition(map.x + goodPosition.x, map.y + goodPosition.y, map.blipSize * getBlipSize(blip), map.blipSize * getBlipSize(blip)) then
				local blipName = blips_name[getBlipIcon(blip)] or "Unknown"
				
				-- veh tracker
				if getBlipIcon(blip) == 2 then
					local blipVeh = getElementData(blip, "thevehicle")
					local year = getElementData(blipVeh, "year")
                    local manufacturer = getElementData(blipVeh, "manufacturer")
                    local model = getElementData(blipVeh, "model")
					
					if blipVeh and year and manufacturer and model then
						blipName = year.." "..manufacturer.." "..model
					else
						blipName = "Tracked Vehicle"
					end
				elseif getBlipIcon(blip) == 8 then
					local bizname = getElementData(blip, "bizname") or "Business"
					
					blipName = bizname
				end
				
				local textWidth = dxGetTextWidth(blipName, 1, "default-bold") + 5
				imports.dxDrawRectangle(goodPosition.x - textWidth/2 + 10, goodPosition.y - 30, textWidth, 25, tocolor(13, 13, 13))

				imports.dxDrawText(blipName, goodPosition.x - textWidth/2 + 10, goodPosition.y - 30, goodPosition.x - textWidth/2 + textWidth + 15, goodPosition.y - 30 + 30, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
			end
		end
	end

	imports.dxSetRenderTarget()

	if not isOverMap then
		mouse.clicked = false
	end
end

addEventHandler("onClientClick", root, function(btn, state, absx, absy)
	--if isOverMap then -- idk fucking why but for some reason this fixed the annoying offset lol?
		if btn == "left" and state == "down" then
			mouse.x, mouse.y = absx, absy
			mouse.clicked = true
		end
	--end

	if btn == "left" and state == "up" then
		mouse.clicked = false
	end
end)