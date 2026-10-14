if localPlayer then
    function sendBottomNotification(...) return exports.hud:sendBottomNotification(...) end
    addEvent("Delivery:SendNotification", true)
    addEventHandler("Delivery:SendNotification", root, sendBottomNotification)
else
    function sendBottomNotification(player, ...)
        return triggerClientEvent(player, "Delivery:SendNotification", player, player, ...)
    end
end