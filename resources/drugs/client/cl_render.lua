--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		Drug System
    Date:		29/06/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.DrugScript = SL.DrugScript or {};
SL.DrugScript.Config = SL.DrugScript.Config or {};


--[[----------------------------------------
    --> Render(s) function(s)
--]]----------------------------------------
--@ Function: renderObjects
--@ Description: Render the blender, etc.
--@ Return: void
function renderObjects()
    renderBlender();
    renderReactor();
    renderPump();
end; 

--@ Function: renderBlender
--@ Description: Render the blender infos
--@ Return: void
function renderBlender()
    --> Variable(s)
    local player = localPlayer;
    local max_distance = 5;
    local x, y, z = getElementPosition(player);
    local camX, camY, camZ = getCameraMatrix();

    --> Loop: Blender
    for _, blender in ipairs(getElementsWithinRange(x, y, z, max_distance, 'object')) do
        --> Check
        if not isElement(blender) then return; end;

        --> Check: Blender ID
        if getElementData(blender, 'itemID') == 380 then
            --> Variable(s)
            x, y, z = getElementPosition(blender);
            local sx, sy = getScreenFromWorldPosition(x, y, z);
            local p_int, p_dim = getElementInterior(blender), getElementDimension(blender);
            local i_int, i_dim = getElementInterior(player), getElementDimension(player);

            --> Check: Player in the same interior and dimension
            --if p_int ~= i_int or p_dim ~= i_dim then return; end;

            --> Render
            if (sx and sy) and isElementOnScreen(blender) then
                --> Variable(s)
                local blend_in_use = getElementData(blender, 'drugs:blender:in_use');
                local blend_table = getElementData(blender, 'drugs:blender:table');
                --local blend_alt_table = blend_table['infos'].alt_tbl;
                local blend_recipe = getElementData(blender, 'drugs:blender:recipe');
                local blend_time = getElementData(blender, 'drugs:blender:time');
                local blend_ready = getElementData(blender, 'drugs:blender:ready');

                --> Render: Show the blender
                dxDrawText('Mixeur', sx, sy * 0.7, sx, sy, tocolor(255, 255, 255, 255), 1, 'default-bold', 'center', 'center');
                
                --> Check: Blender in use
                if blend_in_use then
                    --> Variable(s)
                    local formulas = getRecipeFormula(blend_table['infos'].alt_tbl);

                    --> Render: Blender infos
                    dxDrawText('(' .. formulas[1] .. ' + ' .. formulas[2] .. ' + ' .. formulas[3] .. ')', sx, sy * 0.75, sx, sy, tocolor(200, 200, 200, 255), 1, 'default-bold', 'center', 'center');
                    dxDrawText('[ ' .. blend_time .. ' minute(s) ]', sx, sy * 0.8, sx, sy, tocolor(0, 255, 0, 255), 1, 'default-bold', 'center', 'center');
                end;

                --> Check: Blender ready
                if blend_ready then
                    --> Render: Blender ready
                    dxDrawText('[ MÉLANGE TERMINÉ ]', sx, sy * 0.75, sx, sy, tocolor(200, 200, 200, 255), 1, 'default-bold', 'center', 'center');
                end;
            end;
        end;
    end;
end;

--@ Function: renderReactor
--@ Description: Render the reactor infos
--@ Return: void
function renderReactor()
    --> Variable(s)
    local player = localPlayer;
    local max_distance = 5;
    local x, y, z = getElementPosition(player);
    local camX, camY, camZ = getCameraMatrix();

    --> Loop: Reactor
    for _, reactor in ipairs(getElementsWithinRange(x, y, z, max_distance, 'object')) do
        --> Check
        if not isElement(reactor) then return; end;

        --> Check: Reactor ID
        if getElementData(reactor, 'itemID') == 378 then
            --> Variable(s)
            x, y, z = getElementPosition(reactor);
            local sx, sy = getScreenFromWorldPosition(x, y, z);
            local p_int, p_dim = getElementInterior(reactor), getElementDimension(reactor);
            local i_int, i_dim = getElementInterior(player), getElementDimension(player);

            --> Check: Player in the same interior and dimension
            --if p_int ~= i_int or p_dim ~= i_dim then return; end;

            --> Render
            if (sx and sy) and isElementOnScreen(reactor) then
                --> Variable(s)
                local reactor_blend_mix = getElementData(reactor, 'drugs:reactor:have_blend_mix');
                local reactor_blender_element = getElementData(reactor, 'drugs:reactor:blender_element');

                --> Render: Show the Reactor
                dxDrawText('Laboratoire', sx, sy * 0.7, sx, sy, tocolor(255, 255, 255, 255), 1, 'default-bold', 'center', 'center');

                --> Check: Reactor have blend mix
                if reactor_blend_mix then
                    --> Render: Reactor infos
                    if not getElementData(reactor, 'drugs:reactor:is_finished') then
                        dxDrawText('[ MÉLANGE PRÉSENT ]', sx, sy * 0.75, sx, sy, tocolor(0, 255, 0, 255), 1, 'default-bold', 'center', 'center');
                    end;
                    
                    --> Check: If reactor is configured
                    if not getElementData(reactor, 'drugs:reactor:in_use') then
                        dxDrawText('[ EN ATTENTE DE CONFIGURATION ]', sx, sy * 0.8, sx, sy, tocolor(200, 200, 200, 255), 1, 'default-bold', 'center', 'center');
                    elseif getElementData(reactor, 'drugs:reactor:is_cooking') then
                        dxDrawText('[ EN COURS DE CUISSON ]', sx, sy * 0.8, sx, sy, tocolor(200, 200, 200, 255), 1, 'default-bold', 'center', 'center');
                    elseif getElementData(reactor, 'drugs:reactor:is_finished') then
                        --> Variable(s)
                        local table = getElementData(reactor, 'drugs:reactor:table');
                        local purity = getElementData(reactor, 'drugs:reactor:purity');
                        --local purity = getRecipePurity(alt_table);

                        --> Check: Recipe 
                        if purity > 15 then --> If purity is > 15% then show the recipe name (cuz only good recipe can be > 15%)
                            dxDrawText(getElementData(reactor, 'drugs:reactor:drug_name') .. ' (Pureté: ' .. purity .. '%)', sx, sy * 0.75, sx, sy, tocolor(255, 255, 0, 255), 1, 'default-bold', 'center', 'center');
                        else
                            dxDrawText('Drogue inconnue' .. ' (Pureté: ' .. purity .. '%)', sx, sy * 0.75, sx, sy, tocolor(255, 255, 0, 255), 1, 'default-bold', 'center', 'center');
                        end;
                    else
                        --> Variable(s)
                        local temp = getElementData(reactor, 'drugs:reactor:temperature') or 0;

                        --> Render: Reactor infos
                        dxDrawText('[ +' .. temp .. '°C ]', sx, sy * 0.8, sx, sy, tocolor(255, 255, 0, 255), 1, 'default-bold', 'center', 'center'); 
                    end;
                else
                    --> Render: Reactor infos
                    dxDrawText('[ AUCUN MÉLANGE ]', sx, sy * 0.75, sx, sy, tocolor(200, 200, 200, 255), 1, 'default-bold', 'center', 'center');
                end;
            end;
        end;
    end;
end; 

--@ Function: renderPump
--@ Description: Render the pump infos
--@ Return: void
function renderPump()
    --> Variable(s)
    local player = localPlayer;
    local max_distance = 5;
    local x, y, z = getElementPosition(player);
    local camX, camY, camZ = getCameraMatrix();

    --> Loop: Pump
    for _, pump in ipairs(getElementsWithinRange(x, y, z, max_distance, 'object')) do
        --> Check
        if not isElement(pump) then return; end;

        --> Check: pump ID
        if getElementData(pump, 'itemID') == 379 then
            --> Variable(s)
            x, y, z = getElementPosition(pump);
            local sx, sy = getScreenFromWorldPosition(x, y, z);
            local p_int, p_dim = getElementInterior(pump), getElementDimension(pump);
            local i_int, i_dim = getElementInterior(player), getElementDimension(player);

            --> Check: Player in the same interior and dimension
            --if p_int ~= i_int or p_dim ~= i_dim then return; end;

            --> Render
            if (sx and sy) and isElementOnScreen(pump) then
                --> Variable(s)

                --> Render: Show the pump
                dxDrawText('Pompe', sx, sy * 0.7, sx, sy, tocolor(255, 255, 255, 255), 1, 'default-bold', 'center', 'center');
            
                --> Check: Pump in use
                if getElementData(pump, 'drugs:pump:attached') then
                    dxDrawText('[ RACCORDÉE ]', sx, sy * 0.75, sx, sy, tocolor(0, 255, 0, 255), 1, 'default-bold', 'center', 'center');
                else
                    dxDrawText('[ NON RACCORDÉE ]', sx, sy * 0.75, sx, sy, tocolor(220, 220, 220, 255), 1, 'default-bold', 'center', 'center');
                end;
            end;
        end;
    end;
end;