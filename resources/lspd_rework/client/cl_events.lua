--[[
    Team:  	    Southland
    Author:     Whiletruend
    Addon:		LSPD Scripts Rework
    Date:		24/09/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.LSPD = SL.LSPD or {};
SL.LSPD.Config = SL.LSPD.Config or {};


--[[----------------------------------------
    --> Event(s)
--]]----------------------------------------
--@ Event: payday:run
--@ Description: Handle the payday
addEventHandler('payday:run', getRootElement(), lspdCheckPayday);