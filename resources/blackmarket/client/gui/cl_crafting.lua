--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		BlackMarket
    Date:		12/06/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.BMScript = SL.BMScript or {};
SL.BMScript.GUI = SL.BMScript.GUI or {};
SL.BMScript.GUI.Crafting = SL.BMScript.GUI.Crafting or {};
SL.BMScript.Config = SL.BMScript.Config or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: openBlackmarketCraftingGUI()
--@ Description: Open the crafting GUI
--@ Return: void
function openBlackmarketCraftingGUI(items)
    --> Check
    if isElement(SL.BMScript.GUI.Crafting['main']) then destroyElement(SL.BMScript.GUI.Crafting['main']); end;

    --> Variable(s)
    local player = getLocalPlayer();
    local x, y, w, h = 0.29, 0.29, 0.45, 0.45;
    SL.BMScript.GUI.Crafting['main'] = guiCreateWindow(x, y, w, h, 'Atelier de construction', true);
    local craftTabPanel = guiCreateTabPanel(0, 0.1, 1, 0.685, true, SL.BMScript.GUI.Crafting['main']);
    local craftTab = guiCreateTab('Création d\'arme', craftTabPanel);
    local weps_id = {};

    --> GUI
    guiWindowSetSizable(SL.BMScript.GUI.Crafting['main'], false);

    --> Button(s) (close and craft
    local closeButton = guiCreateButton(0.01, 0.82, 0.45, 0.15, "Fermer", true, SL.BMScript.GUI.Crafting['main']);
    local craftButton = guiCreateButton(0.550, 0.82, 0.45, 0.15, "Construire", true, SL.BMScript.GUI.Crafting['main']);

    ------------------
    --> Craft list <--
    ------------------
    local craftList = guiCreateGridList(0.02, 0.065, 0.965, 0.865, true, craftTab);
    guiGridListAddColumn(craftList, "#", 0.1);
    guiGridListAddColumn(craftList, "Arme", 0.15);
    guiGridListAddColumn(craftList, "Matériel", 0.3);
    guiGridListAddColumn(craftList, "Coût", 0.4);

     --> Show every available Others (name, stock, price)
    for k, v in pairs(SL.BMScript.Config['weapons']['materials']) do
        --> Varaiable(s)
        local row = guiGridListAddRow(craftList);
        local weapon_name = string.gsub(v[1], "Matériaux ", "");
        weps_id[k] = v[3];

        --> Add data
        guiGridListSetItemText(craftList, row, 1, k, false, false);
        guiGridListSetItemText(craftList, row, 2, weapon_name, false, false);
        guiGridListSetItemText(craftList, row, 3, v[1], false, false);

        --> Player's materials part
        local mats_amount = items[v[3]] and items[v[3]][2] or 0;
        if mats_amount > 0 then
            guiGridListSetItemText(craftList, row, 4, 'Besoin de ' .. v[6] .. ' matériaux (Actuellement: ' .. mats_amount .. ')', false, false);
        else
            guiGridListSetItemText(craftList, row, 4, 'Besoin de ' .. v[6] .. ' matériaux', false, false);
        end;
    end;    

    --> Event(s)
     --> Close button
    addEventHandler("onClientGUIClick", closeButton, function()
        if SL.BMScript.GUI.Crafting['main'] then guiSetVisible(SL.BMScript.GUI.Crafting['main'], false); end;
        guiSetVisible(SL.BMScript.GUI.Crafting['main'], false);
        showCursor(false);
    end, false);

     --> Craft button
    addEventHandler("onClientGUIClick", craftButton, function()
        --> Check
        local row, col = guiGridListGetSelectedItem(craftList);
        if row == -1 or col == -1 then return outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Vous devez sélectionner un item.", 255, 0, 0, true); end;
    
        --> Variable(s)
        local weapon_num = tonumber(guiGridListGetItemText(craftList, row, 1));
        local mat_id = weps_id[tonumber(guiGridListGetItemText(craftList, row, 1))];
        local weapon_name = guiGridListGetItemText(craftList, row, 2);
        local weapon_material = guiGridListGetItemText(craftList, row, 3);
        local weapon_cost = SL.BMScript.Config['weapons']['materials'][tonumber(guiGridListGetItemText(craftList, row, 1))][6];
        local mats_amount = items[tonumber(mat_id)] and items[tonumber(mat_id)][2] or 0;
        local table = {};

        --> Check
        if mats_amount < weapon_cost then return outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Vous n'avez pas assez de matériaux pour construire cette arme.", 255, 0, 0, true); end;

        --> Set table data
        --table.weapon_num, table.mat_id, table.weapon_name, table.weapon_material, table.weapon_cost, table.mats_amount = weapon_num, mat_id, weapon_name, weapon_material, weapon_cost, mats_amount;
        table.weapon_num, table.mat_id, table.weapon_cost, table.mats_amount, table.weapon_id = weapon_num, mat_id, weapon_cost, mats_amount, SL.BMScript.Config['weapons']['materials'][tonumber(weapon_num)][7];

        --> Event(s)
        triggerServerEvent("onPlayerCraftWeapon", localPlayer, table);

        --> Destroy
        if isElement(SL.BMScript.GUI.Crafting['main']) then destroyElement(SL.BMScript.GUI.Crafting['main']); end;
    end, false);
end;


--@ Method: openBlackmarketCraftingProgressGUI
--@ Description: Open the crafting progress GUI
--@ Returns: nil
function openBlackmarketCraftingProgressGUI()
    --> Check: if the GUI is already open
    if isElement(SL.BMScript.GUI.Crafting['progress']) then destroyElement(SL.BMScript.GUI.Crafting['progress']); end;

    --> Variable(s)
    local craft_time = math.random(20000, 25000);

    --> GUI
    SL.BMScript.GUI.Crafting['progress'] = exports.dgs:dgsCreateProgressBar(0.398, 0.5, 0.2, 0.05, true);

    --> Progress bar settings
    exports.dgs:dgsProgressBarSetMode(SL.BMScript.GUI.Crafting['progress'], "normal");
    exports.dgs:dgsProgressBarSetProgress(SL.BMScript.GUI.Crafting['progress'], 0);

    --> Event(s)
    addEventHandler('onClientPreRender', root, function()
        --> Check: if the GUI is already open
        if not isElement(SL.BMScript.GUI.Crafting['progress']) then return removeEventHandler('onClientPreRender', root, function() end); end;

        --> Variable(s)
        local progress = exports.dgs:dgsProgressBarGetProgress(SL.BMScript.GUI.Crafting['progress']);

        --> Check: if the progress is done
        if progress >= 100 then
            --> Destroy
            if isElement(SL.BMScript.GUI.Crafting['progress']) then destroyElement(SL.BMScript.GUI.Crafting['progress']); end;

            --> Event(s)
            triggerServerEvent("onPlayerFinishCraftWeapon", localPlayer);

            --> Return
            return removeEventHandler('onClientPreRender', root, function() end);
        end;

        --> Set progress
        exports.dgs:dgsProgressBarSetProgress(SL.BMScript.GUI.Crafting['progress'], progress + 1000 / craft_time);
    end);
end; 