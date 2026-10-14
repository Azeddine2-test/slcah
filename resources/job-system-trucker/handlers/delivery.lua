if localPlayer then
    COrder = nil

    function startDelivery(deliveryID, isRemote)
        if not isRemote then
            if isPlayerOnDelivery(localPlayer) then return false end
            if not deliveryID then return false end
            triggerServerEvent("Delivery:Start", localPlayer, localPlayer, deliveryID)
        else
            COrder = isRemote
            COrder.id = deliveryID
            COrder.warehouse = math.random(#Available_WareHouses)
            triggerEvent("Delivery:Client:Join", localPlayer)
        end
    end
    addEvent("Delivery:Start", true)
    addEventHandler("Delivery:Start", root, startDelivery)

    function stopDelivery(isRemote)
        if not isRemote then
            if not isPlayerOnDelivery(localPlayer) then return false end
            triggerServerEvent("Delivery:Stop", localPlayer, localPlayer)
        else
            triggerEvent("Delivery:Client:Quit", localPlayer)
            COrder = nil
        end
    end
    addEvent("Delivery:Stop", true)
    addEventHandler("Delivery:Stop", root, stopDelivery)
else
    COrder = {}
    CPackage = {}
    CJackTimer = {}
    CRentedVehicle = {}
    local currentRentPoint = 1
    --Enable this only when you wanna create delivery_count column
    --dbExec(database, "ALTER TABLE characters ADD COLUMN delivery_count BIGINT NOT NULL DEFAULT 0")

    --[[
    addCommandHandler("testdeliver", function(player, cmd, interiorID)
        interiorID = tonumber(interiorID)
        if not interiorID then return outputChatBox("TODO: Invalid interior") end
        local deliveryID = false
        for i, j in pairs(COrder) do
            if j.interior == interiorID then
                deliveryID = i
                break
            end
        end
        if not deliveryID then return outputChatBox("TODO: Invalid order") end
        local interior = exports.pool:getElement("interior", COrder[deliveryID].interior)
        local status = getElementData(interior, "status")
        local supplies = fromJSON(status.supplies)
        for i, j in pairs(COrder[deliveryID].supplies) do
            supplies[i] = (supplies[i] or 0) + j
        end
        status.supplies = toJSON(supplies)
        setElementData(interior, "status", status)
        dbExec(database, "UPDATE interiors SET supplies=? WHERE id=?", toJSON(supplies), interior)
        COrder[deliveryID] = nil
        outputChatBox("TODO: Auto delivered the order!")
    end)
    ]]

    addEvent("Delivery:Start", true)
    addEventHandler("Delivery:Start", root, function(player, deliveryID)
        if isPlayerOnDelivery(player) or not COrder[deliveryID] or COrder[deliveryID].deliveryGuy then return false end
        if isPlayerInteriorOwner(player, COrder[deliveryID].interior) then return outputChatBox("Vous ne pouvez pas livrer dans votre propre boutique !", player, 255, 0, 0) end
        local vehicle = getPedOccupiedVehicle(player)
        local vehicleData = isDeliveryTruck(vehicle)
        if not vehicleData then return outputChatBox("Vous n'êtes pas dans un véhicule utilitaire.", player, 255, 0, 0) end
        COrder[deliveryID].deliveryGuy = {}
        COrder[deliveryID].deliveryGuy.isStocked = false
        COrder[deliveryID].deliveryGuy.player = player
        COrder[deliveryID].deliveryGuy.vehicle = vehicle
        COrder[deliveryID].deliveryGuy.isHavePack = false
        setElementData(player, "delivery:id", deliveryID)
        setElementData(player, "delivery:vehicle", vehicle)
        triggerClientEvent(player, "Delivery:Start", player, deliveryID, COrder[deliveryID])
        outputChatBox("Vous venez d'accepter la commande #"..deliveryID.."; Rendez-vous à l'entrepôt !", player, 0, 255, 0)
    end)

    addEvent("Delivery:Stop", true)
    addEventHandler("Delivery:Stop", root, function(player, isPlayerQuit, isSkipMsg)
        local deliveryID, deliveryVehicle = isPlayerOnDelivery(player)
        if not deliveryID then return false end
        if deliveryID and COrder[deliveryID] then COrder[deliveryID].deliveryGuy = nil end
        setElementData(player, "delivery:id", false)
        setElementData(player, "delivery:vehicle", false)
        if not isPlayerQuit then triggerClientEvent(player, "Delivery:Stop", player, true) end
        if not isSkipMsg then outputChatBox("Votre livraison pour la commande #"..deliveryID.." a été interrompue!", player, 0, 255, 0) end
    end)

    addEvent("Delivery:Update", true)
    addEventHandler("Delivery:Update", root, function(player)
        local deliveryID, deliveryVehicle = isPlayerOnDelivery(player)
        if not deliveryID then return false end
        if not COrder[deliveryID].deliveryGuy.isStocked then return outputChatBox("Tu dois recharger ton camion à l'entrepôt avant de livrer !", player, 255, 0, 0) end
        COrder[deliveryID].deliveryGuy.isStocked = false
        local characterID = getElementData(player, "dbid")
        local isOrderFullfilled = true
        if not COrder[deliveryID].isFakeOrder then
            local interior = exports.pool:getElement("interior", COrder[deliveryID].interior)
            local status = getElementData(interior, "status")
            local supplies = fromJSON(status.supplies)
            for i, j in pairs(COrder[deliveryID].deliveryGuy.supplies) do
                supplies[i] = (supplies[i] or 0) + j
                COrder[deliveryID].supplies[i] = COrder[deliveryID].supplies[i] - j
                if COrder[deliveryID].supplies[i] <= 0 then COrder[deliveryID].supplies[i] = nil end
            end
            status.supplies = toJSON(supplies)
            setElementData(interior, "status", status)
            dbExec(database, "UPDATE interiors SET supplies=? WHERE id=?", toJSON(supplies), COrder[deliveryID].interior)
            for i, j in pairs(COrder[deliveryID].supplies) do
                isOrderFullfilled = false
                break
            end
        else
            COrder[deliveryID].packages = COrder[deliveryID].packages - COrder[deliveryID].deliveryGuy.count
            isOrderFullfilled = COrder[deliveryID].packages <= 0
        end
        local earnedMoney = getEarnedMoney(COrder[deliveryID].deliveryGuy.count, getDistanceBetweenPoints3D(COrder[deliveryID].deliveryGuy.loadPoint[1], COrder[deliveryID].deliveryGuy.loadPoint[2], COrder[deliveryID].deliveryGuy.loadPoint[3], COrder[deliveryID].position[1], COrder[deliveryID].position[2], COrder[deliveryID].position[3]))
        exports["global"]:giveMoney(player, earnedMoney)
        setElementData(player, "delivery:delivery_count", getPlayerDeliveryCount(player) + COrder[deliveryID].deliveryGuy.count)
        dbExec(database, "UPDATE characters SET delivery_count=? WHERE id=?", getPlayerDeliveryCount(player), characterID)
        if isOrderFullfilled then
            if not COrder[deliveryID].isFakeOrder then dbExec(database, "DELETE FROM jobs_trucker_orders WHERE orderID=?", deliveryID) end
            local interiorID = COrder[deliveryID].interior
            COrder[deliveryID] = nil
            triggerEvent("Delivery:Stop", player, player, _, true)
            triggerEvent("delivery.onPlayerDelivery", player, interiorID)
            outputChatBox("Vous venez de compléter la livraison #"..deliveryID.."!", player, 0, 255, 0)
            sendBottomNotification(player, DeliveryCompanyName.." Operateur:", "Livraison #"..deliveryID.." terminée.")
        else
            if not COrder[deliveryID].isFakeOrder then dbExec(database, "UPDATE jobs_trucker_orders SET orderSupplies=? WHERE orderID=?", toJSON(COrder[deliveryID].supplies), deliveryID) end
            triggerEvent("Delivery:StockVehicle", player, false)
            outputChatBox("Vous venez de livrer la commande #"..deliveryID.."!", player, 0, 255, 0)
            outputChatBox("Cependant il y a encore des colis à livrer à cet endroit. Visitez l'entrepôt afin de recharger votre camion !", player, 0, 255, 0)
            sendBottomNotification(player, DeliveryCompanyName.." Operateur:", "Restockez votre véhicule pour la commande #"..deliveryID.."")
        end
        outputChatBox("Tu viens de recevoir $"..earnedMoney.." pour ta livraison!", player, 0, 255, 0)
    end)

    addEvent("Delivery:StockVehicle", true)
    addEventHandler("Delivery:StockVehicle", root, function(player, state, loadpoint)
        local deliveryID, deliveryVehicle = isPlayerOnDelivery(player)
        if not deliveryID then return false end
        state = (state and true) or false
        if state and COrder[deliveryID].deliveryGuy.isStocked then return outputChatBox("Ton véhicule est déjà plein !", player, 255, 0, 0) end
        COrder[deliveryID].deliveryGuy.isStocked = state
        if COrder[deliveryID].deliveryGuy.isStocked then
            COrder[deliveryID].deliveryGuy.loadPoint = loadpoint
            local vehicleData = isDeliveryTruck(COrder[deliveryID].deliveryGuy.vehicle)
            COrder[deliveryID].deliveryGuy.count = 0
            if not COrder[deliveryID].isFakeOrder then
                COrder[deliveryID].deliveryGuy.supplies = {}
                for i, j in pairs(COrder[deliveryID].supplies) do
                    COrder[deliveryID].deliveryGuy.supplies[i] = math.min(vehicleData.capacity - COrder[deliveryID].deliveryGuy.count, j)
                    COrder[deliveryID].deliveryGuy.count = COrder[deliveryID].deliveryGuy.count + COrder[deliveryID].deliveryGuy.supplies[i]
                    if COrder[deliveryID].deliveryGuy.count >= vehicleData.capacity then break end
                end
            else
                COrder[deliveryID].deliveryGuy.count = math.min(COrder[deliveryID].packages, vehicleData.capacity)
            end
        end
        playVehicleFX(player, COrder[deliveryID].deliveryGuy.vehicle)
        if COrder[deliveryID].deliveryGuy.isStocked then outputChatBox("Ton véhicule a bien été rechargé en colis, bonne chance pour ta livraison.", player, 0, 255, 0) end
        triggerClientEvent(player, (COrder[deliveryID].deliveryGuy.isStocked and "Delivery:Client:SpawnRoute") or "Delivery:Client:ClearRoute", player)
    end)

    addEvent("Delivery:RentVehicle", true)
    addEventHandler("Delivery:RentVehicle", root, function(player, vehicleID)
        if not player or not Available_Trucks[vehicleID] or not Available_Trucks[vehicleID].rent then return false end
        if CRentedVehicle[player] and isElement(CRentedVehicle[player]) then return outputChatBox("Tu loue déjà un véhicule, pour annuler la location, utilise /annulerlocation", player, 255, 0, 0) end
        if not exports["global"]:hasMoney(player, Available_Trucks[vehicleID].rent) then return outputChatBox("Malheureusement, tu n'as pas assez d'argent pour louer ce véhicule [$"..(Available_Trucks[vehicleID].rent).."].", player, 255, 0, 0) end
        exports["global"]:takeMoney(player, Available_Trucks[vehicleID].rent)
        CRentedVehicle[player] = exports.vehicle_manager:createTempVehicle(player, Available_Trucks[vehicleID].customID, Available_PostOffice.vehicleSpawn[currentRentPoint])
        setElementRotation(CRentedVehicle[player], 0, 0, Available_PostOffice.vehicleSpawn[currentRentPoint].rotation)
        warpPedIntoVehicle(player, CRentedVehicle[player])
        setElementData(CRentedVehicle[player], "Delivery:RentVehicle", true, false)
        setElementData(CRentedVehicle[player], "Delivery:RentVehicle:lastTick", getTickCount(), false)
        triggerClientEvent(player, "showDeliveryTraderGUI", player, _, true)
        currentRentPoint = currentRentPoint + 1
        if currentRentPoint > #Available_PostOffice.vehicleSpawn then currentRentPoint = 1 end
    end)

    addEvent("Delivery:RevokeRent", true)
    addEventHandler("Delivery:RevokeRent", root, function(player)
        if not CRentedVehicle[player] or not isElement(CRentedVehicle[player]) then return false end
        destroyElement(CRentedVehicle[player])
        CRentedVehicle[player] = nil
    end)

    addCommandHandler("annulerlocation", function(player)
        if not CRentedVehicle[player] or not isElement(CRentedVehicle[player]) then return outputChatBox("Tu n'as pas encore loué de véhicule.", player, 255, 0, 0) end
        triggerEvent("Delivery:RevokeRent", player, player)
        outputChatBox("Tu viens d'annuler ta location!", player, 0, 255, 0)
    end)

    addEvent("Delivery:CarryPackageBox", true)
    addEventHandler("Delivery:CarryPackageBox", root, function(player)
        local deliveryID, deliveryVehicle = isPlayerOnDelivery(player)
        if not deliveryID or not COrder[deliveryID].deliveryGuy.isStocked or CPackage[player] then return false end
        setPedAnimation(player, "CARRY", "crry_prtial", 1, false, false, false, true, 250, false)
        CPackage[player] = createObject(1271, 0, 0, 0)
        setElementCollisionsEnabled(CPackage[player], false)
        exports.pAttach:attach(CPackage[player], player, "backpack", 0.3, 0.55, 0, 0, 90, 0)
    end)

    addEvent("Delivery:RemovePackageBox", true)
    addEventHandler("Delivery:RemovePackageBox", root, function(player)
        if not player or not CPackage[player] then return false end
        setPedAnimation(player, "CARRY", "crry_prtial", 1, false, true, true, false, 250, true)
        destroyElement(CPackage[player])
        CPackage[player] = nil
    end)
    
    addEventHandler("onVehicleStartEnter", root, function(player, seat, isJacked)
        if (seat ~= 0) or not isJacked then return false end
        local isDeliveryVehicle = false
        for i, j in ipairs(getElementsByType("player")) do
            local deliveryID, deliveryVehicle = isPlayerOnDelivery(j)
            if deliveryVehicle == source then
                isDeliveryVehicle = true
                break
            end
        end
        if not isDeliveryVehicle then return false end
        if CJackTimer[source] and isTimer(CJackTimer[source]) then killTimer(CJackTimer[source]) end
        setVehicleLocked(source, true)
        CJackTimer[source] = setTimer(function(vehicle)
            CJackTimer[vehicle] = nil
            setVehicleLocked(vehicle, false)
        end, 5000, 1, source)
    end)

    addEventHandler("onVehicleStartExit", root, function(player, seat)
        if (seat ~= 0) or not getElementData(source, "Delivery:RentVehicle") then return false end
        setElementData(source, "Delivery:RentVehicle:lastTick", getTickCount(), false)
    end)

    for i, j in ipairs(getElementsByType("player")) do
        setElementData(j, "delivery:delivery_count", fetchCharacterDeliveryCount(getElementData(j, "dbid")))
    end
    addEventHandler("account:character:spawned", root, function()
        setElementData(source, "delivery:delivery_count", fetchCharacterDeliveryCount(getElementData(source, "dbid")))
    end)
    addEventHandler("onElementDataChange", root, function(key, _, value)
        if ((key == "delivery:id") or (key == "delivery:vehicle")) and not value then
            triggerEvent("Delivery:RemovePackageBox", source, source)
        end
    end)
    addEventHandler("onElementDestroy", root, function()
        if getElementType(source) == "vehicle" then
            if CJackTimer[source] and isTimer(CJackTimer[source]) then
                killTimer(CJackTimer[source])
                CJackTimer[source] = nil
            end
            for i, j in ipairs(getElementsByType("player")) do
                local deliveryID, deliveryVehicle = isPlayerOnDelivery(j)
                if deliveryVehicle == source then
                    triggerEvent("Delivery:Stop", j, j)
                    break
                end
            end
        end
    end)
    addEventHandler("onPlayerQuit", root, function()
        triggerEvent("Delivery:Stop", source, source, true)
        triggerEvent("Delivery:RevokeRent", source, source)
    end)
    addEventHandler("account:character:change", root, function()
        triggerEvent("Delivery:Stop", source, source)
        triggerEvent("Delivery:RevokeRent", source, source)
    end)
    addEventHandler("onResourceStop", resourceRoot, function()
        for i, j in ipairs(getElementsByType("player")) do
            triggerEvent("Delivery:Stop", j, j)
            triggerEvent("Delivery:RevokeRent", j, j)
        end
    end)
    setTimer(function()
        populateOrderList()
        local currentTick = getTickCount()
        for i, j in pairs(CRentedVehicle) do
            if j and isElement(j) and not getVehicleController(j) then
                local lastTick = getElementData(j, "Delivery:RentVehicle:lastTick")
                if (currentTick - lastTick) >= Vehicle_Deletion_Interval then
                    triggerEvent("Delivery:RevokeRent", i, i)
                end
            end
        end
    end, 1*60*1000, 0)
end