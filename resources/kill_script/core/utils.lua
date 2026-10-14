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
--@ Function: table.contains
--@ Description: Check if the entered value is in the table
--@ Return(s): boolean
function table.contains(table, value)
    --> Loop: Table
    for k, v in pairs(table) do
        --> Check: Value
        if v == value then return true; end;
    end;

    --> Return(s)
    return false;
end;
 
--@ Function: isPlayerInjured
--@ Description: Check if the player is injured
--@ Return(s): boolean
function isPlayerInjured(player)
    --> Check: Player
    if not player or not isElement(player) then return; end;

    --> Return(s)
    return getElementData(player, "sl_ks:player:injury") ~= 'none' or false;
end;

--@ Function: canPlayerAcceptDeath
--@ Description: Check if the player can accept death
--@ Return(s): boolean
function canPlayerAcceptDeath(player)
    --> Check: Player
    if not player or not isElement(player) then return false; end;
    if not isPlayerInjured(player) then return false; end;
    
    --> Return(s)
    return getElementData(player, "sl_ks:player:canAccept");
end;

--@ Function: getPlayerInjury
--@ Description: Get the player injury
--@ Return(s): boolean
function getPlayerInjury(player)
    --> Check: Player
    if not player or not isElement(player) then return; end;

    --> Return(s)
    return getElementData(player, "sl_ks:player:injury") or 'none';
end;

--@ Function: formatArgs
--@ Description: string.format the arguments
--@ Return(s): string
function formatArgs(format, ...)
    --> Variable(s)
    local args = {...};
    local result = string.gsub(format, '%%[ds]', function(match)
        if #args > 0 then
            --> Variable(s)
            local arg = table.remove(args, 1);

            --> Check: Match
            if match == '%s' then return tostring(arg);
            elseif match == '%d' then
                if type(arg) == 'number' then return tostring(arg);
                else return 'NaN'; end;
            end;
        end;

        --> Return(s)
        return match;
    end);

    --> Return(s)
    return result;
end;

--@ Function: getTimeUnit
--@ Description: Get the time unit
--@ Return(s): void
function getTimeUnit(seconds)
    --> Return(s): Time Unit
    if seconds < 60 then return seconds, 'seconde(s)';
    elseif seconds < 3600 and seconds >= 60 then return math.floor(seconds / 60), 'minute(s)';
    else return math.floor(seconds / 3600), 'heure(s)'; end;
end;