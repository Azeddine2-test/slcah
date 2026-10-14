local deliveryWnd = false
function createDeliveryListUI(deliveries)
    closeDeliveryUI()
    local screenwidth, screenheight = guiGetScreenSize()
    local Width = 756
    local Height = 432
    local X = (screenwidth - Width)/2
    local Y = (screenheight - Height)/2
    deliveryWnd = guiCreateWindow(X, Y, Width, Height)
    guiWindowSetSizable(deliveryWnd,false)
    local deliveryGrid = guiCreateGridList(0.01, 0.01, 0.98, 0.98 - 0.05, true, deliveryWnd)
    local deliveryGridName = guiGridListAddColumn(logGrid, "Location", 0.7)
    local deliveryGridPackages = guiGridListAddColumn(logGrid, "Packages", 0.2)
    for i, j in ipairs(deliveries) do
        local row = guiGridListAddRow(deliveryGrid)
        guiGridListSetItemText(deliveryGrid, row, deliveryGridName, j[1], false, false)
        guiGridListSetItemText(deliveryGrid, row, deliveryGridPackages, j[2], false, false)
    end
    return true
end

function closeDeliveryUI()
    if deliveryWnd then destroyElement(deliveryWnd) end
    deliveryWnd = false
    return true
end