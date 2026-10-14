--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		Drug System
    Date:		24/06/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.DrugScript = SL.DrugScript or {};
SL.DrugScript.GUI = SL.DrugScript.GUI or {};
SL.DrugScript.GUI.Mixer = SL.DrugScript.GUI.Mixer or {};
SL.DrugScript.Data = SL.DrugScript.Data or {};
SL.DrugScript.Config = SL.DrugScript.Config or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: openMixMenu
--@ Description: Open the mix menu
--@ Return: void
function openMixMenu(components, table)
    --> Check: Player
    if not getLocalPlayer() then return; end;

    --> Check: Tables
    if not table then table = {}; end;
    if not alt_table then alt_table = {}; end;
    if #alt_table >= 3 then alt_table = {}; end;

    --> Count: Table amount
    local table_amount = 0;
    if table then for k, v in pairs(table) do table_amount = table_amount + 1; end; end;

    --> Variable(s)
    local player = getLocalPlayer();
    local w, h = 0.3, 0.3;
    local x, y = (1 - w) * 0.5, (1 - h) * 0.5;
    SL.DrugScript.GUI.Mixer['main'] = guiCreateWindow(x, y, w, h, 'Mixeur - ' .. 3 - table_amount .. ' composant(s) restant(s)', true);
    local mixTabPanel = guiCreateTabPanel(0, 0.1, 1, 0.685, true, SL.DrugScript.GUI.Mixer['main']);
    local mixTab = guiCreateTab('Liste des composants', mixTabPanel);
    local mixList = guiCreateGridList(0.02, 0.065, 0.965, 0.865, true, mixTab);
    local amountFrameOpened = false;
    local player_data = getElementData(player, 'drugs:current:components');

    --> GridList
    guiGridListAddColumn(mixList, "#", 0.1);
    guiGridListAddColumn(mixList, "Composant", 0.3);
    guiGridListAddColumn(mixList, "Formule", 0.25);
    guiGridListAddColumn(mixList, "Quantité", 0.1);
    guiGridListAddColumn(mixList, "Sélectionné", 0.15);

    --> GUI
    guiWindowSetSizable(SL.DrugScript.GUI.Mixer['main'], false);

    --> Button(s) (close and select)
    local closeButton = guiCreateButton(0.01, 0.82, 0.45, 0.15, "Fermer", true, SL.DrugScript.GUI.Mixer['main']);
    local selectButton = guiCreateButton(0.550, 0.82, 0.45, 0.15, "Sélectionner", true, SL.DrugScript.GUI.Mixer['main']);

    --> Show every available Others (name, stock, price)
    for i, v in pairs(components) do
        --> Check: If not Naxolone
        if i ~= 11 then
            --> Variable(s)
            local row = guiGridListAddRow(mixList);

            --> Add: Component to the list
            guiGridListSetItemText(mixList, row, 1, i, false, false);
            guiGridListSetItemText(mixList, row, 2, v[1], false, false);
            guiGridListSetItemText(mixList, row, 3, v[2], false, false);

            if player_data[v[5]] then 
                --> Variable(s)
                --local id, amount, weight = player_data[i][1], player_data[i][2], exports['item-system']:getItemWeight(player_data[v[5]][1], 1, nil);
                local curr_comp = player_data[v[5]];
                local id, amount, weight = curr_comp[1], curr_comp[2], exports['item-system']:getItemsWeight(player, curr_comp[1], 1, nil);

                --> GUI: Show the grams
                guiGridListSetItemText(mixList, row, 4, tostring(weight) .. 'g', false, false);
            else
                guiGridListSetItemText(mixList, row, 4, '0.0g', false, false);
            end;

            --> Check: Table
            if table_amount > 0 and table[i] then
                guiGridListSetItemText(mixList, row, 5, table[i][4], false, false);
            else
                guiGridListSetItemText(mixList, row, 5, '', false, false);
            end;
        end;
    end

    --> Event(s)
     --> Close button
    addEventHandler("onClientGUIClick", closeButton, function()
        --> Destroy: GUI
        guiSetVisible(SL.DrugScript.GUI.Mixer['main'], false);
        showCursor(false);

        --> Trigger: Server event
        triggerServerEvent('onPlayerQuitMixGUI', player);
    end, false);

     --> Select button
    addEventHandler('onClientGUIClick', selectButton, function()
        --> Variable(s)
        local row, col = guiGridListGetSelectedItem(mixList);

        --> Check: Row and Col (if not selected)
        if row == -1 or col == -1 then return; end;

        --> Check: If the amount frame is already opened
        if amountFrameOpened then return; end;

        --> Condition(s)
        if row and col then
            --> Variable(s)
            local num = tonumber(guiGridListGetItemText(mixList, row, 1));
            local component = guiGridListGetItemText(mixList, row, 2);
            local formula = guiGridListGetItemText(mixList, row, 3);
            local quantity = guiGridListGetItemText(mixList, row, 4);
            local real_quantity = tonumber(string.sub(quantity, 1, -2));
            local item_id = components[num][5];
            local select_txt, table_amount = '', 0;

            --> Check: If already selected
            if table[num] then return outputChatBox(SL.DrugScript.Config['base']['PREFIX'] .. "Vous avez déjà sélectionné ce composant.", 255, 0, 0); end;

            --> Check: Quantity (if not enough)
            if real_quantity <= 0 then return outputChatBox(SL.DrugScript.Config['base']['PREFIX'] .. "Vous n'avez pas assez de " .. component .. ".", 255, 0, 0); end;

            --> GUI: Ask for quantity (gram)
            SL.DrugScript.GUI.Mixer['howMuch'] = guiCreateWindow(x * 1.18, y * 1.18, w * 0.6, h * 0.45, "Mixeur - Choix du poids", true);
            guiWindowSetSizable(SL.DrugScript.GUI.Mixer['howMuch'], false);
            amountFrameOpened = true;

            --> Label
            local label = guiCreateLabel(0.05, 0.15, 0.9, 0.15, "Combien de grammes souhaitez-vous utiliser ?", true, SL.DrugScript.GUI.Mixer['howMuch']);
            guiLabelSetHorizontalAlign(label, "center", true);

            --> Edit
            local edit = guiCreateEdit(0.05, 0.3, 0.9, 0.2, '0', true, SL.DrugScript.GUI.Mixer['howMuch']);

            --> Button(s)
            local closeButton = guiCreateButton(0.05, 0.6, 0.425, 0.27, "Retour", true, SL.DrugScript.GUI.Mixer['howMuch']);
            local addButton = guiCreateButton(0.525, 0.6, 0.425, 0.27, "Ajouter", true, SL.DrugScript.GUI.Mixer['howMuch']);

            --> Event(s)
             --> Close button
            addEventHandler("onClientGUIClick", closeButton, function()
                guiSetVisible(SL.DrugScript.GUI.Mixer['howMuch'], false);
                amountFrameOpened = false;

                --> Trigger: Server event
                triggerServerEvent('onPlayerQuitMixGUI', player);
            end, false);

             --> Buy button
            addEventHandler('onClientGUIClick', addButton, function()
                --> Variable(s)
                local input = tonumber(guiGetText(edit));

                --> Check: Quantity 
                if input <= 0 then return outputChatBox(SL.DrugScript.Config['base']['PREFIX'] .. "Vous devez entrer un nombre supérieur à 0.", 255, 0, 0); end;
                if input > real_quantity then return outputChatBox(SL.DrugScript.Config['base']['PREFIX'] .. "Vous n'avez pas assez de " .. component .. ".", 255, 0, 0); end;

                --> Check: Decimals (only 1 decimal: 0.1, 0.2, 0.3, etc.)
                --[[ if not input ~= math.floor(input) and tostring(input):match("^%d+%.%d$") == nil then
                    return outputChatBox(SL.DrugScript.Config['base']['PREFIX'] .. "Vous devez entrer un nombre entier ou une décimale avec un seul chiffre après la virgule.", 255, 0, 0);
                end; ]]

                --> Count: Table amount
                for k, v in pairs(table) do table_amount = table_amount + 1; end;

                --> Check: Table
                if table_amount <= 0 then select_txt = 'Principal'; else select_txt = '×'; end;

                --> Add: Component num to table and restart the menu
                table[num] = {component, formula, tonumber(guiGetText(edit)), select_txt, num, item_id};
                alt_table[#alt_table + 1] = {num, tonumber(guiGetText(edit))};

                --> Output: Chatbox
                outputChatBox(SL.DrugScript.Config['base']['PREFIX'] .. "Vous avez ajouté " .. tostring(input) .. "g de " .. component .. " (" .. formula .. ").", 0, 255, 0);
                --outputChatBox(SL.DrugScript.Config['base']['PREFIX'] .. "Vous avez ajouté le composant: " .. component .. " (" .. formula .. ").", 0, 255, 0);

                --> Check: Table (if 3 components)
                if table_amount >= 2 then 
                    --> Output: Chatbox
                    outputChatBox("\n" .. SL.DrugScript.Config['base']['PREFIX'] .. "Vous avez choisi vos 3 composants, vous pouvez commencer à mélanger.", 0, 255, 0); 
                    destroyElement(SL.DrugScript.GUI.Mixer['main']); 
                    destroyElement(SL.DrugScript.GUI.Mixer['howMuch']);

                    --> GUI: Open the composition list
                    SL.DrugScript.GUI.Mixer['components_list'] = guiCreateWindow(x * 1.18, y * 1.18, w * 0.7, h * 0.7, "Mixeur - Votre composition", true);
                    guiWindowSetSizable(SL.DrugScript.GUI.Mixer['components_list'], false);

                    --> Button(s)
                    local closeButton = guiCreateButton(0, 0.75, 0.45, 0.3, "Fermer", true, SL.DrugScript.GUI.Mixer['components_list']);
                    local mixButton = guiCreateButton(0.55, 0.75, 0.45, 0.3, "Mélanger", true, SL.DrugScript.GUI.Mixer['components_list']);
                    
                    --> Close button
                    addEventHandler("onClientGUIClick", closeButton, function()
                        guiSetVisible(SL.DrugScript.GUI.Mixer['components_list'], false);
                        showCursor(false);

                        --> Trigger: Server event
                        triggerServerEvent('onPlayerQuitMixGUI', player);
                    end, false);

                    --> Gridlist
                    local mixList = guiCreateGridList(0, 0.125, 0.95, 0.4, true, SL.DrugScript.GUI.Mixer['components_list']);
                    guiGridListAddColumn(mixList, "Composant", 0.45);
                    guiGridListAddColumn(mixList, "Formule", 0.3);
                    guiGridListAddColumn(mixList, "Quantité", 0.2);

                    --> Loop: Table (to add the components)
                    for k, v in pairs(table) do
                        --> Variable(s)
                        local row = guiGridListAddRow(mixList);

                        --> Add: Component
                        guiGridListSetItemText(mixList, row, 1, v[1], false, false);

                        --> Add: Formula
                        guiGridListSetItemText(mixList, row, 2, v[2], false, false);

                        --> Add: Quantity
                        guiGridListSetItemText(mixList, row, 3, v[3] .. "g", false, false);
                    end;

                    --> GUI: Show desired temperature & approx final weight (labels)
                     --> Variable(s)
                    local desired_temp = getDesiredTemp(alt_table);
                    local approx_weight = getApproxWeight(alt_table);

                     --> Label(s)
                    local temp_label = guiCreateLabel(0.05, 0.55, 0.9, 0.1, "Température idéale: " .. tostring(desired_temp) .. "°C (pour réacteur)", true, SL.DrugScript.GUI.Mixer['components_list']);
                    local weight_label = guiCreateLabel(0.05, 0.625, 0.9, 0.1, "Poids approximatif: ≈" .. tostring(approx_weight) .. "g", true, SL.DrugScript.GUI.Mixer['components_list']);
                    guiLabelSetHorizontalAlign(temp_label, "center", true);
                    guiLabelSetHorizontalAlign(weight_label, "center", true);

                    --> Event(s)
                     --> Mix button
                    addEventHandler("onClientGUIClick", mixButton, function()
                        --> Modify: Table (add temp & weight)
                        table['infos'] = {desired_temp, approx_weight, alt_tbl = alt_table};

                        --> Destroy: GUI
                        guiSetVisible(SL.DrugScript.GUI.Mixer['components_list'], false);
                        showCursor(false);

                        --> Trigger: Server event
                        triggerServerEvent('onPlayerStartDrugMix', player, table); 

                        --> Trigger: Server event
                        triggerServerEvent('onPlayerQuitMixGUI', player);
                    end, false);

                    return; 
                end;
                
                --> Restart: Menu
                destroyElement(SL.DrugScript.GUI.Mixer['main']);
                destroyElement(SL.DrugScript.GUI.Mixer['howMuch']); 
                openMixMenu(components, table);
            end, false); 
        end;
    end, false);
end;