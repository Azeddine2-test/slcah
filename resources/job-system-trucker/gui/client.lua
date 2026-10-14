local ui = {
    rent = {
        window = {},
        button = {},
        label = {},
        image = {}
    },
    orderlist = {
        window = {},
        button = {},
        gridlist = {}
    }
}

local function isUIOpened()
    for i, j in pairs(ui) do
        if j.state then
            return i
        end
    end
    return false
end

if true then
    ui.rent.showUI = function()
        if ui.rent.state then return false end
        ui.rent.state = true
        triggerEvent("cursorShow", localPlayer)
        local width, height = 800, 405
        ui.rent.window["main"] = exports.dgs:dgsCreateWindow(sX/2-width/2, sY/2-height/2, width, height, "Livreur - Louer un véhicule", false)
        exports.dgs:dgsWindowSetCloseButtonEnabled(ui.rent.window["main"], false)
        addEventHandler("onDgsWindowClose", ui.rent.window["main"], function()
            triggerEvent("cursorHide", localPlayer)
            ui.rent.state = nil
        end, false)

        ui.rent.label["welcome"] = exports.dgs:dgsCreateLabel(20, 5, width - 40, 30, "Bienvenue, quel véhicule souhaitez-vous louer?", false, ui.rent.window["main"])
        exports.dgs:dgsLabelSetVerticalAlign(ui.rent.label["welcome"], "center")
        exports.dgs:dgsLabelSetHorizontalAlign(ui.rent.label["welcome"], "center")
        exports.dgs:dgsSetProperty(ui.rent.label["welcome"], "wordBreak", true)
        exports.dgs:dgsSetFont(ui.rent.label["welcome"], "default-bold")

        local imageWidth, imageHeight = 375, 250
        ui.rent.image["rent-burrito"] = exports.dgs:dgsCreateImage(20, 40, imageWidth, imageHeight, "files/images/vehicle/burrito.png", false, ui.rent.window["main"])
        ui.rent.label["rent-burrito-label"] = exports.dgs:dgsCreateLabel(20, 40 + imageHeight, imageWidth, 30, "Burrito: $"..(Available_Trucks[482].rent), false, ui.rent.window["main"])
        exports.dgs:dgsLabelSetVerticalAlign(ui.rent.label["rent-burrito-label"], "center")
        exports.dgs:dgsLabelSetHorizontalAlign(ui.rent.label["rent-burrito-label"], "center")
        exports.dgs:dgsSetFont(ui.rent.label["rent-burrito-label"], "default-bold")
        addEventHandler("onDgsMouseClickDown", ui.rent.image["rent-burrito"], function()
            exports.dgs:dgsCloseWindow(ui.rent.window["main"])
            triggerServerEvent("Delivery:RentVehicle", localPlayer, localPlayer, 482)
        end, false)

        ui.rent.image["rent-boxville"] = exports.dgs:dgsCreateImage(width - imageWidth - 20, 40, imageWidth, imageHeight, "files/images/vehicle/boxville.png", false, ui.rent.window["main"])
        ui.rent.label["rent-boxville-label"] = exports.dgs:dgsCreateLabel(width - imageWidth - 20, 40 + imageHeight, imageWidth, 30, "Boxville: $"..(Available_Trucks[498].rent), false, ui.rent.window["main"])
        exports.dgs:dgsLabelSetVerticalAlign(ui.rent.label["rent-boxville-label"], "center")
        exports.dgs:dgsLabelSetHorizontalAlign(ui.rent.label["rent-boxville-label"], "center")
        exports.dgs:dgsSetFont(ui.rent.label["rent-boxville-label"], "default-bold")
        addEventHandler("onDgsMouseClickDown", ui.rent.image["rent-boxville"], function()
            exports.dgs:dgsCloseWindow(ui.rent.window["main"])
            triggerServerEvent("Delivery:RentVehicle", localPlayer, localPlayer, 498)
        end, false)

        ui.rent.button["close"] = exports.dgs:dgsCreateButton(20, 330, width - 40, 30, "Fermer", false, ui.rent.window["main"])
        addEventHandler("onDgsMouseClickDown", ui.rent.button["close"], function()
            exports.dgs:dgsCloseWindow(ui.rent.window["main"])
        end, false)
        return true
    end
end

if true then
    ui.orderlist.showUI = function()
        if ui.orderlist.state or isPlayerOnDelivery(localPlayer) then return false end
        ui.orderlist.state = true
        triggerEvent("cursorShow", localPlayer)
        local width, height = 500, 425
        ui.orderlist.window["main"] = exports.dgs:dgsCreateWindow(sX/2-width/2, sY/2-height/2, width, height, "Livreur - Commandes", false)
        exports.dgs:dgsWindowSetCloseButtonEnabled(ui.orderlist.window["main"], false)
        addEventHandler("onDgsWindowClose", ui.orderlist.window["main"], function()
            triggerEvent("cursorHide", localPlayer)
            ui.orderlist.state = nil
        end, false)
        
        ui.orderlist.gridlist["order_list"] = exports.dgs:dgsCreateGridList(20, 5, width - 40, 300, false, ui.orderlist.window["main"])
        exports.dgs:dgsGridListAddColumn(ui.orderlist.gridlist["order_list"], "Nom", 0.6)
        exports.dgs:dgsGridListAddColumn(ui.orderlist.gridlist["order_list"], "Colis", 0.35)
        triggerServerEvent("Delivery:UI:FetchOrders", localPlayer, localPlayer)

        ui.orderlist.button["start_cancel_delivery"] = exports.dgs:dgsCreateButton(20, 315, width - 40, 30, "Commencer Livraison", false, ui.orderlist.window["main"])
        exports.dgs:dgsSetEnabled(ui.orderlist.button["start_cancel_delivery"], false)
        addEventHandler("onDgsMouseClickDown", ui.orderlist.gridlist["order_list"], function()
            local row = exports.dgs:dgsGridListGetSelectedItem(ui.orderlist.gridlist["order_list"])
            exports.dgs:dgsSetEnabled(ui.orderlist.button["start_cancel_delivery"], row ~= -1)
        end, false)
        addEventHandler("onDgsMouseClickDown", ui.orderlist.button["start_cancel_delivery"], function()
            local row = exports.dgs:dgsGridListGetSelectedItem(ui.orderlist.gridlist["order_list"])
            if row == -1 then return false end
            local orderID = exports.dgs:dgsGridListGetItemData(ui.orderlist.gridlist["order_list"], row, 1)
            exports.dgs:dgsCloseWindow(ui.orderlist.window["main"])
            startDelivery(orderID)
        end, false)
    
        ui.orderlist.button["close"] = exports.dgs:dgsCreateButton(20, 355, width - 40, 30, "Fermer", false, ui.orderlist.window["main"])
        addEventHandler("onDgsMouseClickDown", ui.orderlist.button["close"], function()
            exports.dgs:dgsCloseWindow(ui.orderlist.window["main"])
        end, false)
        return true
    end

    addEvent("Delivery:UI:FetchOrders", true)
    addEventHandler("Delivery:UI:FetchOrders", root, function(orders)
        if not ui.orderlist.state then return false end
        exports.dgs:dgsGridListClear(ui.orderlist.gridlist["order_list"])
        for i, j in ipairs(orders) do
            local row = exports.dgs:dgsGridListAddRow(ui.orderlist.gridlist["order_list"])
            exports.dgs:dgsGridListSetItemText(ui.orderlist.gridlist["order_list"], row, 1, j.name, false, false)
            exports.dgs:dgsGridListSetItemText(ui.orderlist.gridlist["order_list"], row, 2, tostring(j.packages), false, false)
            exports.dgs:dgsGridListSetItemData(ui.orderlist.gridlist["order_list"], row, 1, j.id)
        end
    end)

    addCommandHandler("commencerlivraisons", function() ui.orderlist.showUI() end)
    addCommandHandler("annulerlivraison", function()
        if not isPlayerOnDelivery(localPlayer) then return outputChatBox("Tu n'as pas de livraisons pour le moment.", 255, 0, 0) end
        stopDelivery()
    end)
end

addEvent("showDeliveryTraderGUI", true)
addEventHandler("showDeliveryTraderGUI", root, function(ped, isRentUI)
    if not isRentUI and not isNPCDeliveryTrader(ped) then return false end
    if isUIOpened() then return false end
    local vehicleID = getPedOccupiedVehicle(localPlayer)
    if isRentUI then
        if vehicleID then ui.orderlist.showUI() end
        return true
    end
    if not vehicleID then
        ui.rent.showUI()
    else
        ui.orderlist.showUI()
    end
end)