--TM
local markerBlip = false
local blipTimer = false
local hoverLegend = false

local s = {guiGetScreenSize()}
local radarS = {s[1]-400, s[2]-200}
local radarP = {s[1]/2-radarS[1]/2, s[2]/2-radarS[2]/2}
local vizSzin = tocolor(109, 143,175, 255)
local nagymap
local radarM = {3072,3072}
local blipMeret = {20,20}
local jatekosMeret = {12,12}
local zoom = 1
local minZoom = 0.5
local maxZoom = 2
local zoomRadio = 0.05
local mozgatAdat = {0,0}
local honnanMozgat = {0,0}
local chatetRejtett = false
utiBlip = nil
local sx, sy = s[1]/1920, s[2]/1080

local gridCache = 1
local gridRows = 26
local defaultGridRows = 26

local busStopsHidden = tonumber(getElementData(localPlayer, "busstops:hidden"))

gpsPontok = {}
radarDrawing = false
local title = dxCreateFont("files/roboto.ttf", 12 * sx) or "default-bold"
local small = dxCreateFont("files/roboto.ttf", 10 * sx) or "default-bold"


nagymap=dxCreateRenderTarget(radarS[1], radarS[2],false)
radar=dxCreateRenderTarget(radarS[1], radarS[2],false)

assert(nagymap and radar, "Aborting script, failed to create render targets")

function getBusStopsHiddenValue()
	return busStopsHidden
end

addEventHandler("onClientKey", getRootElement(), function(gomb, statusz)
	if(gomb == "F11" and statusz) then
		if currentMapStyling then
			togRadar()
			cancelEvent()
		end
	end
end)

function togRadar()
	if(radarDrawing) then
		radarDrawing = false
		stopMapRender()
		showChat(true)
		unbindKey( "mouse_wheel_up", "down",mwheel)
   		unbindKey( "mouse_wheel_down", "down",mdown)
	else
		radarDrawing = true
		startMapRender()
		showChat(false)
		mozgatAdat = {0,0}
		bindKey( "mouse_wheel_up", "down",mwheel)
   		bindKey( "mouse_wheel_down", "down",mdown)
	end
end

function startMapRender()
	if not radarDrawing then return end
	addEventHandler("onClientRender", getRootElement(), drawMapRender)
end

addEventHandler( "onClientMouseWheel", getRootElement( ),
    function ( fel_le )
		if not radarDrawing then return end
		
        if(fel_le == 1) then
			if(zoom < maxZoom) then
				zoom = zoom + zoomRadio
			end
		elseif(fel_le == -1) then
			if(zoom > minZoom) then
				zoom = zoom - zoomRadio
			end
		end
    end
)

function utvonalTervezes(x,y,z,hx,hy,hz)
	local utvonal = calculatePathByCoords(x,y,z,hx,hy,hu)
	if not utvonal then
		outputConsole('Erreur radar: calculatePathByCoords')
		return
	end
	gpsPontok = {}
	for i,node in ipairs(utvonal) do
		table.insert(gpsPontok, {x = node.x, y = node.y, id=i})
	end
end

function handleMapClick ( gomb, statusz, x, y, ... )
	if(radarDrawing) then
		if hoverLegend then 
			if gomb == "left" and statusz == "up" then
				if not legendX and not legendY and not legendZ then return false end
				createPathMarker(legendX, legendY, legendZ)
				outputDebugString("Left clicked image on map legend, create blip")
				exports.hud:sendBottomNotification(localPlayer, "Marqueur", "Le lieu a été marqué sur votre radar!")
			elseif gomb == "right" and statusz == "up" then
				destroyPathMarker()
				
				outputDebugString("Right clicked image on map legend, destroy blip")
				exports.hud:sendBottomNotification(localPlayer, "Marqueur", "Le lieu marqué a été retiré!")
				legendX, legendY, legendZ = nil, nil, nil
			end
			return 
		end
		if(gomb == "right" and statusz == "down" and handleMapClick) then -- Útvonal tervezés
			if(x > radarP[1] and x < radarP[1]+radarS[1] and y > radarP[2] and y < radarP[2]+radarS[2]) then
				if #gpsPontok == 0 then
					local jx, jy, _ = getElementPosition(localPlayer)
					jx, jy = jx+mozgatAdat[1], jy+mozgatAdat[2]
					local kx = jx+((((x-radarP[1])-(radarS[1]/2))*2)*zoom)
					local ky = jy-((((y-radarP[2])-(radarS[2]/2))*2)*zoom)
					--outputChatBox("X: "..jx.." - Y: "..jy)
					--outputChatBox("CX: "..kx.." - CY: "..ky)
					local ejx, ejy, ejz = getElementPosition(localPlayer)
					local utvonal = calculatePathByCoords(ejx, ejy, ejz,kx,ky, 0)
					if not utvonal then
						--outputConsole('Nem található útvonal.')
						return
					end
					gpsPontok = {}
					for i,node in ipairs(utvonal) do
						table.insert(gpsPontok, {x = node.x, y = node.y, id=i})
					end
					utiBlip = createBlip(kx,ky, 0, 41, 2, 255, 255, 255, 255, 0)
				else
					gpsPontok = {}
					if(utiBlip) then
						destroyElement(utiBlip)
						utiBlip = nil
					end
				end
			end
		elseif(gomb == "left") then
			if(statusz == "down") then
				honnanMozgat = {x+mozgatAdat[1],y-mozgatAdat[2]}
			end
			if(statusz == "up") then
				honnanMozgat = {0,0}
			end
		end
	end
end
addEventHandler ( "onClientClick", getRootElement(), handleMapClick )

local blipNeve = "FASZKIVAN "

local blipNames = {
	{"Mairie (Jobs)", 40},
	{"Police Department", 30},
	{"Auto-Ecole", 36},
	{'Mécanos', 27},
	{"Hopital", 22},
	{'Caserne', 20},
	{"Banque", 52},
	{"Hôtel", 26},
	{"Fourrière", 24},
	{"Casino", 43},
	{"Magasin Vêtement", 45},
	{"Magasin 24/7", 15},
	{"Magasin Electronique", 23},
	{"Pharmacie", 121},
	{"Magasin d'outils", 122},
	{"Station Essence", 21},
	{"Concession (Auto)", 55},
	{"Concession (Bateau)", 9},
	{"Concess (Utilitaire)", 65},
	{"Concess (Vélo/Moto)", 84},
	{"Concess VIP", 16},
	{"Location Trottinette", 61},
	{"Fête Foraine", 8},
	{"Skatepark", 12},
	{"Paintball", 64},
	{"Gym", 54},
	{"Stadium", 33},
	{"Aéroport", 5},
	{"Ammu-nation", 6},
	{"Casse auto/bateau", 11},
	{"Prison Fédérale", 34},
	{"San News", 42},
	{"Tribunal", 86},
	{"Pay N Spray", 63},
	{"Livreur (Job)", 51},
}

local customBlipInfo = {}

addEvent("radar:setCustomBlipInfo", true)
addEventHandler("radar:setCustomBlipInfo", root, function(info)
	customBlipInfo[source] = info
	-- iprint("setCustomBlipInfo", source, info)
end)

addEventHandler("onElementDestroy", root, function()
	if customBlipInfo[source] then
		customBlipInfo[source] = nil
	end
end)

--adicionar onELementDataChange, criar globalVar e mudar essa var quando a data mudar
function busStopsTracker(theKey, oldValue, newValue)
    if (getElementType(source) == "player") and (theKey == "busstops:hidden") then
        busStopsHidden = tonumber(newValue)
    end
end
addEventHandler("onClientElementDataChange", root, busStopsTracker)

function drawMapRender()
	legendX, legendY, legendZ = nil, nil, nil
	if not currentMapStyling and not nagymap then
		return 
	end
	
	if(honnanMozgat[1] ~= 0 or honnanMozgat[2] ~= 0) then
		local kx, ky = getCursorPosition ( )
		if(kx and ky) then
			kx, ky = kx*s[1], ky*s[2]
			mozgatAdat = {kx-honnanMozgat[1], ky-honnanMozgat[2]}
			mozgatAdat = {math.max(math.min(-mozgatAdat[1],6000),-6000), math.max(math.min(mozgatAdat[2], 6000), -6000)}
		end
	end
	if(getKeyState ( "num_add" )) then
		if(zoom > minZoom) then
			zoom = zoom - zoomRadio
		end
	end
	if(getKeyState ( "num_sub" )) then
		if(zoom < maxZoom) then
			zoom = zoom + zoomRadio
		end
	end
	if(getKeyState ( "num_4" )) then
		mozgatAdat[1] = mozgatAdat[1] - 5
	end
	if(getKeyState ( "num_6" )) then
		mozgatAdat[1] = mozgatAdat[1] + 5
	end

	dxSetRenderTarget(nagymap,true)
	dxDrawRectangle ( 0, 0, radarS[1], radarS[2], vizSzin, false )
	local jx, jy, _ = getElementPosition(localPlayer)
	jx, jy = jx+mozgatAdat[1], jy+mozgatAdat[2]
	local e1,e2,e3,e4=(((3000)+jx)/(6000)*(radarM[1]))-((radarS[1]/2)*zoom), ((3000-jy)/(6000)*radarM[2])-((radarS[2]/2)*zoom), radarS[1]*zoom, radarS[2]*zoom
	local xplussz, yplussz = 0, 0
	if(e2+(radarS[2]*zoom) >= radarM[2]) then
		yplussz = radarM[2]-(e2+(radarS[2]*zoom))
	end
	if(e2 <= 0) then
		yplussz = 0-e2
	end
	if(e1+(radarS[1]*zoom) >= radarM[1]) then
		xplussz = radarM[1]-(e1+(radarS[1]*zoom))
	end
	if(e1 <= 0) then
		xplussz = 0-e1
	end
	local axm, aym = 0, 0
	dxDrawImageSection(0+(xplussz/zoom),0+(yplussz/zoom),radarS[1],radarS[2],e1+xplussz,e2+yplussz,e3,e4,"files/radar.png",0,0,0,tocolor(255, 255, 255, 255),false)
	
	local ux, uy = nil, nil
	for i=1, #gpsPontok do

		local x,y = gpsPontok[i].x, gpsPontok[i].y
		local n_x = (((((3000)+x)/(6000)*(radarM[1]))-((radarS[1]/2)*zoom)-e1)+((radarS[1]/2)*zoom))/zoom
		local n_y = ((((3000-y)/(6000)*radarM[2])-((radarS[2]/2)*zoom)-e2)+((radarS[2]/2)*zoom))/zoom
		if(ux and uy) then
			dxDrawLine ( ux, uy, n_x, n_y, tocolor(255, 0, 0, 255), 3 )
			ux, uy = n_x, n_y
		else
			ux, uy = n_x,n_y
		end
	end
	
	--DEFAULT BLIPS
	local defaultBlips = getElementsByType ("blip")
	for i=1, #defaultBlips do
		local bIcon = getBlipIcon(defaultBlips[i])
        local x,y = getElementPosition(defaultBlips[i])
        local b_x = (((((3000)+x)/(6000)*(radarM[1]))-((radarS[1]/2)*zoom)-e1)+((radarS[1]/2)*zoom))/zoom
		local b_y = ((((3000-y)/(6000)*radarM[2])-((radarS[2]/2)*zoom)-e2)+((radarS[2]/2)*zoom))/zoom
        local blip_icon = getBlipIcon(defaultBlips[i])
		--outputChatBox("X: "..b_x)
		b_x = math.min(math.max(b_x, blipMeret[1]/2), radarS[1]-blipMeret[2]/2)
		b_y = math.min(math.max(b_y, blipMeret[2]/2), radarS[2]-blipMeret[2]/2)
		
		local bcR, bcG, bcB = 255, 255, 255
		if getBlipIcon(defaultBlips[i]) == 0 then
			bcR, bcG, bcB = getBlipColor(defaultBlips[i])
		end

		--[[ if blip_icon == 0 then
			print(bcR, bcG, bcB, busStopsHidden)
		end *]]

		--if blip_icon == 0 and (bcR == 255 and bcG == 63 and bcB == 63) and busStopsHidden == 0 then
		if blip_icon == 0 and (((bcR == 255 and bcG == 63 and bcB == 63) or (bcR == 127 and bcG == 255 and bcB == 63) or (bcR == 255 and bcG == 255 and bcB == 63)) and busStopsHidden == 0) then
			
		else
			dxDrawImage ( b_x-blipMeret[1]/2,b_y-blipMeret[2]/2,blipMeret[1],blipMeret[2], "blips/"..blip_icon..".png", 0, 0, 0, tocolor(bcR, bcG, bcB, 255))
			
			local kx, ky = getCursorPosition()
			if kx and ky then
				kx, ky = kx*s[1]-radarP[1], ky*s[2]-radarP[2]
				if (dobozbaVan(b_x-blipMeret[1]/2,b_y-blipMeret[2]/2,blipMeret[1],blipMeret[2], kx, ky)) then

					local info = customBlipInfo[v]
					if info ~= nil then
						blip_icone = info.icon
						blipNeve = info.name
						bcR = info.r
						bcG = info.g
						bcB = info.b
					else

						local foundblip = nil
						for i, j in pairs(blipNames) do
							if j[2] == blip_icon then
								foundblip = i
								break
							end
						end

						if not blipNames[foundblip] then
							if blip_icon == 0 and bcR == 255 and bcG == 63 and bcB == 63 then
								blipNeve = "Arrêt de bus (Inactif)"
							elseif blip_icon == 0 and bcR == 127 and bcG == 255 and bcB == 63 then
								blipNeve = "Le bus arrive bientôt"
							elseif blip_icon == 0 and bcR == 255 and bcG == 255 and bcB == 63 then
								blipNeve = "Arrêt de bus (Actif)"						
							elseif blip_icon == 31 then
								blipNeve = "Chez vous"
							elseif blip_icon == 32 then
								blipNeve = "Votre Business"
							else
								blipNeve = "Point d'intérêt"
							end
						else
							blipNeve = blipNames[foundblip][1]
						end
					end
					
					local szovegHossz =  dxGetTextWidth(blipNeve, 0.7, "default-bold") + 40
					formDobozRajzolasa( b_x-szovegHossz/2,b_y+blipMeret[2],szovegHossz,20, tocolor(20, 20, 20, 150), tocolor(0,0,0,200))
					fontSzovegRender(blipNeve,b_x-szovegHossz/2,b_y+blipMeret[2], szovegHossz, 20, tocolor(255,255,255,220), 1, "default-bold", "center", "center", true, true, false, 0, 0, 0)
				end
			end
		end
    end
	
	--CUSTOM BLIPS
	for k, v in ipairs(created_custom_blips) do
        local x,y = v.x, v.y
        local b_x = (((((3000)+x)/(6000)*(radarM[1]))-((radarS[1]/2)*zoom)-e1)+((radarS[1]/2)*zoom))/zoom
		local b_y = ((((3000-y)/(6000)*radarM[2])-((radarS[2]/2)*zoom)-e2)+((radarS[2]/2)*zoom))/zoom
        local blip_icon = v.icon

		b_x = math.min(math.max(b_x, blipMeret[1]/2), radarS[1]-blipMeret[2]/2)
		b_y = math.min(math.max(b_y, blipMeret[2]/2), radarS[2]-blipMeret[2]/2)
		
		local bcR, bcG, bcB = getCustomBlipColor(k)
		
		dxDrawImage ( b_x-blipMeret[1]/2,b_y-blipMeret[2]/2,blipMeret[1],blipMeret[2], "blips/"..blip_icon..".png", 0, 0, 0, tocolor(bcR, bcG, bcB, 255))
			
		local kx, ky = getCursorPosition()
		if kx and ky then
			kx, ky = kx*s[1]-radarP[1], ky*s[2]-radarP[2]
			if (dobozbaVan(b_x-blipMeret[1]/2,b_y-blipMeret[2]/2,blipMeret[1],blipMeret[2], kx, ky)) then
				blipNeve = custom_blips[v.icon].name
					
				local szovegHossz =  dxGetTextWidth(blipNeve, 0.7, "default-bold")+40
				formDobozRajzolasa( b_x-szovegHossz/2,b_y+blipMeret[2],szovegHossz,20, tocolor(20, 20, 20, 150), tocolor(0,0,0,200))
				fontSzovegRender(blipNeve,b_x-szovegHossz/2,b_y+blipMeret[2], szovegHossz, 20, tocolor(255,255,255,220), 1, "default-bold", "center", "center", true, true, false, 0, 0, 0)
			end
		end
    end
	
	local rot = getPedRotation( localPlayer )
	local jbx, jby, _ = getElementPosition(localPlayer)
    local jb_x = (((((3000)+jbx)/(6000)*(radarM[1]))-((radarS[1]/2)*zoom)-e1)+((radarS[1]/2)*zoom))/zoom
	local jb_y = ((((3000-jby)/(6000)*radarM[2])-((radarS[2]/2)*zoom)-e2)+((radarS[2]/2)*zoom))/zoom
	dxDrawImage ( jb_x-blipMeret[1]/2, jb_y-blipMeret[2]/2, blipMeret[1], blipMeret[2], "files/arrow.png", -rot, 0, 0, tocolor(255,255,255,255) )
	dxSetRenderTarget()
	
	dxCreateBorder(radarP[1], radarP[2], radarS[1], radarS[2], tocolor(0, 0, 0, 200)) -- Radar Keret
	dxDrawImage ( radarP[1], radarP[2], radarS[1], radarS[2], nagymap, 0, 0, 0, tocolor(255,255,255,200) ) -- Radar
	dxDrawRectangle(radarP[1] + radarS[1] - 200, radarP[2], 200, radarS[2], tocolor(0, 0, 0, 200))
	
	if isMouseInPosition(radarP[1] + radarS[1] - 200, radarP[2], 200, radarS[2]) then
		hoverLegend = true
	else
		hoverLegend = false
	end
	
	dxDrawText("Lieux Principaux", radarP[1] + radarS[1] - 200, radarP[2] + 15, 200 + radarP[1] + radarS[1] - 200, radarS[2], tocolor(255, 255, 255), 1, title, "center", "top")
	local x, y = radarP[1] + radarS[1] - 200 + 5, radarP[2] + 50

	dxDrawScrollBar(x + 180, y, 5 * sx, radarS[2] - 75, #blipNames - 1, gridRows, gridCache - 1, tocolor(55, 55, 55), tocolor(255, 100, 100))
	
	gridRows = ((radarS[2] - 75) / 30)
	gridRows = math.floor(gridRows)

	for index = gridCache, (gridCache + gridRows) do
		local blip = blipNames[index]
		if blip then
			dxDrawImage(x, y, 25 * sx, 25 * sy, "blips/" .. blip[2] .. ".png")
			dxDrawText(blip[1], x + 30 * sx, y + 5 * sy, 0, 0, tocolor(255, 255, 255), 1, small)
			
			if isMouseInPosition(x, y, 25 * sx, 25 * sy) then
				if blip[2] >= 64 then
					local nearest = getCustomNearestBlip(blip[2])
					if nearest then
						legendX, legendY, legendZ = nearest.x, nearest.y, nearest.z
					end
				else
					local nearest = getNearestBlip(blip[2])
					if nearest then
						legendX, legendY, legendZ = getElementPosition(nearest)
					end
				end
			end

			y = y + 30
		end
	end

	--[[
		dxDrawImage(x, y, 25, 25, "blips/" .. i .. ".png")
		dxDrawText(j.name, x + 30, y + 5, 0, 0, tocolor(255, 255, 255), 1, small)

		if isMouseInPosition(x, y, 25, 25) then
			local nearest = getCustomNearestBlip(i)
			if nearest then
				legendX, legendY, legendZ = nearest.x, nearest.y, nearest.z
			end
		end

		y = y + 30
	]]
	
	--dxDrawImageSection(0+(xplussz/zoom),0+(yplussz/zoom),radarS[1],radarS[2],(radarP[1]-radarS[1]/2)+e1,(radarP[2]-radarS[2]/2)+e2,e3,e4,"images/radar2.png",0,0,0,tocolor(255, 255, 255, 255),false)
	
	--dxDrawText("E1: "..e1.." E2: "..e2, 20, 600, 1, "default", tocolor("255, 255, 255, 255"))
end

function dxDrawScrollBar(x, y, sz, m, everyObject, seeAble, where, color1, color2)
    if(everyObject > seeAble) then
        dxDrawRectangle(x, y, sz, m, color1 or tocolor(0,0,0,200))
        dxDrawRectangle(x, y+((where)*(m/(everyObject))), sz, m/math.max((everyObject/seeAble),1), color2 or tocolor(102, 153, 204, 255))
    end
end

mwheel = function()
    if #blipNames > 0 then
        if #blipNames>= gridRows + 1 then
            gridCache = math.max(gridCache - 1, 1)
        end
    end
end

mdown = function()
    if #blipNames > 0 then
        if #blipNames >= gridRows + 1 then
            gridCache = math.min(gridCache + 1, #blipNames-gridRows)
        end
    end
 end

function getNearestBlip(blipType)
	local distance = 16000
	local blip 
	local x, y, z = getElementPosition(localPlayer)
	
	for k, v in pairs(getElementsByType("blip")) do
		if getBlipIcon(v) == blipType then
			local bx, by, bz = getElementPosition(v)
			
			local distanceFromMe = getDistanceBetweenPoints2D(x, y, bx, by)
			if distanceFromMe < distance then
				distance = distanceFromMe
				blip = v 
			end
		end
	end
	
	return blip
end

function isMouseInPosition ( x, y, width, height ) -- probably already in here somewhere but I don't speak Ians language lmao
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function fontSzovegRender(szoveg, x, y, b, f, szin, meret, font, ax, ay, clip, szotores, postgui, rot, rotx, roty, fszin)
	if not fszin then fszin = false end
	dxDrawText ( szoveg, x, y, x+b, y+f, szin, meret, "default-bold", ax, ay, clip, szotores, postgui, fszin, false, rot, rotx, roty )
end


function dobozbaVan(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(dobozbaVan(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end

function dxCreateBorder(x,y,w,h,color)
	dxDrawRectangle(x-3,y-3,w+6,3,color) -- Fent
	dxDrawRectangle(x-3,y,3,h,color) -- Bal Oldal
	dxDrawRectangle(x-3,y+h,w+6,3,color) -- Lent Oldal
	dxDrawRectangle(x+w,y-3,3,h+3,color) -- Jobb Oldal
end

local dobozB = {15, 3}
local dobozS = {17, 1, 0, 5}

function formDobozRajzolasa(x, y, sz, m, hszin, kszin, elore)
	-- Keret
	dxDrawRectangle ( x, y+dobozS[4]/2, 1, m-dobozS[4], kszin or tocolor(60,63,63,255), elore) -- Bal oldal
	dxDrawRectangle ( x+sz-(dobozS[1]-dobozB[1]-1), y+dobozS[4]/2, 1, m-dobozS[4], kszin or tocolor(60,63,63,255), elore) -- Jobb oldal
	dxDrawRectangle ( x+dobozS[4]/2, y, sz-dobozS[4], 1, kszin or tocolor(60,63,63,255), elore) -- Teteje oldal
	dxDrawRectangle ( x+dobozS[4]/2, y+m-(dobozS[1]-dobozB[1]-1), sz-dobozS[4], 1, kszin or tocolor(60,63,63,255), elore) -- Alja oldal
	
	dxDrawRectangle(x+1, y+1, sz-2, m-2, hszin or tocolor(60,63,63,100), elore)
end

function stopMapRender()
	if radarDrawing then return end
	removeEventHandler("onClientRender", getRootElement(), drawMapRender)
end


function createPathMarker(ejx, ejy, ejz)
	if #gpsPontok == 0 then
		local jx, jy, _ = getElementPosition(localPlayer)
		--outputChatBox("X: "..jx.." - Y: "..jy)
		--outputChatBox("CX: "..kx.." - CY: "..ky)
		local kx, ky, kz = getElementPosition(localPlayer)
		local utvonal = calculatePathByCoords(ejx, ejy, ejz, kx, ky, 0)
		if not utvonal then
			--outputConsole('Nem található útvonal.')
			return
		end
		gpsPontok = {}
		for i,node in ipairs(utvonal) do
			table.insert(gpsPontok, {x = node.x, y = node.y, id=i})
		end
		utiBlip = createBlip(ejx, ejy, ejz, 41, 2, 255, 255, 255, 255, 0)
	else
		gpsPontok = {}
		if(utiBlip) then
			destroyElement(utiBlip)
			utiBlip = nil
		end
	end
end

function destroyPathMarker()
	gpsPontok = {}
	if(utiBlip) then
		destroyElement(utiBlip)
		utiBlip = nil
	end
end
