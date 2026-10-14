
local dispatchBlips = {}
local allowedFactions = {
	[1] = true,
	[2] = true,
}

function isInAllowedFactions(element)
	for k,v in pairs(allowedFactions) do
		if exports.factions:isPlayerInFaction(element, k) then
			return true
		end
	end
end

DispatchUI = {
    label = {},
    edit = {},
    button = {},
    window = {},
    gridlist = {},
    combobox = {},
    checkbox = {}
}
cooldownDispatch = false
function cooldownDispatchT()
	cooldownDispatch = false
end

local screenX, screenY = guiGetScreenSize()

function dispatchGUI()
	-- to prevent double
	if isElement(DispatchUI.window[1]) then return end

	-- to center the gui window
	local width = 410
	local height = 299
	local x = ( screenX - width ) / 2
	local y = ( screenY - height ) / 2

	-- so you can type freely
	guiSetInputMode("no_binds_when_editing")

	-- getting user's name
	local name = getPlayerName(localPlayer)
	local processedName = string.gsub(name, "_", " ")
	local fID = exports.factions:getCurrentFactionDuty(localPlayer)
	if not fID then
		outputChatBox("Vou n'êtes pas en duty faction.", 255, 100, 100)
		return
	end
	local isFactionLeader = exports.factions:hasMemberPermissionTo(localPlayer, fID, "add_member")

	-- getting the table
	local dispatchTable = getElementData(root, "dispatch:table") or { }

	-- building the gui elements
	DispatchUI.window[1] = guiCreateWindow(x, y, width, height, "Remote Dispatch Device", false)
	guiWindowSetSizable(DispatchUI.window[1], false)
	DispatchUI.gridlist[1] = guiCreateGridList(9, 23, 392, 177, false, DispatchUI.window[1])
	guiGridListAddColumn(DispatchUI.gridlist[1], "Callsign", 0.3)
	guiGridListAddColumn(DispatchUI.gridlist[1], "Nom", 0.3)
	guiGridListAddColumn(DispatchUI.gridlist[1], "Disponibilité", 0.3)
	DispatchUI.label[1] = guiCreateLabel(11, 206, 65, 19, "En service:", false, DispatchUI.window[1])
	DispatchUI.label[2] = guiCreateLabel(11, 234, 65, 19, "Callsign:", false, DispatchUI.window[1])
	DispatchUI.label[3] = guiCreateLabel(11, 261, 65, 19, "Dispo:", false, DispatchUI.window[1])
	DispatchUI.button[1] = guiCreateButton(302, 206, 78, 45, "Fermer", false, DispatchUI.window[1])
	DispatchUI.button[2] = guiCreateButton(214, 206, 78, 45, "Confirmer", false, DispatchUI.window[1])
	guiSetProperty(DispatchUI.button[2], "NormalTextColour", "FF00FF00")
	DispatchUI.combobox[1] = guiCreateComboBox(74, 205, 134, 100, "", false, DispatchUI.window[1])
	guiComboBoxAddItem(DispatchUI.combobox[1], "Oui")
	guiComboBoxAddItem(DispatchUI.combobox[1], "Non")
	DispatchUI.edit[1] = guiCreateEdit(74, 230, 134, 27, "", false, DispatchUI.window[1])
	DispatchUI.edit[2] = guiCreateEdit(74, 261, 134, 27, "", false, DispatchUI.window[1])

	-- displaying the table in gridlist
	if dispatchTable then
		for k, v in pairs(dispatchTable) do
			if v["faction"] == fID then
				local row = guiGridListAddRow(DispatchUI.gridlist[1])
				guiGridListSetItemText(DispatchUI.gridlist[1], row, 1, v["callsign"], false, false)
				guiGridListSetItemText(DispatchUI.gridlist[1], row, 2, k, false, false)
				guiGridListSetItemText(DispatchUI.gridlist[1], row, 3, v["availability"], false, false)
			end
		end
	end

	-- displaying current status for localPlayer, if any
	if type(dispatchTable[processedName]) == "table" then
		guiComboBoxSetSelected(DispatchUI.combobox[1], 0)
		guiSetText(DispatchUI.edit[1], dispatchTable[processedName]["callsign"])
		guiSetText(DispatchUI.edit[2], dispatchTable[processedName]["availability"])
	else
		guiComboBoxSetSelected(DispatchUI.combobox[1], 1)
	end

	-- close button
	addEventHandler("onClientGUIClick", DispatchUI.button[1], function ()
			if isElement(DispatchUI.window[1]) then
				destroyElement(DispatchUI.window[1])
				guiSetInputMode("allow_binds")
			end
		end, false)

	-- update button
	addEventHandler("onClientGUIClick", DispatchUI.button[2], function ()
			if cooldownDispatch then outputChatBox("Veuillez patienter avant de réessayer.", 187, 187, 187) return end
			
			local status = guiGetText( DispatchUI.combobox[1] )
			if status == "Non" then
				if dispatchTable[processedName] then
					dispatchTable[processedName] = nil
					setElementData(getLocalPlayer(), "dispatch:onDuty", false)
					triggerServerEvent("dispatch:onDutyChange", resourceRoot, false)
					setElementData(root, "dispatch:table", dispatchTable)
				end
			else
				if not dispatchTable[processedName] then
					dispatchTable[processedName] = { }
				end
				dispatchTable[processedName]["callsign"] = string.upper(guiGetText(DispatchUI.edit[1]))
				dispatchTable[processedName]["availability"] = guiGetText(DispatchUI.edit[2])
				dispatchTable[processedName]["faction"] = fID
				if not getElementData(getLocalPlayer(), "dispatch:onDuty") then
					setElementData(getLocalPlayer(), "dispatch:onDuty", true)
					triggerServerEvent("dispatch:onDutyChange", resourceRoot, true)
				end
				setElementData( getLocalPlayer(), "dispatch:callsign", string.upper(guiGetText(DispatchUI.edit[1])), true)
				triggerServerEvent("dispatch:callsignChange", resourceRoot, string.upper(guiGetText(DispatchUI.edit[1])))
				setElementData(root, "dispatch:table", dispatchTable)

				for k, v in pairs(dispatchTable) do
					outputChatBox(v['availability']);
				end;
			end

			if not isTimer(cooldownDispatchTimer) then
				cooldownDispatchTimer = setTimer(cooldownDispatchT, 3000, 1)
				cooldownDispatch = true
			end
			refreshClientGUI()
		end, false)
end

function canUseDispatch(cmd)
	if not isInAllowedFactions(localPlayer) then
		return outputChatBox("Vous n'êtes pas dans une faction permettant d'utiliser /"..cmd..".", 255, 100, 100)
	end
	if not exports.global:hasItem(localPlayer, 177) then
		return outputChatBox("Vous n'avez pas l'appareil pour /"..cmd.." dans votre inventaire.", 255, 100, 100)
	end

	-- multifactions won't play well with this
	local count = 0
	for facID, v in pairs(allowedFactions) do
		local found = exports.factions:isPlayerInFaction(localPlayer, facID)
		if found then
			count = count + 1
		end
	end
	if count > 1 then
		return outputChatBox("Vous ne pouvais être dans plusieurs factions qui utilisent /"..cmd.." en même temps.", 255, 0, 0)
	end

    dispatchGUI()
end
addCommandHandler("dispatch", canUseDispatch)

function refreshClientGUI()
	if isElement(DispatchUI.window[1]) then
		destroyElement(DispatchUI.window[1])
		dispatchGUI()
	end
end

-- so it refreshes for all clients using it
addEventHandler("onClientElementDataChange", root,
function (dataName)
	if dataName == "dispatch:table" then
		refreshClientGUI()
	end
end, false )

-- so it removes you from the list if you change character also blip stuff
addEventHandler("onClientPlayerChangeNick", getLocalPlayer(),
function (oldNick)
	local dispatchTable = getElementData(root, "dispatch:table") or { }
	local processedName = string.gsub(oldNick, "_", " ")
	if dispatchTable[processedName] then
		dispatchTable[processedName] = nil
		setElementData(root, "dispatch:table", dispatchTable)
		refreshClientGUI()
	end
end)

-- so it removes you from the list if you leave the server
function removeFromDispatch(source)
	local dispatchTable = getElementData(root, "dispatch:table") or { }
	local processedName = string.gsub(getPlayerName(source), "_", " ")
	if dispatchTable[processedName] then
		dispatchTable[processedName] = nil
		setElementData(root, "dispatch:table", dispatchTable)
		refreshClientGUI()
	end
end

-- BLIPS STARTING NOW ----------------------------------------


function getCallSign(element)
	if getElementType(element) == "player" then
    	callSign = getElementData(element, "dispatch:callsign") or ""
	    if callSign == "" then
	       	for a, b in ipairs(split(getPlayerName(element):gsub("_"," "), ' ')) do 
	       		if tonumber(a) == 1 then
					callSign = callSign .. b:sub( 1, 1) .. ". "
				else
					callSign = callSign .. b:sub( 1, #b) 
				end
			end
		end
	elseif getElementType(element) == "vehicle" then
		callSign = ""
		for k,v in pairs(getVehicleOccupants(element)) do
			if getElementData(v, "dispatch:onDuty") then
				local tempV = (getElementData(v, "dispatch:callsign")) or ""
				if tempV == "" then
	       			for a, b in ipairs(split(getPlayerName(v):gsub("_"," "), ' ')) do 
	       				if tonumber(a) == 1 then
							tempV = tempV .. b:sub( 1, 1) .. ". "
						else
							tempV = tempV .. b:sub( 1, #b) 
						end
					end
				end
				if tablelength(getVehicleOccupants(element)) > 1 then
					callSign = callSign .. tempV .. ", "
				else
					callSign = callSign .. tempV
				end
			end
		end
		if string.find(callSign, ",", #callSign-2) then
			callSign = string.sub(callSign, 1, #callSign-2)
		end
	end
	return callSign or "N/A"
end

function destroyDispatchBlip(v)
	if dispatchBlips[v] then
		exports.customblips:destroyCustomBlip(dispatchBlips[v])
		dispatchBlips[v] = nil
	end
end

function tablelength(T) -- No you can't use # for this.
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
 
function startBlips()
	if getElementData(getLocalPlayer(), "dispatch:onDuty") then
	    for k, thePlayer in ipairs ( getElementsByType( "player" ) ) do
	        if ( not dispatchBlips[thePlayer] ) and getElementData(thePlayer, "dispatch:onDuty") and isInAllowedFactions(thePlayer) then
	        	local veh = getPedOccupiedVehicle( thePlayer )
	        	if veh and not dispatchBlips[veh] then
	        		callSign = getCallSign(veh)
	        		dispatchBlips[veh] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "pedvehicle.png", 999999, true, thePlayer, callSign )
	        		if getElementData(veh, "lspd:siren") then -- Begin flash
	        		    exports.customblips:setBlipImageColor(dispatchBlips[veh], 255, 0, 0)
	        		end
	        	elseif not veh and getLocalPlayer() ~= thePlayer then
	        		callSign = getCallSign(thePlayer)
	            	dispatchBlips[thePlayer] = exports.customblips:createCustomBlip ( 0, 0, 8, 8, "ped.png", 999999, true, thePlayer, callSign )
	            end
	        end
	    end
	end
end
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource() ), startBlips )

function stopBlips()
	for element, theBlip in pairs( dispatchBlips ) do
		destroyDispatchBlip(element)
	end
	dispatchBlips = {}
end
addEventHandler("onClientResourceStop", resourceRoot, stopBlips)
 
addEventHandler("onClientPlayerWasted", root, 
	function()
		if dispatchBlips[source] then return end
		local veh = getPedOccupiedVehicle( source )
		if veh and dispatchBlips[veh] then
			local t = tablelength(getVehicleOccupants(veh) or {})
			if t > 1 then
				found = false
				for k,v in pairs(getVehicleOccupants(veh)) do
					if getElementData(v, "dispatch:onDuty") and v ~= source then
						found = true
						break
					end
				end
				if found then
					exports.customblips:setBlipText(dispatchBlips[veh], getCallSign(veh))
					if getElementData(getLocalPlayer(), "dispatch:onDuty") and getElementData(source, "dispatch:onDuty") then
						dispatchBlips[source] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "ped.png", 99999, true, source, getCallSign(source) )
					end
				else
					destroyDispatchBlip(veh)
					if getElementData(getLocalPlayer(), "dispatch:onDuty") then
						--[[dispatchBlips[veh] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "vehicle.png", 99999, true, veh, "Vehicle Contains Suspect" )
						if getElementData(veh, "lspd:siren") then -- Begin flash
		           		    exports.customblips:setBlipImageColor(dispatchBlips[veh], 255, 0, 0)
		           		end]]
		           		dispatchBlips[source] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "ped.png", 99999, true, source, getCallSign(source) )
					end
				end
			else
				destroyDispatchBlip(veh)
				if getElementData(getLocalPlayer(), "dispatch:onDuty") and getElementData(source, "dispatch:onDuty") and source ~= getLocalPlayer() then
					dispatchBlips[source] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "ped.png", 99999, true, source, getCallSign(source) )
				end
			end
		end
	end
)

addEventHandler( "onClientRender", root,
    function ()
        for element, theBlip in pairs( dispatchBlips ) do
            if ( isElement( element ) ) then 
                if ( theBlip ) then
                	if getElementDimension(element) == getElementDimension(getLocalPlayer()) then
                		if not exports.customblips:isCustomBlipVisible(theBlip) then
                			exports.customblips:setCustomBlipVisible(theBlip, true)
                		end
                    	local x,y,z = getElementPosition( element )
                    	exports.customblips:setCustomBlipPosition ( theBlip, x, y )
                    else
                    	exports.customblips:setCustomBlipVisible(theBlip, false)
                    end
                end
            end
        end
    end
)
 
addEventHandler("onClientPlayerQuit",root,
    function ()
    	local veh = getPedOccupiedVehicle( source )
        if ( dispatchBlips[source] ) then
            destroyDispatchBlip(source)
        elseif veh then
        	local t = tablelength(getVehicleOccupants(veh) or {})
			if dispatchBlips[veh] and t == 0 then
				destroyDispatchBlip(veh)
			elseif dispatchBlips[veh] and t ~= 0 then
				found = false
				for k,v in pairs(getVehicleOccupants(veh)) do
					if getElementData(v, "dispatch:onDuty") then
						found = true
						break
					end
				end
				if not found and getElementData(getLocalPlayer(), "dispatch:onDuty") then
					destroyDispatchBlip(veh)
					--dispatchBlips[veh] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "vehicle.png", 999999, true, veh, "Vehicle Contains Suspect" )
				elseif getElementData(getLocalPlayer(), "dispatch:onDuty") and found then
					exports.customblips:setBlipText(dispatchBlips[veh], getCallSign(veh))
				end
			end
        end
        removeFromDispatch(source)
    end
)

addEvent("dispatch:factionChange", true)
addEventHandler("dispatch:factionChange", resourceRoot, 
	function(faction, oldFaction) -- Reload blips.
		if not oldFaction then oldFaction = {} end
		if not faction then faction = {} end
		for k,v in pairs(allowedFactions) do
			if faction[k] or oldFaction[k] then
				stopBlips()
				startBlips()
				return
			end
		end
	end
)

addEvent("dispatch:blipSiren", true)
addEventHandler("dispatch:blipSiren", resourceRoot, 
	function(inf, veh)
		if dispatchBlips[veh] then
			if inf and inf > 0 then
				exports.customblips:setBlipImageColor(dispatchBlips[veh], 255, 0, 0)
			else
				exports.customblips:setBlipImageColor(dispatchBlips[veh], 255, 255, 255)
			end
		end
	end
)

addEvent("dispatch:callsignChange", true)
addEventHandler("dispatch:callsignChange", resourceRoot,
	function(cs, player)
		setElementData(player, "dispatch:callsign", cs)
		if getElementData(getLocalPlayer(), "dispatch:onDuty") and getElementData(player, "dispatch:onDuty") then
			local veh = getPedOccupiedVehicle( player )
			if veh and dispatchBlips[veh] then
				exports.customblips:setBlipText(dispatchBlips[veh], getCallSign(veh))
			elseif dispatchBlips[player] then
				exports.customblips:setBlipText(dispatchBlips[player], getCallSign(player))
			end
		end
	end
)

addEvent("dispatch:onDutyChange", true)
addEventHandler("dispatch:onDutyChange", resourceRoot, 
	function(data, player)
		setElementData(player, "dispatch:onDuty", data)
		if data then
			if player == getLocalPlayer() then
				startBlips()
				return
			end
			if getElementData(getLocalPlayer(), "dispatch:onDuty") then
	           	local veh = getPedOccupiedVehicle( player )
	           	if veh and not dispatchBlips[veh] then
	           		dispatchBlips[veh] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "pedvehicle.png", 99999, true, veh, getCallSign(veh) )
	           		if getElementData(veh, "lspd:siren") then -- Begin flash
	           		    exports.customblips:setBlipImageColor(dispatchBlips[veh], 255, 0, 0)
	           		end
	           	elseif veh and dispatchBlips[veh] then
	           		destroyDispatchBlip(veh)
	           		dispatchBlips[veh] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "pedvehicle.png", 99999, true, veh, getCallSign(veh) )
	           		if getElementData(veh, "lspd:siren") then -- Begin flash
	           		    exports.customblips:setBlipImageColor(dispatchBlips[veh], 255, 0, 0)
	           		end
	           	elseif not dispatchBlips[player] then
	               	dispatchBlips[player] = exports.customblips:createCustomBlip ( 0, 0, 8, 8, "ped.png", 999999, true, player, getCallSign(player) )
	            end
	        end
        elseif not data then
        	if player == getLocalPlayer() then
        		stopBlips()
        		return
        	else
        		if getElementData(getLocalPlayer(), "dispatch:onDuty") then
        			local veh = getPedOccupiedVehicle( player )
        			if veh then
        				local t = tablelength(getVehicleOccupants(veh) or {})
        				if t > 1 then
        					found = false
							for k,v in pairs(getVehicleOccupants(veh)) do
								if getElementData(v, "dispatch:onDuty") and v ~= player then
									found = true
									break
								end
							end
							if not found then
								if dispatchBlips[veh] then
									destroyDispatchBlip(veh)
								end
								--[[dispatchBlips[veh] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "vehicle.png", 99999, true, veh, "Vehicle Contains Suspect" )
								if getElementData(veh, "lspd:siren") then -- Begin flash
			           		    	exports.customblips:setBlipImageColor(dispatchBlips[veh], 255, 0, 0)
			           			end]]
							elseif found then
								exports.customblips:setBlipText(dispatchBlips[veh], getCallSign(veh))
							end
						elseif t==1 and dispatchBlips[veh] then
							destroyDispatchBlip(veh)
						end
        			else
        				destroyDispatchBlip(player)
        			end
        		end
        	end
		end
	end
)

addEventHandler("onClientVehicleExit", getRootElement(), 
	function(thePlayer)
		local t = tablelength(getVehicleOccupants(source) or {})
		if dispatchBlips[source] and t == 0 then
			destroyDispatchBlip(source)
		elseif dispatchBlips[source] and t ~= 0 then
			found = false
			for k,v in pairs(getVehicleOccupants(source)) do
				if getElementData(v, "dispatch:onDuty") then
					found = true
					break
				end
			end
			if not found then
				destroyDispatchBlip(source)
			elseif found and getElementData(thePlayer, "dispatch:onDuty") and getElementData(getLocalPlayer(), "dispatch:onDuty") then
				exports.customblips:setBlipText(dispatchBlips[source], getCallSign(source))
			end
		end
		if getElementData(thePlayer, "dispatch:onDuty") and getElementData(getLocalPlayer(), "dispatch:onDuty") and getLocalPlayer() ~= thePlayer then
			dispatchBlips[thePlayer] = exports.customblips:createCustomBlip ( 0, 0, 8, 8, "ped.png", 9999999, true, thePlayer, getCallSign(thePlayer) )
		end
	end
)

addEventHandler("onClientVehicleEnter", getRootElement(),
	function(thePlayer)
		if dispatchBlips[thePlayer] then
			destroyDispatchBlip(thePlayer)
		end
		if dispatchBlips[source] then
			found = false
			for k,v in pairs(getVehicleOccupants(source)) do
				if getElementData(v, "dispatch:onDuty") and v ~= thePlayer then
					found = true
					break
				end
			end
			if not found and getElementData(thePlayer, "dispatch:onDuty") and getElementData(getLocalPlayer(), "dispatch:onDuty") then
				destroyDispatchBlip(source)
				dispatchBlips[source] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "pedvehicle.png", 999999, true, source, getCallSign(source) )
				if getElementData(source, "lspd:siren") then -- Begin flash
           		    exports.customblips:setBlipImageColor(dispatchBlips[source], 255, 0, 0)
           		end
           	elseif found and getElementData(thePlayer, "dispatch:onDuty") and getElementData(getLocalPlayer(), "dispatch:onDuty") and dispatchBlips[source] then
           		exports.customblips:setBlipText(dispatchBlips[source], getCallSign(source))
           	end
        else
        	if getElementData(thePlayer, "dispatch:onDuty") and getElementData(getLocalPlayer(), "dispatch:onDuty") then
        		dispatchBlips[source] = exports.customblips:createCustomBlip ( 0, 0, 12, 12, "pedvehicle.png", 999999, true, source, getCallSign(source) )
        		if getElementData(source, "lspd:siren") then -- Begin flash
           		    exports.customblips:setBlipImageColor(dispatchBlips[source], 255, 0, 0)
           		end
        	end
        end
	end
)
