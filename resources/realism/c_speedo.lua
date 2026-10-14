-- Nando 15/03/2023

fuellessVehicle = { [6651]=true, [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [509]=true, [510]=true, [481]=true }
enginelessVehicle = { [510]=true, [509]=true, [481]=true, [6651]=true }

local width, height = guiGetScreenSize()

local speedoShowing = false
local fuelShowing = false

local forceHidden = false

local function togSpeedo(on)
	if on then
		if not speedoShowing then
			speedoShowing = true
			--addEventHandler("onClientRender", root, drawSpeedo)
		end
	else
		if speedoShowing then
			--removeEventHandler("onClientRender", root, drawSpeedo)
			speedoShowing = false
		end
	end
end
local function togFuel(on)
	if on then
		if not fuelShowing then
			fuelShowing = true
			--addEventHandler("onClientRender", root, drawFuel)
		end
	else
		if fuelShowing then
			--removeEventHandler("onClientRender", root, drawFuel)
			fuelShowing = false
		end
	end
end

-- Exported functions
function hideSpeedo()
	forceHidden = true
	-- outputChatBox("[debug] hide speedo")
end
function showSpeedo()
	forceHidden = false
	-- outputChatBox("[debug] show speedo")
end

function drawSpeedo()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then
		togSpeedo(false)
		return
	end
	-- dxDrawText(tostring(forceHidden), 15, 15)
	if forceHidden then return end

	if not (getElementData(localPlayer,"speedo") ~= "0" and not isPlayerMapVisible() and exports.hud:isActive()) then return end

	if getElementData(localPlayer, "using:phone") then return end -- new phone check so it doesn't draw over

	local speed = getVehicleVelocity(vehicle, localPlayer)
	local x = width
	local y = height
	
	-- street names
	local streetname = exports.gps:getPlayerStreetLocation(localPlayer)
	if streetname and exports.global:getVehicleType(vehicle) ~= "Boat" and exports.global:getVehicleType(vehicle) ~= "Helicopter" and exports.global:getVehicleType(vehicle) ~= "Plane" then
		local width = dxGetTextWidth( streetname )
		local x = width < 200 and ( x - 110 - width / 2 ) or ( x - 10 - width )
		dxDrawRectangle( x - 8, y - 296, width + 17, 24, tocolor( 5, 5, 5, 220 ) )
		dxDrawText( streetname, x, y - 292 )
	end
	
	-- district names
	local positionx, positiony, positionz = getElementPosition(localPlayer)
	local district = getZoneName(positionx, positiony, positionz, false)
	local islandx, islandy =  4440.701171875, 1716.4150390625 -- for San Tortuguilla Island		
	if district == "Unknown" and getDistanceBetweenPoints2D( islandx, islandy, positionx, positiony ) < 500 then district = "San Andreas Coast" end
	if district and exports.global:getVehicleType(vehicle) ~= "Boat" and getElementInterior(localPlayer) == 0 and getElementDimension(localPlayer) == 0 then
		local width = dxGetTextWidth( district )
		local x = width < 200 and ( x - 110 - width / 2 ) or ( x - 10 - width )
		dxDrawRectangle( x - 8, y - 76-5, width + 17, 24, tocolor( 5, 5, 5, 220 ) )
		dxDrawText( district, x, y - 72-5 )
	end
	
	if getElementData(localPlayer, "speedo") == "2" then
		dxDrawImage(x-210, y-275, 256, 256, "discmph.png", 0, 0, 0, tocolor(255, 255, 255, 200))
	else
		dxDrawImage(x-210, y-275, 256, 256, "disc.png", 0, 0, 0, tocolor(255, 255, 255, 200))
	end
	
	
	local speedlimit = getElementData(localPlayer, "speedo:limit")
	if speedlimit and exports.global:getVehicleType(vehicle) ~= "Boat" and exports.global:getVehicleType(vehicle) ~= "Helicopter" and exports.global:getVehicleType(vehicle) ~= "Plane" then
		local ax, ay = x - 243, y - 202
		local string = speedlimit
		local factor = 1
		if getElementData(localPlayer, "speedo") == "2" then
			string = speedlimit.."mph"
			factor = 1.609344
		end

		dxDrawImage(ax,ay,64,64,":hud/images/hud/speed" .. string .. ".png")
		ay = ay - 32
		
		if speedlimit >= 120 then
			dxDrawImage(ax,ay,64,64,":hud/images/hud/highway.png")
			ay = ay - 32
		end
		
		if speed > (speedlimit/factor) then
			dxDrawImage(ax,ay,64,64,":hud/images/hud/accident.png")
		end
	end


	if (exports.global:getVehicleType(vehicle) == "Boat" or exports.global:getVehicleType(vehicle) == "Plane" or exports.global:getVehicleType(vehicle) == "Helicopter") and getElementModel(vehicle) ~= 539 then
		dxDrawText("KNOTS", x - 149.5, y - 130, 5, 5, tocolor (255,255,255, 200), 1.8, "default-bold" )

		if(exports.global:getVehicleType(vehicle) == "Plane" or exports.global:getVehicleType(vehicle) == "Helicopter") then
			local vx,vy,vz = getElementPosition(vehicle)
			local altitude = math.floor(vz)
			local vz,vy,vx = getElementRotation(vehicle, "ZYX")
			local heading = 360-math.floor(vx)
			if heading == 0 then
				heading = 360
			end
			local headingString = tostring(heading)
			if string.len(headingString) == 1 then
				headingString = "00"..headingString
			elseif string.len(headingString) == 2 then
				headingString = "0"..headingString
			end
			local callsign = getElementData(vehicle, "aircallsign")
			if not callsign then
				callsign = getVehiclePlateText(vehicle)
			end
			callsign = "CALLSIGN: "..tostring(callsign)

			local airinfo = "ALT: "..tostring(altitude).."    HDG: "..tostring(headingString)

			--local width, height = guiGetScreenSize()
			local x = width
			local y = height
			local width = dxGetTextWidth(airinfo)
			local x = (x/2)-(width/2)
			local y = y-160
			dxDrawRectangle( x, y, width + 20, 24, tocolor( 5, 5, 5, 220 ) )
			dxDrawText( airinfo, x + 10, y + 3 )

			--local width, height = guiGetScreenSize()
			local x = width
			local y = height
			local width = dxGetTextWidth(callsign)
			local x = (x/2)-(width/2)
			local y = y-50
			dxDrawRectangle( x, y, width + 20, 24, tocolor( 5, 5, 5, 220 ) )
			dxDrawText( callsign, x + 10, y + 3 )
		end

	else
		if getElementData(localPlayer, "speedo") == "2" then
			dxDrawText("MPH", x - 136, y - 130, 5, 5, tocolor (255,255,255, 200), 1.8, "default-bold" )
		elseif getElementData(localPlayer, "speedo") == "1" then
			dxDrawText("KM/H", x - 136, y - 130, 5, 5, tocolor (255,255,255, 200), 1.8, "default-bold" )
		end
		--dxDrawText("KM/PH", x - 145, y - 130, 5, 5, tocolor (255,255,255, 200), 1.8, "default-bold" )
	end
	
	if (speed < 100) then
		dxDrawText(math.floor(speed), x - 115, y - 108, 5, 5, tocolor (255,255,255, 200), 1.5 )
	else
		dxDrawText(math.floor(speed), x - 120, y - 108, 5, 5, tocolor (255,255,255, 200), 1.5 )
	end
	
	if getElementData(localPlayer, "speedo") == "2" then
		local factor = 2
		speed = speed * factor
	end

	speed = speed - 100
	nx = x + math.sin(math.rad(-(speed)-150)) * 90
	ny = y + math.cos(math.rad(-(speed)-150)) * 90
	dxDrawLine(x-110, y-175, nx-110, ny-175, tocolor(255, 0, 0, 255), 2)
	
	dxDrawText( "KM: "..tostring(math.floor(getDistanceTraveled()/1000)), x - 150, y - 215, x-70, 5, tocolor (255,255,255, 200), 1, 'default', 'center' )
	dxDrawText( "Batt: "..tostring(math.floor( getElementData( vehicle, 'battery' ) or 100 )).."%", x - 135, y - 145, x-70, 5, tocolor (255,255,255, 200), 1, 'default', 'center' )
end

function drawFuel()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then
		togFuel(false)
		return
	end
	if forceHidden then return end

	if not (getElementData(localPlayer,"speedo") ~= "0" and not isPlayerMapVisible() and exports.hud:isActive()) then return end
	if getElementData(localPlayer, "using:phone") then return end -- new phone check so it doesn't draw over
		
	local x = width
	local y = height
	local fuel = getElementData( vehicle, 'fuel' ) or 100

	local FuelPer = (fuel/exports.vehicle_fuel:getMaxFuel(vehicle))*100
	if FuelPer > 100 then
		FuelPer = fuel 
	end

	dxDrawImage(x-265, y-165, 128, 128, "fueldisc.png", 0, 0, 0, tocolor(255, 255, 255, 200))
	local movingx = x + math.sin(math.rad(-(FuelPer)-50)) * 50
	local movingy = y + math.cos(math.rad(-(FuelPer)-50)) * 50
	dxDrawLine(x-215, y-115, movingx-210, movingy-115, tocolor(255, 194, 14, 255), 2)
	
	local text = (FuelPer == 0 or FuelPer > 1) and math.floor(FuelPer) or exports.global:round( FuelPer, 2 )
	dxDrawText(text.."%", x - 215, y - 110.5, 5, 5, tocolor (255,255,255, 200), 1 )
	
	if FuelPer < 10 then
		local ax, ay = x - 274, y - 202
		--[[
		if (getElementData(vehicle, "vehicle:windowstat") == 1) then
			ay = ay - 32
		end
		]]
		if getTickCount() % 1000 < 500 then
			dxDrawImage(ax,ay,64,64,":hud/images/hud/fuel.png")
		else
			dxDrawImage(ax,ay,64,64,":hud/images/hud/fuel2.png")
		end
	end
end

-- Check if the vehicle is engineless or fuelless when a player enters. If not, draw the speedo and fuel needles.
local function onVehicleEnter(theVehicle, seat)
	if (seat<2) then
		local id = getElementModel(theVehicle)
		if seat == 0 and not (fuellessVehicle[id]) then
			togFuel(true)
		end
		if not (enginelessVehicle[id]) then
			togSpeedo(true)
		end
	end
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, onVehicleEnter, false)

-- Check if the vehicle is engineless or fuelless when a player exits. If not, stop drawing the speedo and fuel needles.
local function onVehicleExit(theVehicle, seat)
	if (seat<2) then
		local id = getElementModel(theVehicle)
		if seat == 0 and not (fuellessVehicle[id]) then
			togFuel(false)
		end
		if not(enginelessVehicle[id]) then
			togSpeedo(false)
		end
	end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, onVehicleExit, false)

function showSpeedoStart()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		if getVehicleOccupant( veh ) == localPlayer then
			onVehicleEnter(veh, 0)
		elseif getVehicleOccupant( veh, 1 ) == localPlayer then
			onVehicleEnter(veh, 1)
		end
	end
end
addEventHandler( "onClientResourceStart", resourceRoot, showSpeedoStart, false )

