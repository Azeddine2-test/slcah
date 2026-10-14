--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		BlackMarket
    Date:		05/06/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.BMScript = SL.BMScript or {};
SL.BMScript.GUI = SL.BMScript.GUI or {};
SL.BMScript.GUI.Admin = SL.BMScript.GUI.Admin or {};
SL.BMScript.Config = SL.BMScript.Config or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: openBlackmarketAdminGUI()
--@ Description: Open the blackmarket admin GUI
--@ Return: void
function openBlackmarketAdminGUI(factions)
    --> Check
    if isElement(SL.BMScript.GUI.Admin['main']) then destroyElement(SL.BMScript.GUI.Admin['main']); end;

    --> Variable(s)
    local player = getLocalPlayer();
    local x, y, w, h = 0.35, 0.35, 0.3, 0.3;
    SL.BMScript.GUI.Admin['main'] = guiCreateWindow(x, y, w, h, 'Marché noir - Administration', true);
    local admTabPanel = guiCreateTabPanel(0, 0.1, 1, 0.685, true, SL.BMScript.GUI.Admin['main']);
    local admTabFactions = guiCreateTab('Liste des factions', admTabPanel);
    local factionList = guiCreateGridList(0.02, 0.065, 0.965, 0.865, true, admTabFactions);
    local otherWindowOpened = false;

    --> x3 Button(s) variable(s)
    local closeButton = guiCreateButton(0, 0.815, 0.22, 0.15, 'Fermer', true, SL.BMScript.GUI.Admin['main']);
    local deleteButton = guiCreateButton(0.265, 0.815, 0.22, 0.15, 'Supprimer', true, SL.BMScript.GUI.Admin['main']);
    local modifyButton = guiCreateButton(0.515, 0.815, 0.22, 0.15, 'Modifier', true, SL.BMScript.GUI.Admin['main']);
    local addButton = guiCreateButton(0.76, 0.815, 0.22, 0.15, 'Ajouter', true, SL.BMScript.GUI.Admin['main']);

    --> GUI
    guiWindowSetSizable(SL.BMScript.GUI.Admin['main'], false);

    --> Faction list
    guiGridListAddColumn(factionList, 'ID', 0.2);
    guiGridListAddColumn(factionList, 'Faction', 0.4);
    guiGridListAddColumn(factionList, 'Nombre de slot(s)', 0.3);

    --> Add faction(s) to the list
    if factions and #factions > 0 then
        for i, v in ipairs(factions) do
            --> Variable(s)
            local row = guiGridListAddRow(factionList);

            --> Add faction(s)
            guiGridListSetItemText(factionList, row, 1, v.id, false, false);
            guiGridListSetItemText(factionList, row, 2, v.name, false, false);
            guiGridListSetItemText(factionList, row, 3, v.maxSlot, false, false);
        end;
    end;

    --> Event(s)
     --> Close button
    addEventHandler('onClientGUIClick', closeButton, function()
        if isElement(SL.BMScript.GUI.Admin['main']) then destroyElement(SL.BMScript.GUI.Admin['main']); end;
    end, false);

     --> Delete button
    addEventHandler('onClientGUIClick', deleteButton, function()
        --> Check if opened or if the player has selected a faction
        if otherWindowOpened then return; end;
        local row, col = guiGridListGetSelectedItem(factionList);
        if row == -1 or col == -1 then outputChatBox(SL.BMScript.Config.base.PREFIX .. "Vous devez sélectionner une faction.", 255, 0, 0); return; end;

        --> Variable(s)
        otherWindowOpened = true;
        local faction_id = guiGridListGetItemText(factionList, row, 1);

        --> GUI
        local deleteWindow = guiCreateWindow(x * 1.18, y * 1.18, w * 0.6, h * 0.35, "Marché noir - Supprimer une faction", true);
        guiWindowSetSizable(deleteWindow, false);
        local deleteLabel = guiCreateLabel(0.05, 0.35, 0.9, 0.5, "Êtes-vous sûr de vouloir supprimer la faction " .. faction_id .. " ?", true, deleteWindow);
        guiLabelSetHorizontalAlign(deleteLabel, "center", true);
        local deleteButton = guiCreateButton(0.05, 0.65, 0.4, 0.25, "Oui", true, deleteWindow);
        local cancelButton = guiCreateButton(0.55, 0.65, 0.4, 0.25, "Non", true, deleteWindow);

        --> Event(s)
         --> Delete button
        addEventHandler('onClientGUIClick', deleteButton, function()
            --> Trigger the event
            triggerServerEvent('onPlayerDeleteFaction', player, tonumber(faction_id));

            --> Destroy element(s)
            if isElement(deleteWindow) then destroyElement(deleteWindow); end;
            if isElement(SL.BMScript.GUI.Admin['main']) then destroyElement(SL.BMScript.GUI.Admin['main']); end;
            showCursor(false);
            otherWindowOpened = false;

            --> Restart the GUI
            triggerServerEvent('onPlayerOpenBlackmarketAdmin', player, player);
        end, false);
        
         --> Cancel button
        addEventHandler('onClientGUIClick', cancelButton, function()
            destroyElement(deleteWindow);
            otherWindowOpened = false;
        end, false);
    end, false);

     --> Modify button
    addEventHandler('onClientGUIClick', modifyButton, function()
        --> Check if opened or if the player has selected a faction
        if otherWindowOpened then return; end;
        local row, col = guiGridListGetSelectedItem(factionList);
        if row == -1 or col == -1 then outputChatBox(SL.BMScript.Config.base.PREFIX .. "Vous devez sélectionner une faction.", 255, 0, 0); return; end;

        --> Variable(s)
        otherWindowOpened = true;
        local faction_id = guiGridListGetItemText(factionList, row, 1);
        local faction_name = guiGridListGetItemText(factionList, row, 2);
        local faction_slots = guiGridListGetItemText(factionList, row, 3);
        local modifyWindow = guiCreateWindow(x * 1.18, y * 1.18, w * 0.6, h * 0.45, "Marché noir - Modifier une faction", true);
        guiWindowSetSizable(modifyWindow, false);

        --> Faction Slots
        local slot = faction_slots;
        local faction_slots = guiCreateLabel(0.05, 0.2, 0.425, 0.15, "Combien de slot(s) ?", true, modifyWindow);
        local faction_slots_edit = guiCreateEdit(0.05, 0.35, 0.9, 0.2, slot, true, modifyWindow);

        --> Button(s)
        local closeButton = guiCreateButton(0.05, 0.6, 0.425, 0.27, "Retour", true, modifyWindow);
        local validateButton = guiCreateButton(0.525, 0.6, 0.425, 0.27, "Valider", true, modifyWindow);

        --> Event(s)
         --> Close button
        addEventHandler("onClientGUIClick", closeButton, function()
            destroyElement(modifyWindow);
            showCursor(false);

            otherWindowOpened = false;
        end, false);

         --> Validate button
        addEventHandler('onClientGUIClick', validateButton, function()
            --> Check(s)
            local new_slot = tonumber(guiGetText(faction_slots_edit));
            if not new_slot then outputChatBox(SL.BMScript.Config.base.PREFIX .. "Vous devez entrer un nombre.", 255, 0, 0); return; end;
            if new_slot < 0 then outputChatBox(SL.BMScript.Config.base.PREFIX .. "Vous ne pouvez pas entrer un nombre inférieur à 0.", 255, 0, 0); return; end;

            --> Update the faction
            triggerServerEvent('onPlayerModifyFaction', player, faction_id, new_slot);

            --> Destroy the window
            destroyElement(modifyWindow);
            destroyElement(SL.BMScript.GUI.Admin['main'])
            showCursor(false);
            otherWindowOpened = false;

            --> Restart the GUI
            triggerServerEvent('onPlayerOpenBlackmarketAdmin', player, player);
        end, false);
    end);

     --> Add button (create new frame to add faction)
    addEventHandler('onClientGUIClick', addButton, function()
        --> Check if opened
        if otherWindowOpened then return; end;

        --> Variable(s)
        otherWindowOpened = true;
        local createWindow = guiCreateWindow(x * 1.18, y * 1.18, w * 0.6, h * 0.45, "Marché noir - Ajouter une faction", true);
        guiWindowSetSizable(createWindow, false);

        --> Faction ID
        local faction_id = guiCreateLabel(0.05, 0.2, 0.425, 0.15, "Quel est l'ID de la faction ?", true, createWindow);
        local faction_id_edit = guiCreateEdit(0.05, 0.35, 0.425, 0.2, "1", true, createWindow);

        --> Faction Slots
        local faction_slots = guiCreateLabel(0.57, 0.2, 0.425, 0.15, "Combien de slot(s) ?", true, createWindow);
        local faction_slots_edit = guiCreateEdit(0.525, 0.35, 0.425, 0.2, "1", true, createWindow)

        --> Button(s)
        local closeButton = guiCreateButton(0.05, 0.6, 0.425, 0.27, "Retour", true, createWindow);
        local validateButton = guiCreateButton(0.525, 0.6, 0.425, 0.27, "Valider", true, createWindow);

        --> Event(s)
         --> Close button
        addEventHandler("onClientGUIClick", closeButton, function()
            destroyElement(createWindow);
            showCursor(false);

            otherWindowOpened = false;
        end, false);

         --> Validate button
        addEventHandler("onClientGUIClick", validateButton, function()
            --> Variable(s)
            local faction_id = tonumber(guiGetText(faction_id_edit));
            local faction_slots = tonumber(guiGetText(faction_slots_edit));

            --> Check(s)
            if faction_id == nil or faction_slots == nil then outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Tous les champs doivent être complétés.", 255, 0, 0, true); return; end;
            if faction_id <= 0 then outputChatBox(SL.BMScript.Config['base'].PREFIX .. "L'ID ne peut être inférieur ou égal à 0. (Actuellement " .. faction_id .. ").", 255, 0, 0, true); return; end;
            
            --> Trigger(s)
            triggerServerEvent('onPlayerAddFaction', player, faction_id, faction_slots);

            --> Destroy element(s)
            destroyElement(createWindow);
            destroyElement(SL.BMScript.GUI.Admin['main'])
            showCursor(false);
            otherWindowOpened = false;

            --> Restart the GUI
            triggerServerEvent('onPlayerOpenBlackmarketAdmin', player, player);
        end, false);
    end, false);
end;