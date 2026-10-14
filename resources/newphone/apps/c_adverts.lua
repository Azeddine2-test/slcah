-- Nando fixed this shit 19/04/2023

loadedAdverts = nil
loadedAdvertsPhotos = {}

function phoneAppAdverts()
	setupPhoneApp("adverts")

	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 30, dxGetTextWidth(advertsTitleText, 0.8, phoneBigBoldFont), 10, advertsTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	--APP START
	if not loadedAdverts then
		phoneGUI.label["fetchingadverts"] = dgsCreateLabel(10, 175, dxGetTextWidth(fetchingAdvertsText, 1, phoneBigFont), 10, fetchingAdvertsText, false, phoneGUI.image["phonewallpaper"])
		dgsSetProperty(phoneGUI.label["fetchingadverts"], "textColor", tocolor(255, 255, 255, 100))
		dgsSetFont(phoneGUI.label["fetchingadverts"], phoneBigFont)
		dgsCenterElement(phoneGUI.label["fetchingadverts"], false, true)
		
		triggerServerEvent("newphone:getAdverts", resourceRoot)
	else
		phoneGUI.tabpanel["adverts"] = dgsCreateTabPanel(0, 62, 369*scaleRatio, 30, false, phoneGUI.image["phonewallpaper"])
		
		phoneGUI.tab["home"] = dgsCreateTab(""..homeTabText.."", phoneGUI.tabpanel["adverts"])
		dgsSetProperty(phoneGUI.tab["home"], "width", (369*scaleRatio)/4.75)
		phoneGUI.tab["vehicles"] = dgsCreateTab(""..vehiclesTabText.."", phoneGUI.tabpanel["adverts"])
		dgsSetProperty(phoneGUI.tab["vehicles"], "width", (369*scaleRatio)/4.75)
		phoneGUI.tab["property"] = dgsCreateTab(""..propertyTabText.."", phoneGUI.tabpanel["adverts"])
		dgsSetProperty(phoneGUI.tab["property"], "width", (369*scaleRatio)/4.75)
		phoneGUI.tab["other"] = dgsCreateTab(""..otherTabText.."", phoneGUI.tabpanel["adverts"])
		dgsSetProperty(phoneGUI.tab["other"], "width", (369*scaleRatio)/4.75)
		
		addEventHandler("onDgsTabSelect", phoneGUI.tabpanel["adverts"], function()
			if source == phoneGUI.tab["home"] then
				if isElement(phoneGUI.scrollpane["homescroll"]) then
					destroyElement(phoneGUI.scrollpane["homescroll"])
				end
				if isElement(phoneGUI.scrollpane["vehiclescroll"]) then
					destroyElement(phoneGUI.scrollpane["vehiclescroll"])
				end
				if isElement(phoneGUI.scrollpane["propertyscroll"]) then
					destroyElement(phoneGUI.scrollpane["propertyscroll"])
				end
				if isElement(phoneGUI.scrollpane["otherscroll"]) then
					destroyElement(phoneGUI.scrollpane["otherscroll"])
				end
				
				phoneGUI.scrollpane["homescroll"] = dgsCreateScrollPane(0, 100, 369*scaleRatio, 300, false, phoneGUI.image["phonewallpaper"])
				-- dgsSetProperty(phoneGUI.scrollpane["homescroll"], "scrollBarState", {true,false})--{vertical,horizontal}
				dgsSetProperty(phoneGUI.scrollpane["homescroll"], "scrollBarThick", 0)
				dgsCenterElement(phoneGUI.scrollpane["homescroll"], false, true)
				
				myAdverts = {}
				--HOME TAB START
				if not currentAdvertUsername or string.len(currentAdvertUsername) < 1 then
					dgsSetEnabled(phoneGUI.tab["vehicles"], false)
					dgsSetEnabled(phoneGUI.tab["property"], false)
					dgsSetEnabled(phoneGUI.tab["other"], false)
					
					phoneGUI.label["welcomeadverts"] = dgsCreateLabel(5, 15, 369*scaleRatio - 10, 50, advertFirstTimeText, false, phoneGUI.scrollpane["homescroll"])
					dgsSetFont(phoneGUI.label["welcomeadverts"], phoneFont)
					dgsSetProperty(phoneGUI.label["welcomeadverts"], "wordBreak", true)
					
					phoneGUI.edit["usernameedit"] = dgsCreateEdit(5, 80, 369*scaleRatio - 10, 30, "", false, phoneGUI.scrollpane["homescroll"])
					dgsSetFont(phoneGUI.edit["usernameedit"], phoneFont)
					dgsEditSetMaxLength(phoneGUI.edit["usernameedit"], 16)
					
					phoneGUI.label["welcomeadverts"] = dgsCreateLabel(5, 120, 369*scaleRatio - 10, 50, changeLaterText, false, phoneGUI.scrollpane["homescroll"])
					dgsSetFont(phoneGUI.label["welcomeadverts"], phoneFont)
					dgsSetProperty(phoneGUI.label["welcomeadverts"], "wordBreak", true)
					
					phoneGUI.button["saveusername"] = dgsCreateButton(125*scaleRatio, 160, 225*scaleRatio, 50*scaleRatio, saveUsernameText, false, phoneGUI.scrollpane["homescroll"])
					dgsCenterElement(phoneGUI.button["saveusername"], false, true)
					addEventHandler("onDgsMouseClickDown", phoneGUI.button["saveusername"], function()
						if source == phoneGUI.button["saveusername"] then
							local newUsername = dgsGetText(phoneGUI.edit["usernameedit"])
							dgsSetEnabled(phoneGUI.scrollpane["homescroll"], false)
							triggerServerEvent("phoneSaveAdUsername", localPlayer, localPlayer, currentPhoneNumber, newUsername)
						end
					end)
				else
					phoneGUI.label["welcomeadverts"] = dgsCreateLabel(5, 15, 369*scaleRatio - 10, 15, ""..welcomeBackText.." "..currentAdvertUsername..".", false, phoneGUI.scrollpane["homescroll"])
					dgsSetFont(phoneGUI.label["welcomeadverts"], phoneFont)
					dgsLabelSetHorizontalAlign(phoneGUI.label["welcomeadverts"], "center")
					
					local characterID = getElementData(localPlayer, "dbid")
					for k, v in pairs(loadedAdverts) do
						for _, i in pairsByKeys(v) do
							if tostring(i.username) == tostring(currentAdvertUsername) then
								myAdverts[#myAdverts+1] = i
							end
						end
					end
					
					phoneGUI.button["postadvert"] = dgsCreateButton(125*scaleRatio, 38, 225*scaleRatio, 50*scaleRatio, postAdvertTitleText, false, phoneGUI.scrollpane["homescroll"])
					dgsCenterElement(phoneGUI.button["postadvert"], false, true)
					addEventHandler("onDgsMouseClickDown", phoneGUI.button["postadvert"], function()
						if source == phoneGUI.button["postadvert"] then
							phoneAppPostAdvert()
						end
					end)
					
					phoneGUI.label["currentadvertcount"] = dgsCreateLabel(5, 90, 369*scaleRatio - 10, 15, ""..youCurrentlyHaveText.." "..#myAdverts.." "..activeListingsText.."", false, phoneGUI.scrollpane["homescroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["currentadvertcount"], "center")
					dgsSetFont(phoneGUI.label["currentadvertcount"], phoneFont)
					
					local adStart = 120
					for k, v in ipairs(myAdverts) do
						
						phoneGUI.image["seperator"] = dgsCreateImage(10, adStart, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.scrollpane["homescroll"], tocolor(255,255,255,100))
						dgsCenterElement(phoneGUI.image["seperator"], false, true)
						adStart = adStart + 10

						phoneGUI.label["adlabel"..k] = dgsCreateLabel(0, adStart, 369*scaleRatio, 15, v.title, false, phoneGUI.scrollpane["homescroll"])
						dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k], "center")
						dgsSetProperty(phoneGUI.label["adlabel"..k], "textSize", {0.85, 0.85})
						dgsSetProperty(phoneGUI.label["adlabel"..k], "wordBreak", true)
						addEventHandler("onDgsMouseClickDown", phoneGUI.label["adlabel"..k], function()
							phoneAppAdvertsView(k)
						end, false)
						addEventHandler("onDgsMouseEnter", phoneGUI.label["adlabel"..k], function()
							dgsSetProperty(phoneGUI.label["adlabel"..k], "textColor", tocolor(255, 194, 14))
						end, false)
						addEventHandler("onDgsMouseLeave", phoneGUI.label["adlabel"..k], function()
							dgsSetProperty(phoneGUI.label["adlabel"..k], "textColor", tocolor(255, 255, 255))
						end, false)
						adStart = adStart + 30
						
						phoneGUI.label["adlabel"..k.."cost"] = dgsCreateLabel(5, adStart, 369*scaleRatio - 10, 15, ""..currencyText..""..exports["global"]:formatMoney(v.cost), false, phoneGUI.scrollpane["homescroll"])
						dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k.."cost"], "right")
						dgsSetProperty(phoneGUI.label["adlabel"..k.."cost"], "textSize", {0.75, 0.75})
						
						phoneGUI.label["adlabel"..k.."date"] = dgsCreateLabel(5, adStart, 369*scaleRatio - 10, 15, ""..os.date("%x", v.timedate).." "..os.date("%X", v.timedate), false, phoneGUI.scrollpane["homescroll"])
						dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k.."date"], "left")
						dgsSetProperty(phoneGUI.label["adlabel"..k.."date"], "textSize", {0.6, 0.6})
						adStart = adStart + 20
					end
				end
			elseif source == phoneGUI.tab["vehicles"] then
				--VEHICLE TAB START
				if isElement(phoneGUI.scrollpane["homescroll"]) then
					destroyElement(phoneGUI.scrollpane["homescroll"])
				end
				if isElement(phoneGUI.scrollpane["vehiclescroll"]) then
					destroyElement(phoneGUI.scrollpane["vehiclescroll"])
				end
				if isElement(phoneGUI.scrollpane["propertyscroll"]) then
					destroyElement(phoneGUI.scrollpane["propertyscroll"])
				end
				if isElement(phoneGUI.scrollpane["otherscroll"]) then
					destroyElement(phoneGUI.scrollpane["otherscroll"])
				end
				
				phoneGUI.scrollpane["vehiclescroll"] = dgsCreateScrollPane(0, 100, 369*scaleRatio, 300, false, phoneGUI.image["phonewallpaper"])
				-- dgsSetProperty(phoneGUI.scrollpane["vehiclescroll"], "scrollBarState", {true,false})--{vertical,horizontal}
				dgsSetProperty(phoneGUI.scrollpane["vehiclescroll"], "scrollBarThick", 0)
				dgsCenterElement(phoneGUI.scrollpane["vehiclescroll"], false, true)
				
				-- phoneGUI.label["welcomeadverts"] = dgsCreateLabel(5, 15, 369*scaleRatio - 10, 15, vehicleAdvertsTitleText, false, phoneGUI.scrollpane["vehiclescroll"])
				-- dgsSetFont(phoneGUI.label["welcomeadverts"], phoneFont)
				-- dgsLabelSetHorizontalAlign(phoneGUI.label["welcomeadverts"], "center")
				
				--[[phoneGUI.label["currentadvertscount"] = dgsCreateLabel(5, 30, 369*scaleRatio - 10, 15, "There are currently "..#loadedAdverts["vehicles"].." active listings.", false, phoneGUI.scrollpane["vehiclescroll"])
				dgsSetFont(phoneGUI.label["currentadvertscount"], phoneFont)]]
				
				local adStart = 0
				for k, v in pairsByKeys(loadedAdverts["vehicles"]) do
						
					phoneGUI.image["seperator"] = dgsCreateImage(10, adStart, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.scrollpane["vehiclescroll"], tocolor(255,255,255,100))
					dgsCenterElement(phoneGUI.image["seperator"], false, true)
					adStart = adStart + 10

					phoneGUI.label["adlabel"..k] = dgsCreateLabel(0, adStart, 369*scaleRatio, 15, v.title, false, phoneGUI.scrollpane["vehiclescroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k], "center")
					dgsSetProperty(phoneGUI.label["adlabel"..k], "textSize", {0.85, 0.85})
					dgsSetProperty(phoneGUI.label["adlabel"..k], "wordBreak", true)
					addEventHandler("onDgsMouseClickDown", phoneGUI.label["adlabel"..k], function()
						phoneAppAdvertsView(k, "vehicles")
					end, false)
					addEventHandler("onDgsMouseEnter", phoneGUI.label["adlabel"..k], function()
						dgsSetProperty(phoneGUI.label["adlabel"..k], "textColor", tocolor(255, 194, 14))
					end, false)
					addEventHandler("onDgsMouseLeave", phoneGUI.label["adlabel"..k], function()
						dgsSetProperty(phoneGUI.label["adlabel"..k], "textColor", tocolor(255, 255, 255))
					end, false)
					adStart = adStart + 30
					
					phoneGUI.label["adlabel"..k.."cost"] = dgsCreateLabel(5, adStart, 369*scaleRatio - 10, 15, ""..currencyText..""..exports["global"]:formatMoney(v.cost), false, phoneGUI.scrollpane["vehiclescroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k.."cost"], "right")
					dgsSetProperty(phoneGUI.label["adlabel"..k.."cost"], "textSize", {0.75, 0.75})
					
					phoneGUI.label["adlabel"..k.."date"] = dgsCreateLabel(5, adStart, 369*scaleRatio - 10, 15, ""..os.date("%x", v.timedate).." "..os.date("%X", v.timedate), false, phoneGUI.scrollpane["vehiclescroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k.."date"], "left")
					dgsSetProperty(phoneGUI.label["adlabel"..k.."date"], "textSize", {0.6, 0.6})
					adStart = adStart + 20
				end
				--VEHICLE TAB END
			elseif source == phoneGUI.tab["property"] then
				--PROPERTY TAB START
				if isElement(phoneGUI.scrollpane["homescroll"]) then
					destroyElement(phoneGUI.scrollpane["homescroll"])
				end
				if isElement(phoneGUI.scrollpane["vehiclescroll"]) then
					destroyElement(phoneGUI.scrollpane["vehiclescroll"])
				end
				if isElement(phoneGUI.scrollpane["propertyscroll"]) then
					destroyElement(phoneGUI.scrollpane["propertyscroll"])
				end
				if isElement(phoneGUI.scrollpane["otherscroll"]) then
					destroyElement(phoneGUI.scrollpane["otherscroll"])
				end
				
				phoneGUI.scrollpane["propertyscroll"] = dgsCreateScrollPane(0, 100, 369*scaleRatio, 300, false, phoneGUI.image["phonewallpaper"])
				-- dgsSetProperty(phoneGUI.scrollpane["propertyscroll"], "scrollBarState", {true,false})--{vertical,horizontal}
				dgsSetProperty(phoneGUI.scrollpane["propertyscroll"], "scrollBarThick", 0)
				dgsCenterElement(phoneGUI.scrollpane["propertyscroll"], false, true)
				
				-- phoneGUI.label["welcomeadverts"] = dgsCreateLabel(5, 15, 369*scaleRatio - 10, 15, propertyAdvertsTitleText, false, phoneGUI.scrollpane["propertyscroll"])
				-- dgsSetFont(phoneGUI.label["welcomeadverts"], phoneFont)
				-- dgsLabelSetHorizontalAlign(phoneGUI.label["welcomeadverts"], "center")
				
				--[[phoneGUI.label["currentadvertscount"] = dgsCreateLabel(5, 30, 369*scaleRatio - 10, 15, "There are currently "..#loadedAdverts["property"].." active listings.", false, phoneGUI.scrollpane["propertyscroll"])
				dgsSetFont(phoneGUI.label["currentadvertscount"], phoneFont)]]
				
				local adStart = 0
				for k, v in pairsByKeys(loadedAdverts["property"]) do
						
					phoneGUI.image["seperator"] = dgsCreateImage(10, adStart, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.scrollpane["propertyscroll"], tocolor(255,255,255,100))
					dgsCenterElement(phoneGUI.image["seperator"], false, true)
					adStart = adStart + 10

					phoneGUI.label["adlabel"..k] = dgsCreateLabel(0, adStart, 369*scaleRatio, 15, v.title, false, phoneGUI.scrollpane["propertyscroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k], "center")
					dgsSetProperty(phoneGUI.label["adlabel"..k], "textSize", {0.85, 0.85})
					dgsSetProperty(phoneGUI.label["adlabel"..k], "wordBreak", true)
					addEventHandler("onDgsMouseClickDown", phoneGUI.label["adlabel"..k], function()
						phoneAppAdvertsView(k, "property")
					end, false)
					addEventHandler("onDgsMouseEnter", phoneGUI.label["adlabel"..k], function()
						dgsSetProperty(phoneGUI.label["adlabel"..k], "textColor", tocolor(255, 194, 14))
					end, false)
					addEventHandler("onDgsMouseLeave", phoneGUI.label["adlabel"..k], function()
						dgsSetProperty(phoneGUI.label["adlabel"..k], "textColor", tocolor(255, 255, 255))
					end, false)
					adStart = adStart + 30
					
					phoneGUI.label["adlabel"..k.."cost"] = dgsCreateLabel(5, adStart, 369*scaleRatio - 10, 15, ""..currencyText..""..exports["global"]:formatMoney(v.cost), false, phoneGUI.scrollpane["propertyscroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k.."cost"], "right")
					dgsSetProperty(phoneGUI.label["adlabel"..k.."cost"], "textSize", {0.75, 0.75})
					
					phoneGUI.label["adlabel"..k.."date"] = dgsCreateLabel(5, adStart, 369*scaleRatio - 10, 15, ""..os.date("%x", v.timedate).." "..os.date("%X", v.timedate), false, phoneGUI.scrollpane["propertyscroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k.."date"], "left")
					dgsSetProperty(phoneGUI.label["adlabel"..k.."date"], "textSize", {0.6, 0.6})
					adStart = adStart + 20
				end
				--PROPERTY TAB END
			elseif source == phoneGUI.tab["other"] then
				--OTHER TAB START
				if isElement(phoneGUI.scrollpane["homescroll"]) then
					destroyElement(phoneGUI.scrollpane["homescroll"])
				end
				if isElement(phoneGUI.scrollpane["vehiclescroll"]) then
					destroyElement(phoneGUI.scrollpane["vehiclescroll"])
				end
				if isElement(phoneGUI.scrollpane["propertyscroll"]) then
					destroyElement(phoneGUI.scrollpane["propertyscroll"])
				end
				if isElement(phoneGUI.scrollpane["otherscroll"]) then
					destroyElement(phoneGUI.scrollpane["otherscroll"])
				end
				
				phoneGUI.scrollpane["otherscroll"] = dgsCreateScrollPane(0, 100, 369*scaleRatio, 300, false, phoneGUI.image["phonewallpaper"])
				-- dgsSetProperty(phoneGUI.scrollpane["otherscroll"], "scrollBarState", {true,false})--{vertical,horizontal}
				dgsSetProperty(phoneGUI.scrollpane["otherscroll"], "scrollBarThick", 0)
				dgsCenterElement(phoneGUI.scrollpane["otherscroll"], false, true)
				
				-- phoneGUI.label["welcomeadverts"] = dgsCreateLabel(5, 15, 369*scaleRatio - 10, 15, otherAdvertsTitleText, false, phoneGUI.scrollpane["otherscroll"])
				-- dgsSetFont(phoneGUI.label["welcomeadverts"], phoneFont)
				-- dgsLabelSetHorizontalAlign(phoneGUI.label["welcomeadverts"], "center")
				
				--[[phoneGUI.label["currentadvertscount"] = dgsCreateLabel(5, 30, 369*scaleRatio - 10, 15, "There are currently "..#loadedAdverts["other"].." active listings.", false, phoneGUI.scrollpane["otherscroll"])
				dgsSetFont(phoneGUI.label["currentadvertscount"], phoneFont)]]
				
				local adStart = 0
				for k, v in pairsByKeys(loadedAdverts["other"]) do
						
					phoneGUI.image["seperator"] = dgsCreateImage(10, adStart, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.scrollpane["otherscroll"], tocolor(255,255,255,100))
					dgsCenterElement(phoneGUI.image["seperator"], false, true)
					adStart = adStart + 10

					phoneGUI.label["adlabel"..k] = dgsCreateLabel(0, adStart, 369*scaleRatio, 15, v.title, false, phoneGUI.scrollpane["otherscroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k], "center")
					dgsSetProperty(phoneGUI.label["adlabel"..k], "textSize", {0.85, 0.85})
					dgsSetProperty(phoneGUI.label["adlabel"..k], "wordBreak", true)
					addEventHandler("onDgsMouseClickDown", phoneGUI.label["adlabel"..k], function()
						phoneAppAdvertsView(k, "other")
					end, false)
					addEventHandler("onDgsMouseEnter", phoneGUI.label["adlabel"..k], function()
						dgsSetProperty(phoneGUI.label["adlabel"..k], "textColor", tocolor(255, 194, 14))
					end, false)
					addEventHandler("onDgsMouseLeave", phoneGUI.label["adlabel"..k], function()
						dgsSetProperty(phoneGUI.label["adlabel"..k], "textColor", tocolor(255, 255, 255))
					end, false)
					adStart = adStart + 30
					
					phoneGUI.label["adlabel"..k.."cost"] = dgsCreateLabel(5, adStart, 369*scaleRatio - 10, 15, ""..currencyText..""..exports["global"]:formatMoney(v.cost), false, phoneGUI.scrollpane["otherscroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k.."cost"], "right")
					dgsSetProperty(phoneGUI.label["adlabel"..k.."cost"], "textSize", {0.75, 0.75})
					
					phoneGUI.label["adlabel"..k.."date"] = dgsCreateLabel(5, adStart, 369*scaleRatio - 10, 15, ""..os.date("%x", v.timedate).." "..os.date("%X", v.timedate), false, phoneGUI.scrollpane["otherscroll"])
					dgsLabelSetHorizontalAlign(phoneGUI.label["adlabel"..k.."date"], "left")
					dgsSetProperty(phoneGUI.label["adlabel"..k.."date"], "textSize", {0.6, 0.6})
					adStart = adStart + 20
				end
				--OTHER TAB END
			end
		end)
		dgsSetSelectedTab(phoneGUI.tabpanel["adverts"], phoneGUI.tab["vehicles"])
		dgsSetSelectedTab(phoneGUI.tabpanel["adverts"], phoneGUI.tab["home"])
	end
	-- HOME TAB end
	
	--APP END
end

function phoneAppAdvertsView(advertID, advertType)
	if not advertType then
		viewLoadedAdverts = myAdverts or {}
	else
		viewLoadedAdverts = loadedAdverts[advertType] or {}
	end
	
	setupPhoneApp("viewadvert")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 30, dxGetTextWidth(viewAdvertTitleText, 0.8, phoneBigBoldFont), 10, viewAdvertTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.image["seperator"] = dgsCreateImage(0, 60, 369*scaleRatio, 5*scaleRatio, ":newphone/files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	--HEADER END
	
	--APP START
	phoneGUI.scrollpane["adscroll"] = dgsCreateScrollPane(0, 62, 369*scaleRatio, 332, false, phoneGUI.image["phonewallpaper"])
	-- dgsSetProperty(phoneGUI.scrollpane["adscroll"], "scrollBarState", {true,false})--{vertical,horizontal}
	dgsSetProperty(phoneGUI.scrollpane["adscroll"], "scrollBarThick", 0)
	dgsCenterElement(phoneGUI.scrollpane["adscroll"], false, true)
	
	phoneGUI.label["adverttitle"] = dgsCreateLabel(5, 15+5, 369*scaleRatio - 10, 30, viewLoadedAdverts[advertID].title, false, phoneGUI.scrollpane["adscroll"])
	dgsSetFont(phoneGUI.label["adverttitle"], phoneBigFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["adverttitle"], "center")
	
	phoneGUI.label["advertdesc"] = dgsCreateLabel(5, 15+30+10, 369*scaleRatio - 10, 90, viewLoadedAdverts[advertID].description, false, phoneGUI.scrollpane["adscroll"])
	dgsSetFont(phoneGUI.label["advertdesc"], phoneFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["advertdesc"], "center")
	dgsSetProperty(phoneGUI.label["advertdesc"], "wordBreak", true)
	
	if (tonumber(viewLoadedAdverts[advertID].cost) or 0) > 0 then
		phoneGUI.label["price"] = dgsCreateLabel(5, 15+30+15+35, 369*scaleRatio - 10, 15, ""..currencyText..""..exports["global"]:formatMoney(viewLoadedAdverts[advertID].cost), false, phoneGUI.scrollpane["adscroll"])
		dgsSetFont(phoneGUI.label["price"], phoneFont)
		dgsLabelSetHorizontalAlign(phoneGUI.label["price"], "center")
		dgsSetProperty(phoneGUI.label["price"], "wordBreak", true)
	end
	
	phoneGUI.label["adphonetitle"] = dgsCreateLabel(10, 15+30+15+66, 369*scaleRatio - 20, 15, phoneAdText, false, phoneGUI.scrollpane["adscroll"])
	dgsSetFont(phoneGUI.label["adphonetitle"], phoneFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["adphonetitle"], "left")
	
	phoneGUI.label["adphonenumber"] = dgsCreateLabel(30, 15+30+15+82+3, 100, 15, viewLoadedAdverts[advertID].phonenumber, false, phoneGUI.scrollpane["adscroll"])
	dgsSetFont(phoneGUI.label["adphonenumber"], phoneFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["adphonenumber"], "left")
	
	phoneGUI.label["adpostertitle"] = dgsCreateLabel(0, 15+30+15+66, 369*scaleRatio-5, 15, postedByText, false, phoneGUI.scrollpane["adscroll"])
	dgsSetFont(phoneGUI.label["adpostertitle"], phoneFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["adpostertitle"], "right")
	
	phoneGUI.label["adposter"] = dgsCreateLabel(115, 15+30+15+82+3, 100, 15, viewLoadedAdverts[advertID].username, false, phoneGUI.scrollpane["adscroll"])
	dgsSetFont(phoneGUI.label["adposter"], phoneFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["adposter"], "right")
	
	phoneGUI.label["posteddate"] = dgsCreateLabel(5, 15+30+15+82+3+20, 369*scaleRatio - 10, 30, ""..postedDateText.." \n"..""..os.date("%x", viewLoadedAdverts[advertID].timedate).." "..os.date("%X", viewLoadedAdverts[advertID].timedate).."", false, phoneGUI.scrollpane["adscroll"])
	dgsSetFont(phoneGUI.label["posteddate"], phoneFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["posteddate"], "center")
	dgsSetProperty(phoneGUI.label["posteddate"], "wordBreak", true)
	
	phoneGUI.image["callad"..viewLoadedAdverts[advertID].phonenumber] = dgsCreateButton(5, 15+30+15+82, iconSize/2.2, iconSize/2.2, "", false, phoneGUI.scrollpane["adscroll"], tocolor(255,255,255,255), 1, 1, ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", ":newphone/files/icons/numbers/call.png", tocolor(255, 255, 255, 200), tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 200))
	addEventHandler("onDgsMouseClickDown", phoneGUI.image["callad"..viewLoadedAdverts[advertID].phonenumber], function()
		if source == phoneGUI.image["callad"..viewLoadedAdverts[advertID].phonenumber] then
			phoneAppCalling(viewLoadedAdverts[advertID].phonenumber, "phone")
		end
	end)
	
	local yAmount = 0
	if exports.integration:isPlayerTrialAdmin(localPlayer, true) then
		phoneGUI.label["posterooc"] = dgsCreateLabel(5, 10+55+30+15+82+3+20, 369*scaleRatio - 10, 30, oocUsernameText.."\n"..viewLoadedAdverts[advertID].oocusername.."", false, phoneGUI.scrollpane["adscroll"])
		dgsSetFont(phoneGUI.label["posterooc"], phoneFont)
		dgsLabelSetHorizontalAlign(phoneGUI.label["posterooc"], "center")
		dgsSetProperty(phoneGUI.label["posterooc"], "wordBreak", true)
		
		yAmount = yAmount + 35
	end
	
	if tostring(viewLoadedAdverts[advertID].phonenumber) == tostring(currentPhoneNumber) then
		phoneGUI.image["editadvert"] = dgsCreateButton(185, 28, iconSize/2, iconSize/2, "", false, phoneGUI.image["phonewallpaper"], tocolor(0,0,0,255), 1, 1, ":newphone/files/icons/edit.png", ":newphone/files/icons/edit.png", ":newphone/files/icons/edit.png")
		addEventHandler("onDgsMouseClickDown", phoneGUI.image["editadvert"], function()
			phoneAppEditAdvert(advertType, advertID)
		end, false)
	end
	
	if exports.integration:isPlayerTrialAdmin(localPlayer, true) or (tostring(viewLoadedAdverts[advertID].username) == tostring(currentAdvertUsername)) then
		phoneGUI.button["deleteadvert"] = dgsCreateButton(125*scaleRatio, 10+55+30+15+82+40+yAmount, 225*scaleRatio, 50*scaleRatio, deleteAdvertText, false, phoneGUI.scrollpane["adscroll"])
		dgsCenterElement(phoneGUI.button["deleteadvert"], false, true)
		addEventHandler("onDgsMouseClickDown", phoneGUI.button["deleteadvert"], function()
			dgsSetEnabled(phoneGUI.scrollpane["adscroll"], false)
			triggerServerEvent("deleteAdvert", localPlayer, localPlayer, viewLoadedAdverts[advertID].dbid)
		end, false)
	end
	
	--APP END
end

function phoneAppPostAdvert()
	setupPhoneApp("postadvert")

	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 30, dxGetTextWidth(postAdvertTitleText, 0.8, phoneBigBoldFont), 10, postAdvertTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	--APP START
	phoneGUI.scrollpane["postadscroll"] = dgsCreateScrollPane(0, 62, 369*scaleRatio, 340, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.scrollpane["postadscroll"], "scrollBarState", {true,false})--{vertical,horizontal}
	-- dgsSetProperty(phoneGUI.scrollpane["postadscroll"], "scrollBarThick", 0)
	dgsCenterElement(phoneGUI.scrollpane["postadscroll"], false, true)
	
	if myAdverts and #myAdverts == 3 then
		phoneGUI.label["welcomeadverts"] = dgsCreateLabel(5, 10, 369*scaleRatio - 10, 15, maxAdvertsText, false, phoneGUI.scrollpane["postadscroll"])
		dgsSetFont(phoneGUI.label["welcomeadverts"], phoneFont)
		dgsLabelSetHorizontalAlign(phoneGUI.label["welcomeadverts"], "center")
		dgsSetProperty(phoneGUI.label["welcomeadverts"], "wordBreak", true)
	else
		phoneGUI.label["adverttitle"] = dgsCreateLabel(5, 10, 369*scaleRatio - 10, 15, advertTitleText, false, phoneGUI.scrollpane["postadscroll"])
		dgsSetFont(phoneGUI.label["adverttitle"], phoneFont)
		dgsSetProperty(phoneGUI.label["adverttitle"], "wordBreak", true)
		
		phoneGUI.edit["adverttitleedit"] = dgsCreateEdit(5, 25, 369*scaleRatio - 10, 30, "", false, phoneGUI.scrollpane["postadscroll"])
		dgsSetFont(phoneGUI.edit["adverttitleedit"], phoneFont)
		if phoneGUI.edit["adverttitleedit"] then
			dgsEditSetMaxLength(phoneGUI.edit["adverttitleedit"], 24)
		end
		
		phoneGUI.label["advertcost"] = dgsCreateLabel(5, 65, 369*scaleRatio, 15, advertPriceText, false, phoneGUI.scrollpane["postadscroll"])
		dgsSetFont(phoneGUI.label["advertcost"], phoneFont)
		dgsSetProperty(phoneGUI.label["advertcost"], "wordBreak", true)
		
		phoneGUI.edit["advertcostedit"] = dgsCreateEdit(5, 80, 369*scaleRatio - 10, 30, "", false, phoneGUI.scrollpane["postadscroll"])
		dgsSetFont(phoneGUI.edit["advertcostedit"], phoneFont)
		
		phoneGUI.label["advertdesc"] = dgsCreateLabel(5, 120, 369*scaleRatio - 10, 15, advertDescText, false, phoneGUI.scrollpane["postadscroll"])
		dgsSetFont(phoneGUI.label["advertdesc"], phoneFont)
		dgsSetProperty(phoneGUI.label["advertdesc"], "wordBreak", true)
		
		phoneGUI.memo["advertdescmemo"] = dgsCreateMemo(5, 135, 369*scaleRatio - 10, 175, "", false, phoneGUI.scrollpane["postadscroll"])
		dgsMemoSetMaxLength(phoneGUI.memo["advertdescmemo"], 100)
		dgsMemoSetReadOnly(phoneGUI.memo["advertdescmemo"], false)
		dgsSetFont(phoneGUI.memo["advertdescmemo"], phoneFont)
		dgsMemoSetWordWrapState(phoneGUI.memo["advertdescmemo"], 2)
		dgsMemoSetScrollBarState(phoneGUI.memo["advertdescmemo"], false, false)
		dgsSetProperty(phoneGUI.memo["advertdescmemo"], "wordBreak", true)
		dgsSetProperty(phoneGUI.memo["advertdescmemo"], "clip", true)
		dgsSetProperty(phoneGUI.memo["advertdescmemo"],"caretOffset", 0)
		
		-- phoneGUI.label["advertphoto"] = dgsCreateLabel(5, 320, 369*scaleRatio, 15, advertPhotoText, false, phoneGUI.scrollpane["postadscroll"])
		-- dgsSetFont(phoneGUI.label["advertphoto"], phoneFont)
		-- dgsSetProperty(phoneGUI.label["advertphoto"], "wordBreak", true)
		
		-- phoneGUI.edit["advertphotoedit"] = dgsCreateEdit(5, 335, 369*scaleRatio - 10, 30, "", false, phoneGUI.scrollpane["postadscroll"])
		-- dgsSetFont(phoneGUI.edit["advertphotoedit"], phoneFont)
		
		phoneGUI.label["adverttype"] = dgsCreateLabel(5, 320, 369*scaleRatio - 10, 15, advertTypeText, false, phoneGUI.scrollpane["postadscroll"])
		dgsSetFont(phoneGUI.label["adverttype"], phoneFont)
		dgsSetProperty(phoneGUI.label["adverttype"], "wordBreak", true)
		
		phoneGUI.gridlist["adverttypelist"] = dgsCreateGridList(5, 335, 369*scaleRatio - 10, 90, false, phoneGUI.scrollpane["postadscroll"])
		dgsGridListAddColumn(phoneGUI.gridlist["adverttypelist"], "", 1)
		dgsSetProperty(phoneGUI.gridlist["adverttypelist"],"leading", 0)
		dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "columnHeight", 0)
		dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "scrollBarThick", 0)
		dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "bgColor", tocolor(0, 0, 0, 20))
		dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowTextColor", tocolor(255, 255, 255, 150))
		dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowColor", {tocolor(100, 100, 100, 40), tocolor(249,139,6, 150), tocolor(249,139,6, 200)})
		dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowHeight", 30)
		dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowTextPosOffset", {2, 0})
		dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowTextSize", {0.8, 0.8})
		
		local vehicleRow = dgsGridListAddRow(phoneGUI.gridlist["adverttypelist"])
		dgsGridListSetItemText(phoneGUI.gridlist["adverttypelist"], vehicleRow, 1, vehiclesTabText)
		local propertyRow = dgsGridListAddRow(phoneGUI.gridlist["adverttypelist"])
		dgsGridListSetItemText(phoneGUI.gridlist["adverttypelist"], propertyRow, 1, propertyTabText)
		local otherRow = dgsGridListAddRow(phoneGUI.gridlist["adverttypelist"])
		dgsGridListSetItemText(phoneGUI.gridlist["adverttypelist"], otherRow, 1, otherTabText)
		
		phoneGUI.button["checkadvert"] = dgsCreateButton(125*scaleRatio, 440, 225*scaleRatio, 50*scaleRatio, checkAdvertText, false, phoneGUI.scrollpane["postadscroll"])
		dgsCenterElement(phoneGUI.button["checkadvert"], false, true)
		addEventHandler("onDgsMouseClickDown", phoneGUI.button["checkadvert"], function()
			if source == phoneGUI.button["checkadvert"] then
				local advertTitle = dgsGetText(phoneGUI.edit["adverttitleedit"])
				
				local selectedType = dgsGridListGetSelectedItem(phoneGUI.gridlist["adverttypelist"])
				if selectedType == 1 then
					advertType = "vehicles"
				elseif selectedType == 2 then
					advertType = "property"
				elseif selectedType == 3 then
					advertType = "other"
				else
					advertType = "error"
				end
				
				local advertCost = dgsGetText(phoneGUI.edit["advertcostedit"])
				local advertDesc = dgsGetText(phoneGUI.memo["advertdescmemo"])
				-- local advertURL = dgsGetText(phoneGUI.edit["advertphotoedit"])
				
				-- triggerServerEvent("authorizeAdvert", localPlayer, localPlayer, advertTitle, advertType, advertCost, advertDesc, advertURL)
				triggerServerEvent("authorizeAdvert", localPlayer, localPlayer, advertTitle, advertType, advertCost, advertDesc)
			end
		end)
		
		phoneGUI.button["postadvert"] = dgsCreateButton(125*scaleRatio, 480, 225*scaleRatio, 50*scaleRatio, postAdvertText, false, phoneGUI.scrollpane["postadscroll"])
		dgsCenterElement(phoneGUI.button["postadvert"], false, true)
		addEventHandler("onDgsMouseClickDown", phoneGUI.button["postadvert"], function()
			if source == phoneGUI.button["postadvert"] then
				local advertTitle = dgsGetText(phoneGUI.edit["adverttitleedit"])
				
				local selectedType = dgsGridListGetSelectedItem(phoneGUI.gridlist["adverttypelist"])
				if selectedType == 1 then
					advertType = "vehicles"
				elseif selectedType == 2 then
					advertType = "property"
				elseif selectedType == 3 then
					advertType = "other"
				else
					advertType = "error"
				end
				
				local advertCost = tonumber(dgsGetText(phoneGUI.edit["advertcostedit"]))
				local advertDesc = dgsGetText(phoneGUI.memo["advertdescmemo"])
				-- local advertURL = dgsGetText(phoneGUI.edit["advertphotoedit"])

				dgsSetEnabled(phoneGUI.scrollpane["postadscroll"], false)
				
				-- triggerServerEvent("postAdvert", localPlayer, localPlayer, advertTitle, advertType, advertCost, advertDesc, advertURL, currentAdvertUsername, currentPhoneNumber)
				triggerServerEvent("postAdvert", localPlayer, localPlayer, advertTitle, advertType, advertCost, advertDesc, currentAdvertUsername, currentPhoneNumber)
			end
		end)
		dgsSetEnabled(phoneGUI.button["postadvert"], false)

		addEventHandler("onDgsTextChange", phoneGUI.scrollpane["postadscroll"], function()
			if isElement(phoneGUI.button["postadvert"]) then
				dgsSetEnabled(phoneGUI.button["postadvert"], false)
			end
		end)
	end
	--APP END
end

addEvent("newphone:postAdResponse", true)
addEventHandler("newphone:postAdResponse", localPlayer, function(updateT)
	if updateT then
		if updateT["adusername"] then
			currentAdvertUsername = updateT["adusername"]
		end
	end
	loadedAdverts = nil
	--phoneAppAdverts()
end, false)

function phoneAppEditAdvert(advertType, advertID)
	if not advertType then
		viewLoadedAdverts = myAdverts
	else
		viewLoadedAdverts = loadedAdverts[advertType]
	end
	setupPhoneApp("editadvert")
	
	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 30, dxGetTextWidth(editAdvertTitleText, 0.8, phoneBigBoldFont), 10, editAdvertTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	phoneGUI.image["seperator"] = dgsCreateImage(0, 60, 369*scaleRatio, 5*scaleRatio, ":newphone/files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	--APP START
	phoneGUI.scrollpane["editadscroll"] = dgsCreateScrollPane(0, 62, 369*scaleRatio, 340, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.scrollpane["editadscroll"], "scrollBarState", {true,false})--{vertical,horizontal}
	-- dgsSetProperty(phoneGUI.scrollpane["editadscroll"], "scrollBarThick", 0)
	dgsCenterElement(phoneGUI.scrollpane["editadscroll"], false, true)
	
	phoneGUI.label["adverttitle"] = dgsCreateLabel(5, 10, 369*scaleRatio - 10, 15, advertTitleText, false, phoneGUI.scrollpane["editadscroll"])
	dgsSetFont(phoneGUI.label["adverttitle"], phoneFont)
	dgsSetProperty(phoneGUI.label["adverttitle"], "wordBreak", true)
	
	phoneGUI.edit["adverttitleedit"] = dgsCreateEdit(5, 25, 369*scaleRatio - 10, 30, viewLoadedAdverts[advertID].title, false, phoneGUI.scrollpane["editadscroll"])
	dgsSetFont(phoneGUI.edit["adverttitleedit"], phoneFont)
	if phoneGUI.edit["adverttitleedit"] then
		dgsEditSetMaxLength(phoneGUI.edit["adverttitleedit"], 24)
	end
	
	phoneGUI.label["advertcost"] = dgsCreateLabel(5, 65, 369*scaleRatio, 15, advertPriceText, false, phoneGUI.scrollpane["editadscroll"])
	dgsSetFont(phoneGUI.label["advertcost"], phoneFont)
	dgsSetProperty(phoneGUI.label["advertcost"], "wordBreak", true)
	
	phoneGUI.edit["advertcostedit"] = dgsCreateEdit(5, 80, 369*scaleRatio - 10, 30, viewLoadedAdverts[advertID].cost, false, phoneGUI.scrollpane["editadscroll"])
	dgsSetFont(phoneGUI.edit["advertcostedit"], phoneFont)
	dgsEditSetMaxLength(phoneGUI.edit["advertcostedit"], 16)
	
	phoneGUI.label["advertdesc"] = dgsCreateLabel(5, 120, 369*scaleRatio - 10, 15, advertDescText, false, phoneGUI.scrollpane["editadscroll"])
	dgsSetFont(phoneGUI.label["advertdesc"], phoneFont)
	dgsSetProperty(phoneGUI.label["advertdesc"], "wordBreak", true)
	
	phoneGUI.memo["advertdescmemo"] = dgsCreateMemo(5, 135, 369*scaleRatio - 10, 175, viewLoadedAdverts[advertID].description, false, phoneGUI.scrollpane["editadscroll"])
	dgsMemoSetMaxLength(phoneGUI.memo["advertdescmemo"], 256)
	dgsMemoSetReadOnly(phoneGUI.memo["advertdescmemo"], false)
	dgsSetFont(phoneGUI.memo["advertdescmemo"], phoneFont)
	dgsMemoSetWordWrapState(phoneGUI.memo["advertdescmemo"], 2)
	dgsMemoSetScrollBarState(phoneGUI.memo["advertdescmemo"], false, false)
	dgsSetProperty(phoneGUI.memo["advertdescmemo"], "wordBreak", true)
	dgsSetProperty(phoneGUI.memo["advertdescmemo"], "clip", true)
	
	-- phoneGUI.label["advertphoto"] = dgsCreateLabel(5, 320, 369*scaleRatio, 15, advertPhotoText, false, phoneGUI.scrollpane["editadscroll"])
	-- dgsSetFont(phoneGUI.label["advertphoto"], phoneFont)
	-- dgsSetProperty(phoneGUI.label["advertphoto"], "wordBreak", true)
	
	-- phoneGUI.edit["advertphotoedit"] = dgsCreateEdit(5, 335, 369*scaleRatio - 10, 30, viewLoadedAdverts[advertID].photo, false, phoneGUI.scrollpane["editadscroll"])
	-- dgsSetFont(phoneGUI.edit["advertphotoedit"], phoneFont)
	
	phoneGUI.label["adverttype"] = dgsCreateLabel(5, 320, 369*scaleRatio - 10, 15, advertTypeText, false, phoneGUI.scrollpane["editadscroll"])
	dgsSetFont(phoneGUI.label["adverttype"], phoneFont)
	dgsSetProperty(phoneGUI.label["adverttype"], "wordBreak", true)
	
	phoneGUI.gridlist["adverttypelist"] = dgsCreateGridList(5, 335, 369*scaleRatio - 10, 90, false, phoneGUI.scrollpane["editadscroll"])
	dgsGridListAddColumn(phoneGUI.gridlist["adverttypelist"], "", 1)
	dgsSetProperty(phoneGUI.gridlist["adverttypelist"],"leading", 0)
	dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "columnHeight", 0)
	dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "scrollBarThick", 0)
	dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "bgColor", tocolor(0, 0, 0, 20))
	dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowTextColor", tocolor(255, 255, 255, 150))
	dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowColor", {tocolor(100, 100, 100, 40), tocolor(249,139,6, 150), tocolor(249,139,6, 200)})
	dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowHeight", 30)
	dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowTextPosOffset", {2, 0})
	dgsSetProperty(phoneGUI.gridlist["adverttypelist"], "rowTextSize", {0.8, 0.8})
	
	local vehicleRow = dgsGridListAddRow(phoneGUI.gridlist["adverttypelist"])
	dgsGridListSetItemText(phoneGUI.gridlist["adverttypelist"], vehicleRow, 1, "Vehicles")
	local propertyRow = dgsGridListAddRow(phoneGUI.gridlist["adverttypelist"])
	dgsGridListSetItemText(phoneGUI.gridlist["adverttypelist"], propertyRow, 1, "Property")
	local otherRow = dgsGridListAddRow(phoneGUI.gridlist["adverttypelist"])
	dgsGridListSetItemText(phoneGUI.gridlist["adverttypelist"], otherRow, 1, "Other")
	
	if viewLoadedAdverts[advertID].adtype == "vehicles" then
		dgsGridListSetSelectedItem(phoneGUI.gridlist["adverttypelist"], 1)
	elseif viewLoadedAdverts[advertID].adtype == "property" then
		dgsGridListSetSelectedItem(phoneGUI.gridlist["adverttypelist"], 2)
	else
		dgsGridListSetSelectedItem(phoneGUI.gridlist["adverttypelist"], 3)
	end
	
	phoneGUI.button["checkadvert"] = dgsCreateButton(125*scaleRatio, 440, 225*scaleRatio, 50*scaleRatio, checkAdvertText, false, phoneGUI.scrollpane["editadscroll"])
	dgsCenterElement(phoneGUI.button["checkadvert"], false, true)
	addEventHandler("onDgsMouseClickDown", phoneGUI.button["checkadvert"], function()
		if source == phoneGUI.button["checkadvert"] then
			local advertTitle = dgsGetText(phoneGUI.edit["adverttitleedit"])
			
			local selectedType = dgsGridListGetSelectedItem(phoneGUI.gridlist["adverttypelist"])
			if selectedType == -1 then
				advertType = "other"
			elseif selectedType == 1 then
				advertType = "vehicles"
			elseif selectedType == 2 then
				advertType = "property"
			elseif selectedType == 3 then
				advertType = "other"
			end
			
			local advertCost = dgsGetText(phoneGUI.edit["advertcostedit"])
			local advertDesc = dgsGetText(phoneGUI.memo["advertdescmemo"])
			-- local advertURL = dgsGetText(phoneGUI.edit["advertphotoedit"])
			
			-- triggerServerEvent("authorizeAdvert", localPlayer, localPlayer, advertTitle, advertType, advertCost, advertDesc, advertURL)
			triggerServerEvent("authorizeAdvert", localPlayer, localPlayer, advertTitle, advertType, advertCost, advertDesc)
		end
	end)
	
	phoneGUI.button["postadvert"] = dgsCreateButton(125*scaleRatio, 480, 225*scaleRatio, 50*scaleRatio, editAdvertText, false, phoneGUI.scrollpane["editadscroll"])
	dgsCenterElement(phoneGUI.button["postadvert"], false, true)
	addEventHandler("onDgsMouseClickDown", phoneGUI.button["postadvert"], function()
		if source == phoneGUI.button["postadvert"] then
			local advertTitle = dgsGetText(phoneGUI.edit["adverttitleedit"])
			
			local selectedType = dgsGridListGetSelectedItem(phoneGUI.gridlist["adverttypelist"])
			if selectedType == 1 then
				advertType = "vehicles"
			elseif selectedType == 2 then
				advertType = "property"
			elseif selectedType == 3 then
				advertType = "other"
			else
				advertType = "error"
			end
			
			local advertCost = tonumber(dgsGetText(phoneGUI.edit["advertcostedit"]))
			local advertDesc = dgsGetText(phoneGUI.memo["advertdescmemo"])
			-- local advertURL = dgsGetText(phoneGUI.edit["advertphotoedit"])
			
			dgsSetEnabled(phoneGUI.scrollpane["editadscroll"], false)
			
			-- triggerServerEvent("updateAdvert", localPlayer, localPlayer, viewLoadedAdverts[advertID].dbid, advertTitle, advertType, advertCost, advertDesc, advertURL, currentAdvertUsername, currentPhoneNumber)
			triggerServerEvent("updateAdvert", localPlayer, localPlayer, viewLoadedAdverts[advertID].dbid, advertTitle, advertType, advertCost, advertDesc, currentAdvertUsername, currentPhoneNumber)
		end
	end)
	dgsSetEnabled(phoneGUI.button["postadvert"], false)


	addEventHandler("onDgsTextChange", phoneGUI.scrollpane["editadscroll"], function()
		if isElement(phoneGUI.button["postadvert"]) then
			dgsSetEnabled(phoneGUI.button["postadvert"], false)
		end
	end)
	--APP END

	phoneGUI.image["seperator"] = dgsCreateImage(0, 400, 369*scaleRatio, 5*scaleRatio, ":newphone/files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
end

-- function sendBackAdAuth(titleGood, typeGood, costGood, descGood, URLGood)
function sendBackAdAuth(titleGood, typeGood, costGood, descGood)
	if true then
		return
	end
	-- if titleGood and typeGood and costGood and descGood and URLGood then
	if titleGood and typeGood and costGood and descGood then
		for element, text in pairs({
			-- [phoneGUI.label["advertphoto"]] = advertPhotoText,
			[phoneGUI.label["adverttitle"]] = advertTitleText,
			[phoneGUI.label["advertcost"]] = advertPriceText,
			[phoneGUI.label["adverttype"]] = advertTypeText,
			[phoneGUI.label["advertdesc"]] = advertDescText,
		}) do
			dgsSetText(element, text)
			dgsSetProperty(element, "textColor", tocolor(255, 255, 255))
		end
		if isElement(phoneGUI.button["postadvert"]) then
			dgsSetEnabled(phoneGUI.button["postadvert"], true)
		end
	else
		-- if not URLGood then
		-- 	dgsSetText(phoneGUI.label["advertphoto"], advertPhotoText.." "..errorNotifText)
		-- 	dgsSetProperty(phoneGUI.label["advertphoto"], "textColor", errorNotifColor)
		-- end
		
		if not titleGood then
			dgsSetText(phoneGUI.label["adverttitle"], advertTitleText.." "..errorNotifText)
			dgsSetProperty(phoneGUI.label["adverttitle"], "textColor", errorNotifColor)
		end
		
		if not costGood then
			dgsSetText(phoneGUI.label["advertcost"], advertPriceText.." "..errorNotifText)
			dgsSetProperty(phoneGUI.label["advertcost"], "textColor", errorNotifColor)
		end
		
		if not typeGood then
			dgsSetText(phoneGUI.label["adverttype"], advertTypeText.." "..errorNotifText)
			dgsSetProperty(phoneGUI.label["adverttype"], "textColor", errorNotifColor)
		end
		
		if not descGood then
			dgsSetText(phoneGUI.label["advertdesc"], advertDescText.." "..errorNotifText)
			dgsSetProperty(phoneGUI.label["advertdesc"], "textColor", errorNotifColor)
		end

		if not (titleGood and typeGood and costGood and descGood) then
			if isElement(phoneGUI.button["postadvert"]) then
				dgsSetEnabled(phoneGUI.button["postadvert"], false)
			end
		end
	end
end
addEvent("sendBackAdAuth", true)
addEventHandler("sendBackAdAuth", root, sendBackAdAuth)

function sendBackAds(adverts)
	if adverts then
		table.sort(adverts, function(a,b)
			return a.timedate > b.timedate
		end)
		loadedAdverts = adverts
		--phoneAppAdverts()
	end
end
addEvent("sendBackAds", true)
addEventHandler("sendBackAds", root, sendBackAds)
