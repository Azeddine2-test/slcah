if localPlayer then
    function isNPCDeliveryTrader(ped)
        return Available_PostOffice.ped == ped
    end
end

function isPlayerOnDelivery(player)
    if not player then return false end
    local deliveryID = getElementData(player, "delivery:id") or false
    local deliveryVehicle = (deliveryID and getElementData(player, "delivery:vehicle")) or false
    return deliveryID, deliveryVehicle
end

function isDeliveryTruck(vehicle)
    if not vehicle or not isElement(vehicle) or (getElementType(vehicle) ~= "vehicle") then return false end
    local vehicleID = getElementModel(vehicle)
    return Available_Trucks[vehicleID] or false
end

function getPlayerDeliveryCount(player)
    if not player then return false end
    return math.max(0, tonumber(getElementData(player, "delivery:delivery_count")) or 0)
end