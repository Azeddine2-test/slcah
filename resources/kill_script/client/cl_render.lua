--[[ 
    Team:  	    Southland
    Author:     Whiletruend
    Addon:		Kill Script
    Date:		31/08/2023
]]--


--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.KillScript = SL.KillScript or {};
local last_exec_time = 0;
local exec_interval = 1000;


--[[----------------------------------------
    --> Function(s)
--]]----------------------------------------
--@ Function: renderKillScript
--@ Description: Renders the kill script (injuries, etc.)
--@ Return(s): void
function renderKillScript()
    --> Variable(s)
    local curr_time = getTickCount();
 
    --> Loop: Through all players
    for _, player in pairs(getElementsByType('player')) do
        --> Check: If element is on the screen and not the local player
        if isElementOnScreen(player) then
            --> Variable(s)
            local camx, camy, camz = getCameraMatrix();
            local px, py, pz = getElementPosition(player);
            local distance = getDistanceBetweenPoints3D(camx, camy, camz, px, py, pz);
            local max_distance = SL.KillScript.Config['base']['3d'].max_distance;
            
            --> Condition(s)
            if distance <= max_distance and (isPlayerInjured(player) or isPedDead(player)) then
                --> Variable(s)
                local injury = getPlayerInjury(player) or 'heavy';
                local is_dead = isPedDead(player);
                local is_overdose = false; --exports['drugs_overdose']:isPlayerInOverdose(player) or false; -- isPlayerOverdose(player);
                local is_unconscious = false; --exports['drugs_overdose']:isPlayerUnconscious(player) or false; -- isPlayerUnconscious(player);
                local message, messages = '', SL.KillScript.Config['base']['messages'];
                local sx, sy = getScreenFromWorldPosition(px, py, pz);

                --> Check: Injury
                if ((isPlayerInjured(player) and not is_dead) and injury ~= 'dead') and (messages[injury] and messages[injury].thirdp_injured) then
                    message = messages[injury].thirdp_injured;
                elseif is_overdose then
                    message = '(( Est en overdose ))';
                elseif is_unconscious then
                    message = '(( Est inconscient ))';
                elseif is_dead then 
                    message = messages.thirdp_killed;
                else
                    if curr_time - last_exec_time >= exec_interval then
                        last_exec_time = curr_time;
                        triggerServerEvent('onClientKsRevive', player, player);
                    end;
                end;
                
                --> Check: Screen X and Y
                if (sx and sy) and player ~= getLocalPlayer() then dxDrawText(message, sx, sy, sx, sy, tocolor(238, 108, 99, 255), 1, 'default-bold', 'center', 'center'); end;
            end;
        end;
    end;
end;