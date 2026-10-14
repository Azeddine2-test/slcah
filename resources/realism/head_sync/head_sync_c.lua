-- Nando: edited | 07/03/2023

local viewDistance = 50
local lookTimer = { }
local scrWidth, scrHeight = guiGetScreenSize()
local sx = scrWidth/2
local sy = scrHeight/2
local sync_interval = 300
local sync_last = getTickCount()
local nearby_npcs = { }
local nearby_vehs = { }
local nearby_players = { }
local angleX = 0
local angleY = 0
local movementSmoothness = 30
local playerData = {}

function sign(x)
    return x >= 0 and 1 or -1
end

local function animTo(var, to, speed)
    return var < to and math.min(var + speed, to) or math.max(to, var - speed)
end

local function clamp(v, a, b)
	return math.min(math.max(v, a), b)
end

local function isNan(v)
	return v ~= v
end

local function getMatrixForward(m)
	return m[2][1], m[2][2], m[2][3]
end

local function getSqrLength(vec1)
	return vec1.x ^ 2 + vec1.y ^ 2 + vec1.z ^ 2
end

local function getDot(vec1, vec2)
	return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z
end

local function getAngle(vec1, vec2)
	local denominator = math.sqrt(getSqrLength(vec1) * getSqrLength(vec2))

	return denominator > 0 and math.deg(math.acos(clamp(getDot(vec1, vec2) / denominator, -1, 1))) or 0
end

local function getSignedAngle(vec1, vec2, axis)
    local crossX = vec1.y * vec2.z - vec1.z * vec2.y
    local crossY = vec1.z * vec2.x - vec1.x * vec2.z
    local crossZ = vec1.x * vec2.y - vec1.y * vec2.x

    return getAngle(vec1, vec2) * sign(axis.x * crossX + axis.y * crossY + axis.z * crossZ)
end

local function filterNearByPlayers()
	local x,y,z = getElementPosition(localPlayer)			
	local filtered = {}
	for i, player in ipairs(getElementsByType("player")) do
		if player and isElement(player) and isElementStreamedIn(player) and isElementOnScreen(player) and player ~= localPlayer then
			local x2, y2, z2 = getElementPosition(player)
			local distance = getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
			if distance <= viewDistance then
				filtered[ getElementData(player, 'dbid') ] = player
			end
		end
	end
	return filtered
end

function onClientLookAtRender()
	if not isPedOnFire(localPlayer) then
		local x, y, z = getWorldFromScreenPosition(sx, sy, viewDistance)
		setPedLookAt(localPlayer, x, y, z, -1, 500)
		-- sync local head to near by players
		--if --[[ false and *]] getTickCount() - sync_last > sync_interval then
			sync_last = getTickCount()
			local filtered = filterNearByPlayers()
			if exports.global:countTable(filtered) > 0 then
				--triggerLatentServerEvent( 'realism:lookat:sync', localPlayer, filtered, { x, y, z } )
			end
		--end
	end
end

function onClientPedsProcessed()
	if isPedDead(localPlayer) or getElementData(localPlayer, "phone.facecam.isEnabled") then
		return
	end

	local x, y, z, lx, ly, lz = getCameraMatrix ()
	local cam = Vector3(lx - x, ly - y, lz - z)
	local fwX, fwY, fwZ = getMatrixForward(getElementMatrix(localPlayer))

	local targetAngleX = getSignedAngle(Vector3(lx - x, ly - y, 0), Vector3(fwX, fwY, 0), Vector3(0, 0, 1))
	local targetAngleY = getSignedAngle(Vector3(1, 0, lz - z), Vector3(1, 0, fwZ), Vector3(0, 1, 0))

	angleX = animTo(angleX, targetAngleX, math.abs(angleX - targetAngleX) / movementSmoothness)
	angleY = animTo(angleY, targetAngleY, math.abs(angleY - targetAngleY) / movementSmoothness)

	local dirX = -clamp(angleX, -45, 45)
	local dirY = -clamp(angleY, -30, 30) - 15

	setElementBoneRotation(localPlayer, 5, dirX, dirY, 0)
	updateElementRpHAnim(localPlayer)

	if --[[ false and *]] getTickCount() - sync_last > sync_interval then
		sync_last = getTickCount()
		local filtered = filterNearByPlayers()
		if exports.global:countTable(filtered) > 0 then
			triggerLatentServerEvent( 'realism:lookat:sync', localPlayer, filtered, { dirX, dirY } )
		end
	end
end

function syncHeads(dir)
	if source and isElement(source) and isElementStreamedIn(source) then
		if not playerData[source] then
			playerData[source] = {angleX = 0, angleY = 0}
		end

		playerData[source].dir = dir

		--setPedAimTarget(source, dir[1], dir[2], dir[3])
		--setPedLookAt(source, dir[1], dir[2], dir[3], -1, 500)
		--outputDebugString(exports.global:getPlayerName(source)..": "..dir[1]..", "..dir[2]--[[ ..", "..dir[3] *]])
	end
end
addEvent( 'realism:lookat:sync', true )
addEventHandler( 'realism:lookat:sync' , root, syncHeads)

addEventHandler("onClientPedsProcessed", root,
	function()
		for player, data in pairs(playerData) do
			if isElement(player) and isElementStreamedIn(player) then
				local data = playerData[player]

				if data.dir[1] ~= data.angleX or data.dir[2] ~= data.angleY then
					data.angleX = animTo(data.angleX, data.dir[1], math.abs(data.angleX - data.dir[1]) / movementSmoothness)
					data.angleY = animTo(data.angleY, data.dir[2], math.abs(data.angleY - data.dir[2]) / movementSmoothness)
			
					if not (isNan(data.angleX) or isNan(data.angleY) or data.angleX == math.huge or data.angleY == math.huge) then
						setElementBoneRotation(player, 5, data.angleX, data.angleY, 0)
						updateElementRpHAnim(player)
					end
				end
			end
		end
	end
)

addEventHandler("onClientPlayerQuit", root,
	function()
		playerData[source] = nil
	end
)

function lookAtClosestElement()
	local element = getClosestPlayer()
	if not element then
		element = getClosestPeds()
	end
	if not element then
		element = getClosestVehicle()
	end
	if element then
		setPedLookAt (localPlayer, 0, 0, 0, 3500, 1000, element)
	end
end

function getClosestPlayer()
	for dbid, player in pairs( filterNearByPlayers()--[[ nearby_players *]] ) do
		local x,y,z = getElementPosition(player)			
		local cx,cy,cz = getCameraMatrix()
		local distance = getDistanceBetweenPoints3D(cx,cy,cz,x,y,z)
		if distance <= viewDistance and (player~=localPlayer) and getElementAlpha(player) == 255 then --Within radius viewDistance
			local px,py,pz = getScreenFromWorldPosition(x,y,z,0.05)
			if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then	
				return player
			end
		end
	end
end

function getClosestPeds()
	for dbid, player in pairs( nearby_npcs ) do
		if isElement(player) then
			local x,y,z = getElementPosition(player)
			local cx,cy,cz = getCameraMatrix()
			local distance = getDistanceBetweenPoints3D(cx,cy,cz,x,y,z)
			if distance <= viewDistance and (player~=localPlayer) then --Within radius viewDistance
				local px,py,pz = getScreenFromWorldPosition(x,y,z,0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then
					return player
				end
			end
		else
			nearby_npcs[dbid] = nil
		end
	end
end

function getClosestVehicle()
	for dbid, player in pairs( nearby_vehs ) do
		local x,y,z = getElementPosition(player)			
		local cx,cy,cz = getCameraMatrix()
		local distance = getDistanceBetweenPoints3D(cx,cy,cz,x,y,z)
		if distance <= viewDistance and (player~=localPlayer) then --Within radius viewDistance
			local px,py,pz = getScreenFromWorldPosition(x,y,z,0.05)
			if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then	
				return player
			end
		end
	end
end

addEventHandler('onClientElementStreamIn', root, function ()
	if getElementType(source) == 'ped' then
		nearby_npcs[ getElementData(source, 'dbid') ] = source
	elseif getElementType(source) == 'player' and source ~= localPlayer then
		nearby_players[ getElementData(source, 'dbid') ] = source
	elseif getElementType(source) == 'vehicle' then
		nearby_vehs[ getElementData(source, 'dbid') ] = source
	end
end)
addEventHandler('onClientElementStreamOut', root, function ()
	if getElementType(source) == 'ped' then
		nearby_npcs[ getElementData(source, 'dbid') ] = nil
	elseif getElementType(source) == 'player' and source ~= localPlayer then
		nearby_players[ getElementData(source, 'dbid') ] = nil
		-- remove look at target for nearby players.
		setPedLookAt (source, 0, 0, 0, 0 )
	elseif getElementType(source) == 'vehicle' then
		nearby_vehs[ getElementData(source, 'dbid') ] = nil
	end
end)

function npcLookAtYou()
	for dbid, npc in pairs(nearby_npcs) do
		if npc and isElement(npc) and isElementOnScreen(npc) then
			setPedLookAt ( npc, 0, 0, 0, 5000, 1000, localPlayer )
			--outputDebugString(exports.global:getPlayerName(npc)..' looks at '..exports.global:getPlayerName(localPlayer))
		end
	end
end

-- Unused by account F10 setting / Deactivated right now

function updateLookAt()
	-- reset stuff

	removeEventHandler("onClientPedsProcessed", root, onClientPedsProcessed)

	setPedLookAt (localPlayer, 0, 0, 0, 0 )
	if lookTimer[1] and isTimer(lookTimer[1]) then
		killTimer(lookTimer[1])
		lookTimer[1] = nil
	end
	if lookTimer[2] and isTimer(lookTimer[2]) then
		killTimer(lookTimer[2])
		lookTimer[2] = nil
	end
	-- set stuff
	local state = tonumber(getElementData(localPlayer, "head_turning") or 0) or 0

	--[[ if state == 1 then
		lookAtClosestElement()
		lookTimer[1] = setTimer(lookAtClosestElement, 3000, 0)
	else *]]if state == 0 then
		addEventHandler("onClientPedsProcessed", root, onClientPedsProcessed)
		--onClientLookAtRender()
		--lookTimer[2] = setTimer(onClientLookAtRender, 200, 0)
	elseif state == 1 then
		angleX = 0
		angleY = 0
	end
end
addEvent("realism:updateLookAt", false)
addEventHandler( "realism:updateLookAt", root, updateLookAt )

setTimer(updateLookAt, 2000, 0)

addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()),
    function ( startedRes )
		-- updateLookAt()
		-- setTimer(npcLookAtYou, 3000, 0)
    end
)

addCommandHandler("headmove",
	function()
		local state = tonumber(getElementData(localPlayer, "head_turning") or 0) or 0
		
		local newState = (state + 1) % (1 + 1)

		triggerEvent("accounts:settings:updateCharacterSettings", localPlayer, "head_turning", tostring(newState))

		--[[ if newState == 1 then
			outputChatBox("Regarder où pointe la caméra.", 0, 255, 0)
		else *]]if newState == 1 then
			outputChatBox("Mouvements de tête OFF", 0, 255, 0)
		elseif newState == 0 then
			outputChatBox("Regarder les éléments autour.", 0, 255, 0)
		end
	end
)