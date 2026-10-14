
local gui = {}

function build_SaleGUI(itemValue)

	if gui["_root"] and isElement(gui["_root"]) then destroyElement(gui["_root"]) end

	guiSetInputMode("no_binds_when_editing")
	showCursor(true)

	gui._placeHolders = {}

	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 400, 252
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "SA Motor Department", false)
	guiWindowSetSizable(gui["_root"], false)

	gui["label"] = guiCreateLabel(170, 25, 70, 45, "Vente de véhicules", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["label"], "left", false)
	guiLabelSetVerticalAlign(gui["label"], "center")

	gui["label_2"] = guiCreateLabel(30, 75, 331, 21, "En signant ce document, j'accepte d'accorder toute la propriété", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["label_2"], "left", false)
	guiLabelSetVerticalAlign(gui["label_2"], "center")

	gui["label_3"] = guiCreateLabel(30, 95, 331, 21, "de ce véhicule à la personne mentionnée.", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["label_3"], "left", false)
	guiLabelSetVerticalAlign(gui["label_3"], "center")

	gui["lineEdit"] = guiCreateEdit(30, 155, 231, 21, "", false, gui["_root"])
	guiEditSetMaxLength(gui["lineEdit"], 32767)

	gui["label_4"] = guiCreateLabel(30, 135, 150, 16, "Nom du nouveau propriétaire", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["label_4"], "left", false)
	guiLabelSetVerticalAlign(gui["label_4"], "center")

	gui["pushButton"] = guiCreateButton(180, 195, 91, 31, "Vendre", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["pushButton"], function ()
			triggerServerEvent("sellVehiclePapers", getResourceRootElement(), localPlayer, "sell", guiGetText(gui["lineEdit"]), itemValue)
		end, false)


	gui["pushButton_2"] = guiCreateButton(290, 195, 91, 31, "Fermer", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["pushButton_2"], function ()
			destroyElement(gui["_root"])
			showCursor(false)
			guiSetInputMode("allow_binds")
		end, false)

	return gui, windowWidth, windowHeight
end
addEvent("build_carsale_gui", true)
addEventHandler("build_carsale_gui", localPlayer, build_SaleGUI)

addEvent("close:build_carsale_gui", true)
addEventHandler("close:build_carsale_gui", localPlayer, function()
	if isElement(gui["_root"]) then
		destroyElement(gui["_root"])
		showCursor(false)
		guiSetInputMode("allow_binds")
	end
end)


--Maxime / 2015.2.10
GUIEditor = {
    button = {},
    window = {},
    edit = {},
    label = {}
}

function openVehSales(cmd, ...)
	closeVehSales()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		local faction, _ = exports.factions:isPlayerInFaction(localPlayer, getElementData(veh, "faction"))
		local leader = exports.factions:hasMemberPermissionTo(localPlayer, getElementData(veh, "faction"), "respawn_vehs")
		if (exports.integration:isPlayerAdmin(localPlayer) and getElementData(localPlayer, "duty_admin") == 1 ) or (getElementData(veh, "owner") == getElementData(localPlayer, "dbid")) or (leader and faction) then
			if not (...) then
				return outputChatBox("SYNTAX: /" .. cmd .. " [partial player name / id]", 255, 194, 14)
			end

			exports['item-system']:playSoundInvOpen()

			GUIEditor.window[1] = guiCreateWindow(1107, 377, 391, 181, "Vehicle Ownership Transfer", false)
			guiWindowSetSizable(GUIEditor.window[1], false)
			exports.global:centerWindow(GUIEditor.window[1])

			GUIEditor.label[1] = guiCreateLabel(35, 36, 323, 79, "You're about to sell vehicle ID# () to player.\n\nTo prevent OOC Vehicle Scam, please input an amount of money that you have agreed with them to start selling:", false, GUIEditor.window[1])
			guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)
			GUIEditor.label[2] = guiCreateLabel(20, 131, 21, 25, "$", false, GUIEditor.window[1])
			guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
			guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
			GUIEditor.edit[1] = guiCreateEdit(41, 131, 176, 25, "sdwd23dsdsdad", false, GUIEditor.window[1])
			GUIEditor.button[1] = guiCreateButton(221, 131, 70, 25, "Sell", false, GUIEditor.window[1])
			GUIEditor.button[2] = guiCreateButton(291, 131, 70, 25, "Close", false, GUIEditor.window[1])
			addEventHandler("onClientGUIClick", GUIEditor.window[1], function ()
				if source == GUIEditor.button[1] then

				elseif source == GUIEditor.button[2] then
					closeVehSales()
				end
			end)
			addEventHandler("onClientPlayerVehicleExit", localPlayer, sellCheck)
		else
			return outputChatBox("You do not own this vehicle or you're not a leader of the faction that owns this vehicle.", 255, 0, 0)
		end
	end
end

function closeVehSales()
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then
		destroyElement(GUIEditor.window[1])
		GUIEditor.window[1] = nil
		exports['item-system']:playSoundInvClose()
		removeEventHandler("onClientPlayerVehicleExit", localPlayer, sellCheck)
	end
end

function sellCheck()
	if localPlayer == source then
		closeVehSales()
	end
end

addEvent('onClientElementDataChange', true)
addEventHandler('onClientElementDataChange', root,
    function(dataName, oldValue)
        if dataName == "vehicle:windowstat" and getElementType(source) == "vehicle" then
			for _,window in ipairs({2,3,4,5}) do
				setVehicleWindowOpen(source, window, getElementData(source, "vehicle:windowstat") == 1)
			end
		end
    end)
	
-- basic detection system to check if a player fell off a bike

local clientStartExit = false

addEventHandler("onClientVehicleStartExit", getRootElement(), function(thePlayer)
	if thePlayer == localPlayer and (exports.global:getVehicleType(source) == "Bike" or exports.global:getVehicleType(source) == "BMX") then
		clientStartExit = true
	else
		clientStartExit = false
	end
end)

addEventHandler("onClientVehicleExit", getRootElement(), function(thePlayer)
	if thePlayer == localPlayer and (exports.global:getVehicleType(source) == "Bike" or exports.global:getVehicleType(source) == "BMX") and not clientStartExit then
		-- The player fell off the bike because onClientVehicleStartExit was not triggered.
		if isVehicleLocked(source) then
			triggerServerEvent("lockUnlockOutsideVehicle", thePlayer, source)
			outputChatBox("Votre vélo a été automatiquement déverrouillé parce que vous êtes tombé.", 255, 0, 0)
		end
		clientStartExit = false
		triggerServerEvent("vehicle:realinvehicle", resourceRoot, thePlayer, 0)
	end
end)



function bindSomeHotKey()
	bindKey("w", "down", function()
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('realism:seatbelt:toggle', localPlayer, localPlayer)
	end) 

	bindKey("x", "down", function() 
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('vehicle:togWindow', localPlayer)
	end)
end
addEventHandler("onClientResourceStart", resourceRoot, bindSomeHotKey, false)



-- Nando 18/04/2023

local NO_DMG_WEAPONS = {
	[0] = 'Poing',
	[1] = 'Brass Knuckles',
	[2] = 'Golf Club',
	[3] = 'Nightstick',
	[4] = 'Knife',
	[5] = 'Baseball Bat',
	[6] = 'Shovel',
	[7] = 'Pool Cue',
	[8] = 'Katana',
	[9] = 'Chainsaw',
	[43] = 'Camera',
	[10] = 'Long Purple Dildo',
	[11] = 'Short tan Dildo',
	[12] = 'Vibrator',
	[15] = 'Cane',
	[14] = 'Flowers',
	[44] = 'Night-Vision Goggles',
	[45] = 'Infrared Goggles',
	[46] = 'Parachute',
	[16] = 'Grenade',
	[17] = 'Tear Gas',
	[18] = 'Molotov Cocktails',
	[37] = 'Flamethrower',
	[39] = 'Satchel',
	[40] = 'Satchel Remote',
	[41] = 'Spraycan',
	[42] = 'Fire Extinguisher',
}

local streamedVehs = {}

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "vehicle" then
		streamedVehs[source] = true
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "vehicle" then
		streamedVehs[source] = nil
	end
end)

local function checkStreamedInExplodes()
	for veh, _ in pairs(streamedVehs) do
		if not isElement(veh) then
			streamedVehs[veh] = nil
		else
			local hp = getElementHealth(veh)
			if hp < 250 then
				setElementHealth(veh, 250)
			end
		end
	end
end
setTimer(checkStreamedInExplodes, 1000, 0)

local function handleVehicleDamage(attacker, weapon, loss, x, y, z, tire)
	local oldHp = getElementHealth(source)
	local newHp = oldHp - loss

	local hasOccupant = false
	for seat, occ in pairs(getVehicleOccupants(source) or {}) do
		hasOccupant = true
		break
	end
	if (not hasOccupant) and NO_DMG_WEAPONS[weapon] then
		cancelEvent()
		return
	end
end
addEventHandler("onClientVehicleDamage", root, handleVehicleDamage)