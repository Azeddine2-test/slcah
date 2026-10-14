-- Nando
local function pairsByKeys(t)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0
    local iter = function()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end
local SW, SH = guiGetScreenSize()
local w = nil
local function showInteriorsList(interiors)
	if isElement(w) then destroyElement(w) end
	triggerEvent("cursorShow", localPlayer)
	guiSetInputMode("no_binds_when_editing")

	local WW, WH = 800, 600
	w = guiCreateWindow((SW-WW)/2, (SH-WH)/2, WW, WH, "Intérieurs Officiels - Southland", false)
	guiWindowSetSizable(w, false)
	
	local x = 10
	local y = 15

	local gHeight = WH-60
	local grid = guiCreateGridList(x, y, WW-10, gHeight, false, w)
	local col_id = guiGridListAddColumn(grid, "ID", 0.1)
	local col_name = guiGridListAddColumn(grid, "Nom", 0.5)
	local col_map = guiGridListAddColumn(grid, "Spécial Southland", 0.2)

	local filter = false
	local filterSpecial = false

	local function updateInteriorsList()
		guiGridListClear(grid)

		for id, v in pairsByKeys(interiors) do
			local interiorName = v[6]
			local isSpecial = type(v[7])=="string"
			if ((not filter) or (string.find(string.lower(interiorName), filter)))
			and ((not filterSpecial) or (isSpecial)) then
				local row = guiGridListAddRow(grid)
				guiGridListSetItemText(grid, row, col_id, id, false, true)
				guiGridListSetItemText(grid, row, col_name, interiorName, false, false)
				if isSpecial then
					guiGridListSetItemText(grid, row, col_map, "Oui", false, false)
					guiGridListSetItemColor(grid, row, col_map, 255, 195, 15)
				else
					guiGridListSetItemText(grid, row, col_map, "Non", false, false)
					guiGridListSetItemColor(grid, row, col_map, 200, 200, 200)
				end
			end
		end
	end
	
	y = y + gHeight + 8

	local lSearch = guiCreateLabel(x, y, 75, 30, "Rechercher", false, w)
	guiLabelSetVerticalAlign(lSearch, "center")
	guiLabelSetHorizontalAlign(lSearch, "center")

	local eFilterSearch = guiCreateEdit(x+75, y, 200, 30, "", false, w)
	addEventHandler("onClientGUIChanged", eFilterSearch, function()
		local text = guiGetText(eFilterSearch)
		if text == "" then
			filter = false
		else
			filter = string.lower(text)
		end
		updateInteriorsList()
	end, false)

	local cFilterSpecial = guiCreateCheckBox(x+280, y, 200, 30, "Intérieurs spéciaux", false, false, w)
	addEventHandler("onClientGUIClick", cFilterSpecial, function()
		filterSpecial = guiCheckBoxGetSelected(cFilterSpecial)
		updateInteriorsList()
	end, false)

	updateInteriorsList()

	local bClose = guiCreateButton(WW-100, y, 95, 30, "Fermer", false, w)
	addEventHandler("onClientGUIClick", bClose, function()
		triggerEvent("cursorHide", localPlayer)
		guiSetInputMode("allow_binds")
		destroyElement(w)
		w = nil
	end, false)
end
addEvent("official-interiors:showList", true)
addEventHandler("official-interiors:showList", localPlayer, showInteriorsList, false)