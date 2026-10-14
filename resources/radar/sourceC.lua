local s = {guiGetScreenSize()}

local rect = exports.dgs:dgsCreateRoundRect(50,false,tocolor(0,0,0,180)) 
local rect_border = exports.dgs:dgsCreateRoundRect(50,false,tocolor(0,0,0,180), false, true) 
local nativeX, nativeY = s[1]/1920, s[2]/1080
radarS = {308 * nativeX, 185 * nativeY}
radarR = {320 * nativeX, 320 * nativeY}
radarP = {10, s[2]-(radarS[2]+35)}
local vizSzin = tocolor(40, 40, 40,255)
local radarM = {3072,3072}
local blipMeret = {20,20}
local zoom = 1
local minZoom = 0.5
local maxZoom = 3
local zoomRadio = 0.01
radarHud = true
local renderData={}

--local radar_texture = dxCreateTexture("files/rect.png")
--local radarTexture= dxCreateTexture("files/radar.png")
--local radarFont = dxCreateFont("files/roboto.ttf", 10 * nativeX) or "default-bold"
--local radarFont = "default-bold"

setElementData(localPlayer, "radar_pos", radarP)
setElementData(localPlayer, "radar_size", radarS)

local moveOffset = false
local moveOffsetX = 0
local moveOffsetY = 0

--renderTarget=dxCreateRenderTarget(radarS[1], radarS[2],true)
--radar=dxCreateRenderTarget(radarS[1], radarS[2],true)
--radarTexture= dxCreateTexture("files/radar.png")
--rectTexture = dxCreateTexture("files/rectTexture.png")
--
--radarMask = dxCreateShader("files/hud_mask.fx")
--dxSetShaderValue(radarMask, "sMaskTexture", rectTexture)
--
--assert(renderTarget and radar and radarTexture and radarMask, "Failed to create radar render target")

function kozeliGPSPontokTorlese()
	for i,pont in ipairs(gpsPontok) do
		local x,y = getElementPosition(getLocalPlayer())
		if(getDistanceBetweenPoints2D ( x, y, pont.x, pont.y ) < 5) then
			table.remove(gpsPontok, i)
			for k,kpont in ipairs(gpsPontok) do 
				if kpont.id < pont.id then
					table.remove(gpsPontok, k)
				end
			end
			if(#gpsPontok == 0) then
				if(utiBlip) then
					destroyElement(utiBlip)
					utiBlip = nil
				end
			end
		end
	end
end

currentMapStyling = true
local rendering = false

function updateMapRender()
	local hasItem = exports.global:hasItem(localPlayer, 111)
	if not hasItem then
		local pv = getPedOccupiedVehicle(localPlayer)
		if pv then
			if exports.global:hasItem(pv, 111) then
				hasItem = true
			elseif (getElementData(pv, "job") or 0) > 0 then
				hasItem = true
			else
				local vf = (getElementData(pv, "faction") or 0)
				if vf > 0 then
					local ft = exports.factions:getFactionType(vf)
					hasItem (ft == 2 or ft == 3 or ft == 4) -- gov factions
				end
			end
		end
	end
	local hudActive = exports.hud:isActive(true)
	local loggedIn = getElementData(localPlayer, "loggedin")==1
	if not (hudActive and hasItem and loggedIn) then
		setPlayerHudComponentVisible("radar", false)
		if rendering then
			newRadar.setState(false)
			removeEventHandler("onClientRender", getRootElement(), ujkRadarRender)
			rendering = false
		end
	else
		local showGangZones = tonumber(getElementData(localPlayer, "gang_zones:show")) == 1
		if showGangZones then
			
			currentMapStyling = false
			if rendering then
				newRadar.setState(false)
				removeEventHandler("onClientRender", getRootElement(), ujkRadarRender)
				rendering = false
			end
			setPlayerHudComponentVisible("radar", true)
		else
			currentMapStyling = true
			setPlayerHudComponentVisible("radar", false)
			if not rendering then
				newRadar.setState(true)
				addEventHandler("onClientRender", getRootElement(), ujkRadarRender)
				rendering = true
			end
		end
	end
end
addEvent("newRadar:update", true)
addEventHandler("newRadar:update", localPlayer, updateMapRender, false)

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "loggedin") == 1 then
		updateMapRender()
	end
end, false)

local max = math.max
local min = math.min
function ujkRadarRender()
	if getElementInterior(localPlayer) > 0 or radarMegjelenitve then return end

		kozeliGPSPontokTorlese()
 
		--[[local camX, camY, camZ = getElementRotation(getCamera())
		local jx, jy, _ = getElementPosition(localPlayer)
		local rot = getPedRotation(localPlayer)
		local mW, mH = dxGetMaterialSize(renderTarget)
		local X, Y = mW/2 -(jx/(6000/radarM[1])), mH/2 +(jy/(6000/radarM[2]))
		dxSetRenderTarget(renderTarget, true)
		if alwaysRenderMap or getElementInterior(localPlayer) == 0 then
			dxDrawImage(X - radarM[1]/2, (Y - radarM[2]/2), radarM[1], radarM[2], radarTexture, camZ, (jx/(6000/radarM[1])), -(jy/(6000/radarM[2])), tocolor(255, 255, 255))
		end

		local lB, rB, tB, bB = radarP[1], radarP[1]+radarS[1], radarP[2], radarP[2]+radarS[2]
		local cX, cY = (rB+lB)/2, (tB+bB)/2
		local toLeft, toTop, toRight, toBottom = cX-lB, cY-tB, rB-cX, bB-cY

		dxSetShaderValue(radarMask, "sPicTexture", renderTarget)
		dxSetShaderValue(radarMask, "sMaskTexture", rectTexture)
		dxSetRenderTarget()

		dxDrawImage(radarP[1], radarP[2], radarS[1], radarS[2], radarMask) -- Radar

		local ux, uy = nil, nil
		for k, v in ipairs(gpsPontok) do
			local bx, by = v.x, v.y
			local actualDist = getDistanceBetweenPoints2D(jx, jy, bx, by)
			local dist = actualDist/(6000/((radarM[1]+radarM[2])/2))
			local rot = findRotation(bx, by, jx, jy)-camZ
			local bpx, bpy = getPointFromDistanceRotation(cX, cY, min(dist, math.sqrt(toTop^2 + toRight^2)), rot)
			bpx = max(lB, min(rB, bpx))
			bpy = max(tB, min(bB, bpy))
			if ux and uy then
			  dxDrawLine(ux, uy, bpx, bpy, tocolor(255, 0, 0, 255), 3)
			  ux, uy = bpx, bpy
			else
			  ux, uy = bpx,bpy
			end
		end

		local blips = getElementsByType("blip")
		for i = 1, #blips do
			local blip = blips[i]
			local bx, by = getElementPosition(blip)
			local actualDist = getDistanceBetweenPoints2D(jx, jy, bx, by)
			local maxDist = getBlipVisibleDistance(blip)
		
		if actualDist <= maxDist and getElementDimension(blip) == getElementDimension(localPlayer) and getElementInterior(blip)==getElementInterior(localPlayer) then
			local dist = actualDist/(6000/((radarM[1]+radarM[2])/2))
			local rot = findRotation(bx, by, jx, jy)-camZ
			local bpx, bpy = getPointFromDistanceRotation(cX, cY, math.min(dist, math.sqrt(toTop^2 + toRight^2)), rot)
			local bpx = math.max(lB, math.min(rB, bpx))
			local bpy = math.max(tB, math.min(bB, bpy))
			local bid = getElementData(blip, "sajatIkon") or getBlipIcon(blip)
			local _, _, _, bcA = getBlipColor(blip)
			local bcR, bcG, bcB = 255, 255, 255
			if getBlipIcon(blip) == 0 then
				bcR, bcG, bcB = getBlipColor(blip)
			end

			if bpx >= radarP[1]+radarS[1]-blipMeret[1]/2 then bpx = radarP[1]+radarS[1]-blipMeret[1]/2 end
			if bpx <= radarP[1]+blipMeret[1]/2 then bpx = radarP[1]+blipMeret[1]/2 end

			if bpy >= radarP[2]+radarS[2]-blipMeret[2]/2 then bpy = radarP[2]+radarS[2]-blipMeret[2]/2 end
			if bpy <= radarP[2]+blipMeret[2]/2 then bpy = radarP[2]+blipMeret[2]/2 end

			dxDrawImage(bpx - blipMeret[1]/2, bpy - blipMeret[2]/2, blipMeret[1], blipMeret[2], "blips/"..bid..".png", 0, 0, 0, tocolor(bcR, bcG, bcB, bcA))
		end
	end

	--CUSTOM BLIPS
	for i = 1, #created_custom_blips do
		local customBlip = created_custom_blips[i]
		local bx, by = customBlip.x, customBlip.y
		local actualDist = getDistanceBetweenPoints2D(jx, jy, bx, by)
		local maxDist = customBlip.visibleDistance
		
		if actualDist <= (maxDist or 350) and customBlip.dimension == getElementDimension(localPlayer) and customBlip.interior == getElementInterior(localPlayer) then
			local dist = actualDist/(6000/((radarM[1]+radarM[2])/2))
			local rot = findRotation(bx, by, jx, jy)-camZ
			local bpx, bpy = getPointFromDistanceRotation(cX, cY, math.min(dist, math.sqrt(toTop^2 + toRight^2)), rot)
			local bpx = math.max(lB, math.min(rB, bpx))
			local bpy = math.max(tB, math.min(bB, bpy))
			local bid = customBlip.icon
			local bcR, bcG, bcB, bcA = getCustomBlipColor(k)

			if bpx >= radarP[1]+radarS[1]-blipMeret[1]/2 then bpx = radarP[1]+radarS[1]-blipMeret[1]/2 end
			if bpx <= radarP[1]+blipMeret[1]/2 then bpx = radarP[1]+blipMeret[1]/2 end

			if bpy >= radarP[2]+radarS[2]-blipMeret[2]/2 then bpy = radarP[2]+radarS[2]-blipMeret[2]/2 end
			if bpy <= radarP[2]+blipMeret[2]/2 then bpy = radarP[2]+blipMeret[2]/2 end

			dxDrawImage(bpx - blipMeret[1]/2, bpy - blipMeret[2]/2, blipMeret[1], blipMeret[2], "blips/"..bid..".png", 0, 0, 0, tocolor(bcR, bcG, bcB, bcA))
		end
	end

	dxDrawImage(radarP[1]+radarS[1]/2 -(blipMeret[1])/2, radarP[2]+radarS[2]/2 -(blipMeret[2])/2, blipMeret[1], blipMeret[2], "files/arrow.png", camZ-getPedRotation(localPlayer), 0, 0)
	dxDrawImage(radarP[1], radarP[2], radarS[1], radarS[2], radar_texture)


	local x,y,z = getElementPosition(localPlayer)
    local location = getZoneName(x,y,z)
    dxDrawText(location, radarP[1]+35, radarP[2]+radarS[2] + 1, radarP[1]+4+radarS[1], radarP[2]+radarS[2]-22, tocolor(255, 255, 255), 1, radarFont, "left", "center") *]]
end

addEventHandler("onClientClick", root, function(key, state, cursorX, cursorY)
	if key == "left" and state == "down" and getElementData(localPlayer, "ui->Setup") then
		if cursorX >= radarP[1] and cursorX <= radarP[1] + radarS[1] and cursorY >= radarP[2] and cursorY <= radarP[2] + radarS[2] then
			moveOffset = true
			moveOffsetX = cursorX-radarP[1]
			moveOffsetY = cursorY-radarP[2]
		end
	elseif key == "left" and state == "up" and getElementData(localPlayer, "ui->Setup") then
		if moveOffset then
			moveOffset = false

			setElementData(localPlayer, "ui->Radar", {radarX = radarP[1], radarY = radarP[2]})
		end
	end
end)

function findRotation(x1,y1,x2,y2)
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
end

function dxCreateBorder(x,y,w,h,color)
	dxDrawRectangle(x-2,y-2,w+4,2,color, true) -- Fent
	dxDrawRectangle(x-2,y,2,h,color, true) -- Bal Oldal
	dxDrawRectangle(x-2,y+h,w+4,2,color, true) -- Lent Oldal
	dxDrawRectangle(x+w,y-2,2,h+2,color, true) -- Jobb Oldal
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end


--createBlip(0, 0, 0, 20)