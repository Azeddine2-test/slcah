--[[
    Team:  	    Southland
    Author:     Whiletruend
    Addon:		LSES Scripts Rework
    Date:		18/08/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.LSES = SL.LSES or {};
SL.LSES.Config = SL.LSES.Config or {};


--[[----------------------------------------
    --> Function(s)
--]]----------------------------------------
--@ Function: isInLSESAndOnDuty
--@ Description: Check if the player is in the LSES faction and on duty
--@ Return(s): void
function isInLSESAndOnDuty(element)
    --> Check: Element
    if not element or not isElement(element) then return false end;
    if getElementType(element) ~= 'player' then return false end;

    --> Variable(s)
    local factions_id, factions_type = {}, {};
    local factions = getElementData(element, 'faction');
    local is_lses, is_duty = false, false;

    --> Loop: Get all factions ID
    for k, v in pairs(factions) do
        if k == 2 then is_lses = true; end; --> Is LSES
    end;

    --> Check: LSES
    if not is_lses then return 'not_lses'; end;

    --> Loop: Get all duty players in LSES
    for _, v in pairs(exports.factions:getPlayersInFactionOnDuty(2)) do
        if v == element then is_duty = true; end; --> Is on duty
    end;

    --> Check: Duty
    if not is_duty then return 'not_duty'; end;

    --> Return(s)
    return true;
end;