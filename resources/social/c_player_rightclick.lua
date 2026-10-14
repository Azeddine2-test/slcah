wRightClick = nil
bAddAsFriend, bFrisk, bRestrain, bCloseMenu, bInformation, bBlindfold, bStabilize = nil
sent = false
ax, ay = nil
player = nil
gotClick = false
closing = false

function clickPlayer(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(localPlayer, "exclusiveGUI") then
		return
	end
	if getElementData(localPlayer, "inventoryManager.bagUIOpen") or getElementData(localPlayer, "inventoryManager.vehicleUIOpen") then
		return
	end
	if (element) and (getElementType(element)=="player") and (button=="right") and (state=="down") and (sent==false) then
		local x, y, z = getElementPosition(localPlayer)
		
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=5) then
			if (wRightClick) then
				hidePlayerMenu()
			end
			--showCursor(true)
			ax = absX
			ay = absY
			player = element
			sent = true
			closing = false
			
			if(element == localPlayer) then
				showPlayerSelfMenu()
			else
				showPlayerMenu(player, isFriendOf(getElementData(player, "account:id")))
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPlayer, true)

function showPlayerSelfMenu()
	local row = {}
	local playerid = tonumber(getElementData(localPlayer, "playerid")) or 0
	local rcMenu = exports['rightclick']:create((exports.global:getPlayerName(localPlayer)).." ("..tostring(playerid)..")")

	bInformation = exports['rightclick']:addRow("Informations")
	addEventHandler("onClientGUIClick", bInformation, showMyPlayerInfo, false)

	if getElementInterior(localPlayer) == 0 and exports.weather:getSnowLevel() >= 2 then
		row.snowball = exports['rightclick']:addRow("Make snowball")
		addEventHandler("onClientGUIClick", row.snowball, makeSnowball, false)
	end


	if getElementData(localPlayer, "realism:stretcher:hasStretcher") then
		row.stretcher = exports['rightclick']:addRow("Poser le brancard")
		addEventHandler("onClientGUIClick", row.stretcher, leaveStretcher, false)
	end
	

	sent = false
end

function showPlayerMenu(targetPlayer, friend)
	local row = {}
	local rcMenu
	local playerid = tonumber(getElementData(targetPlayer, "playerid")) or 0
	rcMenu = exports.rightclick:create(string.gsub(exports.global:getPlayerName(targetPlayer), "_", " ").." ("..tostring(playerid)..")")

	-- are we currently hosting a game of cards?
	if getElementData(localPlayer, "cards:host") then
		local bAddToGame = exports['rightclick']:addRow("Inviter à Jeu de Cartes")
		addEventHandler("onClientGUIClick", bAddToGame, function() triggerServerEvent("cards:invite_player", localPlayer, targetPlayer) end, false)
	end
	
	if not friend then
		bAddAsFriend = exports['rightclick']:addRow("Ajouter en Ami")
		addEventHandler("onClientGUIClick", bAddAsFriend, caddFriend, false)
	else
		bAddAsFriend = exports['rightclick']:addRow("Retirer Ami")
		addEventHandler("onClientGUIClick", bAddAsFriend, cremoveFriend, false)
	end

	-- FRISK

	bFrisk = exports['rightclick']:addRow("Fouiller")
	addEventHandler("onClientGUIClick", bFrisk, cfriskPlayer, false)
	
	-- RESTRAIN
	local cuffed = getElementData(player, "restrain")
	if cuffed == 0 then
		bRestrain = exports['rightclick']:addRow("Menotter")
		addEventHandler("onClientGUIClick", bRestrain, crestrainPlayer, false)
	else
		bRestrain = exports['rightclick']:addRow("Démenotter")
		addEventHandler("onClientGUIClick", bRestrain, cunrestrainPlayer, false)
	end
	
	-- BLINDFOLD
	local blindfold = getElementData(player, "blindfold")
	if (blindfold) and (blindfold == 1) then
		bBlindfold = exports['rightclick']:addRow("Retirer bandeau")
		addEventHandler("onClientGUIClick", bBlindfold, cremoveBlindfold, false)
	else
		bBlindfold = exports['rightclick']:addRow("Bander Yeux")
		addEventHandler("onClientGUIClick", bBlindfold, cBlindfold, false)
	end
	
	-- STABILIZE
	if exports.global:hasItem(localPlayer, 70) and getElementData(player, "injuriedanimation") then
		bStabilize = exports['rightclick']:addRow("Stabilize")
		addEventHandler("onClientGUIClick", bStabilize, cStabilize, false)
	end

	-- Stretcher system
	local stretcherElement = getElementData(localPlayer, "realism:stretcher:hasStretcher") 
	if stretcherElement then
		local stretcherPlayer = getElementData( stretcherElement, "realism:stretcher:playerOnIt" )
		if stretcherPlayer and stretcherPlayer == player then
			bStabilize = exports['rightclick']:addRow("Retirer du brancard")
			addEventHandler("onClientGUIClick", bStabilize, fTakeFromStretcher, false)
		end
		if not stretcherPlayer then
			bStabilize = exports['rightclick']:addRow("Allonger sur le brancard")
			addEventHandler("onClientGUIClick", bStabilize, fLayOnStretcher, false)
		end
	end
	
	bInformation = exports['rightclick']:addRow("Informations")
	addEventHandler("onClientGUIClick", bInformation, showPlayerInfo, false)

	sent = false
end
addEvent("displayPlayerMenu", true)
addEventHandler("displayPlayerMenu", getRootElement(), showPlayerMenu)

function fTakeFromStretcher(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("stretcher:takePedFromStretcher", localPlayer, player)
		hidePlayerMenu()
	end
end

function fLayOnStretcher(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("stretcher:movePedOntoStretcher", localPlayer, player)
		hidePlayerMenu()
	end
end

function leaveStretcher()
	triggerServerEvent("stretcher:leaveStretcher", root)
end

function makeSnowball()
	triggerServerEvent("xmas:snowball:make", localPlayer, localPlayer)
end

function showMyPlayerInfo(button, state)
	if (button=="left") then
		triggerServerEvent("social:look", localPlayer)
		hidePlayerMenu()
	end
end
function showPlayerInfo(button, state)
	if (button=="left") then
		triggerServerEvent("social:look", player)
		hidePlayerMenu()
	end
end


--------------------
--   STABILIZING  --
--------------------

function cStabilize(button, state)
	if button == "left" and state == "up" then
		if (exports.global:hasItem(localPlayer, 70)) then -- Has First Aid Kit?
			local knockedout = getElementData(player, "injuriedanimation")
			
			if not knockedout then
				outputChatBox("Cette personne n'est pas assommée.", 255, 0, 0)
				hidePlayerMenu()
			else
				triggerServerEvent("stabilizePlayer", localPlayer, player)
				hidePlayerMenu()
			end
		else
			outputChatBox("Vous n'avez pas de kit de premiers secours.", 255, 0, 0)
		end
	end
end

--------------------
--  BLINDFOLDING  --
-------------------
function cBlindfold(button, state, x, y)
	if (button=="left") then
		triggerServerEvent("blindfoldPlayer", localPlayer, player)
		hidePlayerMenu()
	end
end

function cremoveBlindfold(button, state, x, y)
	if (button=="left") then
		local blindfolded = getElementData(player, "blindfold")
		if (blindfolded==1) then
			triggerServerEvent("removeBlindfold", localPlayer, player)
			hidePlayerMenu()
		else
			outputChatBox("Cette personne n'a pas les yeux bandés.", 255, 0, 0)
			hidePlayerMenu()
		end
	end
end

addEventHandler("onClientKey", getRootElement(), function(button)
	if (getElementData(localPlayer, "blindfold") == 1) then
		local keys = getBoundKeys("radar")
		if keys and type(keys) == 'table' then
			for keyName, state in pairs(keys) do
				if button == keyName then
					return cancelEvent()
				end
			end
		end
	end
end)

--------------------
--  RESTRAINING   --
--------------------
function crestrainPlayer(button, state, x, y)
	if (button=="left") then
		local restrained = getElementData(player, "restrain")
		if (restrained==1) then
			outputChatBox("Cette personne est déjà menottée/ligottée.", 255, 0, 0)
			hidePlayerMenu()
		else
			triggerServerEvent("restrainPlayer", localPlayer, player)
			hidePlayerMenu()
		end
	end
end

function cunrestrainPlayer(button, state, x, y)
	if (button=="left") then
		local restrained = getElementData(player, "restrain")
		
		if (restrained==0) then
			outputChatBox("Le joueur n'est pas menotté/ligoté.", 255, 0, 0)
			hidePlayerMenu()
		else
			triggerServerEvent("unrestrainPlayer", localPlayer, player)
			hidePlayerMenu()
		end
	end
end
--------------------
-- END RESTRAINING--
--------------------


--------------------
--    FRISKING    -- Fernando 12/05/2021
--------------------

function cfriskPlayer(button, state, x, y)
	if (button=="left") then
		local restrain = getElementData(player, "restrain") == 1
		if restrain or isPedDead(player) then
			triggerServerEvent("friskShowItems", getLocalPlayer(), player)
			hidePlayerMenu()
		else
			triggerServerEvent("requestFrisk", player)
			hidePlayerMenu()
		end
	end
end

local req = {}
function showRequestToGet(askingPlayer, mode)
	closeRequestToGet()

	local title = exports.global:getPlayerName(askingPlayer)
	if mode == "frisk" then
		title = title.." veut vous fouiller"
	elseif mode == "cuff" then
		title = title.." veut vous menotter"
	else
		return
	end
	
	local ww,wh = 300,105
	req.w = guiCreateWindow(0,0,ww,wh, title, false)
	exports.global:centerWindow(req.w)
	local yes = guiCreateButton(0,26, ww, 30, "Accepter", false, req.w)
	guiSetProperty(yes, "NormalTextColour", "FF00FF00")
	local no = guiCreateButton(0,26+35, ww, 30, "Rejeter", false, req.w)
	guiSetProperty(no, "NormalTextColour", "FFFF0000")

	addEventHandler( "onClientGUIClick", req.w, 
	function (button) 
		if button ~= "left" then return end
		if source == yes or source == no then
			closeRequestToGet()
			triggerServerEvent("playerRequestResponse", resourceRoot, askingPlayer, mode, (source == yes))
		end
	end)
end
addEvent("showRequestToGet", true)
addEventHandler("showRequestToGet", root, showRequestToGet)

function closeRequestToGet()
	if isElement(req.w) then
		destroyElement(req.w)
	end
end
addEventHandler("onClientChangeChar", localPlayer, closeRequestToGet)

--------------------
--  END FRISKING  --
--------------------

function caddFriend()
	triggerServerEvent("addFriend", localPlayer, player)
	hidePlayerMenu()
end

function cremoveFriend()
	triggerServerEvent("social:remove", localPlayer, getElementData(player, "account:id"))
	hidePlayerMenu()
end

function hidePlayerMenu()
	if (isElement(bAddAsFriend)) then
		destroyElement(bAddAsFriend)
	end
	bAddAsFriend = nil
	
	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil

	if (isElement(wFriskItems)) then
		destroyElement(wFriskItems)
	end
	wFriskItems = nil
	
	ax = nil
	ay = nil
	
	description = nil
	age = nil
	weight = nil
	height = nil
	
	if player then
		removeEventHandler("onClientPlayerQuit", player, hidePlayerMenu)
	end
	
	sent = false
	player = nil
	
	showCursor(false)
end

function checkMenuWasted()
	if source == localPlayer or source == player then
		hidePlayerMenu()
	end
end

addEventHandler("onClientPlayerWasted", getRootElement(), checkMenuWasted)
