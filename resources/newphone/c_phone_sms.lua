--NEW MESSAGE APP START
function phoneAppNewMessage(forceNumber)
	if not loadedMessages then
		loadedMessages = {}
	end
	
	setupPhoneApp("newmessage")

	phoneGUI.label["messageslabel"] = dgsCreateLabel(20*scaleRatio, 35, dxGetTextWidth(newMessageText, 0.8, phoneBigBoldFont), 10, newMessageText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["messageslabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["messageslabel"], phoneBigBoldFont)
	
	phoneGUI.label["numberlabel"] = dgsCreateLabel(10, 70, dxGetTextWidth(phoneNumberMessageText, 0.8, phoneBoldFont), 10, phoneNumberMessageText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetFont(phoneGUI.label["numberlabel"], phoneBoldFont)
	
	phoneGUI.image["seperator"] = dgsCreateImage(12, 60, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	phoneGUI.edit["numberedit"] = dgsCreateEdit(5, 85, 213, 30, "", false, phoneGUI.image["phonewallpaper"])
	dgsEditSetMaxLength(phoneGUI.edit["numberedit"], 6)
	dgsEditSetTextFilter(phoneGUI.edit["numberedit"], "%D")
	
	phoneGUI.image["seperator"] = dgsCreateImage(12, 125, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	if forceNumber then
		dgsSetText(phoneGUI.edit["numberedit"], tonumber(forceNumber))
	end
	
	phoneGUI.image["seperator"] = dgsCreateImage(12, 360, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	phoneGUI.edit["messageedit"] = dgsCreateMemo(5, 370, 213, 40, "", false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.edit["messageedit"], "textColor", tocolor(0, 0, 0, 150))
	dgsSetFont(phoneGUI.edit["messageedit"], phoneFont)
	dgsMemoSetWordWrapState(phoneGUI.edit["messageedit"],2)
	
	phoneGUI.image["sendmessage"] = dgsCreateButton(160, 420, homeIconSize, homeIconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/send.png", ":newphone/files/icons/send.png", ":newphone/files/icons/send.png")
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["sendmessage"], function()
		if source == phoneGUI.image["sendmessage"] then
			local text = dgsGetText(phoneGUI.edit["messageedit"])
			if string.len(text) == 0 then return end
			
			local newNumber = dgsGetText(phoneGUI.edit["numberedit"])
			if tonumber(newNumber) then
				dgsSetEnabled(phoneGUI.image["phonewallpaper"], false)
				triggerServerEvent("phoneSendTextMessage", localPlayer, localPlayer, currentPhoneNumber, newNumber, text)
			end
		end
	end)
end
--NEW MESSAGE APP END 

local sortfnc = [[
	local arg = {...}
	local a = arg[1]
	local b = arg[2]
	local column = dgsElementData[self].sortColumn
	local texta,textb = a[column][1],b[column][1]
	return textb < texta
]] 

--MESSAGES APP START
function phoneAppMessages()
	setupPhoneApp("messages")

	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 45, dxGetTextWidth(messagesTitleText, 0.8, phoneBigBoldFont), 10, messagesTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.image["createmessage"] = dgsCreateButton(185, 42, iconSize/2, iconSize/2, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/edit.png", ":newphone/files/icons/edit.png", ":newphone/files/icons/edit.png")
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["createmessage"], function()
		if source == phoneGUI.image["createmessage"] then
			phoneAppNewMessage()
		end
	end)
	
	phoneGUI.gridlist["messagesgridlist"] = dgsCreateGridList(0, 82, 369*scaleRatio, 310, false, phoneGUI.image["phonewallpaper"])
	dgsSetFont(phoneGUI.gridlist["messagesgridlist"], phoneFont)
	dgsGridListAddColumn(phoneGUI.gridlist["messagesgridlist"], "", 0.8)
	dgsGridListAddColumn(phoneGUI.gridlist["messagesgridlist"], "", 0.2)
	dgsSetFont(phoneGUI.gridlist["messagesgridlist"], phoneFont)
	dgsSetProperty(phoneGUI.gridlist["messagesgridlist"],"leading", 15)
	dgsSetProperty(phoneGUI.gridlist["messagesgridlist"], "columnHeight", 0)
	dgsSetProperty(phoneGUI.gridlist["messagesgridlist"], "scrollBarThick", 0)
	dgsSetProperty(phoneGUI.gridlist["messagesgridlist"], "bgColor", tocolor(0, 0, 0, 20))
	dgsSetProperty(phoneGUI.gridlist["messagesgridlist"], "rowTextColor", tocolor(255, 255, 255, 150))
	dgsSetProperty(phoneGUI.gridlist["messagesgridlist"], "rowColor", {tocolor(100, 100, 100, 40), tocolor(249,139,6, 80), tocolor(249,139,6, 100)})
	dgsSetProperty(phoneGUI.gridlist["messagesgridlist"], "rowHeight", 45)
	dgsSetProperty(phoneGUI.gridlist["messagesgridlist"], "rowTextPosOffset", {2, 0})
	dgsSetProperty(phoneGUI.gridlist["messagesgridlist"], "rowTextSize", {0.8, 0.8})
	
	dgsGridListSetSortFunction(phoneGUI.gridlist["messagesgridlist"],sortfnc) -- set and load the sorting function
	dgsGridListSetSortColumn(phoneGUI.gridlist["messagesgridlist"],3)

	if loadedMessages and type(loadedMessages) == "table" then
		local contactSmsCount = {}
		for i, v in ipairs(loadedMessages) do
			contactSmsCount[tostring(v.contactNumber)] = (contactSmsCount[tostring(v.contactNumber)] or 0) + 1
		end
		local addedContacts = {}
		for i, v in ipairs(loadedMessages) do
			if not addedContacts[tostring(v.contactNumber)] then
				local row = dgsGridListAddRow(phoneGUI.gridlist["messagesgridlist"])
				if loadedContacts and loadedContacts[tostring(v.contactNumber)] then
					dgsGridListSetItemText(phoneGUI.gridlist["messagesgridlist"], row, 1, loadedContacts[tostring(v.contactNumber)].name)
					dgsGridListSetItemText(phoneGUI.gridlist["messagesgridlist"], row, 2, contactSmsCount[tostring(v.contactNumber)])
				else
					dgsGridListSetItemText(phoneGUI.gridlist["messagesgridlist"], row, 1, tostring(v.contactNumber))
					dgsGridListSetItemText(phoneGUI.gridlist["messagesgridlist"], row, 2, contactSmsCount[tostring(v.contactNumber)])
				end
				dgsGridListSetItemData(phoneGUI.gridlist["messagesgridlist"], row, 1, tostring(v.contactNumber))
				addedContacts[tostring(v.contactNumber)] = true
			end
		end
		
		addEventHandler( "onDgsGridListSelect", phoneGUI.gridlist["messagesgridlist"], function(current, currentcolumn, previous, previouscolumn)
			if current ~= -1 then
				local textNumber = dgsGridListGetItemData(phoneGUI.gridlist["messagesgridlist"], current, 1)
				phoneOpenMessage(textNumber)
			end
		end, false)
	end
end
--MESSAGES APP END

--OPEN MESSAGE START
function phoneOpenMessage(phoneNumber)
	if true then
		return
	end
	
	if currentApp == "messages" or currentApp == "openmessage" or currentApp == "newmessage" or currentApp == "contacts" then		
		setupPhoneApp("openmessage")
		
		openPhoneNumber = phoneNumber
		
		if loadedContacts and loadedContacts[tostring(phoneNumber)] then
			contactName = loadedContacts[tostring(phoneNumber)].name
		else
			contactName = phoneNumber
		end
		
		phoneGUI.label["messageslabel"] = dgsCreateLabel(20*scaleRatio, 35, dxGetTextWidth(contactName, 0.8, phoneBigBoldFont), 10, contactName, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsSetProperty(phoneGUI.label["messageslabel"], "textColor", pageTitleColor)
		dgsSetFont(phoneGUI.label["messageslabel"], phoneBigBoldFont)

		phoneGUI.image["deletemessages"] = dgsCreateButton(185, 30, iconSize/2, iconSize/2, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/delete.png", ":newphone/files/icons/delete.png", ":newphone/files/icons/delete.png")
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["deletemessages"], function()
			if source == phoneGUI.image["deletemessages"] then
				dgsSetEnabled(phoneGUI.image["phonewallpaper"], false)
				triggerServerEvent("newphone:deleteTextMessages", resourceRoot, currentPhoneNumber, phoneNumber)
			end
		end)
		
		phoneGUI.image["seperator"] = dgsCreateImage(12, 60, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
		dgsCenterElement(phoneGUI.image["seperator"], false, true)
		
		phoneGUI.scrollpane["messagescroll"] = dgsCreateScrollPane(10, 75, 210, 270, false, phoneGUI.image["phonewallpaper"])
		dgsSetProperty(phoneGUI.scrollpane["messagescroll"], "scrollBarThick", 0)
		dgsCenterElement(phoneGUI.scrollpane["messagescroll"], false, true)
		
		local currentY = 10
		local padding = 10
		
		if loadedMessages then
			for k = #loadedMessages, 1, -1 do
				local v = loadedMessages[k]
				
				if tostring(v.contactNumber) == tostring(phoneNumber) then
					local textWidth = dxGetTextWidth(v.sms, 0.8, phoneFont)
					local textHeight = dxGetFontHeight(0.8, phoneFont)

					local textBgHeight = textHeight
					if v.sms and string.len(v.sms) > 50 and string.len(v.sms) < 100 then
						textBgHeight = textHeight * 2
					elseif v.sms and string.len(v.sms) > 100 then
						textBgHeight = textHeight * 3
					end
					
					if tostring(v.receiver_number) ~= tostring(currentPhoneNumber) then -- received
						phoneGUI.image["msg"..k.."point"] = dgsCreateImage(192, 0+currentY-12, 12, 12, "files/wallpapers/messagepoint.png", false, phoneGUI.scrollpane["messagescroll"], tocolor(148,91,40,255))
						dgsSetProperty(phoneGUI.image["msg"..k.."point"], "changeOrder", false)
						
						phoneGUI.image["msg"..k.."bg"] = dgsCreateImage(37, 0+currentY, 175, textBgHeight+padding+10, "files/wallpapers/messagebg.png", false, phoneGUI.scrollpane["messagescroll"], tocolor(148,91,40,255))
						dgsSetProperty(phoneGUI.image["msg"..k.."bg"], "changeOrder", false)
						
						phoneGUI.label["msglabel"] = dgsCreateLabel(167, 0+currentY+textBgHeight+padding+10, 50, 10, receivedMessageText, false, phoneGUI.scrollpane["messagescroll"], false, 0.7, 0.7)
						dgsSetProperty(phoneGUI.label["msglabel"], "textColor", tocolor(100, 100, 100))
						dgsSetFont(phoneGUI.label["msglabel"], phoneFont)
						
						phoneGUI.label["msglabeldate"] = dgsCreateLabel(80, 0+currentY+textBgHeight+padding+11, 50, 10, ""..os.date("%x", v.timedate).." "..os.date("%X", v.timedate).."", false, phoneGUI.scrollpane["messagescroll"], false, 0.7, 0.7)
						dgsSetProperty(phoneGUI.label["msglabeldate"], "textColor", tocolor(70, 70, 70))
						dgsSetFont(phoneGUI.label["msglabeldate"], phoneFont)
						
						phoneGUI.label["msg"..k] = dgsCreateLabel(5, 5, 165, textBgHeight+padding, tostring(v.sms), false, phoneGUI.image["msg"..k.."bg"], false, 0.8, 0.8)
						
						dgsSetFont(phoneGUI.label["msg"..k], phoneFont)
						dgsSetProperty(phoneGUI.label["msg"..k], "textColor", tocolor(200, 200, 200))

						dgsSetProperty(phoneGUI.label["msg"..k], "clip", false) -- True to false, elp.
						dgsLabelSetHorizontalAlign(phoneGUI.label["msg"..k], "left") -- right to left, elp.
						dgsSetProperty(phoneGUI.label["msg"..k], "wordBreak", true) -- looks like this has to come after alignment. moved below the above 2 variables. makes sense.
						
						--dgsSetProperty(phoneGUI.label["msg"..k], "textOffset", {-4, -4, false})
					else -- sent
						phoneGUI.image["msg"..k.."point"] = dgsCreateImage(10, 0+currentY-12, 12, 12, "files/wallpapers/messagepoint.png", false, phoneGUI.scrollpane["messagescroll"], tocolor(50,50,50,255))
						dgsSetProperty(phoneGUI.image["msg"..k.."point"], "changeOrder", false)
						
						phoneGUI.image["msg"..k.."bg"] = dgsCreateImage(5, 0+currentY, 175, textBgHeight+padding+10, "files/wallpapers/messagebg.png", false, phoneGUI.scrollpane["messagescroll"], tocolor(50,50,50,255))
						dgsSetProperty(phoneGUI.image["msg"..k.."bg"], "changeOrder", false)
						
						phoneGUI.label["msglabel"] = dgsCreateLabel(5, 0+currentY+textBgHeight+padding+10, 50, 10, sentMessageText, false, phoneGUI.scrollpane["messagescroll"], false, 0.7, 0.7)
						dgsSetProperty(phoneGUI.label["msglabel"], "textColor", tocolor(249,139,6,120))
						dgsSetFont(phoneGUI.label["msglabel"], phoneFont)
						
						phoneGUI.label["msglabeldate"] = dgsCreateLabel(45, 0+currentY+textBgHeight+padding+11, 50, 10, ""..os.date("%x", v.timedate).." "..os.date("%X", v.timedate).."", false, phoneGUI.scrollpane["messagescroll"], false, 0.7, 0.7)
						dgsSetProperty(phoneGUI.label["msglabeldate"], "textColor", tocolor(70, 70, 70))
						dgsSetFont(phoneGUI.label["msglabeldate"], phoneFont)
						
						phoneGUI.label["msg"..k] = dgsCreateLabel(8, 0+currentY+5, 165, textBgHeight+padding, tostring(v.sms), false, phoneGUI.scrollpane["messagescroll"], false, 0.8, 0.8)
						
						dgsSetFont(phoneGUI.label["msg"..k], phoneFont)
						dgsSetProperty(phoneGUI.label["msg"..k], "textColor", tocolor(200, 200, 200))
						dgsSetProperty(phoneGUI.label["msg"..k], "clip", false)
						dgsLabelSetHorizontalAlign(phoneGUI.label["msg"..k], "left")
						dgsSetProperty(phoneGUI.label["msg"..k], "wordBreak", true)
						
						--dgsSetProperty(phoneGUI.label["msg"..k], "textOffset", {4, 4, false})
					end		
					currentY = currentY + textBgHeight + 45
				end
			end
		end
		
		phoneGUI.image["seperator"] = dgsCreateImage(12, 360, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
		dgsCenterElement(phoneGUI.image["seperator"], false, true)
		
		if not noReplyNumbers[tonumber(phoneNumber)] then
			phoneGUI.edit["messageedit"] = dgsCreateMemo(5, 370, 213, 40, "", false, phoneGUI.image["phonewallpaper"])
			--dgsSetProperty(phoneGUI.edit["messageedit"], "bgColor", tocolor(100, 100, 100, 100))
			dgsSetProperty(phoneGUI.edit["messageedit"], "textColor", tocolor(0, 0, 0, 150))
			dgsSetFont(phoneGUI.edit["messageedit"], phoneFont)
			dgsMemoSetWordWrapState(phoneGUI.edit["messageedit"],2)
			
			phoneGUI.image["sendmessage"] = dgsCreateButton(160, 420, homeIconSize, homeIconSize, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/send.png", ":newphone/files/icons/send.png", ":newphone/files/icons/send.png")
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["sendmessage"], function()
				local text = dgsGetText(phoneGUI.edit["messageedit"])
				if string.len(text) == 0 then return end
				
				dgsSetEnabled(phoneGUI.image["phonewallpaper"], false)
				triggerServerEvent("phoneSendTextMessage", localPlayer, localPlayer, currentPhoneNumber, phoneNumber, text)
			end, false)
		else
			noReplyText = "Vous ne pouvez\npas répondre."
			phoneGUI.label["noreplylabel"] = dgsCreateLabel(0, 345, 176, 35, noReplyText, false, phoneGUI.image["phonewallpaper"])
			dgsSetProperty(phoneGUI.label["noreplylabel"], "textColor", tocolor(30, 30, 30))
			dgsSetProperty(phoneGUI.label["noreplylabel"], "wordBreak", true)
			dgsSetProperty(phoneGUI.label["noreplylabel"], "clip", true)
			dgsCenterElement(phoneGUI.label["noreplylabel"], false, true)
			dgsLabelSetHorizontalAlign(phoneGUI.label["noreplylabel"], "center")
		end
		
		setTimer(function()
			dgsScrollPaneSetVerticalScrollPosition(phoneGUI.scrollpane["messagescroll"], 100)
		end, 50, 1)
	end
end
addEvent("reloadTextMessages", true)
addEventHandler("reloadTextMessages", root, phoneOpenMessage)

function updateTextMessages(newMessages, forceNumber)
	if isElement(phoneGUI.image["phonewallpaper"]) and not dgsGetEnabled(phoneGUI.image["phonewallpaper"]) then
		dgsSetEnabled(phoneGUI.image["phonewallpaper"], true)
	end
	if newMessages then
		if type(newMessages) == "table" then
			loadedMessages = newMessages
		end
		
		if currentApp == "messages" then
			phoneAppMessages()
		elseif currentApp == "openmessage" then
			if tonumber(openPhoneNumber) == tonumber(forceNumber) then
				phoneOpenMessage(forceNumber)
			end
		elseif currentApp == "newmessage" then
			phoneOpenMessage(forceNumber)
		end
	end
end
addEvent("updateTextMessagesEvent", true)
addEventHandler("updateTextMessagesEvent", localPlayer, updateTextMessages, false)
--OPEN MESSAGE END

function gotMessagesFromNumber(theNumber)
	local gotMessages = false
	if loadedMessages then
		for i, v in ipairs(loadedMessages) do
			if tostring(v.sender_number) == tostring(theNumber) or tostring(v.receiver_number) == tostring(theNumber) then
				gotMessages = true
				break
			end
		end
	end
	return gotMessages
end
