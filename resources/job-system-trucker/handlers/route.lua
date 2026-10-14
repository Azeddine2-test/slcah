if localPlayer then
    local CElements = {
        blip = {},
        marker = {},
        timer = {}
    }
    
    addEvent("Delivery:Client:Join", true)
    addEventHandler("Delivery:Client:Join", localPlayer, function()
        triggerEvent("Delivery:Client:Quit", localPlayer)
        for i, j in ipairs(Available_WareHouses[(COrder.warehouse)].loadPoint) do
            CElements.blip[("loadBlip:"..i)] = createBlip(j[1], j[2], j[3], 0, 2, Available_WareHouses[(COrder.warehouse)]["loadPoint"].color[1], Available_WareHouses[(COrder.warehouse)]["loadPoint"].color[2], Available_WareHouses[(COrder.warehouse)]["loadPoint"].color[3])
            CElements.marker[("Load:"..i)] = createMarker(j[1], j[2], j[3], "cylinder", 3, Available_WareHouses[(COrder.warehouse)]["loadPoint"].color[1], Available_WareHouses[(COrder.warehouse)]["loadPoint"].color[2], Available_WareHouses[(COrder.warehouse)]["loadPoint"].color[3], Available_WareHouses[(COrder.warehouse)]["loadPoint"].color[4])
            addEventHandler("onClientMarkerHit", CElements.marker[("Load:"..i)], function(player, isDimensionMatching)
                if (player ~= localPlayer) or not isDimensionMatching then return false end
                local deliveryID, deliveryVehicle = isPlayerOnDelivery(localPlayer)
                if not deliveryID or (getVehicleController(deliveryVehicle) ~= localPlayer) or (deliveryVehicle ~= getPedOccupiedVehicle(localPlayer)) then return false end	
                if CElements.timer["Load"] and isTimer(CElements.timer["Load"]) then return false end
                sendBottomNotification(localPlayer, DeliveryCompanyName.." Operateur:", "Restock en cours!")
                CElements.timer["Load"] = setTimer(function()
                    triggerServerEvent("Delivery:StockVehicle", localPlayer, localPlayer, true, j)
                end, Vehicle_Restock_Duration, 1)
            end)
            addEventHandler("onClientMarkerLeave", CElements.marker[("Load:"..i)], function(player, isDimensionMatching)
                if (player ~= localPlayer) or not isDimensionMatching then return false end
                if isTimer(CElements.timer["Load"]) then killTimer(CElements.timer["Load"]) end
            end)
        end
    end)
    
    addEvent("Delivery:Client:Quit", true)
    addEventHandler("Delivery:Client:Quit", root, function()
        for i, j in pairs(CElements.marker) do
            if isElement(j) then
                destroyElement(j)
            end
        end
        for i, j in pairs(CElements.blip) do
            if isElement(j) then
                destroyElement(j)
            end
        end
        for i, j in pairs(CElements.timer) do
            if isTimer(j) then
                killTimer(j)
            end
        end
        CElements.blip = {}
        CElements.marker = {}
        CElements.timer = {}
    end)
    
    addEvent("Delivery:Client:ClearRoute", true)
    addEventHandler("Delivery:Client:ClearRoute", root, function()
        if CElements.marker["route"] and isElement(CElements.marker["route"]) then
            destroyElement(CElements.marker["route"])
        end
        if CElements.marker["route-stop"] and isElement(CElements.marker["route-stop"]) then
            destroyElement(CElements.marker["route-stop"])
        end
        if CElements.blip["route"] and isElement(CElements.blip["route"]) then
            destroyElement(CElements.blip["route"])
        end
    end)
    
    addEvent("Delivery:Client:SpawnRoute", true)
    addEventHandler("Delivery:Client:SpawnRoute", root, function()
        if not COrder then return false end
        triggerEvent("Delivery:Client:ClearRoute", localPlayer)
        CElements.blip["route"] = createBlip(COrder.position[1], COrder.position[2], COrder.position[3], 0, 2, Available_WareHouses[(COrder.warehouse)]["routePoint"].color[1], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[2], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[3])
        CElements.marker["route-stop"] = createMarker(COrder.position[1], COrder.position[2], COrder.position[3], "checkpoint", Available_WareHouses[(COrder.warehouse)]["routePoint"].radius, Available_WareHouses[(COrder.warehouse)]["routePoint"].color[1], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[2], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[3], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[4])
        COrder.deliveryGuy.isHavePack = false
        addEventHandler("onClientMarkerHit", CElements.marker["route-stop"], function(player, isDimensionMatching)
            if (player ~= localPlayer) or not isDimensionMatching then return false end
            local deliveryID, deliveryVehicle = isPlayerOnDelivery(localPlayer)
            if not deliveryID or (getVehicleController(deliveryVehicle) ~= localPlayer) or (deliveryVehicle ~= getPedOccupiedVehicle(localPlayer)) then return false end	
            destroyElement(CElements.blip["route"])
            destroyElement(CElements.marker["route-stop"])
            CElements.blip["route"] = createBlip(COrder.position[1], COrder.position[2], COrder.position[3], 0, 2, Available_WareHouses[(COrder.warehouse)]["routePoint"].color[1], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[2], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[3])
            CElements.marker["route"] = createMarker(COrder.position[1], COrder.position[2], COrder.position[3], "checkpoint", Available_WareHouses[(COrder.warehouse)]["routePoint"].radius*0.15, Available_WareHouses[(COrder.warehouse)]["routePoint"].color[1], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[2], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[3], Available_WareHouses[(COrder.warehouse)]["routePoint"].color[4])
            addEventHandler("onClientMarkerHit", CElements.marker["route"], function(player, isDimensionMatching)
                if (player ~= localPlayer) or not isDimensionMatching then return false end
                local deliveryID, deliveryVehicle = isPlayerOnDelivery(localPlayer)
                if not deliveryID then return false end
                if getPedOccupiedVehicle(localPlayer) then return outputChatBox("Tu dois livrer les colis à pied !", 255, 0, 0) end
                triggerServerEvent("Delivery:RemovePackageBox", localPlayer, localPlayer)
                triggerServerEvent("Delivery:Update", localPlayer, localPlayer)
                COrder.deliveryGuy.isHavePack = true
            end)
        end)
    end)
    
    addEventHandler("onClientPlayerVehicleEnter", localPlayer, function (vehicle, seat)
        if not isPlayerOnDelivery(localPlayer) then
            if isDeliveryTruck(vehicle) then outputChatBox("Tu peux commencer à livrer à l'aide de la commande /commencerlivraisons", 255, 255, 255) end
            return false
        end
        if CElements.marker["route"] and isElement(CElements.marker["route"]) then cancelEvent() end
    end)
    addEventHandler("onClientPlayerVehicleExit", localPlayer, function (vehicle, seat)
        if (seat ~= 0) then return end 
        if not isPlayerOnDelivery(localPlayer) then return false end
        if (COrder.deliveryGuy.isHavePack) then return false end 
        if CElements.timer["Load"] and isTimer(CElements.timer["Load"]) then killTimer(CElements.timer["Load"]) end
        if CElements.marker["route"] and isElement(CElements.marker["route"]) then
            triggerServerEvent("Delivery:CarryPackageBox", localPlayer, localPlayer)
        end
    end)
end