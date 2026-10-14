local dmPed = createPed(100, -660.2373046875, 878.2255859375, 2.0071310997009)
setElementRotation(dmPed, 0, 0, 130)
setElementDimension(dmPed, 0)
setElementInterior(dmPed, 0)
setElementData(dmPed, "rpp.npc.name", "Dirty Money", true)
setElementData(dmPed, "rpp.npc.type", "dirtymoney", true)
setElementFrozen(dmPed, true)


dirtymoneyGUI = {
	window = {},
	button = {},
	label = {},
	gridlist = {},
}

local DGS = exports["dgs"]
local sx, sy = guiGetScreenSize()

local dirtymoneyGUIShowing = false

function showDirtymoneyGUIFunction()
	if not dirtymoneyGUIShowing then
		dirtymoneyGUIShowing = true
		showCursor(true)
		
		local width, height = 500, 500
		
		dirtymoneyGUI.window["main"] = DGS:dgsCreateWindow(sx/2-width/2, sy/2-height/2, width, height, "Money Laundering", false)
		DGS:dgsWindowSetCloseButtonEnabled(dirtymoneyGUI.window["main"], false)
		
		dirtymoneyGUI.label["welcome"] = DGS:dgsCreateLabel(20, 5, 460, 30, "_________ says:", false, dirtymoneyGUI.window["main"])
		DGS:dgsLabelSetVerticalAlign(dirtymoneyGUI.label["welcome"], "center")
		DGS:dgsLabelSetHorizontalAlign(dirtymoneyGUI.label["welcome"], "left")
		DGS:dgsSetFont(dirtymoneyGUI.label["welcome"], "default-bold")
		
		dirtymoneyGUI.label["welcome"] = DGS:dgsCreateLabel(20, 30, 460, 30, "Hey, do you have any money you'd like to launder? I can give you clean money for dirty money but I want a 30% cut.", false, dirtymoneyGUI.window["main"])
		DGS:dgsLabelSetVerticalAlign(dirtymoneyGUI.label["welcome"], "center")
		DGS:dgsLabelSetHorizontalAlign(dirtymoneyGUI.label["welcome"], "center")
		DGS:dgsSetProperty(dirtymoneyGUI.label["welcome"], "wordBreak", true)
		--DGS:dgsSetFont(dirtymoneyGUI.label["welcome"], "default-bold")
		
		dirtymoneyGUI.label["carriedmoney"] = DGS:dgsCreateLabel(20, 70, 460, 10, "Carried Dirty Money:", false, dirtymoneyGUI.window["main"])
		DGS:dgsLabelSetVerticalAlign(dirtymoneyGUI.label["carriedmoney"], "center")
		DGS:dgsLabelSetHorizontalAlign(dirtymoneyGUI.label["carriedmoney"], "left")
		DGS:dgsSetFont(dirtymoneyGUI.label["carriedmoney"], "default-bold")
		
		dirtymoneyGUI.gridlist["moneylist"] = DGS:dgsCreateGridList(20, 85, 460, 300, false, dirtymoneyGUI.window["main"])
		moneyNameCol = DGS:dgsGridListAddColumn(dirtymoneyGUI.gridlist["moneylist"], "Dirty Money Value - Clean Money Value", 0.95)
		
		triggerServerEvent("getPlayerDirtyMoney", localPlayer, localPlayer)
		
		dirtymoneyGUI.button["sellmoney"] = DGS:dgsCreateButton(20, 390, 460, 30, "Swap Money", false, dirtymoneyGUI.window["main"])
		DGS:dgsSetEnabled(dirtymoneyGUI.button["sellmoney"], false)
		addEventHandler("onDgsMouseClickDown", root, function()
			if source == dirtymoneyGUI.button["sellmoney"] then
				local row = DGS:dgsGridListGetSelectedItem(dirtymoneyGUI.gridlist["moneylist"])
				if row ~= -1 then
					dirtymoneyGUIShowing = false
					local itemValue = DGS:dgsGridListGetItemData(dirtymoneyGUI.gridlist["moneylist"], row, 1)
					
					triggerServerEvent("swapDirtyMoney", localPlayer, localPlayer, itemValue)
					
					DGS:dgsCloseWindow(dirtymoneyGUI.window["main"])
					showCursor(false)
				end
			end
		end)
		
		addEventHandler("onDgsMouseClickDown", root, function() -- enable button when click on a money
			if source == dirtymoneyGUI.gridlist["moneylist"] then
				local row = DGS:dgsGridListGetSelectedItem(dirtymoneyGUI.gridlist["moneylist"])
				if row ~= -1 then
					DGS:dgsSetEnabled(dirtymoneyGUI.button["sellmoney"], true)
				else
					DGS:dgsSetEnabled(dirtymoneyGUI.button["sellmoney"], false)
				end
			end
		end)
		
		dirtymoneyGUI.button["closemarket"] = DGS:dgsCreateButton(20, 430, 460, 30, "Leave", false, dirtymoneyGUI.window["main"])
		addEventHandler("onDgsMouseClickDown", root, function()
			if source == dirtymoneyGUI.button["closemarket"] then
				DGS:dgsCloseWindow(dirtymoneyGUI.window["main"])
				showCursor(false)
				dirtymoneyGUIShowing = false
			end
		end)
	end
end
addEvent("showDirtyMoneyGUI", true)
addEventHandler("showDirtyMoneyGUI", root, showDirtymoneyGUIFunction)

function sendBackMoneyFunction(moneyItems)
	if moneyItems then
		if dirtymoneyGUI.gridlist["moneylist"] then
			DGS:dgsGridListClear(dirtymoneyGUI.gridlist["moneylist"])
			
			for slot, item in ipairs(moneyItems) do
				if item.itemValue then
					local row = DGS:dgsGridListAddRow(dirtymoneyGUI.gridlist["moneylist"])
					
					local name = ""
					local desc = exports["item-system"]:getItemDescription(item.itemID, item.itemValue)
					
					local amount70 = math.floor((item.itemValue/100) * 70)
					
					if name ~= desc and #desc > 0 then
						name = desc .. " - Worth: $"..exports["global"]:formatMoney(amount70)
					end
					
					DGS:dgsGridListSetItemText(dirtymoneyGUI.gridlist["moneylist"], row, 1, name, false, false)
					DGS:dgsGridListSetItemData(dirtymoneyGUI.gridlist["moneylist"], row, 1, item.itemValue)
				end
			end
		end
	end
end
addEvent("sendBackMoney", true)
addEventHandler("sendBackMoney", root, sendBackMoneyFunction)