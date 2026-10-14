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
SL.BMScript.Config = SL.BMScript.Config or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: getChoosedSlots
--@ Description: Get the choosed slots from the database
--@ Return: table
function SL.BMScript:getChoosedSlots(factionID)
    --> Trigger
    triggerServerEvent("onPlayerOpenSlots", getLocalPlayer(), factionID);
end;

--@ Method: workbenchRender
--@ Description: Render the workbench
--@ Return: void
function workbenchRender()
    --> Variable(s)
    local player = getLocalPlayer();
    local maxDistance = 5;
    local camX, camY, camZ = getCameraMatrix();
    local x, y, z = getElementPosition(player);

    --> Loop: Workbench
    for _, workbench in ipairs(getElementsWithinRange(x, y, z, maxDistance, 'object')) do
        --> Check
        if not isElement(workbench) then return; end;

        --> Variable(s)
        local o_int, o_dim = getElementInterior(workbench), getElementDimension(workbench);
        local p_int, p_dim = getElementInterior(player), getElementDimension(player);

        --> Check: Interior & Dimension
        if o_int ~= p_int or o_dim ~= p_dim then return; end;

        --> Check: Workbench ID
        if getElementData(workbench, 'itemID') == 366 then
            --> Variable(s)
            x, y, z = getElementPosition(workbench);
            local sx, sy = getScreenFromWorldPosition(x, y, z);

            --> Render
            if sx and sy then
                dxDrawText('Atelier', sx, sy * 0.5, sx, sy, tocolor(255, 255, 255, 255), 1, 'default-bold', 'center', 'center');
                dxDrawText("Faites clique droit pour ouvrir le menu", sx, sy * 0.55, sx, sy, tocolor(0, 255, 0, 255), 1, 'default-bold', 'center', 'center');
            end;
        end;
    end; 
end;