--CONTACTS APP START
function phoneAppContacts()
	setupPhoneApp("contacts")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 30, dxGetTextWidth(contactsTitleText, 0.8, phoneBigBoldFont), 10, contactsTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.image["createcontact"] = dgsCreateButton(185, 28, iconSize/2, iconSize/2, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/edit.png", ":newphone/files/icons/edit.png", ":newphone/files/icons/edit.png")
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["createcontact"], function()
		if source == phoneGUI.image["createcontact"] then
			phoneAppEditContact()
		end
	end)
	
	phoneGUI.image["seperator"] = dgsCreateImage(10, 60, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	phoneGUI.label["numberlabel"] = dgsCreateLabel(10, 65, 160, 20, myNumberText, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.label["numberlabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["numberlabel"], phoneBoldFont)
	
	phoneGUI.label["numberlabel2"] = dgsCreateLabel(10, 80, 160, 20, phoneNumberAreaCode..currentPhoneNumber, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.label["numberlabel2"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["numberlabel2"], phoneFont)
	dgsCenterElement(phoneGUI.label["numberlabel2"], false, true)
	dgsLabelSetHorizontalAlign(phoneGUI.label["numberlabel2"], "center")
	
	phoneGUI.image["seperator"] = dgsCreateImage(10, 103, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	phoneGUI.gridlist["contactsgridlist"] = dgsCreateGridList(0, 105, 369*scaleRatio, 285, false, phoneGUI.image["phonewallpaper"])
	dgsGridListAddColumn(phoneGUI.gridlist["contactsgridlist"], "", 0.65)
	dgsGridListAddColumn(phoneGUI.gridlist["contactsgridlist"], "", 0.15)
	dgsGridListAddColumn(phoneGUI.gridlist["contactsgridlist"], "", 0.15)
	dgsGridListAddColumn(phoneGUI.gridlist["contactsgridlist"], "", 0.05)
	dgsSetProperty(phoneGUI.gridlist["contactsgridlist"],"leading", 15)
	dgsSetProperty(phoneGUI.gridlist["contactsgridlist"], "columnHeight", 0)
	dgsSetProperty(phoneGUI.gridlist["contactsgridlist"], "scrollBarThick", 0)
	dgsSetProperty(phoneGUI.gridlist["contactsgridlist"], "bgColor", tocolor(0, 0, 0, 20))
	dgsSetProperty(phoneGUI.gridlist["contactsgridlist"], "rowTextColor", tocolor(255, 255, 255, 150))
	dgsSetProperty(phoneGUI.gridlist["contactsgridlist"], "rowColor", {tocolor(100, 100, 100, 40), tocolor(249,139,6, 80), tocolor(249,139,6, 100)})
	dgsSetProperty(phoneGUI.gridlist["contactsgridlist"], "rowHeight", 45)
	dgsSetProperty(phoneGUI.gridlist["contactsgridlist"], "rowTextPosOffset", {2, 0})
	dgsSetProperty(phoneGUI.gridlist["contactsgridlist"], "rowTextSize", {0.8, 0.8})
	
	dgsGridListSetSortFunction(phoneGUI.gridlist["contactsgridlist"], alphabetSortFunc) -- set and load the sorting function
	dgsGridListSetSortColumn(phoneGUI.gridlist["contactsgridlist"], 1)
	dgsGridListSetAutoSortEnabled(phoneGUI.gridlist["contactsgridlist"],true)
	
	if loadedContacts then
		for i, v in pairs(loadedContacts) do
			local row = dgsGridListAddRow(phoneGUI.gridlist["contactsgridlist"])
			dgsGridListSetItemText(phoneGUI.gridlist["contactsgridlist"], row, 1, v.name)
			dgsGridListSetItemData(phoneGUI.gridlist["contactsgridlist"], row, 1, i)
			
			phoneGUI.image["callcontact"..i] = dgsCreateButton(0, 10, iconSize/2.2, iconSize/2.2, "", false, phoneGUI.gridlist["contactsgridlist"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200))
			dgsAttachToGridList(phoneGUI.image["callcontact"..i], phoneGUI.gridlist["contactsgridlist"], row, 2)
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["callcontact"..i], function()
				if source == phoneGUI.image["callcontact"..i] then
					phoneAppCalling(i, "contacts")
				end
			end)
			
			phoneGUI.image["smscontact"..i] = dgsCreateButton(0, 10, iconSize/2.2, iconSize/2.2, "", false, phoneGUI.gridlist["contactsgridlist"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/send.png", ":newphone/files/icons/send.png", ":newphone/files/icons/send.png", tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200))
			dgsAttachToGridList(phoneGUI.image["smscontact"..i], phoneGUI.gridlist["contactsgridlist"], row, 3)
			addEventHandler("onDgsMouseClickDown", phoneGUI.image["smscontact"..i], function()
				if gotMessagesFromNumber(i) then
					phoneOpenMessage(i)
				else
					phoneAppNewMessage(tonumber(i))
				end
			end, false)
		end
		
		addEventHandler( "onDgsGridListSelect", phoneGUI.gridlist["contactsgridlist"], function(current, currentcolumn, previous, previouscolumn)
			if current ~= -1 then
				local contactID = dgsGridListGetItemData(phoneGUI.gridlist["contactsgridlist"], current, 1)
				phoneAppEditContact(contactID)
			end
		end, false)
	end
end
--CONTACTS APP END

--EDIT CONTACT START
contactSavedTimer = nil
function phoneAppEditContact(contactID)
	if not loadedContacts then
		loadedContacts = {}
	end

	if not contactID then
		contactnumber = ""
		contactname = ""
		contactnote = ""
		sharelocation = false
	else
		if loadedContacts[contactID] then
			contactnumber = contactID
			contactname = loadedContacts[contactID].name
			contactnote = loadedContacts[contactID].note
			
			if loadedContacts[contactID].shareLocation == 1 then
				sharelocation = true
			else
				sharelocation = false
			end
		end
	end
	
	setupPhoneApp("editcontact")
	
	if contactID then
		phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 30, dxGetTextWidth(editContactTitleText, 0.8, phoneBigBoldFont), 10, editContactTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
		dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)

	else
		phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 30, dxGetTextWidth(newContactTitleText, 0.8, phoneBigBoldFont), 10, newContactTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
		dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	end
	
	if contactID then
		phoneGUI.image["deletenote"] = dgsCreateButton(185, 28, iconSize/2, iconSize/2, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/delete.png", ":newphone/files/icons/delete.png", ":newphone/files/icons/delete.png")
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["deletenote"], function()
			if contactID then
				loadedContacts[contactID] = nil
			end
			
			triggerServerEvent("phoneUpdateContacts", localPlayer, localPlayer, currentPhoneNumber, loadedContacts)
			
			phoneAppContacts()
		end, false)
	end
	
	phoneGUI.image["seperator"] = dgsCreateImage(10, 60, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	phoneGUI.label["namelabel"] = dgsCreateLabel(5, 80, (369*scaleRatio) - 10, 20, newContactNameText, false, phoneGUI.image["phonewallpaper"])
	dgsSetFont(phoneGUI.label["namelabel"], phoneFont)
	
	phoneGUI.edit["nameedit"] = dgsCreateEdit(5, 100, (369*scaleRatio) - 10, 25, contactname, false, phoneGUI.image["phonewallpaper"])
	dgsSetFont(phoneGUI.edit["nameedit"], phoneFont)
	
	phoneGUI.label["numberedit"] = dgsCreateLabel(5, 130, (369*scaleRatio) - 10, 20, newContactNumberText, false, phoneGUI.image["phonewallpaper"])
	dgsSetFont(phoneGUI.label["numberedit"], phoneFont)
	
	phoneGUI.edit["numberedit"] = dgsCreateEdit(5, 150, (369*scaleRatio) - 10, 25, contactnumber, false, phoneGUI.image["phonewallpaper"])
	dgsSetFont(phoneGUI.edit["numberedit"], phoneFont)
	dgsEditSetMaxLength(phoneGUI.edit["numberedit"], 6)
	dgsEditSetTextFilter(phoneGUI.edit["numberedit"], "%D")
	
	phoneGUI.label["contactnotelabel"] = dgsCreateLabel(5, 180, (369*scaleRatio) - 10, 20, newContactNote, false, phoneGUI.image["phonewallpaper"])
	dgsSetFont(phoneGUI.label["contactnotelabel"], phoneFont)
	
	phoneGUI.edit["contactnote"] = dgsCreateMemo(5, 200, (369*scaleRatio) - 10, 60, contactnote, false, phoneGUI.image["phonewallpaper"])
	dgsSetFont(phoneGUI.edit["contactnote"], phoneFont)
	dgsMemoSetMaxLength(phoneGUI.edit["contactnote"], 128)

	sharelocation = true
	
	--use this when reenabling share location
	--phoneGUI.button["savecontact"] = dgsCreateButton(10, 295, 160, 20, saveContactText, false, phoneGUI.image["phonewallpaper"])
	phoneGUI.button["savecontact"] = dgsCreateButton(125*scaleRatio, 295, 225*scaleRatio, 50*scaleRatio, saveContactText, false, phoneGUI.image["phonewallpaper"])
	dgsCenterElement(phoneGUI.button["savecontact"], false, true)
	addEventHandler("onDgsMouseClickDown", phoneGUI.button["savecontact"], function()
		if source == phoneGUI.button["savecontact"] then
			if contactID then
				if tonumber(dgsGetText(phoneGUI.edit["numberedit"])) ~= contactID then
					loadedContacts[contactID] = nil
					contactID = tonumber(dgsGetText(phoneGUI.edit["numberedit"]))
				end
				loadedContacts[contactID] = {}
				loadedContacts[contactID].name = dgsGetText(phoneGUI.edit["nameedit"])
				loadedContacts[contactID].note = dgsGetText(phoneGUI.edit["contactnote"])
				
				if sharelocation == true then
					loadedContacts[contactID].shareLocation = 1
				else
					loadedContacts[contactID].shareLocation = 0
				end
			else
				local newName = dgsGetText(phoneGUI.edit["nameedit"])
				local newNumber = dgsGetText(phoneGUI.edit["numberedit"])
				local newNote = dgsGetText(phoneGUI.edit["contactnote"])
				
				if loadedContacts[tonumber(newNumber)] then					
					if not contactSavedTimer then
						phoneGUI.label["errorlabel"] = dgsCreateLabel(10, 265, 162, 20, alreadySavedNumberText, false, phoneGUI.image["phonewallpaper"])
						dgsSetProperty(phoneGUI.label["errorlabel"], "textColor", tocolor(200, 0, 0, 150))
						dgsSetFont(phoneGUI.label["errorlabel"], phoneFont)
						dgsLabelSetHorizontalAlign(phoneGUI.label["errorlabel"], "center")
						
						contactSavedTimer = setTimer ( function()
							destroyElement(phoneGUI.label["errorlabel"])
							killTimer(contactSavedTimer)
							contactSavedTimer = nil
						end, 1000, 1)
					end
					return
				else
					if sharelocation == true then
						shareLocationInt = 1
					else
						shareLocationInt = 0
					end
					
					loadedContacts[tostring(newNumber)] = {name = newName, note = newNote, shareLocation = shareLocationInt}
				end
			end
			
			triggerServerEvent("phoneUpdateContacts", localPlayer, localPlayer, currentPhoneNumber, loadedContacts)
			
			phoneAppContacts()
		end
	end)
end
--EDIT CONTACT END