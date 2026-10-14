
local currentWeather = 1
local timeSavedHour, timeSavedMinute
local x, y, z = nil

function ChangePlayerWeather(weather, forced)
	if forced or getElementData(localPlayer, 'loggedin') == 1 and getElementInterior( localPlayer ) == 0 and getElementDimension(localPlayer) == 0  then
		currentWeather = weather
		setWeather( currentWeather )
		setWeatherBlended( currentWeather )
	end
end
addEvent( "weather:update", true )
addEventHandler( "weather:update", root, ChangePlayerWeather )

function updateInterior()
	if getElementInterior( getLocalPlayer( ) ) > 0 then
		if getWeather( ) ~= 3 then
			setWeather( 3 )
			setSkyGradient( 0, 0, 0, 0, 0, 0 )
		end
	else
		local currentWeatherID, blended = getWeather( )
		if currentWeatherID ~= currentWeather and not blended then
			setWeather( currentWeather )
		end
		resetSkyGradient( )
	end
end
setTimer( updateInterior, 2000, 0)

function forceWeather( )
	setWeather( currentWeather )
	resetSkyGradient()
	setTime(timeSavedHour, timeSavedMinute+1)
	
	addEventHandler("accounts:characters:new", root, forceWeather)
end

function resetWeather( )
	setWeather(1)
	setWeatherBlended(1)
	outputDebugString('Reset client weather.')
end

addEventHandler( "onClientResourceStart", resourceRoot, function()
	resetWeather()
	addEventHandler( 'account:character:select', root, resetWeather )
end )

addEventHandler( 'onClientResourceStop', resourceRoot, function()
	resetWeather()
	removeEventHandler( 'account:character:select', root, resetWeather )
end)
