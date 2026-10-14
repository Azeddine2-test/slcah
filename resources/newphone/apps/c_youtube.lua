loadedAdverts = nil

webBrowser = nil

local currentRotation = 0

function phoneAppYouTube()
	setupPhoneApp("youtube")
	
	if webBrowser and isElement(webBrowser) then
		destroyElement(webBrowser)
	else
		guiSetInputMode("no_binds")
	end
	webBrowser = dgsCreateBrowser(0, 25, 369*scaleRatio, 650*scaleRatio, false, phoneGUI.image["phonewallpaper"], false, false, 184 * 2, 288 * 2)
	setBrowserProperty(webBrowser, "mobile", "1")
	addEventHandler("onClientBrowserCreated", webBrowser, function()
		loadBrowserURL(webBrowser, "https://youtube.com")
		setBrowserVolume(webBrowser, 0.5)
	end)
	
	--[[phoneGUI.image["rotatephone"] = dgsCreateButton(160, 420, homeIconSize, homeIconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/send.png", ":newphone/files/icons/send.png", ":newphone/files/icons/send.png")
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["rotatephone"], function()
		if currentRotation == 0 then
			local currentURL = "https://youtube.com"
			if webBrowser and isElement(webBrowser) then currentURL = getBrowserURL(webBrowser) destroyElement(webBrowser) end
			webBrowser = dgsCreateBrowser(0, 25, 650*scaleRatio, 369*scaleRatio, false, phoneGUI.image["phonewallpaper"], false, false, 288 * 2, 184 * 2)
			
			setBrowserProperty(webBrowser, "mobile", "1")
			addEventHandler("onClientBrowserCreated", webBrowser, function()
				loadBrowserURL(webBrowser, currentURL)
				setBrowserVolume(webBrowser, 0.5)
			end)
	
			dgsSetVisible(phoneGUI.image["network"], false)
			dgsSetVisible(phoneGUI.label["timelabel"], false)
			
			dgsSetProperty(phoneGUI.image["phoneframe"],"rotation",90)
			dgsSetProperty(phoneGUI.image["phonewallpaper"],"rotation",90)
			dgsSetPosition(webBrowser, -63, 130)
			dgsSetPosition(phoneGUI.image["phoneframe"], sx-417*scaleRatio-130, sy-840*scaleRatio+100)
			
			dgsSetPosition(phoneGUI.image["closephone"], -115, 215)
			dgsSetPosition(phoneGUI.image["rotatephone"], -115, 275)
			
			currentRotation = 90
		else
			currentRotation = 90
		end
	end, false)]]
end