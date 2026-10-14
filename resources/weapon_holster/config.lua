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
SL.WHScript.Config = SL.WHScript.Config or {};


--[[----------------------------------------
    --> Config
--]]----------------------------------------
SL.WHScript.Config = {
    ['weapons'] = {
        --> Weapon(s) in the back
        [2] = {x = 0.3, y = -0.08, z = -0.098, ry = 90, rp = -90, rr = 0, model = 333, bone = 'spine', scale = 1.0}, -- Golfclub
        [5] = {x = 0.3, y = -0.08, z = -0.098, ry = 90, rp = -90, rr = 0, model = 336, bone = 'spine', scale = 1.0}, -- Bat
        [6] = {x = 0.3, y = -0.08, z = -0.098, ry = 90, rp = -90, rr = 0, model = 337, bone = 'spine', scale = 1.0}, -- Shovel
        [7] = {x = 0.3, y = -0.08, z = -0.098, ry = 90, rp = -90, rr = 0, model = 338, bone = 'spine', scale = 1.0}, -- Poolstick
        [8] = {x = 0.3, y = -0.08, z = -0.098, ry = 90, rp = -90, rr = 0, model = 339, bone = 'spine', scale = 1.0}, -- Katana
        [9] = {x = 0.45, y = -0.14, z = -0.18, ry = 0, rp = -140, rr = 0, model = 341, bone = 'spine', scale = 1.0}, -- Chainsaw
        [35] = {x = 0.15, y = -0.2, z = -0.03, ry = -90, rp = 0, rr = 0, model = 359, bone = 'spine', scale = 1.0}, -- Rocket Launcher
        [36] = {x = 0.15, y = -0.2, z = -0.03, ry = -90, rp = 0, rr = 0, model = 360, bone = 'spine', scale = 1.0}, -- // HS
        [37] = {x = 0.45, y = -0.14, z = -0.18, ry = 0, rp = -140, rr = 0, model = 361, bone = 'spine', scale = 1.0}, -- Flamethrower
        [38] = {x = 0.3, y = -0.08, z = -0.098, ry = 90, rp = -90, rr = 0, model = 362, bone = 'spine', scale = 1.0}, -- Minigun 
        [15] = {x = 0.3, y = -0.08, z = -0.098, ry = 90, rp = -90, rr = 0, model = 326, bone = 'spine', scale = 1.0}, -- Cane

        --> Weapon(s) in the front
        [25] = {x = 0.2, y = 0.18, z = -0.15, ry = 0, rp = -20, rr = 180, model = 349, bone = 'spine', scale = 1.0}, -- Shotgun
        [27] = {x = 0.2, y = 0.18, z = -0.15, ry = 0, rp = -20, rr = 180, model = 351, bone = 'spine', scale = 1.0}, -- Combat shotgun
        [29] = {x = 0.2, y = 0.18, z = -0.15, ry = 0, rp = -20, rr = 180, model = 353, bone = 'spine', scale = 1.0}, -- MP5
        [30] = {x = 0.2, y = 0.18, z = -0.15, ry = 0, rp = -20, rr = 180, model = 355, bone = 'spine', scale = 0.9}, -- Ak-47
        [31] = {x = 0.2, y = 0.18, z = -0.15, ry = 0, rp = -20, rr = 180, model = 356, bone = 'spine', scale = 1.0}, -- M4
        [33] = {x = 0.2, y = 0.18, z = -0.15, ry = 0, rp = -20, rr = 180, model = 357, bone = 'spine', scale = 1.0}, -- Rifle
        [34] = {x = 0.2, y = 0.18, z = -0.15, ry = 0, rp = -20, rr = 180, model = 358, bone = 'spine', scale = 1.0}, -- Sniper

        --> Heavy weapons
        ['heavy'] = {
            9, 35, 36, 37, -- Chainsaw, Rocket Launcher, // HS, Flamethrower
            38, 25, 27, 29, -- Minigun, Shotgun, Combat shotgun, MP5
            30, 31, 33, 34, -- Ak-47, M4, Rifle, Sniper
        },
    }
};