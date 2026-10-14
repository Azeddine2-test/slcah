--[[
    Team:  	    Southland
    Author:     Whiletruend
    Addon:		LSPD Scripts Rework
    Date:		09/07/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.LSPD = SL.LSPD or {};
SL.LSPD.Config = SL.LSPD.Config or {};


--[[----------------------------------------
    --> Function(s)
--]]----------------------------------------
--@ Function: isInLSPD
--@ Description: Check if the player is in the LSPD faction
--@ Return(s): void
function isInLSPD(element)
end;

--@ Function: isInLSPDAndOnDuty
--@ Description: Check if the player is in the LSPD faction and on duty
--@ Return(s): void
function isInLSPDAndOnDuty(element)
    --> Check: Element
    if not element or not isElement(element) then return false end;
    if getElementType(element) ~= 'player' then return false end;

    --> Variable(s)
    local factions_id, factions_type = {}, {};
    local factions = getElementData(element, 'faction');
    local is_lspd, is_duty = false, false;

    --> Loop: Get all factions ID
    for k, v in pairs(factions) do
        if k == 1 then is_lspd = true; end; --> Is LSPD
    end;

    --> Check: LSPD
    if not is_lspd then return 'not_lspd'; end;

    --> Loop: Get all duty players in LSPD
    for _, v in pairs(exports.factions:getPlayersInFactionOnDuty(1)) do
        if v == element then is_duty = true; end; --> Is on duty
    end;

    --> Check: Duty
    if not is_duty then return 'not_duty'; end;

    --> Return(s)
    return true;
end;

--@ Function: getPlayerByPhoneNum()
--@ Description: Get a player by his phone number
--@ Return(s): userdata
function getPlayerByPhoneNum(number)
    --> Check: Number
    if not number or type(number) ~= 'string' then return false end;

    --> Variable(s)
    local players = getElementsByType('player');

    --> Loop: Get all players
    for _, v in pairs(players) do
        --> Variable(s)
        local phone = getElementData(v, 'lspd_rework:phones:list') or {};

        --[[ local items = exports['item-system']:getItems(v);
        local phone = {};
    
        --> Loop: Get every phones
        if items then
            for _, item in pairs(items) do
                if tonumber(item[1]) == 2 then
                    --> Variable(s)
                    local is_on = lspdCheckPhoneOn(item[2]);
        
                    --> Table: Set values
                    phone[tostring(item[2])] = {['player'] = v, ['on'] = is_on};
                end;
            end;
        end *]]

        --> Check: Phone
        if phone and phone[number] then
            if phone[number]['on'] and v then
                return v;
            else
                return 'not_on';
            end;
        end;
    end;

    --> Return(s)
    return 'not_found';
end;

--@ Function: getElementSpeed
--@ Description: Get the element speed
--@ Return(s): float
function getElementSpeed(element, type)
    --> Check: Element & Type
    if not element or not isElement(element) then return false end;
    if not type or type ~= 'mph' then type = 'kmh'; end;

    --> Variable(s)
    local speed_x, speed_y, speed_z = getElementVelocity(element);
    local pyth_speed = math.sqrt(speed_x^2 + speed_y^2 + speed_z^2); --> Pythagoras theorem to get the speed
    local kmh = pyth_speed * 180; --> Convert the speed to km/h
    local mph = pyth_speed * 111.847; --> Convert the speed to mph

    --> Return(s)
    return type == 'kmh' and kmh or mph;
end;