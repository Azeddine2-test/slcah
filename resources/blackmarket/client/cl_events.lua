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
SL.BMScript.Config = SL.BMScript.Config or {};
local BM = SL.BMScript;


--[[----------------------------------------
    --> Event(s)
--]]----------------------------------------
--@ Event: blackmarket:GUI:open
--@ Description: Open the blackmarket GUI
addEvent("blackmarket:GUI:open", true);
addEventHandler("blackmarket:GUI:open", getLocalPlayer(), openBlackMarketGUI);

--@ Event: blackmarket:GUI:slots:open
--@ Description: Open the blackmarket GUI
addEvent("blackmarket:GUI:slots:open", true);
addEventHandler("blackmarket:GUI:slots:open", getLocalPlayer(), openSlotChooseGUI);

--@ Event: blackmarket:GUI:admin:open
--@ Description: Open the blackmarket admin GUI
addEvent("blackmarket:GUI:admin:open", true);
addEventHandler("blackmarket:GUI:admin:open", getLocalPlayer(), openBlackmarketAdminGUI);

--@ Event: blackmarket:GUI:admin:crud:open
--@ Description: Open the blackmarket admin GUI
addEvent("blackmarket:GUI:admin:crud:open", true);
addEventHandler("blackmarket:GUI:admin:crud:open", getLocalPlayer(), openBlackmarketAdminCrudGUI);

--@ Event: blackmarket:GUI:crafting:open
--@ Description: Open the crafting GUI
addEvent("blackmarket:GUI:crafting:open", true);
addEventHandler("blackmarket:GUI:crafting:open", getLocalPlayer(), openBlackmarketCraftingGUI);

--@ Event: blackmarket:GUI:crafting:progress
--@ Description: Open the crafting GUI progress bar
addEvent("blackmarket:GUI:crafting:progress", true);
addEventHandler("blackmarket:GUI:crafting:progress", getLocalPlayer(), openBlackmarketCraftingProgressGUI);

--@ Event: onClientRender
--@ Purpose: Handle the render of the client
addEventHandler('onClientRender', getRootElement(), workbenchRender);