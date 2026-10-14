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
SL.DrugScript.Config = SL.DrugScript.Config or {};


--[[----------------------------------------
    --> Event(s)
--]]----------------------------------------
--@ Event: onClientOpenMixMenu
--@ Description: Open the mix menu
addEvent("onClientOpenMixMenu", true);
addEventHandler("onClientOpenMixMenu", getLocalPlayer(), openMixMenu);

--@ Event: onClientRender
--@ Description: Render the blender, etc.
addEventHandler('onClientRender', getRootElement(), renderObjects);

--@ Event: onClientOpenReactorConfig
--@ Description: Open the reactor config
addEvent("onClientOpenReactorConfig", true);
addEventHandler("onClientOpenReactorConfig", getLocalPlayer(), openReactorConfig);

--@ Event: onClientTakeDrug
--@ Description: Take the drug
addEvent("onClientTakeDrug", true);
addEventHandler("onClientTakeDrug", getLocalPlayer(), takeDrug);

--@ Event: onClientPlayerDamage
--@ Description: Handle the player damage event
addEventHandler("onClientPlayerDamage", getLocalPlayer(), playerDamage);