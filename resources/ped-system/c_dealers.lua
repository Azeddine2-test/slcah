local talkToPed = nil

DGS = exports["dgs"]

illegalDealerGUI = {
    button = {},
    window = {},
    label = {},
    gridlist = {},
}

local screenW, screenH = DGS:dgsGetScreenSize()

function openDealerGUI(weaponDealer, level)
	local items = getElementData(weaponDealer, "dealer:items")
	if not items then
		return
	end
	
	if weaponDealer then
		talkToPed = weaponDealer
		--play animation and face towards 
		triggerServerEvent("playTalkDealerAnimation", localPlayer, localPlayer, weaponDealer)
		
		if not illegalDealerGUI.window[1] then
			showCursor(true)
			
			if level == 1 then
				dealerType = "Poor Arms Dealer"
			elseif level == 2 then
				dealerType = "Heavy Arms Dealer"
			elseif level == 3 then
				dealerType = "Low Level Drug Dealer"
			elseif level == 4 then
				deealerType = "High Level Drug Dealer"
			end
			
			illegalDealerGUI.window[1] = DGS:dgsCreateWindow((screenW - 300) / 2, (screenH - 400) / 2, 300, 400, ""..dealerType.."", false)
			DGS:dgsWindowSetCloseButtonEnabled(illegalDealerGUI.window[1], false)
			DGS:dgsWindowSetSizable(illegalDealerGUI.window[1], false)
			
			illegalDealerGUI.label["crackheadsays"] = DGS:dgsCreateLabel(5, 10, 280, 30, "Hey, this is what I've got right now, \ntake it or leave it, but be fast.", false, illegalDealerGUI.window[1])
			DGS:dgsSetProperty(illegalDealerGUI.label["crackheadsays"], "textColor", tocolor(255, 255, 255))
			DGS:dgsSetProperty(illegalDealerGUI.label["crackheadsays"], "wordBreak", true)
			DGS:dgsLabelSetHorizontalAlign(illegalDealerGUI.label["crackheadsays"], "center")
			
			illegalDealerGUI.gridlist[1] = DGS:dgsCreateGridList(10, 40, 280, 290, false, illegalDealerGUI.window[1])
			itemColumn = DGS:dgsGridListAddColumn(illegalDealerGUI.gridlist[1], "Item Name", 0.7)
			priceColumn = DGS:dgsGridListAddColumn(illegalDealerGUI.gridlist[1], "Cost", 0.3)	
			
			for k, v in ipairs(items) do
				if v.name then
					local row = DGS:dgsGridListAddRow(illegalDealerGUI.gridlist[1])
					DGS:dgsGridListSetItemText(illegalDealerGUI.gridlist[1], row, itemColumn, v.name)
					DGS:dgsGridListSetItemText(illegalDealerGUI.gridlist[1], row, priceColumn, "$".. v.price)
					DGS:dgsGridListSetItemData (illegalDealerGUI.gridlist[1], row, itemColumn, k)
				end
			end
			
			addEventHandler("onDgsMouseDoubleClick", illegalDealerGUI.gridlist[1], function ()
				if source == illegalDealerGUI.gridlist[1] then
					local row, col = DGS:dgsGridListGetSelectedItem(illegalDealerGUI.gridlist[1])
					if row > 0 and col > 0 then
						local itemIndex = DGS:dgsGridListGetItemData(illegalDealerGUI.gridlist[1], row, col)
						if itemIndex then
							triggerServerEvent("buyItemFromDealerPed", localPlayer, localPlayer, weaponDealer, itemIndex)
							
							showCursor(false)
		
							DGS:dgsCloseWindow(illegalDealerGUI.window[1]) 
							illegalDealerGUI.window[1] = nil
						end
					end
				end
			end)

			illegalDealerGUI.button[1] = DGS:dgsCreateButton(125, 335, 150, 30, "Close", false, illegalDealerGUI.window[1])   
			DGS:dgsCenterElement(illegalDealerGUI.button[1], false, true)
			addEventHandler("onDgsMouseClickDown", illegalDealerGUI.button[1], function()
				if source == illegalDealerGUI.button[1] then
					showCursor(false)
		
					DGS:dgsCloseWindow(illegalDealerGUI.window[1]) 
					illegalDealerGUI.window[1] = nil
				end
			end
			)
		end
	end
end
addEvent("openDealerGUI", true)
addEventHandler("openDealerGUI", root, openDealerGUI)

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "ped" and talkToPed and talkToPed == source then
		if illegalDealerGUI.window[1] then
			showCursor(false)
				
			DGS:dgsCloseWindow(illegalDealerGUI.window[1]) 
			illegalDealerGUI.window[1] = nil
			executeCommandHandler("togglecursor")
			
			talkToPed = nil
		end
	end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function (theKey, oldValue, newValue)
	if getElementType(source) == "ped" and talkToPed and talkToPed == source then
		if illegalDealerGUI.window[1] and theKey == "items" then
			DGS:dgsGridListClear(illegalDealerGUI.gridlist[1])
			if type(newValue) == "table" then
				for k, v in ipairs(newValue) do
					if v.name then
						local row = DGS:dgsGridListAddRow(illegalDealerGUI.gridlist[1])
						DGS:dgsGridListSetItemText(illegalDealerGUI.gridlist[1], row, itemColumn, v.name)
						DGS:dgsGridListSetItemText(illegalDealerGUI.gridlist[1], row, priceColumn, "$".. v.price)
						DGS:dgsGridListSetItemData (illegalDealerGUI.gridlist[1], row, itemColumn, k)
					end
				end
			end
		end
	end
end)