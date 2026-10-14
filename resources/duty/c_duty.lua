-- Nando 25/03/2023

local screenWidth, screenHeight = guiGetScreenSize()
local gui = {}

addEvent("duty:open", true)

function itemIsAllowed(allowList, id)
	for key,value in pairs(allowList) do
		for k,v in pairs(value) do
			if tonumber(id) == tonumber(v[1]) then
				return true
			end
		end
	end
	return false
end

function selectPackageGUI_open(availablePackages, allowList)

	if isElement(gui["_root"]) then
		destroyElement(gui["_root"])
	end
	
	local windowWidth, windowHeight = 680, 750
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Sélection Duty", false)
	guiWindowSetSizable(gui["_root"], false)
	triggerEvent("cursorShow", localPlayer)

	local gButtons = {}
	local gChks = {}
	
	gui["tabSelection"] = guiCreateTabPanel(10, 25, (windowWidth)-20, windowHeight-70, false, gui["_root"])
	for pIndex, packageDetails in ipairs(availablePackages) do
		local guiTabName = "package"..tostring(packageDetails[1])
		gui[guiTabName] = guiCreateTab(packageDetails[2], gui["tabSelection"])
		setElementData(gui[guiTabName], "tab:factionID", packageDetails.factionID, false)
		setElementData(gui[guiTabName], "tab:grantID", packageDetails[1], false)

		local TW,TH = guiGetSize(gui[guiTabName], false)
		local scrollPane = guiCreateScrollPane(10, 20, TW-20, TH-30, false, gui[guiTabName])

		local xAxis = 0 -- Start
		local yAxis = 0 -- Start
		
		-- Regular items
		local count = 0
		for index, itemDetails in pairs(packageDetails[5]) do
			local guiPrefix = guiTabName.."-package"..tostring(index).."-"
			
			gui[guiPrefix.."chk1"] = guiCreateCheckBox(xAxis + 30, yAxis+50, 16, 17, "chk", false, false, scrollPane)
			setElementData(gui[guiPrefix.."chk1"], "button:action", "Push", false)
			setElementData(gui[guiPrefix.."chk1"], "button:itemDetails", itemDetails, false)
			setElementData(gui[guiPrefix.."chk1"], "button:itemID", index, false)
			setElementData(gui[guiPrefix.."chk1"], "button:grantID", packageDetails[1], false)
			setElementData(gui[guiPrefix.."chk1"], "button:chk", gui[guiPrefix.."chk1"], false)
			table.insert(gChks, gui[guiPrefix.."chk1"])
			
			gui[guiPrefix.."pushButton1"] = guiCreateButton(xAxis, yAxis, 71, 51, exports['item-system']:getItemName(itemDetails[2]), false, scrollPane)
			setElementData(gui[guiPrefix.."pushButton1"], "button:action", "Push", false)
			setElementData(gui[guiPrefix.."pushButton1"], "button:chk", gui[guiPrefix.."chk1"], false)
			gButtons[ gui[guiPrefix.."chk1"] ] = gui[guiPrefix.."pushButton1"]
			
			gui[guiPrefix.."label_3"] = guiCreateLabel(xAxis, yAxis+6, 71, 13, itemDetails[3], false, scrollPane)
			guiLabelSetHorizontalAlign(gui[guiPrefix.."label_3"], "left", false)
			guiLabelSetVerticalAlign(gui[guiPrefix.."label_3"], "center")
			guiSetProperty(gui[guiPrefix.."label_3"], "AlwaysOnTop", "True")

			if not itemIsAllowed(allowList, itemDetails[1]) then
				guiLabelSetColor(gui[guiPrefix.."label_3"], 255, 0, 0)
				guiSetEnabled(gui[guiPrefix.."pushButton1"], false)
				guiSetEnabled(gui[guiPrefix.."chk1"], false)
			end

			if count == 7 then
				count = 0
				xAxis = 0
				yAxis = yAxis + 70
			else
				xAxis = xAxis + 80 -- prepare next column
				count = count + 1
			end
		end
		
		-- Skins
		local skinTable = { }
		
		-- add package skins
		if packageDetails[3] then
			for i, a in pairs(packageDetails[3]) do
				if a[2] == "N/A" then a[2] = nil end
				local a = table.concat(a, ":")
				table.insert(skinTable, tostring(a))
			end
		end

		xAxis = 0 -- Start
		yAxis = yAxis + 70
		
		count = 0
		for skinIndex, skinID in pairs(skinTable) do
			local skinImg = ("%03d"):format(skinID:gsub(":(.*)$", ""), 10)
		
			gui[guiTabName.."-radio-"..skinID] = guiCreateRadioButton (xAxis + 30, yAxis+80, 15, 15, "", false, scrollPane )
			setElementData(gui[guiTabName.."-radio-"..skinID], "button:skinID", skinID, false)
			setElementData(gui[guiTabName.."-radio-"..skinID], "button:grantID", packageDetails[1], false)
			table.insert(gChks, gui[guiTabName.."-radio-"..skinID])
			if skinIndex == 1 then
				guiRadioButtonSetSelected(gui[guiTabName.."-radio-"..skinID], true)
			end
			
			gui[guiTabName.."-skin-"..skinID] = guiCreateStaticImage (xAxis, yAxis, 75, 75, ":account/img/" .. skinImg..".png", false, scrollPane )
			setElementData(gui[guiTabName.."-skin-"..skinID], "button:action", "Radio", false)
			setElementData(gui[guiTabName.."-skin-"..skinID], "button:element", gui[guiTabName.."-radio-"..skinID], false)

			if count == 7 then
				count = 0
				xAxis = 0
				yAxis = yAxis + 100
			else
				xAxis = xAxis + 80 -- prepare next column
				count = count + 1
			end
		end
	end

	-- Position Cancel and Spawn buttons at the bottom of the GUI
	local bCancel = guiCreateButton(10, windowHeight-40, 200, 35, "Annuler", false, gui["_root"])
	guiSetProperty(bCancel, "NormalTextColour", "FFFFAAAA", false)
	setElementData(bCancel, "button:action", "Cancel", false)

	local bSelWidth = windowWidth - 10 - 200 - 10 - 200 - 10 - 10
	local bSelectAll = guiCreateButton(10 + 200 + 10, windowHeight-40, bSelWidth, 35, "Tout sélectionner", false, gui["_root"])
	guiSetProperty(bSelectAll, "NormalTextColour", "FFFFFF00", false)
	setElementData(bSelectAll, "button:action", "SelectAll", false)
	
	local bSpawn = guiCreateButton(windowWidth-10-200, windowHeight-40, 200, 35, "Spawn", false, gui["_root"])
	guiSetProperty(bSpawn, "NormalTextColour", "FF00FF00", false)
	setElementData(bSpawn, "button:action", "Go", false)

	addEventHandler("onClientGUIClick", gui["_root"], function()
		if not isElement(source) then return end
		local btnAction = getElementData(source, "button:action")
		if btnAction then
			if btnAction == "Cancel" then
				closeSelectWindow()
			elseif btnAction == "Radio" then 
				local victimElement = getElementData(source, "button:element")
				if victimElement then
					guiRadioButtonSetSelected(victimElement, true)
				end
			elseif btnAction == "SelectAll" then
				local oneSelected = false
				for tableIndex, chkBox in ipairs(gChks) do
					if not getElementData(chkBox, "button:skinID") then
						if guiCheckBoxGetSelected(chkBox) then
							oneSelected = true
							break
						end
					end
				end
				for tableIndex, chkBox in ipairs(gChks) do
					if not getElementData(chkBox, "button:skinID") then
						guiCheckBoxSetSelected(chkBox, not oneSelected)
					end
				end
			elseif btnAction == "Go" then
				local grantID = getElementData(guiGetSelectedTab(gui["tabSelection"]), "tab:grantID")
				if grantID then
					local spawnRequest = { }
					local spawnSkin = -1
					-- Make spawn request for server
					for tableIndex, chkBox in ipairs(gChks) do
						local rowGrantID = getElementData(chkBox, "button:grantID")
						if rowGrantID == grantID then
							local rowItemDetails = getElementData(chkBox, "button:itemDetails")
							if rowItemDetails then
								if guiCheckBoxGetSelected(chkBox) then
									table.insert(spawnRequest, rowItemDetails)
								end
							end
							local rowSkinDetails = getElementData(chkBox, "button:skinID")
							if rowSkinDetails then
								if guiRadioButtonGetSelected(chkBox) then
									spawnSkin = rowSkinDetails
								end
							end
						end
					end
					local factionID = getElementData(guiGetSelectedTab(gui["tabSelection"]), "tab:factionID")
					
					closeSelectWindow()
					
					if spawnSkin == -1 then
						return
					end
					triggerServerEvent("duty:request", resourceRoot, grantID, spawnRequest, spawnSkin, factionID)
				end
				
			elseif btnAction == "Push" then
				local guiChk = getElementData(source, "button:chk")
				if guiChk then
					local newstate =  not guiCheckBoxGetSelected ( guiChk )
					chkItemDetails = getElementData(guiChk, "button:itemDetails")
					if chkItemDetails and chkItemDetails[1] then
						for tableIndex, chkBox in ipairs(gChks) do
							cchkItemDetails = getElementData(chkBox, "button:itemDetails")
							if cchkItemDetails and cchkItemDetails[1] then
								if (cchkItemDetails[1] == chkItemDetails[1]) then
									guiCheckBoxSetSelected ( chkBox, false )
									guiSetEnabled( gButtons[chkBox], not newstate )
								end
							end
						end	
					end
					
					
					guiCheckBoxSetSelected ( guiChk, newstate )
					guiSetEnabled( gButtons[guiChk], true )
				end
			elseif btnAction == "Block" then
				guiCheckBoxSetSelected ( source, not guiCheckBoxGetSelected ( source ) )
			end
		end
	end)
end
addEventHandler("duty:open", localPlayer, selectPackageGUI_open, false)

function closeSelectWindow()
	if isElement(gui["_root"]) then
		destroyElement(gui["_root"])
		gui = {}
		triggerEvent("cursorHide", localPlayer)
	end
end
addEventHandler("onClientChangeChar", localPlayer, closeSelectWindow, false)

---

-- Exported
function getFactionPackages( factionID )
    if not factionID or not tonumber( factionID ) then
        return false
    end
    local factionDuty = getElementData(resourceRoot, "factionDuty")

    if type(factionDuty) ~= 'table' then
        factionDuty = {}
        factionDuty[tonumber(factionID)] = {}
    end

    return factionDuty[tonumber(factionID)]
end