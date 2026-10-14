wItems, gWallet, gItems, gKeys, colSlot, colName, colValue, colID, items, bDropItem, bUseItem, bTakeItem, bDeleteItem, bShowItem, bDestroyItem, tabPanel, tabWallet, tabItems, tabWeapons = nil
gWeapons, colWSlot, colWName, colWValue = nil

wRightClick = nil
bPickup, bToggle, bPreviousTrack, bNextTrack, bCloseMenu = nil
ax, ay = nil
item = nil
showinvPlayer = nil
setElementData( localPlayer, "exclusiveGUI", false, false ) -- setting this to false prevents possible problems with fridge/shelf inv.

showFood = true
showKeys = true
showDrugs = true
showOther = true
showBooks = true
showClothes = true
showElectronics = true
showEmpty = true
activeTab = 1
isPlayerGPSShowing = false 

-- PLEASE WAIT window
local sx, sy = guiGetScreenSize( )
wWait = guiCreateButton( ( sx - 200 ) / 2, ( sy - 60 ) / 2, 200, 60, "Please wait a moment...", false )
guiSetEnabled( wWait, false )
guiSetVisible( wWait, false )
guiSetProperty( wWait, "AlwaysOnTop", "True" )

--[[function clickItem(button, state, absX, absY, x, y, z, element)
	if (button == "right") and (state=="down") then
		if getElementData(localPlayer, "exclusiveGUI") then
			return
		end

		local px, py, pz = getElementPosition(localPlayer)
		if element and (getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("map-system")) or getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("interior_system"))) then
			element = nil
		end

		if not element then
			local wx, wy, wz = x, y, z
			local x, y, z = nil
			for key, value in ipairs(getElementsByType("object",getResourceRootElement())) do
				if isElementStreamedIn(value) then
					x, y, z = getElementPosition(value)
					local minx, miny, minz, maxx, maxy, maxz = getElementBoundingBox(value)

					local offset = 0.34

					minx = x + minx - offset
					miny = y + miny - offset
					minz = z + minz - offset

					maxx = x + maxx + offset
					maxy = y + maxy + offset
					maxz = z + maxz + offset

					local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

					if (wx >= minx and wx <=maxx) and (wy >= miny and wy <=maxy) and (wz >= minz and wz <=maxz) then
						element = value
						break
					end
				end
			end
		end

		if element and getElementParent(getElementParent(element)) == getResourceRootElement() then
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 3 then
				if (wRightClick) then
					hideItemMenu()
				end
				ax = absX
				ay = absY
				item = element
				showItemMenu()
			else
				outputChatBox("You are too far away from that item.", 255, 0, 0)
			end
		else
			if (wRightClick) then
				hideItemMenu()
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickItem, true)]]

local delayedGBUpdate = nil

function showItemMenu(element, absX, absY)
	if isElement(element) then item = element; ax = absX; ay = absY end
	if not wRightClick then
	local itemID = getElementData(item, "itemID")
	local itemValue = getElementData(item, "itemValue") or 1
	local itemName = getItemName( itemID, itemValue )

	if itemID ~= 80 or itemID ~= 214 then
		itemName = itemName .. " (" .. getItemValue( itemID, itemValue ) .. ")"
	end
	wRightClick = guiCreateWindow(ax, ay, 150, 200, itemName, false)

	local y = 0.13
	if itemID == 81 or itemID == 103 then
		bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Open", true, wRightClick)
		addEventHandler("onClientGUIClick", bPickup,
			function(button)
				if button=="left" and not getElementData(localPlayer, "exclusiveGUI") then
					triggerServerEvent( "openFreakinInventory", localPlayer, item, ax, ay )
					hideItemMenu()
				end
			end,
			false
		)
	else
		bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Ramasser", true, wRightClick)
		addEventHandler("onClientGUIClick", bPickup, pickupItem, false)
	end
	y = y + 0.14

	if itemID == 54 then
		bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.15, "<", true, wRightClick)
		addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, -1) end, false)

		bNextTrack = guiCreateButton(0.53, y, 0.42, 0.15, ">", true, wRightClick)
		addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, 1) end, false)

		y = y + 0.18

		-- volume
		local sVolume = guiCreateScrollBar(0.05, y, 0.9, 0.1, true, true, wRightClick)
		guiSetProperty(sVolume, 'StepSize', '0.1')

		local value = split(tostring(itemValue), ':')
		guiScrollBarSetScrollPosition(sVolume, tonumber(value[2]) or 100)
		addEventHandler('onClientGUIScroll', sVolume,
			function()
				if delayedGBUpdate then
					killTimer(delayedGBUpdate)
				end

				delayedGBUpdate = setTimer(
					function(val)
						triggerServerEvent("changeGhettoblasterVolume", item, val)
						delayedGBUpdate = nil
					end, 500, 1, guiScrollBarGetScrollPosition(source))
			end, false)
	end

	if itemID == 176 then
		bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.15, "Prev. Station", true, wRightClick)
		addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, -1) end, false)

		bNextTrack = guiCreateButton(0.53, y, 0.42, 0.15, "Next Station", true, wRightClick)
		addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, 1) end, false)

		y = y + 0.18

		-- volume
		local sVolume = guiCreateScrollBar(0.05, y, 0.9, 0.1, true, true, wRightClick)
		guiSetProperty(sVolume, 'StepSize', '0.1')

		local value = split(tostring(itemValue), ':')
		guiScrollBarSetScrollPosition(sVolume, tonumber(value[2]) or 100)
		addEventHandler('onClientGUIScroll', sVolume,
			function()
				if delayedGBUpdate then
					killTimer(delayedGBUpdate)
				end

				delayedGBUpdate = setTimer(
					function(val)
						triggerServerEvent("changeGhettoblasterVolume", item, val)
						delayedGBUpdate = nil
					end, 500, 1, guiScrollBarGetScrollPosition(source))
			end, false)
	end

	y = y + 0.14

	bCloseMenu = guiCreateButton(0.05, y, 0.9, 0.1, "Fermer", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideItemMenu, false)
	end
end
addEvent('item:showMenu', false)
addEventHandler("item:showMenu", localPlayer, showItemMenu)

function hideItemMenu()
	if (isElement(bPickup)) then
		destroyElement(bPickup)
	end
	bPickup = nil

	if (isElement(bToggle)) then
		destroyElement(bToggle)
	end
	bToggle = nil

	if (isElement(bPreviousTrack)) then
		destroyElement(bPreviousTrack)
	end
	bPreviousTrack = nil

	if (isElement(bNextTrack)) then
		destroyElement(bNextTrack)
	end
	bNextTrack = nil

	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil

	if delayedGBUpdate then
		killTimer(delayedGBUpdate)
		delayedGBUpdate = nil
	end

	ax = nil
	ay = nil

	item = nil

	triggerEvent("cursorHide", localPlayer)
end

function updateMenu(dataname)
	if source == item and dataname == "itemValue" and (getElementData(source, "itemID") == 54 or getElementData(source, "itemID") == 176) then -- update the track while you're in menu
		guiSetText(wRightClick, "Ghettoblaster (" .. (getElementData(source, "itemValue") or 1) .. ")")
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), updateMenu)

function toggleGhettoblaster(button, state, absX, absY, step)
	triggerServerEvent("toggleGhettoblaster", localPlayer, item)
	hideItemMenu()
end

local pickupTimer = nil --maxime
function pickupItem(button, state, item)
	if (button=="left") then
		local restrain = getElementData(localPlayer, "restrain")

		if (restrain) and (restrain==1) then
			exports.hud:sendBottomNotification(localPlayer, "Echec", "Vous êtes menotté.", 255, 0, 0)
		elseif getElementData(item, "itemID") > 0 and not hasSpaceForItem(localPlayer, getElementData(item, "itemID"), getElementData(item, "itemValue")) then
			exports.hud:sendBottomNotification(localPlayer, "Echec", "Votre inventaire est plein. "..("%.2f/%.2f" ):format( getCarriedWeight( localPlayer ), getMaxWeight( localPlayer ) ).." kg(s)." , 255, 0, 0)
		elseif isElement(item) then
			if wRightClick then
				triggerEvent("cursorHide", localPlayer)
			end
			if getElementData(item, "transfering") then
				return --outputDebugString("[ITEM] pickupItem / Client / Cancelled by pick up cooldown.")
			end

			local itemID = getElementData(item, "itemID")
			if itemID == 366 or itemID == 378 or itemID == 379 or itemID == 380 then
				outputChatBox("Pour ramasser un(e) " .. getItemName(itemID, 1) .. ", faites clique droit et choisissez \"Ramasser\".", 255, 0, 0);
				return;
			end;
			if itemID ~= 223 and itemID ~= 103 then
				triggerServerEvent("pickupItem", localPlayer, item)
			else
				exports['object-interaction']:areYouSure(item)
			end

			if wRightClick then
				hideItemMenu()
			end
		end
	end
end

addEvent('item:move:protect', true)
addEventHandler('item:move:protect', root,
	function()
		if exports.global:isStaffOnDuty(localPlayer) then
			triggerServerEvent("protectItem", source)
		end
	end)

function toggleCategory()
	-- let's add the items again
	if (isElement(gWallet)) then
		guiGridListClear(gWallet)
	end

	if (isElement(gItems)) then
		guiGridListClear(gItems)
	end

	if (isElement(gKeys)) then
		guiGridListClear(gKeys)
	end

	if (isElement(gWeapons)) then
		guiGridListClear(gWeapons)
	end

	local items = getItems(showinvPlayer)

	local tabs = {gWallet, gItems, gKeys, gWeapons}
	for i,v in ipairs(items) do
		local itemid = v[1]
		local itemvalue = v[2]
		local metadata = v[5]
		local tab = tabs[getItemTab(itemid)]
		local row = guiGridListAddRow(tab)
		guiGridListSetItemText(tab, row, colSlot, tostring(row+1), false, true)
		guiGridListSetItemData(tab, row, colSlot, tostring(i))
		guiGridListSetItemText(tab, row, colName, tostring(getItemName(itemid, itemvalue, metadata)), false, false)
		if showinvType ~= "frisk" then
			guiGridListSetItemText(tab, row, colID, tostring(itemid), false, false)
		end
		guiGridListSetItemText(tab, row, colValue, tostring(getItemValue(itemid, itemvalue, metadata)), false, false)
		guiGridListSetItemData(tab, row, colValue, tostring(itemvalue))
	end
end

function toggleInventory()
	if wItems and guiGetEnabled( wItems ) then
		hideInventory()
	end
end
bindKey("i", "down", toggleInventory)

function copyClipboard()
	local row, col = guiGridListGetSelectedItem(source)
	local text = guiGridListGetItemData(source, row, colValue)
	if text == "" then
		-- do nothing
	elseif setClipboard(text) then
		exports.hud:sendBottomNotification(localPlayer, "Copying", "Copied '" .. text .. "' to clipboard.")
	else
		exports.hud:sendBottomNotification(localPlayer, "Copying", "Failed copying '" .. text .. "' to clipboard.")
	end
end

function showInventory(player, type)
	if not (wItems) then

		showinvPlayer = player
		showinvType = type or "unknown"
		local isFrisk = (showinvType == "frisk")
		if wItems then
			hideInventory()
		end
		if getElementData(localPlayer, "exclusiveGUI") then
			return
		end
		setElementData(localPlayer, "exclusiveGUI", true, false)
		local width, height = 600, 450
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		local title = "Inventaire"
		if player ~= localPlayer then
			title = title .. " de " .. getPlayerName(player):gsub("_", " ")
		end
		wItems = guiCreateWindow(x, y, width, height, title, false)
		guiWindowSetSizable(wItems, false)

		tabPanel = guiCreateTabPanel(0.025, 0.05, 0.95, 0.8, true, wItems)
		tabWallet = guiCreateTab("Porte-feuille", tabPanel)
		tabItems = guiCreateTab("Items", tabPanel)
		tabKeys = guiCreateTab("Clés", tabPanel)
		tabWeapons = guiCreateTab("Armes", tabPanel)

		if activeTab == 1 then
			guiSetSelectedTab(tabPanel, tabWallet)
		elseif activeTab == 2 then
			guiSetSelectedTab(tabPanel, tabItems)
		elseif activeTab == 3 then
			guiSetSelectedTab(tabPanel, tabKeys)
		elseif activeTab == 4 then
			guiSetSelectedTab(tabPanel, tabWeapons)
		end

		addEventHandler( "onClientGUITabSwitched", tabPanel,
			function( tab )
				if tab == tabWallet then
					activeTab = 1
				elseif tab == tabItems then
					activeTab = 2
				elseif tab == tabKeys then
					activeTab = 3
				elseif tab == tabWeapons then
					activeTab = 4
				end
			end,
			false )

		-- WALLET
		gWallet = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWallet)
		addEventHandler("onClientGUIDoubleClick", gWallet, copyClipboard, false)

		colSlot = guiGridListAddColumn(gWallet, "Slot", 0.1)
		colName = guiGridListAddColumn(gWallet, "Nom", 0.225)
		if not isFrisk then
			colID = guiGridListAddColumn(gWallet, "Item ID", 0.1)
		end
		colValue = guiGridListAddColumn(gWallet, "Value", 0.625)

		-- ITEMS
		gItems = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabItems)
		addEventHandler("onClientGUIDoubleClick", gItems, copyClipboard, false)

		colSlot = guiGridListAddColumn(gItems, "Slot", 0.1)
		colName = guiGridListAddColumn(gItems, "Nom", 0.225)
		if not isFrisk then
			colID = guiGridListAddColumn(gItems, "Item ID", 0.1)
		end
		colValue = guiGridListAddColumn(gItems, "Value", 0.625)

		-- keys
		gKeys = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabKeys)
		addEventHandler("onClientGUIDoubleClick", gKeys, copyClipboard, false)

		colSlot = guiGridListAddColumn(gKeys, "Slot", 0.1)
		colName = guiGridListAddColumn(gKeys, "Nom", 0.625)
		if not isFrisk then
			colID = guiGridListAddColumn(gKeys, "Item ID", 0.1)
		end
		colValue = guiGridListAddColumn(gKeys, "Value", 0.225)

		-- WEAPONS
		gWeapons = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWeapons)
		addEventHandler("onClientGUIDoubleClick", gWeapons, copyClipboard, false)

		colWSlot = guiGridListAddColumn(gWeapons, "Slot", 0.1)
		colWName = guiGridListAddColumn(gWeapons, "Nom", 0.225)
		if not isFrisk then
			colID = guiGridListAddColumn(gWeapons, "Item ID", 0.1)
			colWValue = guiGridListAddColumn(gWeapons, "Ammo", 0.625)
		end

		bClose = guiCreateButton(0.400, 0.91, 0.2, 0.15, "Fermer", true, wItems)
		addEventHandler("onClientGUIClick", bClose, hideInventory, false)
		
		bTakeItem = guiCreateButton(0.200, 0.91, 0.2, 0.15, "Prendre Item", true, wItems)
		addEventHandler("onClientGUIClick", bTakeItem, takeInventoryItem, false)

		-- bDeleteItem = guiCreateButton(0.600, 0.91, 0.2, 0.15, "Delete Item", true, wItems)
		-- addEventHandler("onClientGUIClick", bDeleteItem, takeInventoryItem, false)

		if isFrisk then
			guiSetVisible(bTakeItem, false)
			-- guiSetProperty(bTakeItem, "Disabled", "True")
			-- guiSetProperty(bDeleteItem, "Disabled", "True")
		end

		source = nil
		toggleCategory()
		triggerEvent("cursorShow", localPlayer)
	end
end
addEvent("showInventory", true)
addEventHandler("showInventory", getRootElement(), showInventory)

function takeInventoryItem(button, state)
	if (button == "left") then
		local whichGrid = false
		local whichTab = guiGetSelectedTab(tabPanel)
		local whichCommand = nil
	
		if whichTab == tabWallet then 
			whichGrid = gWallet
		elseif whichTab == tabItems then 
			whichGrid = gItems
		elseif whichTab == tabKeys then 
			whichGrid = gKeys
		elseif whichTab == tabWeapons then 
			whichGrid = gWeapons
		end
	
		if (source == bTakeItem) then 
			whichCommand = "takeitem"
		else
			whichCommand = "delplayeritem"
		end

		triggerServerEvent("admin-system:takeItem", localPlayer, localPlayer, whichCommand, showinvPlayer, guiGridListGetItemText(whichGrid, guiGridListGetSelectedItem (whichGrid), 3), guiGridListGetItemText (whichGrid, guiGridListGetSelectedItem (whichGrid), 4))
	end
end
function hideInventory()
	colSlot = nil
	colName = nil
	colValue = nil
	colID = nil

	colWSlot = nil
	colWName = nil
	colWValue = nil

	if wItems then
		destroyElement(wItems)
	end
	wItems = nil

	setElementData(localPlayer, "exclusiveGUI", false, false)

	triggerEvent("cursorHide", localPlayer)
	hideNewInventory()
end
addEvent("hideInventory", true)
addEventHandler("hideInventory", getRootElement(), hideInventory)

-- Nando
function useItem(itemSlot, itemID2, itemValue2, metadata2)
	showinvPlayer = localPlayer
	if isPedDead(localPlayer) then
		return
	end
	if itemSlot > 0 then -- ITEMS
		local item = getItems( showinvPlayer )[itemSlot]
		if not item then
			exports.hud:sendBottomNotification(localPlayer, "Inventaire", "Vous n'avez plus d'item dans ce slot.", 255, 194, 14)
			return
		end
		local itemID = item[1]
		if not g_items[itemID] then
			exports.hud:sendBottomNotification(localPlayer, "Inventaire", "Cet item n'existe plus.", 255, 194, 14)
			return
		end
		local itemValue = item[2]
		local metadata = item[5]

		if not (itemID==itemID2 and itemValue==itemValue2) then
			exports.hud:sendBottomNotification(localPlayer, "Inventaire", "Vous n'avez plus cet item.", 255, 194, 14)
			return
		end

		local itemName = getItemName( itemID, itemValue, metadata )

		local additional = nil

		if (itemID==2) then -- cellphone
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
			hideInventory()
			--triggerServerEvent("phone:requestShowPhoneGUI", localPlayer, tostring(itemValue))
			--triggerEvent("phone:slidePhoneIn", localPlayer, itemValue)
			return
		elseif (itemID==6) then -- radio
			exports.hud:sendBottomNotification(localPlayer, "Usage", "Appuyez Y pour utiliser cet item. Faites /tuneradio pour changer la fréquence de votre radio.", 255, 194, 14)
			return
		elseif (itemID==7) then -- phonebook
			exports.hud:sendBottomNotification(localPlayer, "Usage", "Utilisez /phonebook pour utiliser cet item.", 255, 194, 14)
			return
		elseif (itemID==18) then -- City Guide
			triggerEvent( "showCityGuide", getLocalPlayer( ) )
			return
		elseif (itemID==19) then -- MP3 PLayer
			exports.carradio:showMP3GUI()
			hideInventory()
			return
		elseif (itemID==27) then -- Flashbang
			local x, y, z = getElementPosition(getLocalPlayer( ))
			local rot = getPedRotation(getLocalPlayer( ))
			x = x + math.sin(math.rad(-rot)) * 10
			y = y + math.cos(math.rad(-rot)) * 10
			z = getGroundPosition(x, y, z + 2)
			additional = { x, y, z }
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==28 or itemID==54 or itemID==176) then -- Glowstick or Ghettoblaster or speaker
			local x, y, z = getElementPosition(getLocalPlayer( ))
			local rot = getPedRotation(getLocalPlayer( ))
			x = x + math.sin(math.rad(-rot)) * 2
			y = y + math.cos(math.rad(-rot)) * 2
			z = getGroundPosition(x, y, z)
			local int = getElementInterior(getLocalPlayer( ))
			local dim = getElementDimension(getLocalPlayer( ))
			additional = { x, y, z - 0.5, int, dim }
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==30) or (itemID==31) or (itemID==32) or (itemID==33) then
			exports.hud:sendBottomNotification(localPlayer, "Usage", "Use the chemistry set purchasable from 24/7 to use this item.", 255, 0, 0)
			return
		elseif (itemID==34) or (itemID==37) or (itemID==358) then -- COCAINE / heroine / MDMA
			outputChatBox("(( Si vous déconnectez vous perdrez les bonus#FF0000! ))", 255, 255, 255, true)
			doDrugEffect()
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		--[[
		elseif (itemID==34) then -- COCAINE
			doDrug1Effect()
		elseif (itemID==35) then
			doDrug2Effect()
		elseif (itemID==36) then
			doDrug3Effect()
		elseif (itemID==37) then
			doDrug4Effect()
		elseif (itemID==38) then
			if not getPedOccupiedVehicle(localPlayer) then
				doDrug5Effect()
			end
		elseif (itemID==39) then
			doDrug6Effect()
		elseif (itemID==40) then
			doDrug3Effect()
			doDrug1Effect()
		elseif (itemID==41) then
			doDrug4Effect()
			doDrug6Effect()
		elseif (itemID==42) then
			if not getPedOccupiedVehicle(localPlayer) then
				doDrug5Effect()
				doDrug2Effect()
			end
		elseif (itemID==43) then
			doDrug4Effect()
			doDrug1Effect()
			doDrug6Effect()
		]]
		elseif (itemID==44) then
			hideInventory()
			showChemistrySet()
			return
		elseif (itemID==45) or (itemID==46) or (itemID==47) or (itemID==66) then
			exports.hud:sendBottomNotification(localPlayer, "Usage", "Faites clic droit sur quelqu'un pour utiliser cet item.")
			return
		elseif (itemID==50) or (itemID==51) or (itemID==52) then
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
			hideInventory()
		elseif (itemID==53) then -- Breathalizer
			-- exports.hud:sendBottomNotification(localPlayer, "Usage", "Use /breathtest to use this item.")
			return
		elseif (itemID==55) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Carte de visite: " .. tostring(itemValue))
			return
		elseif (itemID==57) then -- FUEL CAN
			hideInventory()
		--[[elseif (itemID==58) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", ( getElementData(localPlayer, "alcohollevel") or 0 ) + 0.1, false)
				end, 15000, 1
			)]]
		elseif (itemID==61) then -- Emergency Light Becon
			exports.hud:sendBottomNotification(localPlayer, "Usage", "Put it in your car inventory and press 'P' to toggle it.")
			return
		elseif (itemID==62) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", ( getElementData(localPlayer, "alcohollevel") or 0 ) + 0.3, false)
				end, 5000, 1
			)
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==63) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", ( getElementData(localPlayer, "alcohollevel") or 0 ) + 0.2, false)
				end, 10000, 1
			)
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==67) then -- GPS
			exports.hud:sendBottomNotification(localPlayer, itemName, "Put it in your car inventory and Press 'F5'.")
			return
		elseif (itemID==70) then -- First Aid Kit
			exports.hud:sendBottomNotification(localPlayer, itemName, "Cliquez-droit sur un joueur KO pour le stabiliser.")
			return
		elseif (itemID==71) then -- Notebook
			exports.hud:sendBottomNotification(localPlayer, itemName, "Utilisez /writenote [text] pour écrire une note. Il reste " .. itemValue .. " pages.")
			return
		elseif (itemID==72) then -- Note
			exports.hud:sendBottomNotification(localPlayer, itemName, "Il est écrit sur la note: " .. itemValue)
		elseif (itemID==77) then
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
			hideInventory()
		elseif (itemID==78) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "This San Andreas Pilot License was issued for " .. itemValue .. ".")
			return
		elseif (itemID==81) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Drop this Fridge in an Interior.")
			return
		elseif (itemID==84) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Put it in a car or carry it to know when police is around.")
			return
		elseif (itemID==85) then -- Emergency Light Becon
			exports.hud:sendBottomNotification(localPlayer, itemName, "Put it in your car inventory and press 'N' to toggle it.")
			return
		elseif (itemID==103) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Drop this shelf in an interior.")
			return
		elseif itemID == 115 then
			local info = split(tostring(itemValue), ':')
			if info and info[1] == '46' then
				exports.hud:sendBottomNotification(localPlayer, itemName, "Scroll to your parachute while in the air to use it.")
			elseif info and info[1] == '2' then
				triggerEvent("golf:start", root)
			else
				setClipboard(info[2])
				exports.hud:sendBottomNotification(localPlayer, itemName, "Série d'arme copiée!")
				--exports.hud:sendBottomNotification(localPlayer, itemName, "This item is (part of) a weapon, you cannot use it with clicking on it. If you have all the parts needed, the gun will appear in your scrollmenu.")
			end
			return
		elseif itemID == 116 then
			local parts = exports.global:explode(':', itemValue)
			local ammo_id = tonumber(parts[1])
			local rounds = tonumber(parts[2])
			local weapons
			if ammo_id and rounds then
				local ammo = exports.weapon:getAmmo( ammo_id )
				if ammo and ammo.weapons then
					exports.hud:sendBottomNotification(localPlayer, ammo.cartridge..' '..itemName, "Cartridge: "..ammo.cartridge..", Bullet Style: "..ammo.bullet_style..", Bullet Weight: "
						..exports.global:round(ammo.bullet_weight*1000,2).." grams, Application: "..ammo.application..", Compactible with "..exports.weapon:formatWeaponNames(ammo.weapons)..".")
				end
			end
			return
		elseif itemID == 117 then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Please place this item into a vehicle, then control it over the vehicles right mouse button menu.")
			return
		elseif itemID == 174 then
			triggerServerEvent("startFAAmapGUI", localPlayer)
			return
		elseif (itemID==118) then
			exports.hud:sendBottomNotification(localPlayer, itemName,  "Placez le dans votre véhicule et approchez un péage.")
			return
		elseif itemID == 121 then
			exports.hud:sendBottomNotification(localPlayer, itemName, "A heavy box full of supplies!")
			return
		elseif itemID == 145 then -- Flashlight
			exports.dynamic_lighting_flash:toggleFlashLight(nil, item[3])
			return
		elseif (itemID==147) then -- Picture Frame --  Adams
			if(itemValue and itemValue ~= 1) then
				local split = exports.global:explode(";", itemValue)
				if(#split > 1) then
					exports.hud:sendBottomNotification(localPlayer, itemName, "Drop this in an interior to replace the texture '"..tostring(split[2]).."'.")
				else
					local url = itemValue
					triggerServerEvent ( "frames:fetchTexture", localPlayer, itemSlot, url )
				end
				return
			else
				triggerEvent ( "frames:showFrameGUI", localPlayer, itemSlot )
				return
			end
		elseif (itemID==148) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "OCW permit - " .. itemValue .. ".")
			return
		elseif (itemID==149) then
			exports.hud:sendBottomNotification(localPlayer, itemName, "CCW permit - " .. itemValue .. ".")
			return
		elseif (itemID==150) then -- ATM card
			local itemExploded = explode(";", itemValue )
			if tonumber( itemExploded[2] ) > 0 then
				exports.hud:sendBottomNotification(localPlayer, g_items[itemID][1] , "CB numéro: '"..itemExploded[1].."', Propriétaire: '"..tostring(exports.cache:getCharacterNameFromID(itemExploded[2])):gsub("_", " ").."'. Glissez sur un ATM pour utiliser.")
			else
				exports.hud:sendBottomNotification(localPlayer, g_items[itemID][1] , "CB numéro: '"..itemExploded[1].."', Propriétaire: '"..tostring(exports.cache:getBusinessNameFromID(math.abs(itemExploded[2]))).."'. Glissez sur un ATM pour utiliser.")
			end
			return
		elseif (itemID==151) then -- ramp remote
			triggerEvent("rampControlGUI", localPlayer, itemValue, true)
			hideInventory()
			return
		elseif (itemID==152) then -- ID card
			local itemExploded = explode(";", itemValue )
			local text = "Nom: '"..itemExploded[1]:gsub("_", " ").."', Genre: '"..itemExploded[2].."', DoB: '"..itemExploded[3].."', Empreinte: '"..itemExploded[4].."' "
			exports.hud:sendBottomNotification(localPlayer, g_items[itemID][1] , text)
			return
		elseif (itemID==133) or (itemID==153) or (itemID==154) or (itemID==155)then
			exports.hud:sendBottomNotification(localPlayer, itemName, "Ce "..itemName.." appartient à " .. itemValue .. ".")
			return
		elseif (itemID==169) then -- Keypad door lock
			exports.hud:sendBottomNotification(localPlayer, g_items[itemID][1].." - Equipping for interior ID #"..itemValue , "Attach this device to a stable wall to install. You can uninstall this device and reinstall it freely later on.")
			return
		elseif (itemID==170) then -- Keycard
			exports.hud:sendBottomNotification(localPlayer, itemName, "Swipe this card at "..tostring(itemValue).." to gain access.")
			return
		elseif (itemID==177) then -- Remote dispatch device
			executeCommandHandler( "dispatch")
			hideInventory()
			return
		elseif (itemID==178) then
			local bInfo = split(tostring(itemValue), ':')
			local bID = bInfo[3]
			triggerServerEvent("books:beginBook", localPlayer, bID, itemSlot)
			hideInventory()
			return
		elseif (itemID==211) then -- Christmas Lottery Ticket
			outputChatBox("Try giving the ticket to Santa to see what you might have won.", 255, 194, 14)
			return
		elseif (itemID==212) then -- Snow Tire
			outputChatBox("Put this in your vehicle for better traction in snow.", 155, 255, 155)
			return
		elseif (itemID == 303) then --> Rename Coin
			--> Check: Item Value
			if string.lower(itemValue) ~= 'rename coin' then return; end;

			--> Variable(s)
			local item_value = itemValue;

			--> Frame variable(s)
			local rename_frame = guiCreateWindow(0.4, 0.43, 0.22, 0.17, "Renommer votre personnage", true);
			local rename_label = guiCreateLabel(0.05, 0.2, 0.9, 0.2, "Entrez le Prénom Nom que vous souhaitez utiliser", true, rename_frame);
			local rename_edit = guiCreateEdit(0.05, 0.35, 0.9, 0.2, "", true, rename_frame);
			local rename_button = guiCreateButton(0.05, 0.6, 0.9, 0.15, "Renommer", true, rename_frame);
			local rename_close = guiCreateButton(0.05, 0.76, 0.9, 0.15, "Fermer", true, rename_frame);

			--> Frame property(s)
			guiWindowSetSizable(rename_frame, false);
			guiWindowSetMovable(rename_frame, false);
			guiSetVisible(rename_frame, true);

			--> Check: Cursor
			if (isCursorShowing(localPlayer)) then showCursor(false); end;
			setTimer(function() if (not isCursorShowing(localPlayer)) then showCursor(true); end; end, 50, 1);

			--> Event(s)
			addEventHandler('onClientKey', root, function(key, press)
				--> Check: Key
				if isElement(rename_frame) then cancelEvent(); end;
			end);

			addEventHandler("onClientGUIClick", rename_button, function()
				--> Variable(s)
				local new_name = guiGetText(rename_edit);
				new_name = string.gsub(new_name, " ", "_");

				--> Condition(s)
				if (string.gsub(new_name, "%s", "") == "") then return outputChatBox("Vous n'avez pas entré de nom.", 255, 0, 0); end;
				if (string.len(new_name) < 3) then return outputChatBox("Le nom doit contenir au moins 3 caractères.", 255, 0, 0); end;
				if (string.len(new_name) > 20) then return outputChatBox("Le nom ne peut pas contenir plus de 20 caractères.", 255, 0, 0); end;

				--> Check if the name is valid
				if not (string.match(new_name, "^[%a%s%-_]+$")) then return outputChatBox("Le nom ne peut contenir que des lettres, des espaces ou des underscores.", 255, 0, 0); end;

				--> Set: Player's data
				setElementData(localPlayer, "rename_coin:new_name", new_name, true);

				--> Trigger: Rename event
				triggerServerEvent("useItem", localPlayer, itemSlot, additional);
				destroyElement(rename_frame);
				showCursor(false);
			end, false);

			addEventHandler("onClientGUIClick", rename_close, function()
				--> Destroy: Element(s)
				destroyElement(rename_frame);
				showCursor(false);
			end, false);
		elseif itemID == 232 then -- car battery charger
			for i, veh in pairs( exports.global:getNearbyElements( localPlayer, 'vehicle', 5 ) ) do
				if veh and isElement(veh) then
					local doors = exports.vehicle:getDoorsFor( getElementModel( veh ) , 0 )
					if #doors > 0 and doors[1] and doors[1][1] == 'Hood' and getVehicleDoorOpenRatio ( veh, 0 ) < 0.5 then
						exports.hud:sendBottomNotification(localPlayer, itemName, "Please open the hood of this vehicle first." )
					elseif isVehicleLocked ( veh ) then
						exports.hud:sendBottomNotification(localPlayer, itemName, "Please unlock this vehicle first." )
					else
						triggerServerEvent( "useItem", localPlayer, itemSlot, veh )
					end
					return
				end
			end
			exports.hud:sendBottomNotification(localPlayer, itemName, "There is no vehicle around you." )
		else
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		end
	end
end

function stopGasmaskDamage(attacker, weapon)
	local gasmask = getElementData(localPlayer, "gasmask")

	if (weapon==17 or weapon==41) and (gasmask) then
		cancelEvent()
	end

	--
	-- Scuba Gear
	--
	if weapon == 53 and getElementData( localPlayer, "scuba" ) then
		cancelEvent( )
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, stopGasmaskDamage)


addEventHandler("onClientChangeChar", getRootElement(), hideInventory)

local function updateInv()
	if wItems and source == showinvPlayer then
		source = nil
		setTimer(toggleCategory, 50, 1)
	end
end
addEventHandler("recieveItems", getRootElement(), updateInv)

addEvent("finishItemDrop", true)
addEventHandler("finishItemDrop", localPlayer,
	function( )
		if wItems then
			guiSetVisible( wWait, false )
			guiSetEnabled( wItems, true )
		end
	end
)

--
-- Carried items weight.
--
addCommandHandler("carried",
	function( command, detailed )
		exports.hud:sendBottomNotification(localPlayer, "Carried Weight", ("%.2f/%.2f" ):format( getCarriedWeight( localPlayer ), getMaxWeight( localPlayer ) ) )
		if detailed == "detailed" then
			for k, v in ipairs( getItems( localPlayer ) ) do
				exports.hud:sendBottomNotification(localPlayer, "Carried Weight",  "  %.2f %s; %s", getItemWeight( v[1], v[2], v[5] ), getItemName( v[1], v[2], v[5] ), getItemDescription( v[1], v[2], v[5] ) )
			end
		end
	end
)

--
-- are we watching TV?
--
function areItemInteractionsDisabled()
	return exports['freecam-tv']:isFreecamEnabled() or getElementData(localPlayer, "viewingInterior")
end
isWatchingTV = areItemInteractionsDisabled


detailedDebug = false
addCommandHandler("detaileditemdebugclient",
	function()
		if exports.global:isPlayerScripter(localPlayer) then
			detailedDebug = not detailedDebug
			outputChatBox("detaileditemdebug [client-side] set to "..tostring(detailedDebug))
		end
	end)