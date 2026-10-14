--[[ 
    Team:  	    Southland
    Author:     Whiletruend
    Addon:		Overdose script for 'Drugs' resource
    Date:		04/09/2023
]]--


--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.Overdose = SL.Overdose or {};


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

--@ Function: isPlayerStartingOverdose
--@ Description: Check if the player is starting overdose
--@ Return(s): boolean
function isPlayerStartingOverdose(player)
    --> Check: Player
    if not player or not isElement(player) then return; end;

    --> Return(s)
    return getElementData(player, "drugs:player:status") == 'start_overdose' or false;
end;

--@ Function: isPlayerInOverdose
--@ Description: Check if the player is in overdose
--@ Return(s): boolean
function isPlayerInOverdose(player)
    --> Check: Player
    if not player or not isElement(player) then return; end;

    --> Return(s)
    return getElementData(player, "drugs:player:status") == 'overdose' or false;
end;

--@ Function: isPlayerUnconscious
--@ Description: Check if the player is unconscious
--@ Return(s): boolean
function isPlayerUnconscious(player)
    --> Check: Player
    if not player or not isElement(player) then return; end;

    --> Return(s)
    return getElementData(player, "drugs:player:status") == 'unconscious' or false;
end;

--@ Function: getPlayerStatus
--@ Description: Get the player status
--@ Return(s): boolean
function getPlayerStatus(player)
    --> Check: Player
    if not player or not isElement(player) then return; end;

    --> Return(s)
    return getElementData(player, "drugs:player:status") or 'none';
end;

--@ Function: getPlayerDependance
--@ Description: Get the player dependance
--@ Return(s): boolean
function getPlayerDependance(player)
    --> Check: Player
    if not player or not isElement(player) then return; end;

    --> Return(s)
    return tonumber(getElementData(player, "drugs:player:dependance")) or 0;
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