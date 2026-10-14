-- Nando 25/03/2023

local sound = false
local made = false

local function isSoundObject(object)
    return getElementModel(object) == 2226 -- LOW_HI_FI_3 ghettoblaster
    or getElementModel(object) == 2232 -- MED_SPEAKER_4 big speaker
end

local audioStreamsEnabled = true

-- function getHUDStates()
-- 	audioStreamsEnabled = exports["account-system"]:loadSavedData("audio_streaming") == 1
--     updateCarRadio()
-- end
-- addEventHandler("accounts:options:settings:updated", root, getHUDStates)

function canListenToRadio()
    return (audioStreamsEnabled)
end

local blasters = { }

local function updateVolume(blaster)
    local splitValue = split(tostring(getElementData(blaster, "itemValue")), ':')
    local volume = (tonumber(splitValue[2]) or 100) / 100
    local sound = blasters[blaster] and blasters[blaster].sound
    if sound then
        local veh = getPedOccupiedVehicle(localPlayer)
        if veh and getElementData(veh, 'vehicle:windowstat') ~= 1  then -- windowstat = 1 -> windows down
            volume = 0.3 * volume
        end
        local dist = 60
        
        setSoundVolume(sound, volume)
        setSoundMaxDistance(sound, dist)
    end
end

function startGB(blaster)
    if not getElementData(blaster, "itemID") then 
        return 
    end

    local splitValue = split(tostring(getElementData(blaster, "itemValue")), ':')
    local station = tonumber(splitValue[1]) or 1
    local volume = (tonumber(splitValue[2]) or 100) / 100
    if station > 0 and volume > 0 then
        local streams = exports.carradio:getStreams()
        local x, y, z = getElementPosition(blaster)
        local int = getElementInterior(blaster)
        local dim = getElementDimension(blaster)
        local px, py, pz = getElementPosition(localPlayer)
        if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 50) then
            
            if blasters[blaster] and isElement ( blasters[blaster].sound ) then
                destroyElement(blasters[blaster].sound)
            end
            
            local sound
            if canListenToRadio() then
                sound = playSound3D(streams[station][2], x, y, z)
                setElementDimension(sound, dim)
                setElementInterior(sound, int)
                attachElements ( sound, blaster )
            end

            blasters[blaster] = {
                sound = sound or nil,
                position = { x, y, z, int, dim },
                itemValue = station
            }

            updateVolume(blaster)
        end
    end
end

function stopGB(blaster)
    if isElement ( blaster ) and getElementType(blaster) == "object" and blasters[blaster] then
        local sound = blasters[blaster].sound
        if isElement ( sound ) then
            destroyElement(sound)
        end
        blasters[blaster] = nil
    end
end

function elementStreamIn()
    if isSoundObject(source) then
        startGB(source)
    end
end
addEventHandler("onClientElementStreamIn", getRootElement(), elementStreamIn)

addEventHandler("onClientElementStreamOut", getRootElement(), function ( ) stopGB ( source ) end )
addEventHandler("onClientElementDestroy", getRootElement(), function ( ) stopGB ( source ) end )

function dampenSound(theVehicle)
    if exports.global:getVehicleType( theVehicle ) ~= "Automobile" then
        return
    end
    for blaster in pairs(blasters) do
        updateVolume(blaster)
    end
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, dampenSound)

function boostSound(thePlayer)
    for blaster in pairs(blasters) do
        updateVolume(blaster)
    end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, boostSound)

function toggleSound()
    if isElementStreamedIn(source) then
        local splitValue = split(tostring(getElementData(source, "itemValue")), ':')
        local station = tonumber(splitValue[1]) or 1

        if not blasters[source] or station ~= blasters[source].itemValue then
            stopGB(source)
            if station > 0 then
                startGB(source)
            end
        else
            local volume = (tonumber(splitValue[2]) or 100) / 100
            if volume == 0 then
                stopGB(source)
            else
                updateVolume(source)
            end
        end
    end
end
addEvent("toggleSound", true )
addEventHandler("toggleSound", root, toggleSound)

addEventHandler ( "onClientResourceStart", resourceRoot,
    function ( )
        for i,v in ipairs ( getElementsByType ( "object", root, true ) ) do
            if isSoundObject(v) then
                if isElementStreamedIn(v) then
                    startGB(v)
                end
            end
        end
    end )

addEventHandler ( "onClientRender", root,
    function ( )
        local lx, ly, lz = getCameraMatrix ( localPlayer )
        local pdim = getElementDimension ( localPlayer )

        for i,v in pairs ( blasters ) do
            local x, y, z, int, dim = v.position[1], v.position[2], v.position[3], v.position[4], v.position[5]

            if pdim ~= dim then return end
            
            local distance = getDistanceBetweenPoints3D ( lx, ly, lz, x, y, z )
            z = z + 0.7
            local sx, sy = getScreenFromWorldPosition ( x, y, z )
            
            if sx and distance <= 10 and isLineOfSightClear(lx, ly, lz, x, y, z, true, true, true, true, true, false, false, localPlayer) then
                local itemValue = v.itemValue
                
                local song
                if isElement ( v.sound ) and getSoundMetaTags ( v.sound ) then
                    local musicTitle = getSoundMetaTags ( v.sound )["stream_title"]
                    if type(musicTitle) == "string" then
                        song = "Now playing: "..musicTitle
                    end
                elseif not canListenToRadio() then
                    song = "(( Audio Streaming is disabled ))"
                end
                
                local streams = exports.carradio:getStreams()
                dxDrawText ( "#" .. itemValue .. " - " .. streams[itemValue][1], sx, sy, sx, sy, tocolor ( 255, 255, 255, 255 ), 0.85, "default-bold", "center" )
                
                if type ( song ) == "string" then
                    dxDrawText ( song, sx, sy + 15, sx, sy, tocolor ( 255, 255, 255, 255 ), 0.85, "default-bold", "center" )
                end
            end
        end
    end
)

-- Called when F10 audio streaming setting is changed
function updateCarRadio()
    -- re-populate them all
    for i,v in ipairs ( getElementsByType ( "object", root, true ) ) do
        if isSoundObject(v) then
            if isElementStreamedIn(v) then
                startGB(v)
            end
        end
    end
end

addEvent('updateWindow', true)
addEventHandler('updateWindow', root,
    function()
        if source == getPedOccupiedVehicle(localPlayer) then
            for blaster in pairs(blasters) do
                updateVolume(blaster)
            end
        end
    end
)
