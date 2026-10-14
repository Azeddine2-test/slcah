local aircraftRoot
local aircraftRotorRoot
local rotorsElementData = {}
local aircraftSourceMap = Cluster:new()

--[[

	Rotate aircraft

]]

function rotateAircraft()

	local timeNow = exports.servertimesync:getServerTime()
	if timeNow then

		local rotorData = rotorsElementData[source]

		local position = rotorData.position

		local duration = rotorData.duration

		-- Rotate 0-359
		local currentRotation = ((timeNow % duration) / duration) * 360 + rotorData.initialRotation

		setElementRotation( source, 0, 0, currentRotation )

		moveObject( source, duration, position[1], position[2], position[3], 0, 0, 360 )
	end
end

--[[

	Initialize

]]

addEventHandler( "onClientResourceStart", resourceRoot, function()
	aircraftRoot = getElementByID( "aircraftRoot" )
	aircraftRotorRoot = getElementByID( "aircraftRotorRoot" )

	addEventHandler( "onClientObjectMoveStop", aircraftRotorRoot, rotateAircraft )

	local timeNow = exports.servertimesync:getServerTime()
	if timeNow then initializeAircraft() end
end, false )

function initializeAircraft()

	local rotors = getElementChildren( aircraftRotorRoot )
	for rotorIndex = 1, #rotors do

		local rotor = rotors[rotorIndex]

		local rotorData = {}

		rotorsElementData[rotor] = rotorData
		rotorData.rotorElement = rotor

		local rotorPosition = { getElementPosition( rotor ) }
		rotorData.position = rotorPosition

		local centerCell = aircraftSourceMap:getCellFromWorldMap( rotorPosition[1], rotorPosition[2] )

		local cellsOfAircraft = aircraftSourceMap:getCellsBetweenCells( aircraftSourceMap:getCellFromSourceMap( centerCell.x - 10, centerCell.y - 10 ),
		                                                                aircraftSourceMap:getCellFromSourceMap( centerCell.x + 10, centerCell.y + 10 ) )

		if cellsOfAircraft then
			for i = 1, #cellsOfAircraft do
				local cell = cellsOfAircraft[i]
				if cell then
					local rotorCollection = cell:getData( "rotorCollection" )
					if not rotorCollection then
						rotorCollection = {}
						cell:setData( "rotorCollection", rotorCollection )
					end
					local cellWorldPositionX, cellWorldPositionY = aircraftSourceMap:getCellWorldPosition( cell )
					local distance = getDistanceBetweenPoints2D( cellWorldPositionX, cellWorldPositionY, rotorPosition[1], rotorPosition[2] )
					if distance < 1200 then rotorCollection[#rotorCollection + 1] = rotorData end
				end
			end
		end

		rotorData.initialRotation = getElementData( rotor, "initialRotation" )
		rotorData.duration = getElementData( rotor, "duration" )
		rotorData.aircraftType = getElementData( rotor, "aircraftType" )

		rotorData.vehicle_id = getElementData( rotor, "vehicle_id" )

		-- setElementCollisionsEnabled( aircraft, false )

		local subElement = createObject( rotorObject_id, 0, 0, -10, 0, 0, 0, true )
		setElementAlpha( subElement, 0 )
		setElementCollisionsEnabled( subElement, false )
		rotorData.subElement = subElement

		attachElements( subElement, rotor, 500, 0, 100, 0, 0, 0 )

		triggerEvent( "onClientObjectMoveStop", rotor )

	end

	setTimer( updateAircraftStreamer, 1000, 0 )
	checkDebugMode()
end
addEventHandler( "onServerTimeInitialized", root, function() initializeAircraft() end )

--[[

	The aircraft streamer

]]

local streamedInAircrafts = {}

function updateAircraftStreamer()
	local localPlayerX, localPlayerY, localPlayerZ = getElementPosition( localPlayer )
	local cellData = aircraftSourceMap:getCellFromWorldMap( localPlayerX, localPlayerY )
	if not cellData then return end

	local rotorsDataCollection = cellData:getData( "rotorCollection" ) or {}

	local pastStreamedInAircrafts = streamedInAircrafts
	streamedInAircrafts = {}

	for rotorIndex = 1, #rotorsDataCollection do
		local rotorData = rotorsDataCollection[rotorIndex]

		local subElement = rotorData.subElement
		local aircraft = rotorData.aircraft
		local aircraftType = rotorData.aircraftType

		if not aircraft then

			setElementStreamable( rotorData.rotorElement, false )
			setElementStreamable( subElement, false )

			--[[

				Set-up aircraft

			]]
			aircraft = createVehicle( rotorData.vehicle_id, localPlayerX, localPlayerY, localPlayerZ + 100 )
			setVehicleGravity( aircraft, 0, 0, 0 )
			setVehicleDamageProof( aircraft, true )
			setElementStreamable( aircraft, false )
			setElementParent( aircraft, aircraftRoot )
			rotorData.aircraft = aircraft
			attachElements( aircraft, subElement, 0, 0, 0, 0, 0, 0 )

			--[[

				Set-up pilot

			]]

			local ped = createPed( 61, 0, 0, -10 )
			setElementParent( ped, aircraft )
			warpPedIntoVehicle( ped, aircraft )
			setPedControlState( ped, "accelerate", true )

			--[[

				Set-up blip

			]]

			--rotorData.blip = createBlipAttachedTo( aircraft, 0, 1, 0, 0, 0, 100, -32768, 200 )
			--setElementParent( rotorData.blip, aircraft )

			--[[

				Initial aircraft type

			]]
			if aircraftType == "plane" then setVehicleLandingGearDown( aircraft, false ) end
		end

		if aircraftType == "heli" then setHelicopterRotorSpeed( aircraft, 0.2 ) end

		--[[

			Fixing dirty bug in the attachement system, with a dirty solution

		]]
		setElementRotation( aircraft, getElementRotation( subElement ) )

		--[[

			Manage streamer

		]]
		streamedInAircrafts[aircraft] = rotorData
		pastStreamedInAircrafts[aircraft] = nil
	end

	--[[

		Remove aircraft if it is far away

	]]
	if next( pastStreamedInAircrafts ) then
		for aircraft, rotorData in pairs( pastStreamedInAircrafts ) do
			setElementStreamable( rotorData.rotorElement, true )
			setElementStreamable( rotorData.subElement, true )
			if isElement( aircraft ) then
				destroyElement( aircraft )
				rotorData.aircraft = nil
				--rotorData.blip = nil
			end
		end

	end
end

--[[

    Debug information

]] --
function checkDebugMode()
	if getElementData( resourceRoot, "debugMode" ) then

		local dxDrawCross = function( screenX, screenY, size, color )
			dxDrawLine( screenX + size, screenY, screenX - size, screenY, color, 2 )
			dxDrawLine( screenX, screenY + size, screenX, screenY - size, color, 2 )
		end

		local mapHeight = getElementData( resourceRoot, "mapHeight" )

		local Vector3 = Vector3
		local Matrix = Matrix

		-- Your resolution as developer.
		local devScreenX = 2560
		local devScreenY = 1440

		-- The current resolution of the client
		local screenX, screenY = guiGetScreenSize()

		-- Get the scale value
		local scaleValue = screenY / devScreenY

		-- Set an upper limit, so that it isn't scaled too small.
		scaleValue = math.max( scaleValue, 0.65 )

		local redColor = tocolor( 255, 0, 0, 255 )
		local greenColor = tocolor( 0, 255, 0, 255 )
		local blueColor = tocolor( 0, 0, 255, 255 )
		local camera = getCamera()

		addEventHandler( "onClientRender", root, function()
			--[[

				Streamed in by custom streamer

			]]
			local cameraX, cameraY, cameraZ = getElementPosition( camera )
			local centerCell = aircraftSourceMap:getCellFromWorldMap( cameraX, cameraY )
			if centerCell then
				local rotorsDataCollection = centerCell:getData( "rotorCollection" )
				if rotorsDataCollection then dxDrawText( "Aircraft streamedIn: " .. #rotorsDataCollection .. " (green color)", 600, 600 ) end

				if mapHeight then
					--[[

						Display map height

					]]
					local captureSize = 5
					captureSize = math.floor( captureSize / 2 + 0.5 )

					local cellsOfAircraft = aircraftSourceMap:getCellsBetweenCells( aircraftSourceMap:getCellFromSourceMap( centerCell.x - captureSize,
					                                                                                                        centerCell.y - captureSize ),
					                                                                aircraftSourceMap:getCellFromSourceMap( centerCell.x + captureSize,
					                                                                                                        centerCell.y + captureSize ) )
					if cellsOfAircraft then
						for i = 1, #cellsOfAircraft do
							local cell = cellsOfAircraft[i]
							if cell then
								local x, y = cell.x, cell.y
								if mapHeight[x] then
									local mapHeight = mapHeight[x][y]
									local posX, posY = aircraftSourceMap:getCellWorldPosition( cell )
									local posZ = mapHeight
									local screenX, screenY, success = getScreenFromWorldPosition( posX, posY, posZ, 1, true )
									if success then
										local size = math.max( 10000 / getDistanceBetweenPoints3D( posX, posY, posZ, cameraX, cameraY, cameraZ ), scaleValue )
										size = size * scaleValue
										dxDrawCross( screenX, screenY, size, blueColor )
									end

								end
							end
						end
					end
				end
			end
			--[[

				Make all aircraft visible

			]]
			local rotors = getElementChildren( aircraftRotorRoot )
			for rotorIndex = 1, #rotors do

				local rotor = rotors[rotorIndex]

				local rotorData = rotorsElementData[rotor]
				if rotorData then

					--[[

						Make the position/offset calculations by math, checking if the position of the offset is correct. attachElements

					]]
					local timeNow = exports.servertimesync:getServerTime()
					if timeNow then

						local rotorPosition = rotorData.position

						local duration = rotorData.duration

						-- Rotate 0-359
						local currentRotation = ((timeNow % duration) / duration) * 360 + rotorData.initialRotation

						local rotorMatrix = Matrix( Vector3( rotorPosition[1], rotorPosition[2], rotorPosition[3] ), Vector3( 0, 0, currentRotation ) )

						-- Calculate the offset from the matrix
						local centerPositionVector = rotorMatrix:transformPosition( Vector3( 500, 0, 100 ) )

						-- Get the offset position from the vector
						local posX, posY, posZ = centerPositionVector.x, centerPositionVector.y, centerPositionVector.z
						local screenX, screenY, success = getScreenFromWorldPosition( posX, posY, posZ, 1, true )
						if success then
							local size = math.max( 10000 / getDistanceBetweenPoints3D( posX, posY, posZ, cameraX, cameraY, cameraZ ), scaleValue )
							local aircraft = rotorData.aircraft
							local color = aircraft and streamedInAircrafts[aircraft] and greenColor or redColor

							size = size * scaleValue
							dxDrawCross( screenX, screenY, size, color )
						end
					end
				end
			end
		end )
	end

end

