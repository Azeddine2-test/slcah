phoneShowing = false

sx, sy = guiGetScreenSize()

phoneFont = dgsCreateFont("files/font.otf", 9, false, "cleartype") or "default-bold"
phoneBoldFont = dgsCreateFont("files/font.otf", 7, false, "cleartype") or "default-bold"
phoneBigFont = dgsCreateFont("files/font.otf", 12, true, "cleartype") or "default-bold"
phoneBigBoldFont = dgsCreateFont("files/font.otf", 16, true, "cleartype") or "default-bold"

phoneGUI = {
	image = {},
	label = {},
	gridlist = {},
	button = {},
	memo = {},
	edit = {},
	scrollpane = {},
	tabpanel = {},
	tab = {},
	rndrect = {},
}

scaleRatio = 0.6

homeIconSize = 40
iconSize = 50

loadedCustomWallpaper = false
wallpaperID = 2
ringtoneID = 1
messageToneID = 1
currentSoundMode = 3
loadedNotes = nil
currentPhoneNumber = nil
currentAdvertUsername = nil
currentNewsUsername = nil
currentApp = nil
currentPin = nil

function createPhoneGUI(phoneID, phonePower, number, hiddennumber, wallpaper, ringtone, messagetone, soundmode, contacts, notes, messages, callhistory, pin, adusername, newsusername, customwallpaper, customcolor, startCallingPhoneNumber)
	if phoneShowing == false then
		if not isCursorShowing() then
			executeCommandHandler("togglecursor")
		end
		
		dgsSetInputMode("no_binds_when_editing")
		
		currentPhoneNumber = tonumber(number)
		phoneShowing = true

		wallpaperID = tonumber(wallpaper)
		wallpaperURL = tostring(customwallpaper)
		wallpaperColor = fromJSON(customcolor or "")
		ringtoneID = tonumber(ringtone)
		messageToneID = tonumber(messagetone)
		currentSoundMode = tonumber(soundmode) or 3
		hideNumber = tonumber(hiddennumber)
		
		loadedNotes2 = fromJSON(notes)
		loadedNotes = table.reverse(loadedNotes2 or {})
		
		loadedContacts = fromJSON(contacts)
		loadedMessages = messages
		loadedCallHistory = fromJSON(callhistory or "")
		currentAdvertUsername = adusername
		currentNewsUsername = newsusername
		
		--phoneGUI.image["phoneframe"] = dgsCreateImage(sx-417*scaleRatio-25, sy-840*scaleRatio-25, 417*scaleRatio, 840*scaleRatio, "files/phoneframe.png", false, false, tocolor(255,255,255,255))
	end
		
	if tonumber(phonePower) == 1 then
		local displayNumberCalling = getElementData(localPlayer, "phonecall:numberCalling")
		local caller = getElementData(localPlayer, "phonecall")
		local callerNumber = getElementData(localPlayer, "phonecall:number")
		if displayNumberCalling and caller and callerNumber and not getElementData(localPlayer, "phonecalling") then
			--phoneAppCalled(caller, callerNumber, displayNumberCalling)
			return
		end
		
		if pin and tonumber(pin) and string.len(pin) == 4 then
			--phoneAppPIN(pin, startCallingPhoneNumber)
			currentPin = pin
			return
		else
			--phoneAppHome(startCallingPhoneNumber)
		end
	else
		if pin and tonumber(pin) and string.len(pin) == 4 then
			currentPin = pin
		end
		--phoneAppPowerOff()
	end
end
addEvent("createPhoneGUI", true)
addEventHandler("createPhoneGUI", root, createPhoneGUI)

function phoneAppPIN(pin, startCallingPhoneNumber)
	if true then
		return
	end
	
	setupPhoneApp("pin")
	
	phoneGUI.label["phonelabel"] = dgsCreateLabel(10, 35, dxGetTextWidth(pinTitleText, 0.8, phoneBigBoldFont), 10, pinTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["phonelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["phonelabel"], phoneBigBoldFont)
	dgsCenterElement(phoneGUI.label["phonelabel"], false, true)
	
	local typedPin = ""
	phoneGUI.label["pinnumber"] = dgsCreateLabel(10, 70, 162, 10, typedPin, false, phoneGUI.image["phonewallpaper"], false, 1.2, 1.2)
	dgsCenterElement(phoneGUI.label["pinnumber"], false, true)
	dgsSetProperty(phoneGUI.label["pinnumber"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["pinnumber"], phoneBigBoldFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["pinnumber"], "center")
	
	--[[phoneGUI.image["seperator"] = dgsCreateImage(10, 100, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)]]
	
	--DIAL BUTTONS START
	local left = 20
	local startX = 0
	local startY = 0
	local buttonCount = 0
	
	local dialButtons = {
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
		[9] = true,
		[10] = true,
		[11] = true,
		[12] = true,
	}
	
	for k, v in ipairs(dialButtons) do		
		if buttonCount == 3 then
			startY = startY + 70
			startX = 0
			buttonCount = 0
		end
		
		if k == 10 then
			k = "cancel"
		elseif k == 11 then
			k = 0
		elseif k == 12 then	
			k = "accept"
		end
		
		phoneGUI.image["dialbutton"..k] = dgsCreateButton(left+startX, 130+startY, iconSize, iconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,150), 1, 1, ":newphone/files/icons/numbers/"..k..".png", ":newphone/files/icons/numbers/"..k..".png", ":newphone/files/icons/numbers/"..k..".png", tocolor(255, 255, 255, 150), tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255))
		if tonumber(k) then
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["dialbutton"..k], function()
				if source == phoneGUI.image["dialbutton"..k] then
					if tostring(typedPin) and  string.len(tostring(typedPin)) < 4 then
						typedPin = typedPin..""..k
						dgsSetText(phoneGUI.label["pinnumber"], typedPin)
					end
				end
			end)
		elseif k == "cancel" then
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["dialbutton"..k], function()
				if source == phoneGUI.image["dialbutton"..k] then
					typedPin = ""
					dgsSetText(phoneGUI.label["pinnumber"], typedPin)
				end
			end)
		elseif k == "accept" then
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["dialbutton"..k], function()
				if source == phoneGUI.image["dialbutton"..k] then	
					if tostring(pin) == tostring(typedPin) then
						--outputDebugString("correct pin")
						phoneAppHome(startCallingPhoneNumber)
					else
						typedPin = ""
						dgsSetText(phoneGUI.label["pinnumber"], typedPin)

						phoneGUI.label["pinerror"] = dgsCreateLabel(10, 100, 162, 10, incorrectPinText, false, phoneGUI.image["phonewallpaper"], false, 0.6, 0.6)
						dgsSetProperty(phoneGUI.label["pinerror"], "textColor", tocolor(255, 0, 0, 175))
						dgsSetFont(phoneGUI.label["pinerror"], phoneBigBoldFont)
						dgsLabelSetHorizontalAlign(phoneGUI.label["pinerror"], "center")
						
						phoneIncorrectPinTimer = setTimer ( function()
							destroyElement(phoneGUI.label["pinerror"])
							killTimer(phoneIncorrectPinTimer)
						end, 1500, 1)
					end
				end
			end)
		end
		
		startX = startX + 65
		buttonCount = buttonCount + 1
	end
	--DIAL BUTTONS END 
end

--CLOSE PHONE START
function phoneClose(force)
	if phoneShowing == true --[[ and (isElement(phoneGUI.image["closephone"]) or force == true) *]] then
		currentPhoneNumber = nil
		dgsSetInputMode("allow_binds")
		phoneShowing = false
		
		wallpaperID = nil
		wallpaperURL = nil
		ringtoneID = nil
		hideNumber = nil
		loadedNotes = nil
		loadedAdverts = nil
		
		if loadedAdvertsPhotos then
			for k, v in pairs(loadedAdvertsPhotos) do
				destroyElement(v)
			end
		end
		
		loadedAdvertsPhotos = {}
		
		loadedContacts = nil
		phonePower = nil
		currentPin = nil
		
		loadedCustomWallpaper = false
		
		if phoneTimeTimer and isTimer(phoneTimeTimer) then
			killTimer(phoneTimeTimer)
		end
		
		if isCursorShowing() then
			executeCommandHandler("togglecursor")
		end
		if isElement(webBrowser) then
			destroyElement(webBrowser)
			guiSetInputMode("allow_binds")
		end
		webBrowser = nil

		--phoneGUI.image["phoneframe"] = dgsCreateImage(sx-100, sy-840*scaleRatio+-25, 417*scaleRatio, 840*scaleRatio, "files/phoneframe.png", false, false, tocolor(255,255,255,255))
		
		if isElement(phoneGUI.image["phoneframe"]) then
			destroyElement(phoneGUI.image["phoneframe"])
		end
		if isElement(phoneGUI.image["phonewallpaper"]) then
			destroyElement(phoneGUI.image["phonewallpaper"])
		end
		if isCursorShowing() then
			executeCommandHandler("togglecursor")
		end
		
		currentApp = nil
		
		triggerServerEvent("closedPhone", localPlayer, localPlayer, force)
	end
end
addEvent("newphone:close", true)
addEventHandler("newphone:close", localPlayer, phoneClose, false)
--CLOSE PHONE END

addEventHandler("onClientChangeChar", localPlayer, function()
	phoneClose(true)
end, false)

function setupPhoneApp(appType)
	if true then
		return
	end

	if isElement(phoneGUI.image["phonewallpaper"]) then
		destroyElement(phoneGUI.image["phonewallpaper"])
	end
	
	if appType then
		currentApp = appType
		
		if appType == "home" or appType == "pin" then
			if wallpaperURL and string.len(wallpaperURL) > 1 and isURLValid(wallpaperURL) then
				if loadedCustomWallpaper then
					phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, loadedCustomWallpaper, false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
					dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
				else
					local texture = dgsCreateRemoteImage(wallpaperURL)
					if texture then			
						local tex = dgsRemoteImageGetTexture(texture)

						phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, "files/wallpapers/off.png", false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
						dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
						
						addEventHandler("onDgsRemoteImageLoad", texture, function()
							local tex = dgsRemoteImageGetTexture(texture) --Get the texture from remote image
							local maskTex = dxCreateTexture("files/wallpapers/mask.png")  -- Your Mask ( You'd better use black&white texture )
							loadedCustomWallpaper = dgsCreateMask(tex, maskTex)
							
							if currentApp == "home" or currentApp == "pin" then
								dgsImageSetImage(phoneGUI.image["phonewallpaper"], loadedCustomWallpaper)
							end
						end,false)
					else
						phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, "files/wallpapers/"..wallpaperID..".png", false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
						dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
					end
				end
			else
				phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, "files/wallpapers/"..wallpaperID..".png", false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
				dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
			end
			
			if wallpaperColor then
				colorR = wallpaperColor["red"]
				colorG = wallpaperColor["green"]
				colorB = wallpaperColor["blue"]
			else
				colorR = wallpapers[wallpaperID].textColor[1]
				colorG = wallpapers[wallpaperID].textColor[2]
				colorB = wallpapers[wallpaperID].textColor[3]
			end
		elseif appType == "adverts" or appType == "postadvert" or appType == "viewadvert" or appType == "editadvert" then
			phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, "files/wallpapers/greymenu.png", false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
			dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
		elseif appType == "banking" then
			--darkmenu
			phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, "files/wallpapers/darkmenu.png", false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
			dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
		elseif appType == "weather" then
			phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, "files/wallpapers/weather.png", false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
			dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
			
			colorR = 0
			colorG = 0
			colorB = 0
		elseif appType == "snake" then
			phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, "files/wallpapers/snake.png", false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
			dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
			
			colorR = 255
			colorG = 255
			colorB = 255
		elseif appType == "poweroff" then
			phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, "files/wallpapers/off.png", false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
			dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
		else
			--lightmenu
			phoneGUI.image["phonewallpaper"] = dgsCreateImage(13, 0, 369*scaleRatio, 800*scaleRatio, "files/wallpapers/darkmenu.png", false, phoneGUI.image["phoneframe"], tocolor(255,255,255,255))
			dgsCenterElement(phoneGUI.image["phonewallpaper"], true)
			colorR = 255
			colorG = 255
			colorB = 255
		end
	end
	
	--unload these
	if appType ~= "adverts" then
		loadedAdverts = nil
	end
	
	phoneGUI.label["timelabel"] = dgsCreateLabel(18, 5, 74, 10, getPhoneTime(), false, phoneGUI.image["phonewallpaper"], nil, 0.85, 0.85)
	dgsSetFont(phoneGUI.label["timelabel"], phoneFont)
	dgsSetProperty(phoneGUI.label["timelabel"], "textColor", tocolor(colorR, colorG, colorB))
	
	phoneTimeTimer = setTimer(function()
		if phoneGUI.label["timelabel"] and isElement(phoneGUI.label["timelabel"]) then
			dgsSetText(phoneGUI.label["timelabel"], getPhoneTime())
		end
	end, 1000, 0)
	
	phoneGUI.image["network"] = dgsCreateImage(165, 5, 74*scaleRatio, 15*scaleRatio, "files/icons/Network.png", false, phoneGUI.image["phonewallpaper"], tocolor(colorR, colorG, colorB))
	
	if appType == "callfailed" or appType == "phonecalling" or appType == "phonecall" or appType == "phonecalled" then
	
	else
		phoneGUI.image["closephone"] = dgsCreateButton(0, 420, homeIconSize, homeIconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/Home.png", ":newphone/files/icons/Home.png", ":newphone/files/icons/Home.png", tocolor(255, 255, 255, 150), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200))
		dgsCenterElement(phoneGUI.image["closephone"], false, true)
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["closephone"], phoneFunctions)
	end
	
	return true
end

--HOME PAGE START
function phoneAppHome(startCallingPhoneNumber)
	if true then
		return
	end

	setupPhoneApp("home")

	local phoneX = 0
	local phoneY = 0
	local buttonCount = 0
	local totalButtonCount = 0
	
	phoneGUI.scrollpane["homescroll"] = dgsCreateScrollPane(0, 100, 369*scaleRatio, 300, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.scrollpane["homescroll"], "scrollBarThick", 0)
	dgsCenterElement(phoneGUI.scrollpane["homescroll"], false, true)
	for i, v in ipairs(phoneButtons) do
		if totalButtonCount == 12 then
			phoneY = 0
			buttonCount = 0
		elseif totalButtonCount > 11 and buttonCount == 3 then
			phoneX = phoneX - 75*3
			phoneY = phoneY + 70
			buttonCount = 0
		elseif buttonCount == 3 then
			phoneX = 0
			phoneY = phoneY + 70
			buttonCount = 0
		end
		
		--phoneGUI.image[v.name] = dgsCreateImage(10+phoneX, 30+phoneY, iconSize, iconSize, v.image, false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
		phoneGUI.image[v.name] = dgsCreateButton(10+phoneX, 0+phoneY, iconSize, iconSize, "", false, phoneGUI.scrollpane["homescroll"], tocolor(255,255,255,255), 1, 1, ":newphone/"..v.image, ":newphone/"..v.image, ":newphone/"..v.image, tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 210))
		addEventHandler("onDgsMouseClickDown", phoneGUI.image[v.name], phoneFunctions)
		phoneGUI.label[v.displayName] = dgsCreateLabel(0, 50, 50, 10, v.displayName, false, phoneGUI.image[v.name])
		dgsLabelSetHorizontalAlign(phoneGUI.label[v.displayName], "center")
		dgsSetFont(phoneGUI.label[v.displayName], phoneBoldFont)
		phoneX = phoneX + 75
		
		buttonCount = buttonCount + 1
		totalButtonCount = totalButtonCount + 1
		
		dgsSetProperty(phoneGUI.label[v.displayName], "textColor", tocolor(colorR, colorG, colorB))
	end
	
	if totalButtonCount > 12 then -- so far only added support for 24 apps, soz but I don't see us ever needing any more than that LOL I don't even have that many on my IRL phone
		phoneGUI.image["spacer"] = dgsCreateButton(445, 0+phoneY, 0, 1, "", false, phoneGUI.scrollpane["homescroll"])
	end
	
	if startCallingPhoneNumber then
		phoneAppCalling(startCallingPhoneNumber, "phone")
	end
end
--HOME PAGE END

--POWER OFF START
function phoneAppPowerOff()	
	if true then
		return
	end

	setupPhoneApp("poweroff")
	
	phoneGUI.image["poweron"] = dgsCreateImage(0, 200, iconSize, iconSize, "files/icons/Power.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["poweron"], false, true)
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["poweron"], phoneFunctions)
end
--POWER OFF END

--PHONE APP START
function phoneAppPhone()
	if true then
		return
	end

	local phoneNumber = ""
	local areaCode = phoneNumberAreaCode
	
	setupPhoneApp("phone")

	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 30, dxGetTextWidth(phoneTitleText, 0.8, phoneBigBoldFont), 10, phoneTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.image["callhistory"] = dgsCreateButton(185, 28, iconSize/2, iconSize/2, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/callhistory.png", ":newphone/files/icons/callhistory.png", ":newphone/files/icons/callhistory.png")
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["callhistory"], function()
		if source == phoneGUI.image["callhistory"] then
			phoneAppCallHistory()
		end
	end)
	
	phoneGUI.image["seperator"] = dgsCreateImage(10, 60, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	phoneGUI.label["phonenumber"] = dgsCreateLabel(10, 70, 162, 10, areaCode..""..phoneNumber, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["phonenumber"], "textColor", tocolor(255, 255, 255, 255))
	dgsSetFont(phoneGUI.label["phonenumber"], phoneBigBoldFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["phonenumber"], "center")
	dgsCenterElement(phoneGUI.label["phonenumber"], false, true)
	
	phoneGUI.image["seperator"] = dgsCreateImage(10, 100, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	--DIAL BUTTONS START
	local left = 20
	local startX = 0
	local startY = 0
	local buttonCount = 0
	
	local dialButtons = {
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
		[9] = true,
		[10] = true,
		[11] = true,
		[12] = true,
	}
	
	for k, v in ipairs(dialButtons) do		
		if buttonCount == 3 then
			startY = startY + 70
			startX = 0
			buttonCount = 0
		end
		
		if k == 10 then
			k = "cancel"
		elseif k == 11 then
			k = 0
		elseif k == 12 then	
			k = "call"
		end
		
		phoneGUI.image["dialbutton"..k] = dgsCreateButton(left+startX, 130+startY, iconSize, iconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/"..k..".png", ":newphone/files/icons/numbers/"..k..".png", ":newphone/files/icons/numbers/"..k..".png", tocolor(255, 255, 255, 150), tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255))
		if tonumber(k) then
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["dialbutton"..k], function()
				if source == phoneGUI.image["dialbutton"..k] then
					if tostring(phoneNumber) and  string.len(tostring(phoneNumber)) < 6 then
						phoneNumber = phoneNumber..""..k
						dgsSetText(phoneGUI.label["phonenumber"], areaCode..""..phoneNumber)
					end
				end
			end)
		elseif k == "cancel" then
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["dialbutton"..k], function()
				if source == phoneGUI.image["dialbutton"..k] then
					phoneNumber = ""
					dgsSetText(phoneGUI.label["phonenumber"], areaCode..""..phoneNumber)
				end
			end)
		elseif k == "call" then
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["dialbutton"..k], function()
				if source == phoneGUI.image["dialbutton"..k] then	
					phoneAppCalling(phoneNumber)
				end
			end)
		end
		
		startX = startX + 65
		buttonCount = buttonCount + 1
	end
end
--PHONE APP END

--PHONE CALLED START
function phoneAppCalled(caller, number, displayNumber)
	if true then
		return
	end

	if caller and number and displayNumber then
		setupPhoneApp("phonecalled")
		
		local areaCode = phoneNumberAreaCode
	
		callingEnd = ""
		phoneGUI.label["callinglabel"] = dgsCreateLabel(10, 35, 160, 10, ""..incomingCallText..""..callingEnd.."", false, phoneGUI.image["phonewallpaper"], false, 0.6, 0.6)
		dgsLabelSetHorizontalAlign(phoneGUI.label["callinglabel"], "center")
		dgsSetProperty(phoneGUI.label["callinglabel"], "textColor", pageTitleColor)
		dgsSetFont(phoneGUI.label["callinglabel"], phoneBigBoldFont)
		dgsCenterElement(phoneGUI.label["callinglabel"], false, true)
		
		phoneCallingTextTimer = setTimer ( function()
			if isElement(phoneGUI.label["callinglabel"]) then
				if callingEnd == "..." then
					callingEnd = ""
				else
					callingEnd = callingEnd.."."
				end
				
				dgsSetText(phoneGUI.label["callinglabel"], ""..incomingCallText..""..callingEnd.."")
			else
				if isTimer(phoneCallingTextTimer) then
					killTimer(phoneCallingTextTimer)
				end
			end
		end, 300, 0 )
		
		contactName = nil
		if loadedContacts then
			for k, v in pairs(loadedContacts) do
				if tonumber(k) == tonumber(number) then
					contactName = v.name
				end
			end
		end
		
		if tonumber(displayNumber) then
			if contactName then
				phoneGUI.label["phonecontact"] = dgsCreateLabel(10, 130, 162, 10, contactName, false, phoneGUI.image["phonewallpaper"], false, 1, 1)
				dgsSetProperty(phoneGUI.label["phonecontact"], "textColor", tocolor(255, 255, 255, 200))
				dgsSetFont(phoneGUI.label["phonecontact"], phoneBoldFont)
				dgsLabelSetHorizontalAlign(phoneGUI.label["phonecontact"], "center")
				dgsCenterElement(phoneGUI.label["phonecontact"], false, true)
			end
		end
		
		if tonumber(displayNumber) then
			numberText = areaCode..""..displayNumber
		else
			numberText = displayNumber
		end
		
		phoneGUI.label["phonenumber"] = dgsCreateLabel(10, 150, 162, 10, numberText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsSetProperty(phoneGUI.label["phonenumber"], "textColor", tocolor(255, 255, 255, 200))
		dgsSetFont(phoneGUI.label["phonenumber"], phoneBigBoldFont)
		dgsLabelSetHorizontalAlign(phoneGUI.label["phonenumber"], "center")
		dgsCenterElement(phoneGUI.label["phonenumber"], false, true)
		
		local width, height = dgsGetSize(phoneGUI.image["phonewallpaper"], false)
		phoneGUI.image["endcall"] = dgsCreateButton(width-iconSize-20, 350, iconSize, iconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/endcall.png", ":newphone/files/icons/numbers/endcall.png", ":newphone/files/icons/numbers/endcall.png", tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255))
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["endcall"], function()
			if source == phoneGUI.image["endcall"] then
				local caller = getElementData(localPlayer, "phonecall")
				triggerServerEvent("endPhoneCall", localPlayer, localPlayer, currentPhoneNumber, number)
			end
		end)
		
		phoneGUI.image["answercall"] = dgsCreateButton(20, 350, iconSize, iconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255))
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["answercall"], function()			
			if source == phoneGUI.image["answercall"] then
				triggerServerEvent("answerPhoneCall", localPlayer, currentPhoneNumber, displayNumber, localPlayer, caller)
			end
		end)
	else
		phoneAppHome()
	end
end
addEvent("showNewCall", true)
addEventHandler("showNewCall", root, phoneAppCalled)
--PHONE CALLED END

--PHONE CALL START
function phoneAppCall(caller, number)	
	if caller and number then
		if isTimer(phoneCallOutTimer) then
			killTimer(phoneCallOutTimer)
		end
		if isElement(diallingSound) then
			destroyElement(diallingSound)
		end

		if true then
			return
		end
				
		local areaCode = phoneNumberAreaCode
	
		setupPhoneApp("phonecall")
		
		local minutes = 0
		local seconds = 0
		local callTime = string.format("%02d:%02d", minutes, seconds)
		
		phoneGUI.label["calllabel"] = dgsCreateLabel(10, 35, 160, 10, callTime, false, phoneGUI.image["phonewallpaper"], false, 0.6, 0.6)
		dgsLabelSetHorizontalAlign(phoneGUI.label["calllabel"], "center")
		dgsSetProperty(phoneGUI.label["calllabel"], "textColor", pageTitleColor)
		dgsSetFont(phoneGUI.label["calllabel"], phoneBigBoldFont)
		dgsCenterElement(phoneGUI.label["calllabel"], false, true)
		
		local minutes = 0
		local seconds = 0
		phoneCallTimer = setTimer ( function()
			if isElement(phoneGUI.label["calllabel"]) then
				if seconds + 1 == 60 then
					minutes = minutes + 1
					seconds = 0
				else
					seconds = seconds + 1
				end
				
				callTime = string.format("%02d:%02d", minutes, seconds)
			
				dgsSetText(phoneGUI.label["calllabel"], callTime)
			else
				if isTimer(phoneCallTimer) then
					killTimer(phoneCallTimer)
				end
			end
		end, 1000, 0 )
		
		if loadedContacts then
			for k, v in pairs(loadedContacts) do
				if k == number then
					contactName = v.name
				end
			end
		end
		
		if contactName then
			phoneGUI.label["phonecontact"] = dgsCreateLabel(10, 130, 162, 10, contactName, false, phoneGUI.image["phonewallpaper"], false, 1, 1)
			dgsSetProperty(phoneGUI.label["phonecontact"], "textColor", tocolor(255, 255, 255, 200))
			dgsSetFont(phoneGUI.label["phonecontact"], phoneBoldFont)
			dgsLabelSetHorizontalAlign(phoneGUI.label["phonecontact"], "center")
			
			dgsCenterElement(phoneGUI.label["phonecontact"], false, true)
		end
		
		if tonumber(number) then
			numberText = areaCode..""..number
		else
			numberText = number
		end
		
		phoneGUI.label["phonenumber"] = dgsCreateLabel(10, 150, 162, 10, numberText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsSetProperty(phoneGUI.label["phonenumber"], "textColor", tocolor(255, 255, 255, 200))
		dgsSetFont(phoneGUI.label["phonenumber"], phoneBigBoldFont)
		dgsLabelSetHorizontalAlign(phoneGUI.label["phonenumber"], "center")
		dgsCenterElement(phoneGUI.label["phonenumber"], false, true)
		
		local loudspeaker = false
		phoneGUI.image["loudspeaker"] = dgsCreateButton(369*scaleRatio/2 - iconSize/2, 250, iconSize, iconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/loudspeakeroff.png", ":newphone/files/icons/numbers/loudspeakeron.png", ":newphone/files/icons/numbers/loudspeakeron.png", tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255))
		dgsCenterElement(phoneGUI.image["loudspeaker"], true, true)
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["loudspeaker"], function()
			if source == phoneGUI.image["loudspeaker"] then
				if loudspeaker == false then
					triggerServerEvent("loudspeakerPhone", localPlayer, localPlayer, 1)
					loudspeaker = true
					dgsSetProperty(phoneGUI.image["loudspeaker"], "image",{":newphone/files/icons/numbers/loudspeakeron.png", ":newphone/files/icons/numbers/loudspeakeroff.png", ":newphone/files/icons/numbers/loudspeakeroff.png"})
				else
					triggerServerEvent("loudspeakerPhone", localPlayer, localPlayer, 0)
					loudspeaker = false
					dgsSetProperty(phoneGUI.image["loudspeaker"], "image",{":newphone/files/icons/numbers/loudspeakeroff.png", ":newphone/files/icons/numbers/loudspeakeron.png", ":newphone/files/icons/numbers/loudspeakeron.png"})
				end
			end
		end)
		
		phoneGUI.image["endcall"] = dgsCreateButton(20, 350, iconSize, iconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/endcall.png", ":newphone/files/icons/numbers/endcall.png", ":newphone/files/icons/numbers/endcall.png", tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255))
		dgsCenterElement(phoneGUI.image["endcall"], true, true)
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["endcall"], function()
			if source == phoneGUI.image["endcall"] then
				local caller = getElementData(localPlayer, "phonecall")
				triggerServerEvent("endPhoneCall", localPlayer, localPlayer, currentPhoneNumber, number)
			end
		end)
		dgsCenterElement(phoneGUI.image["endcall"], false, true)
	else
		phoneAppHome()
	end
end
addEvent("phoneCallShow", true)
addEventHandler("phoneCallShow", root, phoneAppCall)
--PHONE CALL END

local resetPhoneStateTimer
--PHONE CALLING START
function phoneAppCalling(phoneNumber, app)
	if phoneShowing then
		diallingSound = playSound("files/sounds/calling.mp3", true, false)

		if true then
			return
		end

		local areaCode = phoneNumberAreaCode
		
		setupPhoneApp("phonecalling")
		
		callingEnd = ""
		phoneGUI.label["callinglabel"] = dgsCreateLabel(10, 35, 160, 10, ""..callingText..""..callingEnd.."", false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsLabelSetHorizontalAlign(phoneGUI.label["callinglabel"], "center")
		dgsSetProperty(phoneGUI.label["callinglabel"], "textColor", pageTitleColor)
		dgsSetFont(phoneGUI.label["callinglabel"], phoneBigBoldFont)
		dgsCenterElement(phoneGUI.label["callinglabel"], false, true)
		
		phoneCallingTextTimer = setTimer ( function()
			if isElement(phoneGUI.label["callinglabel"]) then
				if callingEnd == "..." then
					callingEnd = ""
				else
					callingEnd = callingEnd.."."
				end
				
				dgsSetText(phoneGUI.label["callinglabel"], ""..callingText..""..callingEnd.."")
			else
				if isElement(diallingSound) then
					destroyElement(diallingSound)
				end
				if isTimer(phoneCallingTextTimer) then
					killTimer(phoneCallingTextTimer)
				end
			end
		end, 300, 0 )
		
		contactName = nil
		
		if hotlineNumbers[tonumber(phoneNumber)] then
			contactName = hotlineNumbers[tonumber(phoneNumber)].name
		else
			if loadedContacts then
				for k, v in pairs(loadedContacts) do
					if k == phoneNumber then
						contactName = v.name
					end
				end
			end
		end
		
		if contactName then
			phoneGUI.label["phonecontact"] = dgsCreateLabel(10, 130, 162, 10, contactName, false, phoneGUI.image["phonewallpaper"], false, 1, 1)
			dgsSetProperty(phoneGUI.label["phonecontact"], "textColor", tocolor(255, 255, 255, 200))
			dgsSetFont(phoneGUI.label["phonecontact"], phoneBoldFont)
			dgsLabelSetHorizontalAlign(phoneGUI.label["phonecontact"], "center")
			dgsCenterElement(phoneGUI.label["phonecontact"], false, true)
		end

		if isTimer(resetPhoneStateTimer) then
			killTimer(resetPhoneStateTimer)
		end
		resetPhoneStateTimer = nil
		
		--triggerServerEvent("callANumber", localPlayer, localPlayer, currentPhoneNumber, phoneNumber, app)
		
		phoneCallOutTimer = setTimer ( function()
			local called = getElementData(localPlayer, "phonecall")
			if called then
				triggerServerEvent("endPhoneCall", localPlayer, localPlayer, currentPhoneNumber, phoneNumber)
			end
			phoneCallOutTimer = nil
		end, 60000, 1 )
		
		phoneGUI.label["phonenumber"] = dgsCreateLabel(10, 150, 162, 10, areaCode..""..phoneNumber, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsSetProperty(phoneGUI.label["phonenumber"], "textColor", tocolor(255, 255, 255, 200))
		dgsSetFont(phoneGUI.label["phonenumber"], phoneBigBoldFont)
		dgsLabelSetHorizontalAlign(phoneGUI.label["phonenumber"], "center")
		dgsCenterElement(phoneGUI.label["phonenumber"], false, true)
		
		phoneGUI.image["endcall"] = dgsCreateButton(0, 350, iconSize, iconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/endcall.png", ":newphone/files/icons/numbers/endcall.png", ":newphone/files/icons/numbers/endcall.png", tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255))
		dgsCenterElement(phoneGUI.image["endcall"], false, true)
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["endcall"], function()
			if source == phoneGUI.image["endcall"] then
				if isTimer(phoneCallOutTimer) then
					killTimer(phoneCallOutTimer)
				end
				phoneCallOutTimer = nil

				local called = getElementData(localPlayer, "phonecall")
				if called then
					triggerServerEvent("endPhoneCall", localPlayer, localPlayer, currentPhoneNumber, phoneNumber)
				end
				
				if app == "contacts" then
					phoneAppContacts()
				else
					phoneAppPhone()
				end
				--ADD END CALL STUFF HERE
			end
		end)
	end
end
--PHONE CALLING END 

--CALL HISTORY APP START
function phoneAppCallHistory()
	if true then
		return
	end

	setupPhoneApp("callhistory")
	
	phoneGUI.label["messageslabel"] = dgsCreateLabel(20*scaleRatio, 70, dxGetTextWidth(callHistoryTitleText, 0.8, phoneBigBoldFont), 10, callHistoryTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["messageslabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["messageslabel"], phoneBigBoldFont)
	
	phoneGUI.image["deletecallhistory"] = dgsCreateButton(185, 68, iconSize/2, iconSize/2, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/delete.png", ":newphone/files/icons/delete.png", ":newphone/files/icons/delete.png")
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["deletecallhistory"], function()
		loadedCallHistory = {}
		triggerServerEvent("phoneWipeCallHistory", localPlayer, localPlayer, currentPhoneNumber)
		phoneAppPhone()
	end, false)
	
	phoneGUI.image["seperator"] = dgsCreateImage(5, 100, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	phoneGUI.gridlist["notesgridlist"] = dgsCreateGridList(0, 102, 369*scaleRatio, 288, false, phoneGUI.image["phonewallpaper"])
	dgsSetFont(phoneGUI.gridlist["notesgridlist"], phoneFont)
	dgsGridListAddColumn(phoneGUI.gridlist["notesgridlist"], "", 0.8)
	dgsGridListAddColumn(phoneGUI.gridlist["notesgridlist"], "", 0.18)
	dgsSetFont(phoneGUI.gridlist["notesgridlist"], phoneFont)
	dgsSetProperty(phoneGUI.gridlist["notesgridlist"],"leading", 15)
	dgsSetProperty(phoneGUI.gridlist["notesgridlist"], "columnHeight", 0)
	dgsSetProperty(phoneGUI.gridlist["notesgridlist"], "scrollBarThick", 0)
	dgsSetProperty(phoneGUI.gridlist["notesgridlist"], "bgColor", tocolor(0, 0, 0, 20))
	dgsSetProperty(phoneGUI.gridlist["notesgridlist"], "rowTextColor", tocolor(255, 255, 255, 150))
	dgsSetProperty(phoneGUI.gridlist["notesgridlist"], "rowColor", {tocolor(100, 100, 100, 40), tocolor(249,139,6, 80), tocolor(249,139,6, 100)})
	dgsSetProperty(phoneGUI.gridlist["notesgridlist"], "rowHeight", 45)
	dgsSetProperty(phoneGUI.gridlist["notesgridlist"], "rowTextPosOffset", {2, 0})
	dgsSetProperty(phoneGUI.gridlist["notesgridlist"], "rowTextSize", {0.8, 0.8})
	
	if loadedCallHistory then
		local reversedCallHistory = table.reverse(loadedCallHistory)
		for i, v in ipairs(reversedCallHistory) do
			local row = dgsGridListAddRow(phoneGUI.gridlist["notesgridlist"])
			if v.hiddenNumber and tonumber(v.hiddenNumber) == 1 then
				displayHistoryNumber = hiddenNumberText
			elseif loadedContacts and loadedContacts[tostring(v.number)] then
				displayHistoryNumber = loadedContacts[tostring(v.number)].name
			else
				displayHistoryNumber = v.number
			end
			
			if v.inout and tonumber(v.inout) == 1 then
				inOrOut = inText
			else
				inOrOut = outText
			end
			
			--CHANGE THIS TO V.TIMEDATE
			dgsGridListSetItemText(phoneGUI.gridlist["notesgridlist"], row, 1, ""..inOrOut.." "..os.date("%x", v.timedate).." "..os.date("%X", v.timedate).." - "..displayHistoryNumber.."")
			dgsGridListSetItemData(phoneGUI.gridlist["notesgridlist"], row, 1, v.number)
			
			if displayHistoryNumber ~= hiddenNumberText then
				phoneGUI.image["callhotline"..v.number] = dgsCreateButton(0, 10, iconSize/2.2, iconSize/2.2, "", false, phoneGUI.gridlist["contactsgridlist"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200))
				dgsAttachToGridList(phoneGUI.image["callhotline"..v.number], phoneGUI.gridlist["notesgridlist"], row, 2)
				
				addEventHandler("onDgsMouseClickDown", phoneGUI.image["callhotline"..v.number], function()
					phoneAppCalling(v.number, "phone")
				end, false)
			end
		end
	end
end
--CALL HISTORY APP END

function reloadCallHistory(phoneNumber, callHistory)
	if tonumber(phoneNumber) == tonumber(currentPhoneNumber) then
		loadedCallHistory = fromJSON(callHistory)
	end
end
addEvent("reloadCallHistory", true)
addEventHandler("reloadCallHistory", root, reloadCallHistory)

--PHONE CALL FAILED START
function phoneCallFailed(phoneNumber, failType, app, calltype)
	if phoneShowing then
		if isTimer(phoneCallingTextTimer) then
			killTimer(phoneCallingTextTimer)
		end
		phoneCallingTextTimer = nil

		if isElement(diallingSound) then
			destroyElement(diallingSound)
		end
		
		local areaCode = phoneNumberAreaCode
		
		setupPhoneApp("callfailed")
		
		if failType == "Busy" then
			failText = lineBusyText
			busySound = playSound("files/sounds/busy.mp3", true, false)
		else
			failText = callDisconnectedText
			busySound = playSound("files/sounds/hangup.mp3", false, false)
		end
		
		--[[ phoneGUI.label["callinglabel"] = dgsCreateLabel(10, 35, 160, 10, failText, false, phoneGUI.image["phonewallpaper"], false, 0.7, 0.7)
		dgsLabelSetHorizontalAlign(phoneGUI.label["callinglabel"], "center")
		dgsSetProperty(phoneGUI.label["callinglabel"], "textColor", pageTitleColor)
		dgsSetFont(phoneGUI.label["callinglabel"], phoneBigBoldFont)
		dgsCenterElement(phoneGUI.label["callinglabel"], false, true)
		
		if hotlineNumbers[tonumber(phoneNumber)] then
			contactName = hotlineNumbers[tonumber(phoneNumber)].name
		else
			if loadedContacts then
				for k, v in pairs(loadedContacts) do
					if k == phoneNumber then
						contactName = v.name
					end
				end
			end
		end
		
		if contactName then
			phoneGUI.label["phonecontact"] = dgsCreateLabel(10, 130, 162, 10, contactName, false, phoneGUI.image["phonewallpaper"], false, 1, 1)
			dgsSetProperty(phoneGUI.label["phonecontact"], "textColor", tocolor(255, 255, 255, 200))
			dgsSetFont(phoneGUI.label["phonecontact"], phoneBoldFont)
			dgsLabelSetHorizontalAlign(phoneGUI.label["phonecontact"], "center")
			dgsCenterElement(phoneGUI.label["phonecontact"], false, true)
		end
		
		phoneGUI.label["phonenumber"] = dgsCreateLabel(10, 150, 162, 10, areaCode..""..phoneNumber, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsSetProperty(phoneGUI.label["phonenumber"], "textColor", tocolor(255, 255, 255, 200))
		dgsSetFont(phoneGUI.label["phonenumber"], phoneBigBoldFont)
		dgsLabelSetHorizontalAlign(phoneGUI.label["phonenumber"], "center")
		dgsCenterElement(phoneGUI.label["phonenumber"], false, true) *]]
		
		resetPhoneStateTimer = setTimer ( function()
			--[[ if app == "contacts" then
				phoneAppContacts()
			else
				phoneAppPhone()
			end *]]
			
			if isElement(busySound) then
				destroyElement(busySound)
			end
		end, 2000, 1 )
		
		triggerServerEvent("phoneInsertCallHistory", localPlayer, localPlayer, currentPhoneNumber, phoneNumber, loadedCallHistory)
	end
end
addEvent("phoneCallFailed", true)
addEventHandler("phoneCallFailed", root, phoneCallFailed)
--PHONE CALL FAILED END

--PHONE FUNCTIONS START
function phoneFunctions(button)
	if true then
		return
	end

	if button == "right" then
		if source == phoneGUI.image["closephone"] then
			if currentApp == "home" or currentApp == "pin" then
				phoneAppPowerOff()
				triggerServerEvent("phonePowerState", localPlayer, localPlayer, currentPhoneNumber, 0)
			end
		end
	end
	
	if source == phoneGUI.image["settings"] then
		phoneAppSettings()
	elseif source == phoneGUI.image["phone"] then
		phoneAppPhone()
	elseif source == phoneGUI.image["notes"] then
		phoneAppNotes()
	elseif source == phoneGUI.image["health"] then
		phoneAppHealth()
	elseif source == phoneGUI.image["weather"] then
		phoneAppWeather()
	elseif source == phoneGUI.image["poweron"] then
		if currentPin and string.len(currentPin) == 4 then
			phoneAppPIN(currentPin)
			triggerServerEvent("phonePowerState", localPlayer, localPlayer, currentPhoneNumber, 1)
		else
			phoneAppHome()
			currentPin = nil
			triggerServerEvent("phonePowerState", localPlayer, localPlayer, currentPhoneNumber, 1)
		end
	elseif source == phoneGUI.image["home"] then
		if isElement(ringtonePreview) then
			destroyElement(ringtonePreview)
		end
		phoneAppHome()
	elseif source == phoneGUI.image["contacts"] then
		phoneAppContacts()
	elseif source == phoneGUI.image["messages"] then
		phoneAppMessages()
	elseif source == phoneGUI.image["phonebook"] then
		phoneAppPhonebook()
	elseif source == phoneGUI.image["maps"] then
		phoneAppMaps()
	elseif source == phoneGUI.image["wallet"] then
		phoneAppBanking()
	elseif source == phoneGUI.image["adverts"] then
		phoneAppAdverts()
	elseif source == phoneGUI.image["youtube"] then
		phoneAppYouTube()
	elseif source == phoneGUI.image["closephone"] then
		if currentApp == "home" or currentApp == "pin" or currentApp == "poweroff" then
			phoneClose()
		elseif currentApp == "editnote" then
			phoneAppNotes()
		elseif currentApp == "postadvert" or currentApp == "viewadvert" or currentApp == "editadvert" then
			phoneAppAdverts()
		elseif currentApp == "newmessage" or currentApp == "openmessage" then
			phoneAppMessages()
		elseif currentApp == "callhistory" then
			phoneAppPhone()
		elseif currentApp == "settingspage" then
			if ringtonePreview and isElement(ringtonePreview) then
				destroyElement(ringtonePreview)
				ringtonePreview = nil
			end
			
			phoneAppSettings()
		elseif currentApp == "pinsettingspage" then
			phoneAppSettingsSecurity()
		elseif currentApp == "customwallpaper" then
			phoneAppSettingsWallpaper()
		elseif currentApp == "editcontact" then
			phoneAppContacts()
		elseif currentApp == "maps" then	
			removeEventHandler("onClientRender", root, drawDXMap)
			
			phoneAppHome()
		elseif currentApp == "youtube" then
			if webBrowser and getBrowserURL(webBrowser) == "https://www.youtube.com/" then
				phoneAppHome()
			else
				loadBrowserURL(webBrowser, "https://youtube.com")
			end
		elseif currentApp == "youtubemusic" then
			if webBrowser and getBrowserURL(webBrowser) == "https://music.youtube.com/" then
				phoneAppHome()
			else
				loadBrowserURL(webBrowser, "https://music.youtube.com")
			end
		else
			phoneAppHome()
		end
	end
end
--PHONE FUNCTIONS END

--BWC FUNCTIONS START
function radioDispatchBeep()
	playSound("files/sounds/dispatch.mp3", false)
end
addEvent("phones:radioDispatchBeep", true)
addEventHandler("phones:radioDispatchBeep", getRootElement(), radioDispatchBeep)

p_Sound = {}
t_Sound = {}

function startPhoneRinging(ringType, ringtone)
	if not ringtone then ringtone = 5 end
	
	if isElement(p_Sound[source]) then
		destroyElement(p_Sound[source])
		p_Sound[source] = nil
	end
	
	if ringtone > 0 then
		local x, y, z = getElementPosition(source)
		if ringType == 1 then -- phone call
		
			p_Sound[source] = playSound3D(ringtones[ringtone].sound, x, y, z , true)
			setSoundVolume(p_Sound[source], 0.4)
			setSoundMaxDistance(p_Sound[source], 22)
			setElementDimension(p_Sound[source], getElementDimension(source))
			setElementInterior(p_Sound[source], getElementInterior(source))
			attachElements(p_Sound[source], source)
		end
	end
end
addEvent("startRinging", true)
addEventHandler("startRinging", getRootElement(), startPhoneRinging)

function playMessageTone(messagetone)
	if not messagetone then messagetone = 4 end
	
	if isElement(t_Sound[source]) then
		destroyElement(t_Sound[source])
		t_Sound[source] = nil
	end
	
	if messagetone > 0 then
		local x, y, z = getElementPosition(source)
		t_Sound[source] = playSound3D(messagetones[messagetone].sound, x, y, z)
		setSoundVolume(t_Sound[source], 0.4)
		setSoundMaxDistance(t_Sound[source], 22)
		setElementDimension(t_Sound[source], getElementDimension(source))
		setElementInterior(t_Sound[source], getElementInterior(source))
	end
end
addEvent("playMessageTone", true)
addEventHandler("playMessageTone", getRootElement(), playMessageTone)

function stopPhoneRinging()
	if isElement(p_Sound[source]) then
		destroyElement(p_Sound[source])
	end
end
addEvent("stopRinging", true)
addEventHandler("stopRinging", getRootElement(), stopPhoneRinging)
--BWC FUNCTIONS END 