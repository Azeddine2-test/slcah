--WEATHER APP START
function phoneAppWeather()
	setupPhoneApp("weather")
	
	local hour, minute = getTime()
	
	if getElementInterior(localPlayer) > 0 or getElementDimension(localPlayer) > 0 then
		phoneGUI.label["citylabel"] = dgsCreateLabel(10, 40, dxGetTextWidth(noSignalText, 1, phoneBigBoldFont), 10, noSignalText, false, phoneGUI.image["phonewallpaper"])
		dgsSetProperty(phoneGUI.label["citylabel"], "textColor", tocolor(255, 255, 255))
		dgsSetFont(phoneGUI.label["citylabel"], phoneBigBoldFont)
		dgsCenterElement(phoneGUI.label["citylabel"], false, true)
		
	else
		local x, y, z = getElementPosition(localPlayer)
		local locationName = getZoneName(x, y, z, true)
		phoneGUI.label["citylabel"] = dgsCreateLabel(10, 40, dxGetTextWidth(locationName, 1, phoneBigBoldFont), 10, locationName, false, phoneGUI.image["phonewallpaper"])
		dgsSetProperty(phoneGUI.label["citylabel"], "textColor", tocolor(255, 255, 255))
		dgsSetFont(phoneGUI.label["citylabel"], phoneBigBoldFont)
		dgsCenterElement(phoneGUI.label["citylabel"], false, true)
		
		local activeWeather, upcomingWeather = getWeather()
		if not weatherDetails[tonumber(activeWeather)] then
			outputDebugString("[PHONE] Weather details missing for active weather ID "..activeWeather..".")
		end
		
		if upcomingWeather then
			if not weatherDetails[tonumber(upcomingWeather)] then
				outputDebugString("[PHONE] Weather details missing for upcoming weather ID "..upcomingWeather..".")
			end
		end
		
		if hour > 21 or hour < 8 then
			if activeWeather then
				tempActive = weatherDetails[activeWeather].temp / 1.7
			end
			if upcomingWeather then
				tempUpcoming = weatherDetails[upcomingWeather].temp / 1.7
			end
		else
			if activeWeather then
				if weatherDetails[activeWeather] then
					tempActive = weatherDetails[activeWeather].temp
				end
			end
			if upcomingWeather then
				tempUpcoming = weatherDetails[upcomingWeather].temp
			end
		end
		
		if weatherDetails[activeWeather] then
			phoneGUI.label["weatherlabel"] = dgsCreateLabel(10, 65, dxGetTextWidth(weatherDetails[activeWeather].name, 1, phoneFont), 10, weatherDetails[activeWeather].name, false, phoneGUI.image["phonewallpaper"])
			dgsSetProperty(phoneGUI.label["weatherlabel"], "textColor", tocolor(255, 255, 255))
			dgsSetFont(phoneGUI.label["weatherlabel"], phoneFont)
			dgsCenterElement(phoneGUI.label["weatherlabel"], false, true)
			
			phoneGUI.label["temperaturelabel"] = dgsCreateLabel(10, 90, dxGetTextWidth(math.floor(tempActive).."°C", 1, phoneBigBoldFont), 10, math.floor(tempActive).."°C", false, phoneGUI.image["phonewallpaper"])
			dgsSetProperty(phoneGUI.label["temperaturelabel"], "textColor", tocolor(255, 255, 255))
			dgsSetFont(phoneGUI.label["temperaturelabel"], phoneBigBoldFont)
			dgsCenterElement(phoneGUI.label["temperaturelabel"], false, true)
			
			phoneGUI.image["weathericon"] = dgsCreateImage(0, 140, 67, 67, ""..weatherDetails[activeWeather].icon.."", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
			dgsCenterElement(phoneGUI.image["weathericon"], false, true)
		end
		
		phoneGUI.image["seperator"] = dgsCreateImage(10, 220, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
		dgsCenterElement(phoneGUI.image["seperator"], false, true)
		
		if weatherDetails[upcomingWeather] then
			
			phoneGUI.label["upcominglabel"] = dgsCreateLabel(10, 170+60, dxGetTextWidth("Next Forecast", 1, phoneFont), 10, "Next Forecast", false, phoneGUI.image["phonewallpaper"])
			dgsSetProperty(phoneGUI.label["upcominglabel"], "textColor", tocolor(255, 255, 255))
			dgsSetFont(phoneGUI.label["upcominglabel"], phoneFont)
			dgsCenterElement(phoneGUI.label["upcominglabel"], false, true)
			
			phoneGUI.label["upcomingweatherlabel"] = dgsCreateLabel(10, 170+80, dxGetTextWidth(weatherDetails[upcomingWeather].name, 1, phoneFont), 10, weatherDetails[upcomingWeather].name, false, phoneGUI.image["phonewallpaper"])
			dgsSetProperty(phoneGUI.label["upcomingweatherlabel"], "textColor", tocolor(255, 255, 255))
			dgsSetFont(phoneGUI.label["upcomingweatherlabel"], phoneFont)
			dgsCenterElement(phoneGUI.label["upcomingweatherlabel"], false, true)
			
			phoneGUI.label["temperaturelabel"] = dgsCreateLabel(10, 190+80, dxGetTextWidth(math.floor(tempUpcoming).."°C", 1, phoneBigBoldFont), 10, math.floor(tempUpcoming).."°C", false, phoneGUI.image["phonewallpaper"])
			dgsSetProperty(phoneGUI.label["temperaturelabel"], "textColor", tocolor(255, 255, 255))
			dgsSetFont(phoneGUI.label["temperaturelabel"], phoneBigBoldFont)
			dgsCenterElement(phoneGUI.label["temperaturelabel"], false, true)
			
			phoneGUI.image["weathericon"] = dgsCreateImage(0, 190+80+50, 67, 67, ""..weatherDetails[upcomingWeather].icon.."", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
			dgsCenterElement(phoneGUI.image["weathericon"], false, true)
		end
	end
end
--WEATHER APP END