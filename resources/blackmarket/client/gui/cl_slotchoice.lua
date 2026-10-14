--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		BlackMarket
    Date:		31/05/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.BMScript = SL.BMScript or {};
SL.BMScript.GUI = SL.BMScript.GUI or {};
SL.BMScript.GUI.SlotChoose = SL.BMScript.GUI.SlotChoose or {};
SL.BMScript.Config = SL.BMScript.Config or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: openSlotChooseGUI
--@ Description: Open the slot choose GUI
--@ Return: void
function openSlotChooseGUI(factionID, slots)
    --> Check
    if isElement(SL.BMScript.GUI.SlotChoose['main']) then if guiGetVisible(SL.BMScript.GUI.SlotChoose['main']) then guiSetVisible(SL.BMScript.GUI.SlotChoose['main'], false); return; end; end;

    --> Variable(s)
    local x, y = 0.350, 0.350;
    local w, h = 0.3, 0.3;
    local usedSlotsID = {};
    local every_slots = {};

    for k, v in pairs(slots) do if (v['itemType'] == 'material' or v['itemType'] == 'other') then table.insert(usedSlotsID, v['slot']); end; end;

    --> Add: Every slots to the table
    for k, v in pairs(SL.BMScript.Config['weapons']['materials']) do 
        if table.find(v[8], exports.factions:getFactionType(factionID)) then every_slots[k] = v; end;
    end;
    for k, v in pairs(SL.BMScript.Config['weapons']['others']) do 
        if table.find(v[6], exports.factions:getFactionType(factionID)) then every_slots[k] = v; end;--table.insert(every_slots, v); end; 
    end;

    --> GUI
     --> Main window
    SL.BMScript.GUI.SlotChoose['main'] = guiCreateWindow(x, y, w, h, "Marché noir - Choix des slots", true);
    guiWindowSetSizable(SL.BMScript.GUI.SlotChoose['main'], false);

    ------------------
    --> Slots list <--
    ------------------
    local slotList = guiCreateGridList(0, 0.1, 1, 0.65, true, SL.BMScript.GUI.SlotChoose['main']);
    guiGridListAddColumn(slotList, "N°", 0.1);
    guiGridListAddColumn(slotList, "Selectionné", 0.1);
    guiGridListAddColumn(slotList, "Description", 0.4);
    guiGridListAddColumn(slotList, "Slot", 0.1)
    guiGridListAddColumn(slotList, "", 0.3);

    --> Show every available Materials (name, stock, price)
    local i = 0;
    for k, v in pairs(every_slots) do
        --> Variable(s)
        i = i + 1;
        local row = guiGridListAddRow(slotList);
        local real_slot = 0;

        --> Get: Real slot
        for _, v2 in pairs(SL.BMScript.Config['weapons']['materials']) do if v2[1] == v[1] then real_slot = _; end; end;
        for _, v2 in pairs(SL.BMScript.Config['weapons']['others']) do if v2[1] == v[1] then real_slot = _; end; end;

        --> Grid list
        guiGridListSetItemText(slotList, row, 1, tostring(i), false, false);
        guiGridListSetItemText(slotList, row, 2, "", false, false); 
        guiGridListSetItemText(slotList, row, 3, v[1], false, false);
        guiGridListSetItemText(slotList, row, 4, v[5], false, false);
        guiGridListSetItemText(slotList, row, 5, v[4] .. ' unités par semaines', false, false);

        --> Loop to make every used slots to "selected" with real slot
        if #slots >= 1 and #usedSlotsID >= 1 then
            for _, v2 in pairs(usedSlotsID) do
                if tonumber(v2) == tonumber(real_slot) then
                    guiGridListSetItemText(slotList, row, 2, "×", false, false);
                end;
            end;
        end;
    end;

    --> Button(s) (close and buy)
    local closeButton = guiCreateButton(0.01, 0.8, 0.45, 0.15, "Fermer", true, SL.BMScript.GUI.SlotChoose['main']);
    local buyButton = guiCreateButton(0.550, 0.8, 0.45, 0.15, "Choisir", true, SL.BMScript.GUI.SlotChoose['main']);

    --> Event(s)
     --> Close button
    addEventHandler("onClientGUIClick", closeButton, function()
        guiSetVisible(SL.BMScript.GUI.SlotChoose['main'], false);
        showCursor(false);
    end, false);

    --> Choose button
    addEventHandler("onClientGUIClick", buyButton, function()
        --> Variable(s)
        local row, col = guiGridListGetSelectedItem(slotList);

        --> Check
        if row == -1 or col == -1 then return; end;

        --> Condition(s)
        if row and col then
            --> Variable(s)
            local slot_name = guiGridListGetItemText(slotList, row, 3); 

            --> Get: Real slot
            for k, v in pairs(SL.BMScript.Config['weapons']['materials']) do if v[1] == slot_name then slot = k; end; end;
            for k, v in pairs(SL.BMScript.Config['weapons']['others']) do if v[1] == slot_name then slot = k; end; end;

            --local slot = guiGridListGetItemText(slotList, row, 1);
            local amount = guiGridListGetItemText(slotList, row, 5);
            amount = tonumber(string.match(amount, "%d+"));
            local slotTaken = every_slots[tonumber(slot)][5];
            
            --> Check
            if tonumber(amount) <= 0 then outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Vous ne pouvez pas choisir ce slot car il n'est pas disponible.", 255, 0, 0); return; end;

            --> Event
            triggerServerEvent('onPlayerChoosedSlot', getLocalPlayer(), factionID, slot, slot_name, amount, slotTaken);

            --> Close GUI & Restart
            destroyElement(SL.BMScript.GUI.SlotChoose['main']);
            triggerServerEvent('onPlayerOpenSlots', getLocalPlayer(), factionID);
        end;
    end, false);
end;