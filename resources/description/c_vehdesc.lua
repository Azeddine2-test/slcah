

--MAXIME, fixed by Nando

local scrWidth, scrHeight = guiGetScreenSize()
local wEditDescription

function showEditDescription()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if theVehicle then
		local playerId = getElementData(localPlayer, "dbid")
		local dbid = getElementData(theVehicle, "dbid")
		local factionid = getElementData(theVehicle, "faction")
		local owner = getElementData(theVehicle, "owner")
		if exports.global:hasItem(localPlayer, 3, dbid)
		or owner == playerId
		or exports.global:hasItem(theVehicle, 3, dbid)
		or exports.factions:isPlayerInFaction(localPlayer, factionid)
		or exports.integration:isPlayerTrialAdmin(localPlayer, true) then
			if dbid > 0 then

				if isElement(wEditDescription) then destroyElement(wEditDescription) end

				local description1 = getElementData(theVehicle, "description:1")
				local description2 = getElementData(theVehicle, "description:2")
				local description3 = getElementData(theVehicle, "description:3")
				local description4 = getElementData(theVehicle, "description:4")
				local description5 = getElementData(theVehicle, "description:5")
				local adescription = getElementData(theVehicle, "description:admin")
				
				local x = scrWidth/2 - (441/2)
				local y = scrHeight/2 - (230/2)
				wEditDescription = guiCreateWindow(x,y,441,230,"Edit Vehicle Description",false)


				guiWindowSetSizable(wEditDescription, false)
				
				local descriptionLines = {}
				descriptionLines[1] = guiCreateEdit(10,23,422,26,description1,false,wEditDescription)
				descriptionLines[2] = guiCreateEdit(9,51,422,26,description2,false,wEditDescription)
				descriptionLines[3] = guiCreateEdit(9,79,422,26,description3,false,wEditDescription)
				descriptionLines[4] = guiCreateEdit(9,107,422,26,description4,false,wEditDescription)
				descriptionLines[5] = guiCreateEdit(9,135,422,26,description5,false,wEditDescription)
				descriptionLines[6] = guiCreateEdit(9,163,422,26,adescription or "",false,wEditDescription)
				
				if not exports.integration:isPlayerTrialAdmin(localPlayer, true) then
					guiSetEnabled(descriptionLines[6], false)
				end

				bSave = guiCreateButton(10,198,210,75,"Save",false,wEditDescription)
				bClose = guiCreateButton(220,198,210,75,"Close",false,wEditDescription)

				local function closeWin()
					destroyElement(wEditDescription)
					guiSetInputMode("allow_binds")
					triggerEvent("cursorHide", localPlayer)
				end

				addEventHandler("onClientGUIClick", bClose, closeWin, false)

				addEventHandler("onClientGUIClick", bSave, function()
					local savedDescriptions = { }
					savedDescriptions[1] = guiGetText(descriptionLines[1])
					savedDescriptions[2] = guiGetText(descriptionLines[2])
					savedDescriptions[3] = guiGetText(descriptionLines[3])
					savedDescriptions[4] = guiGetText(descriptionLines[4])
					savedDescriptions[5] = guiGetText(descriptionLines[5])
					if isElement(descriptionLines[6]) then
						savedDescriptions[6] = guiGetText(descriptionLines[6])
					end
					closeWin()
					triggerServerEvent("saveDescriptions", resourceRoot, savedDescriptions, theVehicle)
				end, false)

				guiSetInputMode("no_binds_when_editing")
				triggerEvent("cursorShow", localPlayer)
			else
				exports.hud:sendBottomNotification(localPlayer, "Vehicle Description", "You cannot set descriptions on temporary vehicles.")
			end
		else
			exports.hud:sendBottomNotification(localPlayer, "Vehicle Description", "Vous n'avez pas les clés de ce véhicule.")
		end
	else
		exports.hud:sendBottomNotification(localPlayer, "Vehicle Description", "You must be in the vehicle you wish to change the description of.")
	end
end
addCommandHandler("ed", showEditDescription, false, false)
addCommandHandler("editdescription", showEditDescription, false, false)

addEvent("editdescription", false)
addEventHandler("editdescription", localPlayer, showEditDescription, false)
