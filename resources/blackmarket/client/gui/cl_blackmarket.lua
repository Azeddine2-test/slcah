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
SL.BMScript.GUI.BlackMarket = SL.BMScript.GUI.BlackMarket or {};
SL.BMScript.Config = SL.BMScript.Config or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: openBlackMarketGUI
--@ Description: Open the blackmarket GUI
--@ Return: void
function openBlackMarketGUI(factionID, slots, element)
    --> Check
    if SL.BMScript.GUI.BlackMarket['main'] then if guiGetVisible(SL.BMScript.GUI.BlackMarket['main']) then guiSetVisible(SL.BMScript.GUI.BlackMarket['main'], false); return; end; end;

    --> Variable(s)
    local x, y = 0.350, 0.350;
    local w, h = 0.3, 0.3;

    --> GUI
     --> Main window
    SL.BMScript.GUI.BlackMarket['main'] = guiCreateWindow(x, y, w, h, "Marché noir", true);
    guiWindowSetSizable(SL.BMScript.GUI.BlackMarket['main'], false);

    --> Tabs 
    local tabPanel = guiCreateTabPanel(0, 0.1, 1, 0.65, true, SL.BMScript.GUI.BlackMarket['main']);
    local materialTab = guiCreateTab("Armes", tabPanel);
    local ammoTab = guiCreateTab("Munitions", tabPanel);
    --local drugTab = guiCreateTab("Drogues", tabPanel);
    local otherTab = guiCreateTab("Divers", tabPanel);
    local weapons_item_val, displayed_ammos, used_weapons = {}, {}, {};
    local buyFrameOpened = false;

    ----------------------
    --> Materials list <--
    ----------------------
    local materialList = guiCreateGridList(0.02, 0.065, 0.965, 0.865, true, materialTab);
    guiGridListAddColumn(materialList, "Nom", 0.3);
    guiGridListAddColumn(materialList, "Stock", 0.3);
    guiGridListAddColumn(materialList, "Prix", 0.3);

     --> Show every available Materials (name, stock, price)
    for k, v in pairs(slots) do
        --> Check
        if v.itemType == 'material' then
            weapons_item_val[SL.BMScript.Config['weapons']['materials'][tonumber(v.slot)][7]] = true;
            
            local row = guiGridListAddRow(materialList);
            guiGridListSetItemText(materialList, row, 1, SL.BMScript.Config['weapons']['materials'][tonumber(v.slot)][1], false, false);
            guiGridListSetItemText(materialList, row, 2, v.amountLeft, false, false);
            guiGridListSetItemText(materialList, row, 3, SL.BMScript.Config['weapons']['materials'][tonumber(v.slot)][2] .. '$', false, false);
        end;
    end;

    -----------------
    --> Ammo list <--
    -----------------
    local ammoList = guiCreateGridList(0.02, 0.065, 0.965, 0.865, true, ammoTab);
    guiGridListAddColumn(ammoList, "Nom", 0.3);
    guiGridListAddColumn(ammoList, "Stock", 0.3);
    guiGridListAddColumn(ammoList, "Prix", 0.3);

    -- Show every available Ammo (name, stock, price)
    for k, v in pairs(slots) do
        if v.itemType == 'ammo' then
            --> Variable(s)
            local row = guiGridListAddRow(ammoList);

            --> Set: Ammo name, stock and price
            guiGridListSetItemText(ammoList, row, 1, SL.BMScript.Config['weapons']['ammos'][tonumber(v.slot)][1], false, false);
            guiGridListSetItemText(ammoList, row, 2, v.amountLeft, false, false);
            guiGridListSetItemText(ammoList, row, 3, SL.BMScript.Config['weapons']['ammos'][tonumber(v.slot)][2] .. '$', false, false);

            --> Add: Used weapons
            for _, weapon in pairs(SL.BMScript.Config['weapons']['ammos'][tonumber(v.slot)][5]) do
                if weapons_item_val[weapon] then
                    used_weapons[v.slot] = weapon;
                    break;
                end;
            end;
        end;
    end;

    --> Button(s) (close and buy)
    local closeButton = guiCreateButton(0.01, 0.8, 0.45, 0.15, "Fermer", true, SL.BMScript.GUI.BlackMarket['main']);
    local buyButton = guiCreateButton(0.550, 0.8, 0.45, 0.15, "Choisir", true, SL.BMScript.GUI.BlackMarket['main']);

    ------------------
    --> Other list <--
    ------------------
    local otherList = guiCreateGridList(0.02, 0.065, 0.965, 0.865, true, otherTab);
    guiGridListAddColumn(otherList, "Nom", 0.3);
    guiGridListAddColumn(otherList, "Stock", 0.3);
    guiGridListAddColumn(otherList, "Prix", 0.3);

     --> Show every available Others (name, stock, price)
    for k, v in pairs(slots) do
        if v.itemType == 'other' then
            --> Variable(s)
            local real_slot = v.slot;
            local row = guiGridListAddRow(otherList);

            --> Set: Item name, stock and price
            guiGridListSetItemText(otherList, row, 1, SL.BMScript.Config['weapons']['others'][tonumber(real_slot)][1], false, false);
            guiGridListSetItemText(otherList, row, 2, v.amountLeft, false, false);
            guiGridListSetItemText(otherList, row, 3, SL.BMScript.Config['weapons']['others'][tonumber(real_slot)][2] .. '$', false, false);
        end;
    end;

    --> Event(s)
     --> Close button
    addEventHandler("onClientGUIClick", closeButton, function()
        if SL.BMScript.GUI.BlackMarket['howMuch'] then guiSetVisible(SL.BMScript.GUI.BlackMarket['howMuch'], false); end;
        guiSetVisible(SL.BMScript.GUI.BlackMarket['main'], false);
        showCursor(false);
    end, false);

     --> Buy button
    addEventHandler("onClientGUIClick", buyButton, function()
        --> Check
        if buyFrameOpened then if SL.BMScript.GUI.BlackMarket['howMuch'] then guiSetVisible(SL.BMScript.GUI.BlackMarket['howMuch'], false); end; buyFrameOpened = false; return; end;

        --> Variable(s)
        local row, col = nil, nil;
        local itemType = nil;
        if guiGetSelectedTab(tabPanel) == materialTab then row, col = guiGridListGetSelectedItem(materialList); itemType = 'material'; end;
        if guiGetSelectedTab(tabPanel) == ammoTab then row, col = guiGridListGetSelectedItem(ammoList); itemType = 'ammo'; end;
        if guiGetSelectedTab(tabPanel) == otherTab then row, col = guiGridListGetSelectedItem(otherList); itemType = 'other'; end;

        --> Check
        if row and col then
            --> Check if no item selected
            if row == -1 or col == -1 then outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Vous devez sélectionner un item.", 255, 0, 0, true); return; end;

            --> Variable(s)
            local selectedTab = guiGetSelectedTab(tabPanel)
            local itemName = guiGridListGetItemText((selectedTab == materialTab and materialList) or (selectedTab == ammoTab and ammoList) or otherList, row, 1)
            local itemPrice = guiGridListGetItemText((selectedTab == materialTab and materialList) or (selectedTab == ammoTab and ammoList) or otherList, row, 3)
            itemPrice = tonumber(itemPrice:sub(1, #itemPrice - 1));
            local itemStock = guiGridListGetItemText((selectedTab == materialTab and materialList) or (selectedTab == ammoTab and ammoList) or otherList, row, 2)

            --> Check if item is available
            if tonumber(itemStock) <= 0 then outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Cet item n'est plus disponible. Attendez la prochaine livraison.", 255, 0, 0, true); return; end;

            --> Check if player has enough money
            if exports.global:hasMoney(getLocalPlayer(), itemPrice) then 
                --> Get selected item slot
                local slot = nil;
                for k, v in pairs(slots) do
                    if v.itemType == itemType and tonumber(v.amountLeft) > 0 then
                        if guiGetSelectedTab(tabPanel) == materialTab then
                            if SL.BMScript.Config['weapons']['materials'][tonumber(v.slot)][1] == itemName then slot = v.slot; break; end;
                        end;
                        if guiGetSelectedTab(tabPanel) == ammoTab then
                            if SL.BMScript.Config['weapons']['ammos'][tonumber(v.slot)][1] == itemName then slot = v.slot; break; end;
                        end;
                        if guiGetSelectedTab(tabPanel) == otherTab then
                            --> Variable(s)
                            real_slot = v.slot;

                            --> Check
                            if SL.BMScript.Config['weapons']['others'][tonumber(real_slot)][1] == itemName then slot = v.slot; break; end;
                        end;
                    end;
                end;

                --> Variable(s)
                local items = {};
                buyFrameOpened = true;

                --> Condition(s)
                if itemType == 'ammo' then
                    local weapon_id = used_weapons[slot];
                    items = {itemName, itemPrice, itemStock, slot, itemType, weapon_id};
                else
                    items = {itemName, itemPrice, itemStock, slot, itemType};
                end;

                items.faction_id = tonumber(factionID);

                --> Create the "how much" window
                SL.BMScript.GUI.BlackMarket['howMuch'] = guiCreateWindow(x * 1.18, y * 1.18, w * 0.6, h * 0.45, "Marché noir", true);
                guiWindowSetSizable(SL.BMScript.GUI.BlackMarket['howMuch'], false);

                --> Label
                local label = guiCreateLabel(0.05, 0.15, 0.9, 0.15, "Combien d'unités voulez-vous acheter ?", true, SL.BMScript.GUI.BlackMarket['howMuch']);
                guiLabelSetHorizontalAlign(label, "center", true);

                --> Edit
                local edit = guiCreateEdit(0.05, 0.3, 0.9, 0.2, "1", true, SL.BMScript.GUI.BlackMarket['howMuch']);

                --> Button(s)
                local closeButton = guiCreateButton(0.05, 0.6, 0.425, 0.27, "Retour", true, SL.BMScript.GUI.BlackMarket['howMuch']);
                local buyButton = guiCreateButton(0.525, 0.6, 0.425, 0.27, "Acheter", true, SL.BMScript.GUI.BlackMarket['howMuch']);

                --> Event(s)
                 --> Close button
                addEventHandler("onClientGUIClick", closeButton, function()
                    guiSetVisible(SL.BMScript.GUI.BlackMarket['howMuch'], false);
                    showCursor(false);

                    buyFrameOpened = false;
                end, false);

                    --> Buy button
                addEventHandler("onClientGUIClick", buyButton, function()
                    --> Variable(s)
                    local amount = tonumber(guiGetText(edit));

                    --> Check
                    if amount and amount > 0 then
                        if exports.global:hasMoney(getLocalPlayer(), itemPrice * amount) then
                            if exports.global:hasSpaceForItem(getLocalPlayer(), itemName, amount) then
                                --> Close the "how much" window
                                guiSetVisible(SL.BMScript.GUI.BlackMarket['howMuch'], false);
                                showCursor(false);
                                buyFrameOpened = false;

                                --> Buy the item
                                triggerServerEvent("onPlayerBuyBlackmarketItem", getLocalPlayer(), items, amount);

                                --> Close the main window
                                guiSetVisible(SL.BMScript.GUI.BlackMarket['main'], false);
                                showCursor(false);
                            else
                                outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Vous n'avez pas assez de place dans votre inventaire pour acheter " .. amount .. " unité(s).", 255, 0, 0, true);
                                return;
                            end;
                        else
                            outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Vous n'avez pas assez d'argent pour acheter " .. amount .. " unité(s).", 255, 0, 0, true);
                            return;
                        end;
                    else
                        outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Vous devez entrer un nombre valide.", 255, 0, 0, true);
                        return;
                    end;
                end, false);
            else
                outputChatBox(SL.BMScript.Config['base'].PREFIX .. "Vous n'avez pas assez d'argent pour acheter cet item.", 255, 0, 0, true);
                return;
            end;
        end;
    end, false);

    --> Show cursor
    showCursor(true);
end;
