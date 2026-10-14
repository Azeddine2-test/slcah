--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		Drug System
    Date:		07/07/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.DrugScript = SL.DrugScript or {};
SL.DrugScript.Config = SL.DrugScript.Config or {};
SL.DrugScript.Players = SL.DrugScript.Players or {};


--[[----------------------------------------
    --> Function(s)
--]]----------------------------------------
--@ Function: takeDrug
--@ Description: Take the drug
--@ Return(s): void
function takeDrug(drug, time)
    --> Check: Drug and time
    if (not drug or not time) then return; end;
    if not type(drug) == 'string' or not type(time) == 'number' then return; end;

    --> Variable(s)
    local player = getLocalPlayer();

    --> Condition(s)
    if drug == 'drugs:cocaine' then
        --> Check: If the player is already under the effect of cocaine
        if getElementData(getLocalPlayer(), 'drugs:player:cocaine') then return; end;

        --> Set: Shake camera
        setCameraShakeLevel(200);

        --> Timer: Reset camera shake
        setTimer(function()
            --> Reset: Shake camera
            setCameraShakeLevel(0);

            --> Trigger: Server event (reset effect)
            triggerServerEvent("onPlayerResetDrug", player, 'drugs:cocaine', player);
        end, time, 1);
    elseif drug == 'drugs:heroin' then
        --> Check: If the player is already under the effect of heroin
        if getElementData(getLocalPlayer(), 'drugs:player:heroin') then return; end;

        --> Variable(s)
        local r1, g1, b1, r2, g2, b2 = getSkyGradient();

        --> Set: Sky gradient effect
        setSkyGradient(255, 165, 0, 255, 165, 0);

        --> Timer: Reset sky gradient effect
        setTimer(function()
            --> Reset: Sky gradient effect
            setSkyGradient(r1, g1, b1, r2, g2, b2);

            --> Trigger: Server event (reset effect)
            triggerServerEvent("onPlayerResetDrug", player, 'drugs:heroin', player);
        end, time, 1);
    elseif drug == 'drugs:mdma' then
        --> Check: If the player is already under the effect of mdma
        if getElementData(getLocalPlayer(), 'drugs:player:mdma') then return; end;

        --> Variable(s)
        local w, h = guiGetScreenSize();
        local blur_strength = 6;
        local scr_source = dxCreateScreenSource(w, h);
        blur_shader, blur_tec = dxCreateShader("textures/drunk_effect.fx");

        --> Event: onClientPreRender
        addEventHandler("onClientPreRender", getRootElement(), function()
            if blur_shader then
                --> Set: Screen source
                dxUpdateScreenSource(scr_source);

                --> Set: Shader value
                dxSetShaderValue(blur_shader, "ScreenSource", scr_source);
                dxSetShaderValue(blur_shader, "BlurStrength", blur_strength);
                dxSetShaderValue(blur_shader, "UVSize", w, h);

                --> Set: Shader
                dxDrawImage(0, 0, w, h, blur_shader);
            end;
        end);

        --> Timer: Reset screen source
        setTimer(function()
            --> Reset: Screen source
            removeEventHandler("onClientPreRender", getRootElement(), function()
                if blur_shader then
                    --> Reset: Shader
                    destroyElement(blur_shader);
                    blur_shader = nil;
                end;
            end);

            --> Remove: Shader
            if blur_shader then 
                destroyElement(blur_shader); 
                blur_shader = nil;
            end;

            --> Trigger: Server event (reset effect)
            triggerServerEvent("onPlayerResetDrug", player, 'drugs:mdma', player);
        end, time, 1);
    end;
end;

--@ Function: playerDamage
--@ Description: Handle the player damage event
--@ Return(s): void
function playerDamage(attacker, weapon, bodypart, loss)
    --> Check: Attacker, weapon, bodypart and loss
    if (not attacker or not weapon or not bodypart or not loss) then return; end;
    if not type(attacker) == 'userdata' or not type(weapon) == 'number' or not type(bodypart) == 'number' or not type(loss) == 'number' then return; end;

    --> Variable(s)
    local player = getLocalPlayer();

    --> Check: LocalPlayer
    if getElementType(player) == 'player' and getElementData(player, 'drugs:player:mdma') then
        --> Variable(s)
        local reduced_loss = loss * 0.65;

        --> Set: Reduced loss
        setElementHealth(player, getElementHealth(player) + reduced_loss);
    end;
end;