--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		Weapon Holster
    Date:		15/05/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.WHScript = SL.WHScript or {};
SL.WHScript.Weapons = SL.WHScript.Weapons or {};
SL.WHScript.Config = SL.WHScript.Config or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: getPedWeapons
--@ Description: Called to get the weapons list of a ped
--@ Return: table
function getPedWeapons(ped)
    --> Variable(s)
    local weapons = {};

    --> Condition(s)
    if ped and isElement(ped) and getElementType(ped) == 'player' then
        --> Loop
        for i = 1, 9 do -- From the weapon slots 1 to 9
            --> Variable(s)
            local wep = getPedWeapon(ped, i);

            --> Condition(s)
            if wep and wep ~= 0 then table.insert(weapons, wep); end;
        end;
    else
        return false;
    end;

    --> Return
    return weapons;
end;

--@ Method: table.contains
--@ Description: Check if a table contains a value
--@ Return: boolean
function table.contains(table, value)
    --> Check
    if not table or not value then return; end;

    --> Loop
    for _, v in ipairs(table) do
        if v == value then return true; end;
    end;

    --> Return
    return false;
end;

--@ Method: table.missingValue
--@ Description: Check if a table contains a value and return the missing value
--@ Return: boolean, value
function table.missingValue(a, b)
    --> Variable(s table.missingValue)
    local elements = {};

    --> Loop (store the elements of the first table)
    for _, v in ipairs(a) do
        elements[v] = true;
    end;

    --> Loop (check the absent elements)
    for _, v in ipairs(b) do
        if not elements[v] then return v; end;
    end;

    --> Loop (if no absent elements, check the absent elements of the second table)
    for _, v in ipairs(a) do
        if not elements[v] then return v; end;
    end;
    
    --> Return
    return nil; -- No absent elements
end;

--@ Method: table.compare
--@ Description: Compare two tables
--@ Return: bool
function table.compare(a, b)
    --> Condition(s)
    if type(a) ~= 'table' or type(b) ~= 'table' then return false; end;

    --> Function(s)
    local function size(t)
        --> Check
        if type(t) ~= 'table' then return false; end;

        --> Variable(s)
        local n = 0;

        --> Loop
        for _ in pairs(t) do
            n = n + 1;
        end;

        --> Return
        return n;
    end;

    --> Condition(s)
    if size(a) == 0 and size(b) == 0 then
        return true;
    elseif size(a) ~= size(b) then
        return false;
    end;

    --> Loop
    for _, v in pairs(a) do
        --> Variable(s)
        local v2 = b[_];

        --> Condition(s)
        if type(v) == type(v2) then
            if type(v) == 'table' and type(v2) == 'table' then
                if size(v) ~= size(v2) then return false; end;
                if size(v) > 0 and size(v2) > 0 then
                    if not table.compare(v, v2) then
                        return false;
                    end;
                end;
            elseif type(v) == 'string' or type(v) == 'number' and type(v2) == 'string' or type(v2) == 'number' then
                if v ~= v2 then return false; end;
            else
                return false;
            end;
        else
            return false;
        end;
        return true;
    end;

    --> Return
    return false;
end;

--@ Method: table.find
--@ Description: Find a value in a table
--@ Return: int/bool
function table.find(t, v)
    --> Condition(s)
    if type(t) ~= 'table' then return false; end;

    --> Loop
    for k, v2 in pairs(t) do
        --> Condition(s)
        if v2 == v then return k; end;
    end;

    --> Return
    return false;
end;