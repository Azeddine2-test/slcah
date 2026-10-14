ringtonePreview = nil

--SETTINGS APP START
function phoneAppSettings()
	setupPhoneApp("settings")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 140*scaleRatio, dxGetTextWidth(newContactTitleText, 0.8, phoneBigBoldFont), 10, settingsTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	local soundSettingsEntries = {
		{name="silent"},
		{name="vibrate"},
		{name="loud"},
	}
	
	local startSY = 250
	local startSX = 55
	
	phoneGUI.label["soundlabel"] = dgsCreateLabel(20*scaleRatio, (startSY-30)*scaleRatio, dxGetTextWidth(newContactTitleText, 1, phoneFont), 10, soundModeText, false, phoneGUI.image["phonewallpaper"], false, 1, 1)
	dgsSetProperty(phoneGUI.label["soundlabel"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["soundlabel"], phoneFont)
	dgsCenterElement(phoneGUI.label["soundlabel"], false, true)
	dgsLabelSetHorizontalAlign(phoneGUI.label["soundlabel"], "center")
	
	local soundModeSound = nil
	local soundColour = tocolor(255, 255, 255)
	for k, v in ipairs(soundSettingsEntries) do
		if currentSoundMode == k then
			soundColour = tocolor(249,139,6)
		else
			soundColour = tocolor(255, 255, 255)
		end
		
		phoneGUI.button[tostring(v.name)] = dgsCreateImage(startSX, (startSY)*scaleRatio, 54*scaleRatio, 54*scaleRatio, "files/icons/"..v.name..".png", false, phoneGUI.image["phonewallpaper"], soundColour)
		
		startSX = startSX + 64*scaleRatio
		
		addEventHandler("onDgsMouseClickDown", phoneGUI.button[tostring(v.name)], function()
			dgsSetProperty(phoneGUI.button["silent"], "color", tocolor(255, 255, 255))
			dgsSetProperty(phoneGUI.button["vibrate"], "color", tocolor(255, 255, 255))
			dgsSetProperty(phoneGUI.button["loud"], "color", tocolor(255, 255, 255))
			dgsSetProperty(phoneGUI.button["loud"], "color", tocolor(255, 255, 255))
			
			dgsSetProperty(phoneGUI.button[tostring(v.name)], "color", tocolor(249,139,6))
			
			local volume = messagetones[messageToneID].volume / 2
			if messageToneID == 4 then
				volume = 1
			end
			
			if currentSoundMode ~= k and k == 2 then
				if soundModeSound and isElement(soundModeSound) then destroyElement(soundModeSound) end
				local x, y, z = getElementPosition(localPlayer)
				soundModeSound = playSound3D(messagetones[4].sound, x, y, z)
			elseif currentSoundMode ~= k and k == 3 then
				if soundModeSound and isElement(soundModeSound) then destroyElement(soundModeSound) end
				local x, y, z = getElementPosition(localPlayer)
				soundModeSound = playSound3D(messagetones[messageToneID].sound, x, y, z)
				setSoundVolume(soundModeSound, volume)
			else
				if soundModeSound and isElement(soundModeSound) then destroyElement(soundModeSound) end
			end
			
			triggerServerEvent("phoneSetSoundModeState", localPlayer, localPlayer, currentPhoneNumber, k)
			
			currentSoundMode = k
		end, false)
	end
	
	local settingsEntries = {
		{name="Fond d'écran"},
		{name="Sonnerie"},
		{name="Sonnerie SMS"},
		{name="Sécurité"},
	}
	
	local startSY = 350
	for k, v in ipairs(settingsEntries) do
		phoneGUI.button[tostring(v.name)] = dgsCreateButton(0, (startSY)*scaleRatio, 300*scaleRatio, 50*scaleRatio, v.name, false, phoneGUI.image["phonewallpaper"])
		addEventHandler("onDgsMouseClickDown", phoneGUI.button[tostring(v.name)], function()
			if dgsGetText(source) == "Fond d'écran" then
				phoneAppSettingsWallpaper()
			elseif dgsGetText(source) == "Sonnerie" then
				phoneAppSettingsRingtone()
			elseif dgsGetText(source) == "Sonnerie SMS" then
				phoneAppSettingsMessagetone()
			elseif dgsGetText(source) == "Sécurité" then
				phoneAppSettingsSecurity()
			end
		end, false)
		dgsCenterElement(phoneGUI.button[tostring(v.name)], false, true)
		
		startSY = startSY + 65
	end
	
	phoneGUI.label["hidemycallerid"] = dgsCreateLabel(40*scaleRatio, (startSY+30)*scaleRatio, dxGetTextWidth(hideCallerIDText, 1, phoneFont), 10, hideCallerIDText, false, phoneGUI.image["phonewallpaper"], false, 1, 1)
	dgsSetProperty(phoneGUI.label["hidemycallerid"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["hidemycallerid"], phoneFont)
	
	local isNumberHidden = false
	if hideNumber and hideNumber == 1 then
		isNumberHidden = true
	end
	phoneGUI.button["calleridswitch"] = dgsCreateSwitchButton(275*scaleRatio, (startSY+28)*scaleRatio, 40*scaleRatio, 30*scaleRatio, nil, nil, isNumberHidden, false, phoneGUI.image["phonewallpaper"])
	addEventHandler("onDgsMouseClickDown", phoneGUI.button["calleridswitch"], function()
		if isNumberHidden == true then
			isNumberHidden = false
			hideNumber = 0
		else
			isNumberHidden = true
			hideNumber = 1
		end
		
		triggerServerEvent("phoneHideNumberState", localPlayer, localPlayer, currentPhoneNumber, not isNumberHidden)
	end, false)
end

function phoneAppSettingsWallpaper()
	setupPhoneApp("settingspage")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 80*scaleRatio, dxGetTextWidth(newContactTitleText, 0.8, phoneBigBoldFont), 10, wallpaperSettingsTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.scrollpane["settingscroll"] = dgsCreateScrollPane(0, 150*scaleRatio, 369*scaleRatio, (800-350)*scaleRatio, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.scrollpane["settingscroll"], "scrollBarThick", 0)
	dgsCenterElement(phoneGUI.scrollpane["settingscroll"], false, true)
	
	local currentSelectedWallpaper = wallpaperID
	local startY, startX = 0, 25
	for i, v in ipairs(wallpapers) do
		phoneGUI.image["phonewallpaperpreview"..i..""] = dgsCreateImage(startX*scaleRatio, startY*scaleRatio, 369*scaleRatio/3.8, 800*scaleRatio/3.8, v.image, false, phoneGUI.scrollpane["settingscroll"], tocolor(255,255,255,255))
		startX = startX + 700*scaleRatio/3.8
		
		if i == wallpaperID then
			phoneGUI.image["phonewallpaperpreviewtick"] = dgsCreateImage((369*scaleRatio/3.8)-25*scaleRatio, 0*scaleRatio, 25*scaleRatio, 25*scaleRatio, "files/icons/selected.png", false, phoneGUI.image["phonewallpaperpreview"..i..""], tocolor(255,255,255,255))
		end
		
		if startX > 300 then
			startX = 25
			startY = startY + 1500*scaleRatio/3.8
		end
		
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["phonewallpaperpreview"..i..""], function()
			if phoneGUI.image["phonewallpaperpreviewtick"] and isElement(phoneGUI.image["phonewallpaperpreviewtick"]) then destroyElement(phoneGUI.image["phonewallpaperpreviewtick"]) end
			
			phoneGUI.image["phonewallpaperpreviewtick"] = dgsCreateImage((369*scaleRatio/3.8)-25*scaleRatio, 0*scaleRatio, 25*scaleRatio, 25*scaleRatio, "files/icons/selected.png", false, phoneGUI.image["phonewallpaperpreview"..i..""], tocolor(255,255,255,255))
			
			currentSelectedWallpaper = i
			
			if currentSelectedWallpaper ~= wallpaperID then
				dgsSetEnabled(phoneGUI.button["savewallpaper"], true)
			else
				dgsSetEnabled(phoneGUI.button["savewallpaper"], false)
			end
		end, false)
	end
	
	--dgsGridListSetSelectedItem(phoneGUI.gridlist["wallpapers"], wallpaperID)
	
	--[[addEventHandler("onDgsMouseClickDown", phoneGUI.gridlist["wallpapers"], function ()
		if source == phoneGUI.gridlist["wallpapers"] then
			local selected = dgsGridListGetSelectedItem(phoneGUI.gridlist["wallpapers"])
			if selected == -1 then
				dgsGridListSetSelectedItem(phoneGUI.gridlist["wallpapers"], wallpaperID)
				dgsImageSetImage(phoneGUI.image["phonewallpaperpreview"], ""..wallpapers[wallpaperID].image.."")
				return
			end
			
			dgsImageSetImage(phoneGUI.image["phonewallpaperpreview"], ""..wallpapers[selected].image.."")
		end
	end)]]
	
	phoneGUI.button["savewallpaper"] = dgsCreateButton(125*scaleRatio, 625*scaleRatio, 225*scaleRatio, 50*scaleRatio, saveWallpaperText, false, phoneGUI.image["phonewallpaper"])
	dgsCenterElement(phoneGUI.button["savewallpaper"], false, true)
	dgsSetEnabled(phoneGUI.button["savewallpaper"], false)
	addEventHandler ( "onDgsMouseClickDown", phoneGUI.button["savewallpaper"], function ()
		if source == phoneGUI.button["savewallpaper"] then			
			if wallpaperID ~= currentSelectedWallpaper then
				if currentSelectedWallpaper == customWallpaperID then
					phoneAppCustomWallpaper()
				else
					wallpaperURL = false
					wallpaperColor = false
					wallpaperID = currentSelectedWallpaper
					loadedCustomWallpaper = false
					
					triggerServerEvent("phoneSaveWallpaper", localPlayer, localPlayer, currentPhoneNumber, wallpaperID)
					
					dgsSetEnabled(phoneGUI.button["savewallpaper"], false)
				end
			end
		end
	end)
end
--SETTINGS APP END

function phoneAppCustomWallpaper()
	setupPhoneApp("customwallpaper")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 100*scaleRatio, dxGetTextWidth(customWallpaperText, 0.8, phoneBigBoldFont), 10, customWallpaperText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)

	--APP START
	phoneGUI.scrollpane["customwallpaperscroll"] = dgsCreateScrollPane(0, 90, (369*scaleRatio), 301, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.scrollpane["customwallpaperscroll"], "scrollBarThick", 0)
	dgsCenterElement(phoneGUI.scrollpane["customwallpaperscroll"], false, true)

	phoneGUI.label["wallpaperurl"] = dgsCreateLabel(20*scaleRatio, 10, (330*scaleRatio), 15, wallpaperURLText, false, phoneGUI.scrollpane["customwallpaperscroll"])
	dgsSetProperty(phoneGUI.label["wallpaperurl"], "textColor", tocolor(255, 255, 255))
	dgsSetFont(phoneGUI.label["wallpaperurl"], phoneFont)
	dgsSetProperty(phoneGUI.label["wallpaperurl"], "wordBreak", true)
	
	phoneGUI.edit["wallpaperurledit"] = dgsCreateEdit(20*scaleRatio, 25, (330*scaleRatio), 30, "", false, phoneGUI.scrollpane["customwallpaperscroll"])
	dgsSetFont(phoneGUI.edit["wallpaperurledit"], phoneFont)
	
	phoneGUI.label["redcolorcode"] = dgsCreateLabel(20*scaleRatio, 65, (330*scaleRatio), 15, redRgbText, false, phoneGUI.scrollpane["customwallpaperscroll"])
	dgsSetProperty(phoneGUI.label["redcolorcode"], "textColor", tocolor(255, 255, 255))
	dgsSetFont(phoneGUI.label["redcolorcode"], phoneFont)
	dgsSetProperty(phoneGUI.label["redcolorcode"], "wordBreak", true)
	
	phoneGUI.edit["redcolorcodeedit"] = dgsCreateEdit(20*scaleRatio, 80, (330*scaleRatio), 30, "", false, phoneGUI.scrollpane["customwallpaperscroll"])
	dgsSetFont(phoneGUI.edit["redcolorcodeedit"], phoneFont)
	dgsEditSetTextFilter(phoneGUI.edit["redcolorcodeedit"] ,"%D")
	dgsEditSetMaxLength(phoneGUI.edit["redcolorcodeedit"], 3)
	
	phoneGUI.label["greencolorcode"] = dgsCreateLabel(20*scaleRatio, 120, (330*scaleRatio), 15, greenRgbText, false, phoneGUI.scrollpane["customwallpaperscroll"])
	dgsSetProperty(phoneGUI.label["greencolorcode"], "textColor", tocolor(255, 255, 255))
	dgsSetFont(phoneGUI.label["greencolorcode"], phoneFont)
	dgsSetProperty(phoneGUI.label["greencolorcode"], "wordBreak", true)
	
	phoneGUI.edit["greencolorcodeedit"] = dgsCreateEdit(20*scaleRatio, 135, (330*scaleRatio), 30, "", false, phoneGUI.scrollpane["customwallpaperscroll"])
	dgsSetFont(phoneGUI.edit["greencolorcodeedit"], phoneFont)
	dgsEditSetTextFilter(phoneGUI.edit["greencolorcodeedit"] ,"%D")
	dgsEditSetMaxLength(phoneGUI.edit["greencolorcodeedit"], 3)

	phoneGUI.label["bluecolorcode"] = dgsCreateLabel(20*scaleRatio, 175, (330*scaleRatio), 15, blueRgbText, false, phoneGUI.scrollpane["customwallpaperscroll"])
	dgsSetProperty(phoneGUI.label["bluecolorcode"], "textColor", tocolor(255, 255, 255))
	dgsSetFont(phoneGUI.label["bluecolorcode"], phoneFont)
	dgsSetProperty(phoneGUI.label["bluecolorcode"], "wordBreak", true)
	
	phoneGUI.edit["bluecolorcodeedit"] = dgsCreateEdit(20*scaleRatio, 190, (330*scaleRatio), 30, "", false, phoneGUI.scrollpane["customwallpaperscroll"])
	dgsSetFont(phoneGUI.edit["bluecolorcodeedit"], phoneFont)
	dgsEditSetTextFilter(phoneGUI.edit["bluecolorcodeedit"] ,"%D")
	dgsEditSetMaxLength(phoneGUI.edit["bluecolorcodeedit"], 3)

	phoneGUI.button["checkwallpaper"] = dgsCreateButton(20*scaleRatio, 230, (330*scaleRatio), 50*scaleRatio, checkWallpaperText, false, phoneGUI.scrollpane["customwallpaperscroll"])
	addEventHandler("onDgsMouseClickDown", phoneGUI.button["checkwallpaper"], function()
		if source == phoneGUI.button["checkwallpaper"] then
			local newURL = dgsGetText(phoneGUI.edit["wallpaperurledit"])
			local redColor = dgsGetText(phoneGUI.edit["redcolorcodeedit"])
			local blueColor = dgsGetText(phoneGUI.edit["bluecolorcodeedit"])
			local greenColor = dgsGetText(phoneGUI.edit["greencolorcodeedit"])
			
			triggerServerEvent("authorizeWallpaper", localPlayer, localPlayer, newURL, redColor, blueColor, greenColor)
		end
	end)
	
	phoneGUI.button["updatewallpaper"] = dgsCreateButton(20*scaleRatio, 270, (330*scaleRatio), 50*scaleRatio, saveWallpaperText, false, phoneGUI.scrollpane["customwallpaperscroll"])
	addEventHandler("onDgsMouseClickDown", phoneGUI.button["updatewallpaper"], function()
		if source == phoneGUI.button["updatewallpaper"] then
			local newURL = dgsGetText(phoneGUI.edit["wallpaperurledit"])
			local redColor = dgsGetText(phoneGUI.edit["redcolorcodeedit"])
			local blueColor = dgsGetText(phoneGUI.edit["bluecolorcodeedit"])
			local greenColor = dgsGetText(phoneGUI.edit["greencolorcodeedit"])
			
			triggerServerEvent("phoneUploadNewWallpaper", localPlayer, localPlayer, currentPhoneNumber, newURL, redColor, blueColor, greenColor)
			wallpaperID = customWallpaperID
			wallpaperURL = newURL
			wallpaperColor = {
				["red"] = redColor,
				["green"] = redColor,
				["blue"] = redColor,
			}
			
			phoneAppSettings()
		end
	end)
	dgsSetEnabled(phoneGUI.button["updatewallpaper"], false)
	--APP END
end

function sendBackWallpaperAuth(urlGood, redColorGood, blueColorGood, greenColorGood)
	if true then
		return
	end
	
	if urlGood and redColorGood and blueColorGood and greenColorGood then
		if isElement(phoneGUI.button["updatewallpaper"]) then
			dgsSetEnabled(phoneGUI.button["updatewallpaper"], true)
			
			dgsSetEnabled(phoneGUI.edit["wallpaperurledit"], false)
			dgsSetEnabled(phoneGUI.edit["redcolorcodeedit"], false)
			dgsSetEnabled(phoneGUI.edit["bluecolorcodeedit"], false)
			dgsSetEnabled(phoneGUI.edit["greencolorcodeedit"], false)
		end
	else
		if not urlGood then
			setTimer ( function()
				if isElement(phoneGUI.label["wallpaperurl"]) then
					dgsSetText(phoneGUI.label["wallpaperurl"], wallpaperURLText)
				end
			end, 3500, 1)
			dgsSetText(phoneGUI.label["wallpaperurl"], wallpaperURLText.." "..errorNotifText)
		end
		
		if not redColorGood then
			setTimer ( function()
				if isElement(phoneGUI.label["redcolorcode"]) then
					dgsSetText(phoneGUI.label["redcolorcode"], blueRgbText)
				end
			end, 3500, 1)
			dgsSetText(phoneGUI.label["redcolorcode"], redRgbText.." "..errorNotifText)
		end
		
		if not blueColorGood then
			setTimer ( function()
				if isElement(phoneGUI.label["bluecolorcode"]) then
					dgsSetText(phoneGUI.label["bluecolorcode"], blueRgbText)
				end
			end, 3500, 1)
			dgsSetText(phoneGUI.label["bluecolorcode"], blueRgbText.." "..errorNotifText)
		end
		
		if not greenColorGood then
			setTimer ( function()
				if isElement(phoneGUI.label["greencolorcode"]) then
					dgsSetText(phoneGUI.label["greencolorcode"], greenRgbText)
				end
			end, 3500, 1)
			dgsSetText(phoneGUI.label["greencolorcode"], greenRgbText.." "..errorNotifText)
		end
	end
end
addEvent("sendBackWallpaperAuth", true)
addEventHandler("sendBackWallpaperAuth", root, sendBackWallpaperAuth)

function phoneAppSettingsRingtone()
	setupPhoneApp("settingspage")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 130, dxGetTextWidth(ringtoneSettingsTitleText, 0.8, phoneBigBoldFont), 10, ringtoneSettingsTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.gridlist["ringtones"] = dgsCreateGridList(0, 160, 369*scaleRatio, 150, false, phoneGUI.image["phonewallpaper"])
	dgsGridListAddColumn(phoneGUI.gridlist["ringtones"], "", 0.8)
	dgsGridListAddColumn(phoneGUI.gridlist["ringtones"], "", 0.2)
	dgsSetFont(phoneGUI.gridlist["ringtones"], phoneFont)
	dgsSetProperty(phoneGUI.gridlist["ringtones"],"leading", 15)
	dgsSetProperty(phoneGUI.gridlist["ringtones"], "columnHeight", 0)
	dgsSetProperty(phoneGUI.gridlist["ringtones"], "scrollBarThick", 0)
	dgsSetProperty(phoneGUI.gridlist["ringtones"], "bgColor", tocolor(0, 0, 0, 20))
	dgsSetProperty(phoneGUI.gridlist["ringtones"], "rowTextColor", tocolor(255, 255, 255, 150))
	dgsSetProperty(phoneGUI.gridlist["ringtones"], "rowColor", {tocolor(100, 100, 100, 40), tocolor(249,139,6, 80), tocolor(249,139,6, 100)})
	dgsSetProperty(phoneGUI.gridlist["ringtones"], "rowHeight", 45)
	dgsSetProperty(phoneGUI.gridlist["ringtones"], "rowTextPosOffset", {2, 0})
	dgsSetProperty(phoneGUI.gridlist["ringtones"], "rowTextSize", {0.8, 0.8})
		
	for i, v in ipairs(ringtones) do
		if not v.hidden then
			local row = dgsGridListAddRow(phoneGUI.gridlist["ringtones"])
			dgsGridListSetItemText(phoneGUI.gridlist["ringtones"], row, 1, v.ringtonename)
			
			phoneGUI.image["ringtones"..i] = dgsCreateButton(0, 10, iconSize/2.2, iconSize/2.2, "", false, phoneGUI.gridlist["ringtones"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/sound.png", ":newphone/files/icons/sound.png", ":newphone/files/icons/sound.png", tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200))
			dgsAttachToGridList(phoneGUI.image["ringtones"..i], phoneGUI.gridlist["ringtones"], row, 2)
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["ringtones"..i], function()
				if ringtonePreview and isElement(ringtonePreview) then destroyElement(ringtonePreview) end
				
				ringtonePreview = playSound(ringtones[i].sound, false, false)
				setSoundVolume(ringtonePreview, ringtones[i].volume)
			end, false)
		end
	end
	
	dgsGridListSetSelectedItem(phoneGUI.gridlist["ringtones"], ringtoneID)
	addEventHandler ( "onDgsMouseClickDown", phoneGUI.gridlist["ringtones"], function ()
		local selected = dgsGridListGetSelectedItem(phoneGUI.gridlist["ringtones"])
		if selected == -1 then
			dgsGridListSetSelectedItem(phoneGUI.gridlist["ringtones"], 1)
			return
		elseif selected ~= ringtoneID then
			dgsSetEnabled(phoneGUI.button["saveringtone"], true)
		else
			dgsSetEnabled(phoneGUI.button["saveringtone"], false)
		end
	end, false)
	
	phoneGUI.button["saveringtone"] = dgsCreateButton(125*scaleRatio, 550*scaleRatio, 225*scaleRatio, 50*scaleRatio, saveRingtoneText, false, phoneGUI.image["phonewallpaper"])
	dgsSetEnabled(phoneGUI.button["saveringtone"], false)
	dgsCenterElement(phoneGUI.button["saveringtone"], false, true)
	addEventHandler("onDgsMouseClickDown", phoneGUI.button["saveringtone"], function()
		if source == phoneGUI.button["saveringtone"] then
			if isElement(ringtonePreview) then
				destroyElement(ringtonePreview)
			end
			
			local selected = dgsGridListGetSelectedItem(phoneGUI.gridlist["ringtones"])
			if ringtoneID ~= selected then
				ringtoneID = selected
				triggerServerEvent("phoneSaveRingtone", localPlayer, localPlayer, currentPhoneNumber, ringtoneID)
				
				dgsSetEnabled(phoneGUI.button["saveringtone"], false)
			end
		end
	end)
end

function phoneAppSettingsMessagetone()
	setupPhoneApp("settingspage")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 130, dxGetTextWidth(messagetoneSettingsTitleText, 0.8, phoneBigBoldFont), 10, messagetoneSettingsTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.gridlist["messagetones"] = dgsCreateGridList(0, 160, 369*scaleRatio, 150, false, phoneGUI.image["phonewallpaper"])
	dgsGridListAddColumn(phoneGUI.gridlist["messagetones"], "", 0.8)
	dgsGridListAddColumn(phoneGUI.gridlist["messagetones"], "", 0.2)
	dgsSetFont(phoneGUI.gridlist["messagetones"], phoneFont)
	dgsSetProperty(phoneGUI.gridlist["messagetones"],"leading", 15)
	dgsSetProperty(phoneGUI.gridlist["messagetones"], "columnHeight", 0)
	dgsSetProperty(phoneGUI.gridlist["messagetones"], "scrollBarThick", 0)
	dgsSetProperty(phoneGUI.gridlist["messagetones"], "bgColor", tocolor(0, 0, 0, 20))
	dgsSetProperty(phoneGUI.gridlist["messagetones"], "rowTextColor", tocolor(255, 255, 255, 150))
	dgsSetProperty(phoneGUI.gridlist["messagetones"], "rowColor", {tocolor(100, 100, 100, 40), tocolor(249,139,6, 80), tocolor(249,139,6, 100)})
	dgsSetProperty(phoneGUI.gridlist["messagetones"], "rowHeight", 45)
	dgsSetProperty(phoneGUI.gridlist["messagetones"], "rowTextPosOffset", {2, 0})
	dgsSetProperty(phoneGUI.gridlist["messagetones"], "rowTextSize", {0.8, 0.8})
		
	for i, v in ipairs(messagetones) do
		if not v.hidden then
			local row = dgsGridListAddRow(phoneGUI.gridlist["messagetones"])
			dgsGridListSetItemText(phoneGUI.gridlist["messagetones"], row, 1, v.messagetonename)
			
			phoneGUI.image["messagetones"..i] = dgsCreateButton(0, 10, iconSize/2.2, iconSize/2.2, "", false, phoneGUI.gridlist["messagetones"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/sound.png", ":newphone/files/icons/sound.png", ":newphone/files/icons/sound.png", tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200))
			dgsAttachToGridList(phoneGUI.image["messagetones"..i], phoneGUI.gridlist["messagetones"], row, 2)
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["messagetones"..i], function()
				if ringtonePreview and isElement(ringtonePreview) then destroyElement(ringtonePreview) end
				
				ringtonePreview = playSound(messagetones[i].sound, false, false)
				setSoundVolume(ringtonePreview, messagetones[i].volume)
			end, false)
		end
	end
	
	dgsGridListSetSelectedItem(phoneGUI.gridlist["messagetones"], messageToneID)
	addEventHandler ( "onDgsMouseClickDown", phoneGUI.gridlist["messagetones"], function ()
		local selected = dgsGridListGetSelectedItem(phoneGUI.gridlist["messagetones"])
		if selected == -1 then
			dgsGridListSetSelectedItem(phoneGUI.gridlist["messagetones"], 1)
			return
		elseif selected ~= messageToneID then
			dgsSetEnabled(phoneGUI.button["savemessagetone"], true)
		else
			dgsSetEnabled(phoneGUI.button["savemessagetone"], false)
		end
	end, false)
	
	phoneGUI.button["savemessagetone"] = dgsCreateButton(125*scaleRatio, 550*scaleRatio, 225*scaleRatio, 50*scaleRatio, saveMessageToneText, false, phoneGUI.image["phonewallpaper"])
	dgsSetEnabled(phoneGUI.button["savemessagetone"], false)
	dgsCenterElement(phoneGUI.button["savemessagetone"], false, true)
	addEventHandler("onDgsMouseClickDown", phoneGUI.button["savemessagetone"], function()
		if source == phoneGUI.button["savemessagetone"] then
			if isElement(ringtonePreview) then
				destroyElement(ringtonePreview)
			end
			
			local selected = dgsGridListGetSelectedItem(phoneGUI.gridlist["messagetones"])
			if messageToneID ~= selected then
				messageToneID = selected
				triggerServerEvent("phoneSaveMessageTone", localPlayer, localPlayer, currentPhoneNumber, messageToneID)
				
				dgsSetEnabled(phoneGUI.button["savemessagetone"], false)
			end
		end
	end)
end

function phoneAppSettingsSecurity()
	setupPhoneApp("settingspage")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 130, dxGetTextWidth(securitySettingsTitleText, 0.8, phoneBigBoldFont), 10, securitySettingsTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.label["pinlabel"] = dgsCreateLabel(20*scaleRatio, 170, dxGetTextWidth(pinCodeLabelText, 1, phoneFont), 10, pinCodeLabelText, false, phoneGUI.image["phonewallpaper"], false, 1, 1)
	dgsSetProperty(phoneGUI.label["pinlabel"], "textColor", tocolor(255, 255, 255, 255))
	dgsSetFont(phoneGUI.label["pinlabel"], phoneFont)
	
	if currentPin and tonumber(currentPin) and tonumber(currentPin) > 0 then
		phoneGUI.label["pinshowlabel"] = dgsCreateLabel(0, 190, 369*scaleRatio, 10, currentPin, false, phoneGUI.image["phonewallpaper"], false, 1.5, 1.5)
		dgsSetProperty(phoneGUI.label["pinshowlabel"], "textColor", tocolor(0, 200, 0, 175))
		dgsSetFont(phoneGUI.label["pinshowlabel"], phoneFont)
		--dgsCenterElement(phoneGUI.image["pinshowlabel"], false, true)
		dgsLabelSetHorizontalAlign(phoneGUI.label["pinshowlabel"], "center")
		
		phoneGUI.button["changepin"] = dgsCreateButton(125*scaleRatio, 220, 225*scaleRatio, 50*scaleRatio, changePinText, false, phoneGUI.image["phonewallpaper"])
		addEventHandler ( "onDgsMouseClickDown", phoneGUI.button["changepin"], function ()
			if source == phoneGUI.button["changepin"] then
				phoneAppSetPin()
			end
		end)
		dgsCenterElement(phoneGUI.button["changepin"], false, true)
		
		phoneGUI.button["removepin"] = dgsCreateButton(125*scaleRatio, 270, 225*scaleRatio, 50*scaleRatio, removePinText, false, phoneGUI.image["phonewallpaper"])
		addEventHandler ( "onDgsMouseClickDown", phoneGUI.button["removepin"], function ()
			if source == phoneGUI.button["removepin"] then
				triggerServerEvent("phoneRemovePin", localPlayer, localPlayer, currentPhoneNumber)
				phoneClose()
			end
		end)
		dgsCenterElement(phoneGUI.button["removepin"], false, true)
	else
		phoneGUI.label["pinshowlabel"] = dgsCreateLabel(0, 190, 369*scaleRatio, 10, noPinText, false, phoneGUI.image["phonewallpaper"], false, 1.5, 1.5)
		dgsSetProperty(phoneGUI.label["pinshowlabel"], "textColor", tocolor(200, 0, 0, 175))
		dgsSetFont(phoneGUI.label["pinshowlabel"], phoneFont)
		--dgsCenterElement(phoneGUI.image["pinshowlabel"], false, true)
		dgsLabelSetHorizontalAlign(phoneGUI.label["pinshowlabel"], "center")
		
		phoneGUI.button["setpin"] = dgsCreateButton(125*scaleRatio, 220, 225*scaleRatio, 50*scaleRatio, "Set PIN", false, phoneGUI.image["phonewallpaper"])
		addEventHandler ( "onDgsMouseClickDown", phoneGUI.button["setpin"], function ()
			if source == phoneGUI.button["setpin"] then
				phoneAppSetPin()
			end
		end)
		dgsCenterElement(phoneGUI.button["setpin"], false, true)
	end
end


function phoneAppSetPin(change)	
	setupPhoneApp("pinsettingspage")
	
	phoneGUI.label["phonelabel"] = dgsCreateLabel(10, 35, dxGetTextWidth(newPinCodeText, 0.8, phoneBigBoldFont), 10, newPinCodeText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["phonelabel"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["phonelabel"], phoneBigBoldFont)
	dgsCenterElement(phoneGUI.label["phonelabel"], false, true)
	phoneGUI.label["pinerror"] = dgsCreateLabel(10, 55, 162, 10, pinLengthText, false, phoneGUI.image["phonewallpaper"], false, 0.4, 0.4)
	dgsSetProperty(phoneGUI.label["pinerror"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["pinerror"], phoneBigBoldFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["pinerror"], "center")
	dgsCenterElement(phoneGUI.label["pinerror"], false, true)
	
	local typedPin = ""
	phoneGUI.label["pinnumber"] = dgsCreateLabel(10, 70, 162, 10, typedPin, false, phoneGUI.image["phonewallpaper"], false, 1.2, 1.2)
	dgsSetProperty(phoneGUI.label["pinnumber"], "textColor", tocolor(255, 255, 255, 175))
	dgsSetFont(phoneGUI.label["pinnumber"], phoneBigBoldFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["pinnumber"], "center")
	dgsCenterElement(phoneGUI.label["pinnumber"], false, true)
	
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
		
		phoneGUI.image["dialbutton"..k] = dgsCreateButton(left+startX, 130+startY, iconSize, iconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/"..k..".png", ":newphone/files/icons/numbers/"..k..".png", ":newphone/files/icons/numbers/"..k..".png", tocolor(255, 255, 255, 150), tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255))
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
					if tonumber(typedPin) and string.len(typedPin) == 4 then
						--outputDebugString("Submit: "..typedPin)
						--outputDebugString(currentPhoneNumber)
						
						triggerServerEvent("phoneSetPin", localPlayer, localPlayer, currentPhoneNumber, typedPin)
						phoneClose()
					else
						--outputDebugString("Invalid: "..typedPin)
						typedPin = ""
						dgsSetText(phoneGUI.label["pinnumber"], typedPin)
						
						phoneGUI.label["pinerror"] = dgsCreateLabel(10, 100, 162, 10, incorrectPinText, false, phoneGUI.image["phonewallpaper"], false, 0.6, 0.6)
						dgsSetProperty(phoneGUI.label["pinerror"], "textColor", tocolor(255, 0, 0, 175))
						dgsSetFont(phoneGUI.label["pinerror"], phoneBigBoldFont)
						dgsLabelSetHorizontalAlign(phoneGUI.label["pinerror"], "center")
						
						phoneIncorrectPinTimer = setTimer ( function()
							destroyElement(phoneGUI.label["pinerror"])
							killTimer(phoneIncorrectPinTimer)
						end, 500, 1)
					end
				end
			end)
		end
		
		startX = startX + 65
		buttonCount = buttonCount + 1
	end
end
--SECURITY APP END