
--PHONEBOOK APP START
function phoneAppPhonebook()	
	setupPhoneApp("phonebook")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 80*scaleRatio, dxGetTextWidth(phonebookTitleText, 0.8, phoneBigBoldFont), 10, phonebookTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)

	phoneGUI.gridlist["phonebooklist"] = dgsCreateGridList(0, 90, 369*scaleRatio, 300, false, phoneGUI.image["phonewallpaper"])
	dgsSetFont(phoneGUI.gridlist["phonebooklist"], phoneFont)
	dgsGridListAddColumn(phoneGUI.gridlist["phonebooklist"], "", 0.55)
	dgsGridListAddColumn(phoneGUI.gridlist["phonebooklist"], "", 0.25)
	dgsGridListAddColumn(phoneGUI.gridlist["phonebooklist"], "", 0.15)
	dgsSetProperty(phoneGUI.gridlist["phonebooklist"],"leading", 15)
	dgsSetProperty(phoneGUI.gridlist["phonebooklist"], "columnHeight", 0)
	dgsSetProperty(phoneGUI.gridlist["phonebooklist"], "scrollBarThick", 0)
	dgsSetProperty(phoneGUI.gridlist["phonebooklist"], "bgColor", tocolor(0, 0, 0, 20))
	dgsSetProperty(phoneGUI.gridlist["phonebooklist"], "rowTextColor", tocolor(255, 255, 255, 150))
	dgsSetProperty(phoneGUI.gridlist["phonebooklist"], "rowColor", {tocolor(100, 100, 100, 40), tocolor(249,139,6, 80), tocolor(0, 0, 0, 60)})
	dgsSetProperty(phoneGUI.gridlist["phonebooklist"], "rowHeight", 45)
	dgsSetProperty(phoneGUI.gridlist["phonebooklist"], "rowTextPosOffset", {2, 0})
	dgsSetProperty(phoneGUI.gridlist["phonebooklist"], "rowTextSize", {0.8, 0.8})
	
	-- dgsGridListSetSortFunction(phoneGUI.gridlist["phonebooklist"], alphabetSortFunc) -- set and load the sorting function
	-- dgsGridListSetSortColumn(phoneGUI.gridlist["phonebooklist"], 1)
	-- dgsGridListSetAutoSortEnabled(phoneGUI.gridlist["phonebooklist"],true)
	
	addEventHandler("onDgsGridListSelect", phoneGUI.gridlist["phonebooklist"], function ( current, currentcolumn, previous, previouscolumn )
		if current ~= -1 then
			dgsGridListSetSelectedItem(phoneGUI.gridlist["phonebooklist"], -1)
		end
	end, false)

	for _, i in ipairs(hotlineNumbersOrdered) do
		local row = dgsGridListAddRow(phoneGUI.gridlist["phonebooklist"])
		dgsGridListSetItemData(phoneGUI.gridlist["phonebooklist"], row, 1, i)
		dgsGridListSetItemText(phoneGUI.gridlist["phonebooklist"], row, 1, hotlineNumbers[i].name)
		dgsGridListSetItemText(phoneGUI.gridlist["phonebooklist"], row, 2, i)

		if i == 911 then
			dgsGridListSetItemFont(phoneGUI.gridlist["phonebooklist"], row, 1, "default-bold")
			dgsGridListSetItemFont(phoneGUI.gridlist["phonebooklist"], row, 2, "default-bold")
			dgsGridListSetItemColor(phoneGUI.gridlist["phonebooklist"], row, 1, tocolor(255, 150, 150))
			dgsGridListSetItemColor(phoneGUI.gridlist["phonebooklist"], row, 2, tocolor(255, 150, 150))
		end
		
		phoneGUI.image["callhotline"..i] = dgsCreateButton(0, 10, iconSize/2.2, iconSize/2.2, "", false, phoneGUI.gridlist["contactsgridlist"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200))
		dgsAttachToGridList(phoneGUI.image["callhotline"..i], phoneGUI.gridlist["phonebooklist"], row, 3)
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["callhotline"..i], function()
			if source == phoneGUI.image["callhotline"..i] then
				phoneAppCalling(i, "contacts")
			end
		end)
	end
end
--PHONEBOOK APP END
