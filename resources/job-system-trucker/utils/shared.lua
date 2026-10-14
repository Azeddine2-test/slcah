local __outputChatBox = outputChatBox
function outputChatBox(text, ...)
    if not text then return false end
    if string.len(text) > 128 then
        __outputChatBox(string.sub(text, 1, 127), ...)
        outputChatBox(string.sub(text, 128), ...)
    else __outputChatBox(text, ...) end
    return true
end

if localPlayer then
    sX, sY = guiGetScreenSize()

    addEventHandler("onClientResourceStart", resourceRoot, function()
        Available_PostOffice.ped = createPed(Available_PostOffice.skin, Available_PostOffice.position[1], Available_PostOffice.position[2], Available_PostOffice.position[3])
        setElementRotation(Available_PostOffice.ped, 0, 0, Available_PostOffice.rotation)
        setElementDimension(Available_PostOffice.ped, Available_PostOffice.dimension)
        setElementInterior(Available_PostOffice.ped, Available_PostOffice.interior)
        setElementData(Available_PostOffice.ped, "name", Available_PostOffice.name, true)
        setElementData(Available_PostOffice.ped, "rpp.npc.type", "delivery:trader", true)
        setElementFrozen(Available_PostOffice.ped, true)
    end)
else
    database = exports.mysql:getConn("mta")

    function isPlayerInteriorOwner(player, interior)
        interior = exports.pool:getElement("interior", interior)
        if interior then
            local status = getElementData(interior, "status")
            if status and (status.owner == getElementData(player, "dbid")) then
                return true
            end
        end
        return false
    end
    
    function fetchCharacterDeliveryCount(characterID)
        if not characterID then return false end
        local queryHandle = dbQuery(database, "SELECT delivery_count from characters WHERE id=?", characterID)
        local results = dbPoll(queryHandle, -1)
        dbFree(queryHandle)
        return (results and results[1] and results.delivery_count) or false
    end

    function populateOrderList()
        local orderCounter = 0
        for i, j in pairs(COrder) do
            orderCounter = orderCounter + 1
        end
        if orderCounter <= 10 then
            for i = orderCounter, 10, 1 do
                createFakeOrder()
            end
        end
        return true
    end

    function countTotalPackages(supplies)
        local count = 0
        for i, j in pairs(supplies) do
            count = count + j
        end
        return count
    end

    function notifyTruckers(content)
        for dbid, player in ipairs(exports.pool:getPoolElementsByType("playerByDbid")) do
            if isPlayerOnDelivery(player) then
                outputChatBox(content, player, 120, 255, 80)
            end
        end
    end
    
    function getEarnedMoney(capacity, distance)
        distance = math.min(distance/2000, 1)
        local totalEarned = 0
        for i = 1, capacity, 1 do
            totalEarned = totalEarned + math.random(4, 6)
        end
        return math.floor(totalEarned*distance)
    end
    
    function findRootInteriorMarker(dim)
        local foundRootInterior = false
        for key, interior in pairs(getElementsByType("interior")) do
            if dim == getElementData(interior, "dbid") then
                local marker = getElementData(interior, "entrance")
                if marker.int == 0 and marker.dim == 0 then
                    return marker.x, marker.y, marker.z, getElementData(interior, "name") or "Unknown"
                else
                    return false, marker.dim
                end
                break
            end
        end
    end
end