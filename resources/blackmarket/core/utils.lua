--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		BlackMarket
    Date:		23/05/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.BMScript = SL.BMScript or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: getRandomName
--@ Description: Get a random name 
--@ Return: string
function getRandomName(type, gender)
    --> Check if the type and gender are empty
    if type == nil then type = "full" end;
    if gender == 0 then gender = 'male'; elseif(gender == 1) then gender = 'female'; end;
    if gender == nil then gender = "male" end;

    --> Variable(s)
	local genders = {"male", "female"};	
	local males = {
        "John", "Will", "Jacob", "Henry", "Oliver", "Adam", "Christian",
	    "Chris", "Christopher", "Michael", "Mike", "Joe", "Aaron", "Ethan",
	    "Noah", "Lucas", "Lukas", "Gabriel", "Owen", "Jack", "Dorian",
	    "James", "Colin", "Luke", "Daniel", "Evan", "Seth", "Jason",
	    "David", "Thomas", "Justin", "Jasper", "Alex", "Alexander", "William"
    };
	local females = { 
        "Rebecca", "Eva", "Emma", "Olivia", "Lilly", "Sophie", 
        "Chloe", "Hannah", "Emily", "Claire", "Belle", "Natalie", "Page",
        "Mia", "Leah", "Gabriella", "Zoe", "Kylie", "Samantha", "Alex",
        "Alexis", "Catherine", "Cathy", "Faith", "Victoria", "Lillian", "Brooke", 
        "Julia", "Alice", "Caroline", "Allison", "Amy", "Dolly", "Juliet",
        "Ashley", "Amber", "Kate", "Katie", "Mary", "Evelyn", "Pamela",
        "Jaqueline", "Elliot"
	};	
	local lastnames = {
        "Goldsmith", "Carter", "Cooper", "Ford", "Montana", "Hut", "Willson",
        "Smith", "Johnson", "Jones", "Williams", "Brown", "Davis", "Miller",
        "Wilson", "Moore", "Taylor", "Anderson", "Jackson", "Harris", "Thompson",
        "Martinez", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen",
        "Young", "Hernandez", "Jimenez", "Nilson", "Adams", "Baker", "Turner",
        "Reed", "Bell", "Cox", "Howard", "Watson", "Brooks", "Jenkins",
        "Foster", "Butler", "Diaz", "West", "Fisher", "Hunter", "Stevens",
        "Tucker", "Daniels", "Porter", "Rice", "Burns", "Black",
        "White", "Crawford", "Robinson"
	};
	
    --> Condition(s)
    if type == 'full' then
        --> Variable(s)
        local randFirstname;
        local randLastname;
        local name;

        --> Condition(s)
        if not gender then gender = genders[math.random(table.getn(genders))]; end;
        if gender == 'male' then randFirstname = males[math.random(table.getn(males))];
		elseif gender == 'female' then randFirstname = females[math.random(table.getn(females))]; end;

        --> Set variable(s)
		randLastname = lastnames[math.random(table.getn(lastnames))];
		name = tostring(randFirstname.." "..randLastname);

		--> Return
		return name;
    elseif type == 'last' then
		--> Variable(s)
		local randLastname;

		--> Set variable(s)
		randLastname = lastnames[math.random(table.getn(lastnames))];

		--> Return
		return randLastname;
	elseif type == 'first' then
		--> Variable(s)
		local randFirstname;

		--> Set variable(s)
		if gender == 'male' then
			randFirstname = males[math.random(table.getn(males))];
		elseif gender == 'female' then
			randFirstname = females[math.random(table.getn(females))];
		end;

		--> Return
		return randFirstname;
	elseif type == 'gender' then
		--> Variable(s)
		gender = genders[math.random(table.getn(genders))];

		--> Condition(s)
		if gender == 'male' then return 0; elseif gender == 'female' then return 1; end;
	end;
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

--@ Method: isPlayerGangLeader
--@ Description: Check if the player is the leader of a gang
--@ Return: bool
function isPlayerGangLeader(player)
    --> Variable(s)
    local factionsID, factionsType = {}, {};

    --> Loop to get the faction ID
    for k, v in pairs(getElementData(player, 'faction')) do table.insert(factionsID, k); end; --> Get the different factions ID of the player
    for k, v in pairs(factionsID) do table.insert(factionsType, exports.factions:getFactionType(v)); end; --> Get the faction type of the player

    --> Condition(s)
    if table.find(factionsType, 0) then
        --> Variable(s)
        local isLeader = exports.factions:hasMemberPermissionTo(player, factionsID[table.find(factionsType, 0)], 'add_member');

        --> Return
        return isLeader;
    end;

    --> Return
    return false;
end;

--@ Method: getPlayerLeadingGangID
--@ Description: Get the ID of the gang that the player is leading
--@ Return: int
function getPlayerLeadingGangID(player)
    --> Check
    if not isPlayerGangLeader(player) then return; end;

    --> Variable(s)
    local factionsID, factionsType = {}, {};

    --> Loop to get the faction ID
    for k, v in pairs(getElementData(player, 'faction')) do table.insert(factionsID, k); end; --> Get the different factions ID of the player
    for k, v in pairs(factionsID) do table.insert(factionsType, exports.factions:getFactionType(v)); end; --> Get the faction type of the player

    --> Return
    return factionsID[table.find(factionsType, 0)];
end;

--@ Method: isFactionIllegal
--@ Description: Check if the faction is illegal
--@ Return: bool
function isFactionIllegal(faction_id)
    --> Check: Faction ID
    if not faction_id then return; end;

    --> Variable(s)
    local faction_type = exports.factions:getFactionType(faction_id);
    local illegals_fac = {0, 1, 10};

    --> Condition(s)
    if table.find(illegals_fac, faction_type) then return true; end;

    --> Return
    return false;
end;

--@ Method: isPlayerLeadingIllegalFaction
--@ Description: Check if the player is leading an illegal faction
--@ Return: bool
function isPlayerLeadingIllegalFaction(player)
    --> Check: Player
    if not player or not isElement(player) or getElementType(player) ~= 'player' then return; end;

    --> Variable(s)
    local factionsID, factionsType = {}, {};
    local illegals_fac = {0, 1, 10};

    --> Loop: To get the faction ID
    for k, v in pairs(getElementData(player, 'faction')) do table.insert(factionsID, k); end; --> Get the different factions ID of the player
    for k, v in pairs(factionsID) do table.insert(factionsType, exports.factions:getFactionType(v)); end; --> Get the faction type of the player

    --> Condition(s)
    if table.find(factionsType, 0) or table.find(factionsType, 1) or table.find(factionsType, 10) then
        --> Variable(s)
        local isLeader = exports.factions:hasMemberPermissionTo(player, factionsID[table.find(factionsType, 0)], 'add_member') or exports.factions:hasMemberPermissionTo(player, factionsID[table.find(factionsType, 1)], 'add_member') or exports.factions:hasMemberPermissionTo(player, factionsID[table.find(factionsType, 10)], 'add_member');

        --> Return
        return isLeader;
    end;

    --> Return
    return false;
end;

--@ Method: getTodayDate
--@ Description: Get the date of today (DD/MM/YYYY HH:MM:SS)
--@ Return: string
function getTodayDate()
    local time, hours, minutes, seconds, day, month, year = getRealTime(), getRealTime().hour, getRealTime().minute, getRealTime().second, getRealTime().monthday, getRealTime().month, getRealTime().year;
    local formattedTime = string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, day, hours + 2, minutes, seconds);

    --> Return
    return formattedTime;
end;

--@ Method: convertToUnixTime
--@ Description: Convert a date to unix time
--@ Return: int
function convertToUnixTime(date)
    --> Variable(s)
    local year, month, day, hour, min, sec = string.match(date, "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)");
    local france_timezone = 7 * 60 * 60; -- UTC+2 (CEST) offset in seconds
    local unix_time = os.time({year = year, month = month, day = day, hour = hour, min = min, sec = sec}) - france_timezone;

    --> Return
    return unix_time;
end;

--@ Method: convertToTime
--@ Description: Convert a unix time to a date
--@ Return: string
function convertToTime(unix_time)
    --> Variable(s)
    local france_timezone = 7 * 60 * 60; -- UTC+2 (CEST) offset in seconds
    local corrected_unix_time = unix_time + france_timezone;
    local time, hours, minutes, seconds, day, month, year = corrected_unix_time, os.date("%H", corrected_unix_time), os.date("%M", corrected_unix_time), os.date("%S", corrected_unix_time), os.date("%d", corrected_unix_time), os.date("%m", corrected_unix_time), os.date("%Y", corrected_unix_time);
    local formattedTime = string.format("%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hours, minutes, seconds);

    --> Return
    return formattedTime;
end;

--@ Function: switch
--@ Description: Create a switch statement
--@ Return: function
function switch(case, cases)
    --> Check: Case & Cases
    if not case or not cases then return; end;

    --> Variable(s)
    local case_function = cases[case] or cases.default;

    --> Check: Case function
    if case_function then
        if type(case_function) == 'function' then
            return case_function();
        else
            return error('[BM ERR!]: The case function is not a function.');
        end;
    end;
end;