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
    --> Config
--]]----------------------------------------
SL.LSPD.Config = {
    ['base'] = {
        PREFIX = '[LSPD] ',
        MAX_MICRO = 3,
        MICRO_DISTANCE = 10,
    },

    ['authorized_factions'] = {
        [1] = true,  --> LSPD
        [2] = true, --> LSES 
        [4] = true, --> Mechanic Garage
        [10] = true, --> Auto Parks
    },

    ['commands'] = {
        GEOLOC = 'geoloc',
        WIRETAPPING = 'ecoute',
        CHECKNUM = 'checknum',
        MICRO = 'micro',
    },

    ['phrases'] = {
        GEOLOCALISE_ON = 'Vous avez activé la géolocalisation sur le téléphone de ',
        GEOLOCALISE_OFF = 'Vous avez désactivé la géolocalisation sur le téléphone de ',
        WIRETAPPING_ON = 'Vous avez activé l\'écoute sur le téléphone de ',
        WIRETAPPING_OFF = 'Vous avez désactivé l\'écoute sur le téléphone de ',
        CHECKNUM = 'Ce numéro de téléphone correspond à ',
        MICRO_PUT = 'Vous avez posé un micro.',
        MICRO_REMOVE = 'Vous avez retiré un micro.',
    }
};