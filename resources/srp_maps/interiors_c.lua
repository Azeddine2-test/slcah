--[[
    Southland Roleplay Map Loader

    Interior Support (inspired by Owl "official-interiors")

    Author: Fernando
    Created: 21/03/2023
]]

local interiorCols = {}
local mapContents = {}
local unloadMaps = {}

local function enterInterior(mapName, forceDimension)
    unloadMaps[mapName] = nil
    if isMapLoaded(mapName) then
        if updateMapDimension(mapName, forceDimension) then
            -- print("Interior dim updated: ", mapName, forceDimension)
        end
    else
        if loadOneMap(mapName, mapContents[mapName], forceDimension) then
            -- print("Interior loaded 1st time: ", mapName, forceDimension)
        end
    end
end

local function leaveInterior(mapName)
    if isMapLoaded(mapName) then
        if updateMapDimension(mapName, 65535) then
            -- print("Interior dim updated: ", mapName, 65535)
        end
    end
end

local function handleColShapeHitLeave(element)
    if element ~= localPlayer then return end
    local interiorInfo = interiorCols[source]
    if not interiorInfo then return end
    if eventName == "onClientColShapeHit" then
        local pDim = getElementDimension(localPlayer)
        if getElementInterior(localPlayer) == interiorInfo.interior and pDim > 0 then
            enterInterior(interiorInfo.mapName, pDim)
        end
    else
        leaveInterior(interiorInfo.mapName)
    end
end
addEventHandler("onClientColShapeHit", resourceRoot, handleColShapeHitLeave)
addEventHandler("onClientColShapeLeave", resourceRoot, handleColShapeHitLeave)

local function handleInteriorChange(oldInterior, newInterior)
    if oldInterior == newInterior then return end
    local pDim = getElementDimension(localPlayer)
    for col, interiorInfo in pairs(interiorCols) do
        if interiorInfo.interior == newInterior and isElementWithinColShape(localPlayer, col) and pDim > 0 then
            enterInterior(interiorInfo.mapName, pDim)
        else
            leaveInterior(interiorInfo.mapName)
        end
    end
end
addEventHandler("onClientElementInteriorChange", localPlayer, handleInteriorChange, false)

local function handleDimensionChange(oldDimension, newDimension)
    if oldDimension == newDimension then return end
    local pInt = getElementInterior(localPlayer)
    for col, interiorInfo in pairs(interiorCols) do
        if interiorInfo.interior == pInt and isElementWithinColShape(localPlayer, col) and newDimension > 0 then
            enterInterior(interiorInfo.mapName, newDimension)
        else
            leaveInterior(interiorInfo.mapName)
        end
    end
end
addEventHandler("onClientElementDimensionChange", localPlayer, handleDimensionChange, false)

local function setupOneInterior(map, mapEncodeKey)
    local name = map.name
    local interiorValues = map.interiorValues
    local interiorWorld = interiorValues.interior or 0
    local col = createColSphere(interiorValues.x, interiorValues.y, interiorValues.z, interiorValues.radius or 100)
    interiorCols[col] = {
        mapName = name,
        interior = interiorWorld,
    }
    --mapContents[name] = map.content
    mapContents[name] = getMapContent(map.path, mapEncodeKey)
    if isElementWithinColShape(localPlayer, col) then
        local pDim = getElementDimension(localPlayer)
        if getElementInterior(localPlayer) == interiorWorld and pDim > 0 then
            enterInterior(name, pDim)
        end
    end
end

function prepareAllInteriors(mapList, mapEncodeKey)
    for col, _ in pairs(interiorCols) do
        if isElement(col) then
            destroyElement(col)
        end
    end
    interiorCols = {}
    mapContents = {}
    for i, map in ipairs(mapList) do
        setupOneInterior(map, mapEncodeKey)
    end
end
--addEvent("srp_maps:prepareAllInteriors", true)
--addEventHandler("srp_maps:prepareAllInteriors", localPlayer, prepareAllInteriors, false)