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
SL.DrugScript.GUI.Reactor = SL.DrugScript.GUI.Reactor or {};
SL.DrugScript.Data = SL.DrugScript.Data or {};
SL.DrugScript.Config = SL.DrugScript.Config or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: openReactorMenu
--@ Description: Open the reactor menu
--@ Return: void
function openReactorConfig(element)
    --> Check: Player & Element
    if not getLocalPlayer() or not element then return; end;
    if not isElement(element) then return; end; 

    --> Variable(s)
    local player = getLocalPlayer();
    local w, h = 0.25, 0.2;
    local x, y = (1 - w) * 0.5, (1 - h) * 0.5;
    local reactor_choosed_temp = getElementData(element, "drugs:reactor:choosed_temperature") or 0;

    --> Create: Window
    SL.DrugScript.GUI.Reactor['main'] = guiCreateWindow(x, y, w, h, "Réacteur - Configuration", true);
    guiWindowSetSizable(SL.DrugScript.GUI.Reactor['main'], false);

    --> Create: Label (Actuel temp, different modes, etc.)
    SL.DrugScript.GUI.Reactor['actual_temp'] = guiCreateLabel(0.05, 0.15, 0.9, 0.2, "Température choisie : " .. reactor_choosed_temp .. "°C", true, SL.DrugScript.GUI.Reactor['main']);
    SL.DrugScript.GUI.Reactor['modes'] = guiCreateLabel(0.05, 0.25, 0.9, 0.2, "Température élevée = Chauffe rapide, mais risque de brûlure.", true, SL.DrugScript.GUI.Reactor['main']);
    SL.DrugScript.GUI.Reactor['modes2'] = guiCreateLabel(0.05, 0.425, 0.9, 0.2, "Chosissez la température de chauffe du réacteur :", true, SL.DrugScript.GUI.Reactor['main']);

    --> Color: Label
    guiLabelSetColor(SL.DrugScript.GUI.Reactor['modes'], 231, 76, 60);

    --> Center: Labels
    guiLabelSetHorizontalAlign(SL.DrugScript.GUI.Reactor['actual_temp'], "center", false);
    guiLabelSetHorizontalAlign(SL.DrugScript.GUI.Reactor['modes'], "center", false);
    guiLabelSetHorizontalAlign(SL.DrugScript.GUI.Reactor['modes2'], "center", false);

    --> Create: Edit (Temp)
    SL.DrugScript.GUI.Reactor['temp'] = guiCreateEdit(0.05, 0.525, 0.9, 0.15, "", true, SL.DrugScript.GUI.Reactor['main']);

    --> Create: Button (Validate & Close)
    local validate_text = getElementData(element, "drugs:reactor:in_use") and "Modifier" or "Démarrer";
    SL.DrugScript.GUI.Reactor['validate'] = guiCreateButton(0.55, 0.725, 0.4, 0.2, validate_text, true, SL.DrugScript.GUI.Reactor['main']);
    SL.DrugScript.GUI.Reactor['close'] = guiCreateButton(0.05, 0.725, 0.4, 0.2, "Fermer", true, SL.DrugScript.GUI.Reactor['main']);

    --> Add: Event(s)
     --> Validate: GUI
    addEventHandler("onClientGUIClick", SL.DrugScript.GUI.Reactor['validate'], function() 
        --> Variable(s)
        local temp = guiGetText(SL.DrugScript.GUI.Reactor['temp']);
        
        --> Check: Temp
        if not temp then return outputChatBox(SL.DrugScript.Config['base'].PREFIX .. "Vous devez entrer une température.", 255, 0, 0); end;
        if not temp:match("^%d+$") then return outputChatBox(SL.DrugScript.Config['base'].PREFIX .. "Vous devez entrer une température valide.", 255, 0, 0); end;
        if tonumber(temp) < 0 then return outputChatBox(SL.DrugScript.Config['base'].PREFIX .. "Vous devez entrer une température supérieure à 0.", 255, 0, 0); end;
        if tonumber(temp) > 600 then return outputChatBox(SL.DrugScript.Config['base'].PREFIX .. "Vous devez entrer une température inférieure ou égale à 600.", 255, 0, 0); end;

        --> Trigger: Server Event & Destroy: GUI
        triggerServerEvent("onPlayerReactorConfig", player, element, tonumber(temp));
        destroyElement(SL.DrugScript.GUI.Reactor['main']);
    end, false);

     --> Close: GUI
    addEventHandler("onClientGUIClick", SL.DrugScript.GUI.Reactor['close'], function() 
        destroyElement(SL.DrugScript.GUI.Reactor['main']);
    end, false);
end;