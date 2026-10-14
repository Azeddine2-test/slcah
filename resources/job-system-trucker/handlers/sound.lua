if localPlayer then
    addEvent("Delivery:PlayVehicleFX", true)
    addEventHandler("Delivery:PlayVehicleFX", root, function(x, y, z, dimension, interior)
        local sound = playSound3D("files/sounds/"..math.random(1, 6)..".mp3", x, y, z)
        setElementDimension(sound, dimension)
        setElementInterior(sound, interior)
    end)
else
    function playVehicleFX(player, vehicle)
        if not player or not vehicle then return false end
        local x, y, z = getElementPosition(vehicle)
        local dimension = getElementDimension(vehicle)
        local interior = getElementInterior(vehicle)
        triggerClientEvent(player, "Delivery:PlayVehicleFX", player, x, y, z, dimension, interior)
    end
end