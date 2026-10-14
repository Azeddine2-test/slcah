-- Nando 29/04/2023

local SW, SH = guiGetScreenSize()
local WW, WH = 500, 250
local DGS = exports.dgs
local win, gridlist, spawnButton

local function closeWin()
	
	destroyElement(win)
	win = nil
	gridlist = nil
	closeButton = nil
	spawnButton = nil

	setupBinds(false)

	triggerEvent("cursorHide", localPlayer)
end

local function handleClickSelect(selItem)
	if selItem > 0 then
		local id = tonumber(DGS:dgsGridListGetItemText(gridlist, selItem, 1))
		closeWin()
		triggerServerEvent("vehicle:spawn", root, id)
	end
end

function handleMenuKey(key, pressed)
	if not pressed then return end
	if isChatBoxInputActive() or isConsoleActive() then return end
	local selItem = DGS:dgsGridListGetSelectedItem(gridlist)
	if selItem < 1 then
		selItem = 1
	end
	if key == "arrow_u" then
		if selItem > 1 then
			DGS:dgsGridListSetSelectedItem(gridlist, selItem-1)
		else
			DGS:dgsGridListSetSelectedItem(gridlist, DGS:dgsGridListGetRowCount(gridlist))
		end
		cancelEvent()
	elseif key == "arrow_d" then
		if selItem < DGS:dgsGridListGetRowCount(gridlist) then
			DGS:dgsGridListSetSelectedItem(gridlist, selItem+1)
		else
			DGS:dgsGridListSetSelectedItem(gridlist, 1)
		end
		cancelEvent()
	elseif key == "enter" then
		handleClickSelect(selItem)
		cancelEvent()
	elseif key == "backspace" then
		closeWin()
	end
end

function setupBinds(activate)
	if activate then
		addEventHandler("onClientKey", root, handleMenuKey, false)
	else
		removeEventHandler("onClientKey", root, handleMenuKey, false)
	end
end

local function handleClickWin()
	if source == closeButton then
		closeWin()
	else
		local selItem = DGS:dgsGridListGetSelectedItem(gridlist)
		if selItem > 0 then
			DGS:dgsSetEnabled(spawnButton, true)
		else
			DGS:dgsSetEnabled(spawnButton, false)
		end
		if source == spawnButton then
			handleClickSelect(selItem)
		end
	end
end

local function showVehicleSpawnMenu(vehList)
	local newWin = false
	if isElement(win) then
		destroyElement(win)
	else
		newWin = true
	end

	win = DGS:dgsCreateWindow(SW/2 - WW/2, SH/2 - WH/2, WW, WH, "Spawn de Véhicule", false)
	DGS:dgsWindowSetSizable(win, false)
	DGS:dgsWindowSetCloseButtonEnabled(win, false)

	local infoLabel = DGS:dgsCreateLabel(5, 5, WW-10, 25, "Alternative: /v spawn <id>", false, win)
	DGS:dgsLabelSetHorizontalAlign(infoLabel, "center")

	gridlist = DGS:dgsCreateGridList(5, 35, WW-10, WH-100, false, win)
	DGS:dgsSetProperty(gridlist, "columnTextColor", tocolor(200, 200, 200))
	DGS:dgsGridListAddColumn(gridlist, "ID", 0.2)
	DGS:dgsGridListAddColumn(gridlist, "Nom", 0.6)
	DGS:dgsGridListAddColumn(gridlist, "Modèle", 0.2)
	
	closeButton = DGS:dgsCreateButton(5, WH-55, WW/2-10, 25, "Fermer", false, win)
	spawnButton = DGS:dgsCreateButton(WW/2+5, WH-55, WW/2-10, 25, "Spawn", false, win)
	DGS:dgsSetEnabled(spawnButton, false)
	DGS:dgsSetProperty(spawnButton, "textColor", tocolor(100, 255, 100))

	for _, veh in ipairs(vehList) do
		local row = DGS:dgsGridListAddRow(gridlist)
		DGS:dgsGridListSetItemText(gridlist, row, 1, veh[1])
		DGS:dgsGridListSetItemText(gridlist, row, 2, veh[2])
		DGS:dgsGridListSetItemText(gridlist, row, 3, veh[3] or "")
		if veh[4] then
			DGS:dgsGridListSetItemColor(gridlist, row, 1, 255, 125, 125)
			DGS:dgsGridListSetItemColor(gridlist, row, 2, 255, 125, 125)
		end
	end

	DGS:dgsGridListSetSelectedItem(gridlist, 1)

	addEventHandler("onDgsMouseClickUp", win, handleClickWin)
	
	if newWin then
		triggerEvent("cursorShow", localPlayer)
		setupBinds(true)
	end
end
addEvent("vehicle:spawnMenu", true)
addEventHandler("vehicle:spawnMenu", localPlayer, showVehicleSpawnMenu, false)