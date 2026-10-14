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


--[[----------------------------------------
    --> Function(s)
--]]----------------------------------------
--@ Function: playerDamage
--@ Description: Handles the player damage event
--@ Return(s): void
function playerDamage(attacker, weapon, bodypart, loss)
    --> Check: Source and attacker
    if not source or not isElement(source) then return; end;
    if not attacker or not isElement(attacker) then attacker = source; end;

    --> Fix: Invincible players in damaged vehicles
    if isPedInVehicle(source) then
        --> Variable(s)
        local curr_health = getElementHealth(source);
        local new_health = curr_health - loss;
        
        --> Set: Element health
        setElementHealth(source, new_health); 
    end;

    --> Check: If the attacker is an object
    if getElementType(attacker) == 'object' then return; end;

    --> Check: Weapon type
    if (weapon == 24 and (getElementData(attacker, "deaglemode") == 0 or getElementData(attacker, "deaglemode") == 2)) then return; end;
	if (weapon == 25 and getElementData(attacker, "shotgunmode") == 0) then return; end;
	if getElementData(source, "paintball") and getElementData(source, "paintball") == 2 then return; end;
    if getElementData(source, "tazed") then return; end;
 
    --> Check: If player is flying
    if getElementData(source, 'superman:flying') then return cancelEvent(); end;

    --> Variable(s)
    local health = getElementHealth(source);
    local supposed_dead = health - loss <= 0;
    local ksx1 = (not isPlayerInjured(source) and supposed_dead);
    local non_lethal_weps, lethal_weps = SL.KillScript.Config['weapons']['non_lethal'], SL.KillScript.Config['weapons']['lethal'];
    local unix_time = getElementData(source, "sl_ks:player:unix") or 0;

    --> Check: KS x1
    if ksx1 then
        --> Check: If the player is already injured
        if isPlayerInjured(source) or getPlayerInjury(source) ~= 'none' then return; end;

        --> Variable(s)
        local injury_type = (table.contains(lethal_weps, weapon) and 'heavy' or 'light') or 'light';
        local current_unix = getRealTime().timestamp;

        --> Trigger: Event
        triggerServerEvent("onPlayerApplyInjury", source, source, injury_type, current_unix, false, attacker);
        triggerEvent('onClientPlayerInjured', source);

        --> Cancel: Event
        return cancelEvent();
    end;

    --> Check: If the weapon is non-lethal
    if (isPlayerInjured(source) and table.contains(non_lethal_weps, weapon)) then
        --> Cancel: Event
        return cancelEvent();
    end;

    --> Check: Unix time invincibility
    if unix_time > getRealTime().timestamp then
        --> Cancel: Event
        return cancelEvent();
    end;
end; 

--@ Function: keyPress
--@ Description: Handles the player key press event
--@ Return(s): void
function keyPress(key, state)
    --> Check: Player
    if not localPlayer or not isElement(localPlayer) then return; end;

    --> Check: Injury
    if not isPlayerInjured(localPlayer) or getPlayerInjury(localPlayer) == 'none' then return; end;

    --> Variable(s)
    local chat_keys = getBoundKeys('chatbox');
    local using_chat_keys = not not chat_keys[key] or false; --> "Pingu" shitty way conversion to boolean (it was returning me 'down' instead...)
    local vector_3, max_distance = Vector3(getElementPosition(localPlayer)), 10;

    --> Check: If the player is injured
    if (isPlayerInjured(localPlayer) and not using_chat_keys and key ~= 'escape') and getPlayerInjury(localPlayer) ~= 'none' then
        --> Variable(s)
        local anim, block = getPedAnimation(localPlayer);
        local injury = getPlayerInjury(localPlayer);
        local velocity = Vector3(getElementVelocity(localPlayer));
        local is_moving = velocity.x ~= 0 or velocity.y ~= 0 or velocity.z ~= 0;

        --> Check: Player animation
        if (tostring(anim) ~= 'crack' or tostring(block) ~= 'crckdeth2') or (is_moving) then
            --> Check: If the player is injured
            if getPlayerInjury(localPlayer) == 'none' then return; end; --> Prevent: Player from getting injured if he's not

            --> Trigger: Event
            triggerServerEvent("onPlayerApplyInjury", localPlayer, localPlayer, injury, getRealTime().timestamp, true, nil, true);
        end; 
    end;

    --> Check: All players around the localplayer
    for _, player in ipairs(getElementsWithinRange(vector_3, max_distance, 'player')) do
        if (isPlayerInjured(player) and not isPedDead(player)) and getPlayerInjury(player) ~= 'none' then
            --> Variable(s)
            local anim, block = getPedAnimation(player);

            --> Check: Player animation
            if (tostring(anim) ~= 'crack' or tostring(block) ~= 'crckdeth2') then
                setPedAnimation(player, 'CRACK', 'crckdeth2', -1, false, false, false, true);
            end; 
        end;
    end;
end; 