-- Nando 05/03/2023

-- RECON
local reconTarget = nil
function toggleRecon(state, targetPlayer)
	if state then
		local cur = exports.data:load("reconCurpos")
		if not cur then
			cur = {}
			cur.x, cur.y, cur.z = getElementPosition(localPlayer)
			cur.rx, cur.ry, cur.rz = getElementRotation(localPlayer)
			cur.dim = getElementDimension(localPlayer)
			cur.int = getElementInterior(localPlayer)
		end

		cur.target = getElementData(targetPlayer, "playerid")
		reconTarget = targetPlayer
		exports.data:save(cur, "reconCurpos")
		return triggerServerEvent("admin:recon:async:activate", localPlayer, cur)
	else
		local cur = exports.data:load("reconCurpos")
		if cur then
			setElementPosition(localPlayer, cur.x, cur.y, cur.z)
			setElementRotation(localPlayer, cur.rx, cur.ry, cur.rz)

			setElementDimension(localPlayer, cur.dim)
			setElementInterior(localPlayer, cur.int)
			setCameraInterior(cur.int)

			setCameraTarget(localPlayer, nil)
			setElementAlpha(localPlayer, 255)
			setElementCollisionsEnabled ( localPlayer, true )

			exports.data:save(nil, "reconCurpos")
			reconTarget = nil
			return triggerServerEvent("admin:recon:async:deactivate", localPlayer, cur)
		end
	end
end

function reconPlayer(commandName, targetPlayer)
	if source then localPlayer = source end
	if getElementData(localPlayer, "loggedin") == 1 and (exports.integration:isPlayerTrialAdmin(localPlayer)) then
		local reconx = getElementData(localPlayer, "reconx")
		if not (targetPlayer) then
			if not reconx then
				return outputChatBox("Utilisation: /" .. commandName .. " [Prénom_Nom]", 242, 151, 65)
			end
			toggleRecon(false)
			outputChatBox("[ADMIN] Vous venez de quitter le mode spectateur.", 242, 151, 65)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(localPlayer, targetPlayer)
			if not targetPlayer then
				return outputChatBox("Erreur: Ce joueur n'existe pas.", 252, 106, 104)
			end

			if getElementData(targetPlayer, "loggedin") ~= 1 then
				return outputChatBox("Erreur: Ce joueur n'est pas connecté.", 252, 106, 104)
			end

			if targetPlayer == localPlayer then
				return outputChatBox("Erreur: Vous ne pouvez pas vous spec vous-même.", 252, 106, 104)
			end

			if exports.freecam:isEnabled (localPlayer) then
				exports.freecam:toggleFreecam("dropme")
			end

			local newtarget = getElementData(targetPlayer, "reconx")
			if isElement(newtarget) then
				return exports["srp_notifs"]:add("La personne que vous voulez spec ("..targetPlayerName..") est déjà en train de spec.", "error")
			end

			if reconx == targetPlayer then
				return exports["srp_notifs"]:add("Vous êtes déjà en train de spec "..targetPlayerName..".", "error")
			end
			
			local id = getElementData(targetPlayer, "playerid")
			toggleRecon(true, targetPlayer)
			return outputChatBox("[ADMIN] Vous venez de vous mettre en spectateur sur "..targetPlayerName.." ("..id..").", 242, 151, 65)
		end
	end
end
addEvent("admin:recon", true)
addEventHandler("admin:recon", root, reconPlayer)
addCommandHandler("spec", reconPlayer, false)
addCommandHandler("specoff", reconPlayer, false)

addEvent("recon:goto", true)
addEventHandler("recon:goto", root, function(x, y, z, interior, dimension, r)
	cur = {}
	cur.x, cur.y, cur.z = x, y, z
	cur.rx, cur.ry, cur.rz = 0, 0, r
	cur.dim = dimension
	cur.int = interior
	exports.data:save(cur, "reconCurpos")
	triggerEvent("admin:recon", localPlayer, "spec")
end)

addEventHandler ( "onClientElementDataChange", root,
function ( dataName )
	if getElementType ( source ) == "player" and dataName == "reconx" and source == getLocalPlayer() then
		if getElementData(source, "reconx") and not getElementData(source, "recon:whereToDisplayY") then -- New recon target and not already reconning
			addEventHandler("onClientRender", root, displayReconInfo)
		elseif not getElementData(source, "reconx") then
			setElementData(localPlayer, "recon:whereToDisplayY", nil, false)
			removeEventHandler("onClientRender", root, displayReconInfo)
		end
	end
end )

local function tableToString(table)
	local text = ""
	for i, id in ipairs(table) do
		text = text..id..", "
	end
	return #text>0 and string.sub(text, 1, #text-2) or "None"
end

local sw, sh = guiGetScreenSize()
function displayReconInfo()
	if not exports.hud:isActive() then
		return
	end

	if (not isElement(reconTarget)) or (getElementData(reconTarget, "loggedin") ~= 1) then
		setElementData(localPlayer, "recon:whereToDisplayY", nil, false)
		toggleRecon(false)
		return removeEventHandler("onClientRender", root, displayReconInfo)
	end

	local w, h = 760, 105
	local x, y = (sw-w)/2, sh-h-30
	setElementData(localPlayer, "recon:whereToDisplayY", y, false)
    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 100), true)
    local ox, oy = 507, 396
	local xo, yo = x-ox, y-oy
	local text = ""
    dxDrawText("HP: "..math.floor( getElementHealth( reconTarget )), 517+xo, 423+yo, 706+xo, 440+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Cible: "..exports.global:getPlayerFullIdentity(reconTarget,3,true), 517+xo, 406+yo, 887+xo, 423+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    local weapon = getPedWeapon( reconTarget )
	if weapon then
		weapon = getWeaponNameFromID( weapon )
	else
		weapon = "N/A"
	end
    dxDrawText("Arme: "..weapon, 517+xo, 440+yo, 706+xo, 457+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Armure: "..math.floor( getPedArmor( reconTarget ) ), 706+xo, 423+yo, 887+xo, 440+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Skin: "..getElementModel( reconTarget ), 706+xo, 440+yo, 887+xo, 457+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Argent liquide: "..exports.global:formatMoney(getElementData(reconTarget, "money")).."$", 517+xo, 457+yo, 706+xo, 474+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Argent en banque: "..exports.global:formatMoney(getElementData(reconTarget, "bankmoney")).."$", 706+xo, 457+yo, 887+xo, 474+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    local veh = "Utilisez les flèches ←/→ pour changer de joueur"
    local vehicle = getPedOccupiedVehicle( reconTarget )
    if vehicle then
    	veh = "Véhicule: " .. exports.global:getVehicleName( vehicle ) .. " (" ..getVehicleName( vehicle ).." - ID #"..getElementData( vehicle, "dbid" ) .. " - HP Véhicule: "..math.floor( getElementHealth( vehicle ))..")"
    end
    dxDrawText(veh, 517+xo, 474+yo, 1257+xo, 491+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    text = ""
	local fid = getElementData(reconTarget, "faction")
	for k,v in pairs(fid) do
		local rank = v.rank
		local theFaction = exports.factions:getFactionFromID(k)
		if rank and theFaction then
			text = text .. k
			local ranks = getElementData(theFaction, "ranks")
			if ranks then
				local fRank = ranks[rank] and ranks[rank] or false
				if fRank then
					text = text.." (Rang: "..fRank.."), "
				end
			end
		end
	end
	local loc = getZoneName(getElementPosition(reconTarget))
	local int = getElementInterior(reconTarget)
	local dim = getElementDimension(reconTarget)

	-- Follow the recon target through interiors
	if dim ~= getElementDimension(localPlayer) then
		triggerServerEvent("recon:reattach", resourceRoot, reconTarget, int, dim)
	end

	if dim > 0 then
		loc = "Intérieur #"..dim
	end
    dxDrawText("Faction: "..text, 887+xo, 406+yo, 1257+xo, 423+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, true, true, false, false)
    dxDrawText("Lieu: "..loc, 1076+xo, 440+yo, 1257+xo, 440+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Intérieur: "..int, 887+xo, 457+yo, 1076+xo, 457+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Dimension: "..dim, 1076+xo, 457+yo, 1257+xo, 457+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    local hoursplayed = getElementData(reconTarget, "hoursplayed")
    hoursplayed = tonumber(hoursplayed) or "?"
    dxDrawText("Heures de jeu: "..hoursplayed, 887+xo, 474+yo, 1076+xo, 474+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Ping: "..getPlayerPing(reconTarget), 1076+xo, 474+yo, 1257+xo, 474+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
end

addEventHandler( "onClientKey", root, function(button,press)
	if getElementData(localPlayer, "reconx") and press then
	    if button == "arrow_l" or button == "arrow_r" then
	    	local targetID = getElementData(reconTarget, "playerid")
			local nextPlayerID, nextPlayer
			local searchLower = button == "arrow_l"
			local sortedPlayers = getElementsByType("player")
			if #sortedPlayers > 1 then
				if searchLower then
					-- highest id first
					table.sort(sortedPlayers, function(a,b) return getElementData(a, "playerid") > getElementData(b, "playerid") end)
				else
					-- lowest id first
					table.sort(sortedPlayers, function(a,b) return getElementData(a, "playerid") < getElementData(b, "playerid") end)
				end
				for i, player in ipairs(sortedPlayers) do
					if (player ~= localPlayer) and (player ~= reconTarget)
					and (getElementData(player, "loggedin")==1) then
						local playerid = getElementData(player, "playerid")
						if searchLower then
							if (playerid < targetID) and ((not nextPlayerID) or playerid > nextPlayerID) then
								if getElementData(player, "reconx") then
									exports["srp_notifs"]:add("Skip car en spec: ("..playerid..") "..exports.global:getPlayerName(player), "error")
								else
									nextPlayerID = playerid
									nextPlayer = player
								end
							end
						else
							if (playerid > targetID) and ((not nextPlayerID) or playerid < nextPlayerID) then
								if getElementData(player, "reconx") then
									exports["srp_notifs"]:add("Skip car en spec: ("..playerid..") "..exports.global:getPlayerName(player), "error")
								else
									nextPlayerID = playerid
									nextPlayer = player
								end
							end
						end
					end
				end
			end
				
			if not nextPlayerID then
				outputChatBox("Erreur: Il n'y a personne à regarder.", 252, 106, 104)
				return
			end
			outputConsole("SPEC SWITCH: ("..nextPlayerID..") "..exports.global:getPlayerName(nextPlayer))
			triggerEvent("admin:recon", localPlayer, "spec", nextPlayerID)
	    end
	end
end )

addEventHandler("onClientPlayerDamage", localPlayer, function()
	if getElementData(localPlayer, "reconx") then
		cancelEvent()
	end
end, false)