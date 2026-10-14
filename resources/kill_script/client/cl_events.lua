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
    --> Event(s)
--]]----------------------------------------
--@ Event: onClientRender
--@ Description: Handle the render
addEventHandler('onClientRender', getRootElement(), renderKillScript); 

--@ Event: onPlayerDamage
--@ Description: Handle the player damage
addEventHandler('onClientPlayerDamage', getLocalPlayer(), playerDamage);

--@ Event: onClientKey
--@ Description: Handle the key press
addEventHandler('onClientKey', getRootElement(), keyPress);

--@ Event: onClientPlayerInjured
--@ Description: Handle the player injured
addEvent('onClientPlayerInjured', true);