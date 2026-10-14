--NOTES APP START
function phoneAppNotes()
	setupPhoneApp("notes")
	
	phoneGUI.label["noteslabel"] = dgsCreateLabel(20*scaleRatio, 105, dxGetTextWidth(notesTitleText, 0.8, phoneBigBoldFont), 10, notesTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["noteslabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["noteslabel"], phoneBigBoldFont)
	
	phoneGUI.image["createnote"] = dgsCreateButton(185, 100, iconSize/2, iconSize/2, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/edit.png", ":newphone/files/icons/edit.png", ":newphone/files/icons/edit.png")
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["createnote"], function()
		if source == phoneGUI.image["createnote"] then
			phoneAppEditNote()
		end
	end)

	phoneGUI.gridlist["notesgridlist"] = dgsCreateGridList(0, 132, 369*scaleRatio, 250, false, phoneGUI.image["phonewallpaper"])
	dgsGridListAddColumn(phoneGUI.gridlist["notesgridlist"], "", 0.9)
	dgsGridListAddColumn(phoneGUI.gridlist["notesgridlist"], "", 0.1)
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
	
	if loadedNotes then
		for i, v in ipairs(loadedNotes) do
			local row = dgsGridListAddRow(phoneGUI.gridlist["notesgridlist"])
			dgsGridListSetItemText(phoneGUI.gridlist["notesgridlist"], row, 1, v)
			dgsGridListSetItemData(phoneGUI.gridlist["notesgridlist"], row, 1, i)
		end
		
		addEventHandler( "onDgsGridListSelect", phoneGUI.gridlist["notesgridlist"], function(current, currentcolumn, previous, previouscolumn)
			if current ~= -1 then
				local noteID = dgsGridListGetItemData(phoneGUI.gridlist["notesgridlist"], current, 1)
				phoneAppEditNote(noteID)
			end
		end, false)
	end
end
--NOTES APP END

--EDIT NOTE START
function phoneAppEditNote(noteID)
	if not loadedNotes then
		loadedNotes = {}
	end
	
	setupPhoneApp("editnote")
	
	if noteID then
		phoneGUI.label["noteslabel"] = dgsCreateLabel(20*scaleRatio, 70, dxGetTextWidth(editNoteText, 0.8, phoneBigBoldFont), 10, editNoteText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsSetProperty(phoneGUI.label["noteslabel"], "textColor", pageTitleColor)
		dgsSetFont(phoneGUI.label["noteslabel"], phoneBigBoldFont)
	else 
		phoneGUI.label["noteslabel"] = dgsCreateLabel(20*scaleRatio, 70, dxGetTextWidth(createNoteText, 0.8, phoneBigBoldFont), 10, createNoteText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
		dgsSetProperty(phoneGUI.label["noteslabel"], "textColor", pageTitleColor)
		dgsSetFont(phoneGUI.label["noteslabel"], phoneBigBoldFont)
	end
	
	phoneGUI.image["deletenote"] = dgsCreateButton(185, 68, iconSize/2, iconSize/2, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/delete.png", ":newphone/files/icons/delete.png", ":newphone/files/icons/delete.png")
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["deletenote"], function()
		if noteID then
			table.remove(loadedNotes, noteID)
		end
		
		triggerServerEvent("phoneUpdateNotes", localPlayer, localPlayer, currentPhoneNumber, loadedNotes)
		
		phoneAppNotes()
	end, false)
	
	phoneGUI.image["seperator"] = dgsCreateImage(10, 100, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	if noteID then
		text = loadedNotes[noteID][1]
	else
		text = ""
	end
	
	phoneGUI.memo["editnote"] = dgsCreateMemo(0, 102, 222, 225, text, false, phoneGUI.image["phonewallpaper"])
	dgsMemoSetMaxLength(phoneGUI.memo["editnote"], 128)
	dgsMemoSetReadOnly(phoneGUI.memo["editnote"], false)
	dgsSetFont(phoneGUI.memo["editnote"], phoneFont)
	dgsMemoSetWordWrapState(phoneGUI.memo["editnote"], 2)
	dgsMemoSetScrollBarState(phoneGUI.memo["editnote"], false, false)
	dgsSetProperty(phoneGUI.memo["editnote"], "wordBreak", true)
	dgsSetProperty(phoneGUI.memo["editnote"], "clip", true)
	dgsSetProperty(phoneGUI.memo["editnote"],"caretOffset", 0)
	
	phoneGUI.image["seperator"] = dgsCreateImage(0, 102+225, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))

	phoneGUI.button["savenote"] = dgsCreateButton(125*scaleRatio, 600*scaleRatio, 225*scaleRatio, 50*scaleRatio, saveNoteText, false, phoneGUI.image["phonewallpaper"])
	dgsCenterElement(phoneGUI.button["savenote"], false, true)
	addEventHandler("onDgsMouseClickDown", phoneGUI.button["savenote"], function()
		if source == phoneGUI.button["savenote"] then
			if noteID then
				loadedNotes[noteID] = {dgsGetText(phoneGUI.memo["editnote"])}
			else
				-- MAGIC.
				local unreversed = table.reverse(loadedNotes)
				unreversed[#loadedNotes+1] = {dgsGetText(phoneGUI.memo["editnote"])}
				
				loadedNotes = table.reverse(unreversed)
			end
			
			triggerServerEvent("phoneUpdateNotes", localPlayer, localPlayer, currentPhoneNumber, loadedNotes)
			
			phoneAppNotes()
		end
	end)
end
--EDIT NOTE END