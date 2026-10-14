local ui = {
    modiflist = {
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
    ui.modiflist.showUI = function()
        if ui.modiflist.state then return false end
        ui.modiflist.state = true
        triggerEvent("cursorShow", localPlayer)
        local width, height = 800, 465
        ui.modiflist.window["main"] = exports.dgs:dgsCreateWindow(sX/2-width/2, sY/2-height/2, width, height, "Character - Modifications", false)
        exports.dgs:dgsWindowSetCloseButtonEnabled(ui.modiflist.window["main"], false)
        addEventHandler("onDgsWindowClose", ui.modiflist.window["main"], function()
            triggerEvent("cursorHide", localPlayer)
            ui.modiflist.state = nil
        end, false)
        
        ui.modiflist.gridlist["modif_list"] = exports.dgs:dgsCreateGridList(20, 5, width - 40, 300, false, ui.modiflist.window["main"])
        exports.dgs:dgsGridListAddColumn(ui.modiflist.gridlist["modif_list"], "ID", 0.05)
        exports.dgs:dgsGridListAddColumn(ui.modiflist.gridlist["modif_list"], "Name (Old Name)", 0.2)
        exports.dgs:dgsGridListAddColumn(ui.modiflist.gridlist["modif_list"], "Age (Old Age)", 0.15)
        exports.dgs:dgsGridListAddColumn(ui.modiflist.gridlist["modif_list"], "Skin (Old Skin)", 0.15)
        exports.dgs:dgsGridListAddColumn(ui.modiflist.gridlist["modif_list"], "Height (Old Height)", 0.2)
        exports.dgs:dgsGridListAddColumn(ui.modiflist.gridlist["modif_list"], "Weight (Old Weight)", 0.2)
        triggerServerEvent("Account:UI:FetchModifiedCharacters", localPlayer)

        ui.modiflist.button["accept"] = exports.dgs:dgsCreateButton(20, 315, width - 40, 30, "Accept", false, ui.modiflist.window["main"])
        ui.modiflist.button["decline"] = exports.dgs:dgsCreateButton(20, 355, width - 40, 30, "Decline", false, ui.modiflist.window["main"])
        exports.dgs:dgsSetEnabled(ui.modiflist.button["accept"], false)
        exports.dgs:dgsSetEnabled(ui.modiflist.button["decline"], false)
        addEventHandler("onDgsMouseClickDown", ui.modiflist.gridlist["modif_list"], function()
            local row = exports.dgs:dgsGridListGetSelectedItem(ui.modiflist.gridlist["modif_list"])
            exports.dgs:dgsSetEnabled(ui.modiflist.button["accept"], row ~= -1)
            exports.dgs:dgsSetEnabled(ui.modiflist.button["decline"], row ~= -1)
        end, false)
        addEventHandler("onDgsMouseClickDown", ui.modiflist.button["accept"], function()
            local row = exports.dgs:dgsGridListGetSelectedItem(ui.modiflist.gridlist["modif_list"])
            if row == -1 then return false end
            local characterID = exports.dgs:dgsGridListGetItemData(ui.modiflist.gridlist["modif_list"], row, 1)
            triggerServerEvent("Account:UI:ProcessModifiedCharacter", localPlayer, characterID, true)
            triggerServerEvent("Account:UI:FetchModifiedCharacters", localPlayer)
        end, false)
        addEventHandler("onDgsMouseClickDown", ui.modiflist.button["decline"], function()
            local row = exports.dgs:dgsGridListGetSelectedItem(ui.modiflist.gridlist["modif_list"])
            if row == -1 then return false end
            local characterID = exports.dgs:dgsGridListGetItemData(ui.modiflist.gridlist["modif_list"], row, 1)
            triggerServerEvent("Account:UI:ProcessModifiedCharacter", localPlayer, characterID, false)
            triggerServerEvent("Account:UI:FetchModifiedCharacters", localPlayer)
        end, false)
    
        ui.modiflist.button["close"] = exports.dgs:dgsCreateButton(20, 395, width - 40, 30, "Close", false, ui.modiflist.window["main"])
        addEventHandler("onDgsMouseClickDown", ui.modiflist.button["close"], function()
            exports.dgs:dgsCloseWindow(ui.modiflist.window["main"])
        end, false)
        return true
    end

    addEvent("Account:UI:FetchModifiedCharacters", true)
    addEventHandler("Account:UI:FetchModifiedCharacters", root, function(characters)
        if not ui.modiflist.state then return false end
        exports.dgs:dgsGridListClear(ui.modiflist.gridlist["modif_list"])
        for i, j in ipairs(characters) do
            local row = exports.dgs:dgsGridListAddRow(ui.modiflist.gridlist["modif_list"])
            exports.dgs:dgsGridListSetItemText(ui.modiflist.gridlist["modif_list"], row, 1, j.id, false, false)
            exports.dgs:dgsGridListSetItemData(ui.modiflist.gridlist["modif_list"], row, 1, j.id)
            exports.dgs:dgsGridListSetItemText(ui.modiflist.gridlist["modif_list"], row, 2, j.name.." ("..j.prevName..")", false, false)
            exports.dgs:dgsGridListSetItemText(ui.modiflist.gridlist["modif_list"], row, 3, j.age.." ("..j.prevAge..")", false, false)
            exports.dgs:dgsGridListSetItemText(ui.modiflist.gridlist["modif_list"], row, 4, j.skin.." ("..j.prevSkin..")", false, false)
            exports.dgs:dgsGridListSetItemText(ui.modiflist.gridlist["modif_list"], row, 5, j.height.." ("..j.prevHeight..")", false, false)
            exports.dgs:dgsGridListSetItemText(ui.modiflist.gridlist["modif_list"], row, 6, j.weight.." ("..j.prevWeight..")", false, false)
        end
    end)

    addCommandHandler("cklist", function()
        if not exports.integration:isPlayerAdmin(localPlayer) then return false end
        ui.modiflist.showUI()
    end)
    
    addEventHandler("accounts:characters:change", root, function()
        if not ui.modiflist.state then return false end
        exports.dgs:dgsCloseWindow(ui.modiflist.window["main"])
    end)
    addEventHandler("accounts:characters:logout", root, function()
        if not ui.modiflist.state then return false end
        exports.dgs:dgsCloseWindow(ui.modiflist.window["main"])
    end)
end