--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

local myWindow = nil
local loading = nil
local tab, grid, col = {}, {}, {}
local currentCate = "Chat"
function bindKeys()
	--bindKey("F1", "down", F1RPhelp)
	--triggerLatentServerEvent("sendCmdsHelpToClient", localPlayer)
end
addEventHandler("onClientResourceStart", resourceRoot, bindKeys)

local gui = { reportWindow = {} }

local cmds = {}
function getCmdsHelpFromServer(cmds1)
	if cmds1 and type(cmds1) == "table" then
		cmds = cmds1
	end
	if myWindow and isElement( myWindow ) then
		updateCmdList()
	end
end
addEvent("getCmdsHelpFromServer", true)
addEventHandler("getCmdsHelpFromServer", root, getCmdsHelpFromServer)

local categories = {
	[1] = "Chat",
	[2] = "Factions",
	[3] = "Vehicles",
	[4] = "Properties",
	[5] = "Items",
	[6] = "Jobs",
	[7] = "Misc",
	[8] = "Search",
}

function getCateIDFromName(name)
	for i, cate in pairs(categories) do
		if cate == name then
			return i
		end
	end
	return 1
end

local perms = {
	[0] = "Player",
	[1] = "Trial Admin",
	[2] = "Admin",
	[3] = "Senior Admin",
	[4] = "Lead Admin",
	[5] = "Head Admin",
	[11] = "Supporter",
	[21] = "VCT Member",
	[31] = "Mapper",
	[41] = "Scripter",
}

function getPermIDFromName(name)
	for i, perm in pairs(perms) do
		if perm == name then
			return i
		end
	end
	return 0
end

function F1RPhelp( key, keyState )
	if getElementData(localPlayer, "loggedin") ~= 1 then return false end
	if not myWindow then
		triggerEvent( 'hud:blur', resourceRoot, 6, false, 0.5, nil )
		showCursor( true )
		local xmlExplained = xmlLoadFile( "commands/whatisroleplaying.xml" )
		local xmlOverview = xmlLoadFile( "commands/overview.xml" )
		local xmlRules = xmlLoadFile( "commands/rules.xml" )

		myWindow = guiCreateWindow ( 0, 0, 800, 600, "Southland - Demande Aide", false )
		exports.global:centerWindow(myWindow)
		guiWindowSetSizable(myWindow, false)
		local tabPanel = guiCreateTabPanel ( 0, 0.04, 1, 1, true, myWindow )

		gui.reportWindow.main = guiCreateTab( "Nouveau Rapport", tabPanel )
        -- draw the upper part of the tab.
        populateReportCenter()

		-- this is to prevent binds while typing.
		addEventHandler("onClientGUIFocus", myWindow, function()
			guiSetInputEnabled( true )
		end)
		addEventHandler("onClientGUIBlur", myWindow, function()
			guiSetInputEnabled( false )
		end)

		triggerEvent("hud:convertUI", localPlayer, myWindow)
	else
		closeF1RPhelp()
	end
end
addEvent("viewF1Help", true)
addEventHandler("viewF1Help", getRootElement(), F1RPhelp)
addCommandHandler('report', F1RPhelp)
addCommandHandler('irc', F1RPhelp)

local reportedPlayer = nil

local function checkReportLength()
	guiSetText(gui.reportWindow.memo_details_desc, "Caractères: " .. string.len(tostring(guiGetText(gui.reportWindow.memo_details)))-1 .. "/100")

	if (tonumber(string.len(tostring(guiGetText(gui.reportWindow.memo_details))))-1>100) then
		guiLabelSetColor(gui.reportWindow.memo_details_desc, 255, 0, 0)
		return false
	elseif (tonumber(string.len(tostring(guiGetText(gui.reportWindow.memo_details))))-1<5) then
		guiLabelSetColor(gui.reportWindow.memo_details_desc, 255, 0, 0)
		return false
	elseif (tonumber(string.len(tostring(guiGetText(gui.reportWindow.memo_details))))-1>80) then
		guiLabelSetColor(gui.reportWindow.memo_details_desc, 255, 255, 0)
		return true
	else
		guiLabelSetColor(gui.reportWindow.memo_details_desc,0, 255, 0)
		return true
	end
end

local function checkNameExists()
	local repType = guiComboBoxGetSelected(gui.reportWindow.combo_type)
	if repType == 0 then
		-- SUP REPORT
		guiSetText(gui.reportWindow.label_player_desc, "")
		guiSetText(gui.reportWindow.edit_player, "Nom du Joueur / ID")
		guiSetEnabled(gui.reportWindow.edit_player, false)
		reportedPlayer = nil
		return
	end
	if not guiGetEnabled(gui.reportWindow.edit_player) then
		guiSetEnabled(gui.reportWindow.edit_player, true)
	end
	local found = nil
	local count = 0
	local text = guiGetText(gui.reportWindow.edit_player)
	if text and #text > 0 then
		local players = getElementsByType("player")
		if tonumber(text) then
			local id = tonumber(text)
			for key, value in ipairs(players) do
				if getElementData( value, 'loggedin' ) == 1 and getElementData(value, "playerid") == id then
					found = value
					count = 1
					break
				end
			end
		else
			local text2 = string.lower(text)
			for key, value in ipairs(players) do
				if getElementData( value, 'loggedin' ) == 1 then
					local pn = string.lower(getPlayerName(value))
					if string.find(pn, text2) or string.find(pn:gsub("_", " "), text2) then
						count = count + 1
						found = value
						break
					end
				end
			end
		end
	end

	if (count>1) then
		guiSetText(gui.reportWindow.label_player_desc, "Plusieurs joueurs trouvés.")
		guiLabelSetColor(gui.reportWindow.label_player_desc, 255, 255, 0)
	elseif (count==1) then
		guiSetText(gui.reportWindow.label_player_desc, "Joueur trouvé: " .. getPlayerName(found) .. " (ID #" .. getElementData(found, "playerid") .. ")")
		guiLabelSetColor(gui.reportWindow.label_player_desc, 0, 255, 0)
		reportedPlayer = found
	elseif (count==0) then
		guiSetText(gui.reportWindow.label_player_desc, "Joueur non trouvé - Mettez leur nom ou ID.")
		guiLabelSetColor(gui.reportWindow.label_player_desc, 255, 0, 0)
	end
end

local function canISubmit()
	checkNameExists()
	if checkReportLength() then
		local reportnum = getElementData( localPlayer, "reportNum")
		local repType = guiComboBoxGetSelected(gui.reportWindow.combo_type)
		if reportnum or (repType == -1) or (repType == 1 and not isElement(reportedPlayer)) then
			guiSetEnabled(gui.reportWindow.btn_submit, false)
			return false
		else
			guiSetEnabled(gui.reportWindow.btn_submit, true)
			return true
		end
	else
		guiSetEnabled(gui.reportWindow.btn_submit, false)
		return false
	end
end

function populateReportCenter( submited )
	if gui.reportWindow.topPanel and isElement(gui.reportWindow.topPanel) then
		destroyElement( gui.reportWindow.topPanel )
		gui.reportWindow.topPanel = nil
	end

	local margin = 20
	gui.reportWindow.topPanel = guiCreateScrollPane(10+margin, 8+margin, 762, 454, false, gui.reportWindow.main)
	local pending_report = getElementData( localPlayer, "reportNum")
	if submited then
		local l = guiCreateLabel ( 0, 0, 1, 1, "Merci d'avoir soumis votre rapport. Veuillez nous permettre quelques minutes pour revenir vers vous.", true, gui.reportWindow.topPanel )
		guiLabelSetVerticalAlign( l, 'center' )
		guiLabelSetHorizontalAlign( l, 'center' )
		exports.global:playSoundSuccess()
		
		closeReportButton = guiCreateButton(0, 0.95, 0.95, 0.05, "Fermer",true, gui.reportWindow.topPanel)
		addEventHandler("onClientGUIClick", closeReportButton, function()
			closeF1RPhelp()
		end, false)
	elseif pending_report then
		local l = guiCreateLabel ( 0, 0, 1, 1, "Votre rapport ID #" .. (pending_report[8] or "").. " est toujours en cours.\nMerci d'attendre ou faites /er pour fermer ce rapport avant d'en soumettre un autre.", true, gui.reportWindow.topPanel )
		guiLabelSetVerticalAlign( l, 'center' )
		guiLabelSetHorizontalAlign( l, 'center' )
		
		closeReportButton = guiCreateButton(0, 0.95, 0.95, 0.05, "Fermer",true, gui.reportWindow.topPanel)
		addEventHandler("onClientGUIClick", closeReportButton, function()
			closeF1RPhelp()
		end, false)
	else
		gui.reportWindow.label_type = guiCreateLabel(23, 22, 351, 22, "Que voulez vous faire?", false, gui.reportWindow.topPanel)
        guiSetFont(gui.reportWindow.label_type, "default-bold-small")

        gui.reportWindow.combo_type = guiCreateComboBox(23, 44, 351, 27, "Type de rapport", false, gui.reportWindow.topPanel)
        local reportTypes = exports.report:getReportTypes()
        for key, value in ipairs( reportTypes ) do
			guiComboBoxAddItem(gui.reportWindow.combo_type, value[1])
		end
		exports.global:guiComboBoxAdjustHeight( gui.reportWindow.combo_type, #reportTypes )

		gui.reportWindow.label_type_desc = guiCreateLabel(390, 22, 347, 49, "", false, gui.reportWindow.topPanel)
        guiLabelSetHorizontalAlign(gui.reportWindow.label_type_desc, "center", true)
        guiLabelSetVerticalAlign(gui.reportWindow.label_type_desc, "center")

        gui.reportWindow.label_details = guiCreateLabel(23, 81, 600, 22, "Veuillez ajouter tous les détails qui pourraient nous aider à vous assister:", false, gui.reportWindow.topPanel)
        guiSetFont(gui.reportWindow.label_details, "default-bold-small")

        gui.reportWindow.memo_details = guiCreateMemo(23, 109, 714, 139, "", false, gui.reportWindow.topPanel)
        --guiSetEnabled( gui.reportWindow.memo_details, false )

        gui.reportWindow.memo_details_desc = guiCreateLabel(454, 252, 273, 25, "", false, gui.reportWindow.topPanel)
        guiSetFont(gui.reportWindow.memo_details_desc, "default-bold-small")
        guiLabelSetHorizontalAlign(gui.reportWindow.memo_details_desc, "right", false)

        gui.reportWindow.label_player = guiCreateLabel(23, 265, 420, 22, "Le joueur que vous souhaitez report (Laissez vide si c'est une question):", false, gui.reportWindow.topPanel)
        guiSetFont(gui.reportWindow.label_player, "default-bold-small")

        gui.reportWindow.edit_player = guiCreateEdit(23, 287, 351, 34, "Nom du Joueur / ID", false, gui.reportWindow.topPanel)

        gui.reportWindow.label_player_desc = guiCreateLabel(390, 287, 347, 34, "", false, gui.reportWindow.topPanel)
        guiSetFont(gui.reportWindow.label_player_desc, "default-bold-small")
        guiLabelSetVerticalAlign(gui.reportWindow.label_player_desc, "center")

        gui.reportWindow.btn_submit = guiCreateButton(23, 343, 143, 34, "Envoyer", false, gui.reportWindow.topPanel)
        guiSetProperty(gui.reportWindow.btn_submit, "NormalTextColour", "FF00FF00")
        guiSetEnabled( gui.reportWindow.btn_submit, canISubmit() )
		
		closeReportButton = guiCreateButton(0, 0.95, 0.95 , 0.05, "Fermer",true, gui.reportWindow.topPanel)
		addEventHandler("onClientGUIClick", closeReportButton, function()
			closeF1RPhelp()
		end, false)

        addEventHandler("onClientGUIChanged", gui.reportWindow.topPanel, canISubmit )
        addEventHandler("onClientGUIClick", gui.reportWindow.topPanel, canISubmit )

        addEventHandler("onClientGUIClick", gui.reportWindow.topPanel, function()
        	if source == gui.reportWindow.edit_player then
				guiSetText( source,"" )
			elseif source == gui.reportWindow.btn_submit then
				if checkReportLength() then
					triggerServerEvent("clientSendReport", localPlayer, reportedPlayer or localPlayer, guiGetText(gui.reportWindow.memo_details), guiComboBoxGetSelected(gui.reportWindow.combo_type) + 1)
					populateReportCenter( true )
					reportedPlayer = nil
				end
			end
		end )
		-- triggerEvent("hud:convertUI", localPlayer, gui.reportWindow.btn_submit)
	end
end

function updateCmdList()
	for i, cateName in ipairs(categories) do
		guiGridListClear(grid[i])
	end

	for i, cmd in ipairs(cmds) do
		local canAccess, requiredRank = getCmdPerms(tonumber(cmd["permission"]))
		if canAccess or exports.integration:isPlayerScripter(localPlayer) then
			local category = tonumber(cmd["category"]) or 0
			local row = guiGridListAddRow ( grid[category] )
			guiGridListSetItemText ( grid[category], row, 1, cmd["id"], false, true)
			guiGridListSetItemText ( grid[category], row, 2, cmd["command"], false, false)
			guiGridListSetItemText ( grid[category], row, 3, cmd["hotkey"] or "N/A", false, false)
			guiGridListSetItemText ( grid[category], row, 4, cmd["explanation"] or "N/A", false, false)
			guiGridListSetItemText ( grid[category], row, 5, requiredRank , false, false)
		end
	end
end

function togF1Menu(state)
	if myWindow and isElement(myWindow) then
		guiSetEnabled(myWindow, state)
	end
end

function closeF1RPhelp()
	if myWindow and isElement(myWindow) and not loading then
		removeEventHandler("onClientGUITabSwitched", root, tabSwitch)
		destroyElement(myWindow)
		myWindow = nil
		showCursor(false)
		closeNewCommand()
		guiSetInputEnabled( false )
		triggerEvent( 'hud:blur', resourceRoot, 'off' )
	end
end

function getCmdPerms(perm)
	if perm >=0 and perm <=10 then --Admins
		local adminLevel = getElementData(localPlayer, "admin_level") or 0
		if adminLevel >= perm then
			return true, exports.global:getAdminTitles()[perm] or "Player"
		else
			return false, exports.global:getAdminTitles()[perm] or "Player"
		end
	elseif perm >=11 and perm <=20 then --Supporters
		return exports.integration:isPlayerSupporter(localPlayer) or exports.integration:isPlayerTrialAdmin(localPlayer), "Supporter"
	elseif perm >=21 and perm <=30 then --VCTs
		return exports.integration:isPlayerVCTMember(localPlayer) or exports.integration:isPlayerAdmin(localPlayer), "VCT Member"
	elseif perm >=31 and perm <=40 then --Mappers
		return exports.integration:isPlayerMappingTeamMember(localPlayer) or exports.integration:isPlayerTrialAdmin(localPlayer), "Mapper"
	elseif perm >=41 and perm <=50 then --Scripter
		return exports.integration:isPlayerScripter(localPlayer), "Scripter"
	else
		return false, "Player"
	end
end

local gui = {}
function openNewCommand(id, perm, cmd, key, ex)
	closeNewCommand()
	togF1Menu(false)
	exports.global:playSoundSuccess()
	local w, h = 500, 225
	gui.wNewStation = guiCreateStaticImage(0, 0, w, h, ":resources/window_body.png", false)
	exports.global:centerWindow(gui.wNewStation)
	local margin = 20
	local lineH = 25
	local lineH2 = lineH
	local col1 = 100
	gui.l1 = guiCreateLabel(margin, margin, w-margin*2, lineH, "CREATE A NEW COMMAND", false, gui.wNewStation)
	guiSetFont(gui.l1, "default-bold-small")
	guiLabelSetHorizontalAlign(gui.l1, "center", true)
	guiLabelSetVerticalAlign(gui.l1, "center", true)

	gui.l5 = guiCreateLabel(margin, margin+lineH2, col1, lineH, "Category:", false, gui.wNewStation)
	guiSetFont(gui.l5, "default-bold-small")
	guiLabelSetVerticalAlign(gui.l5, "center", true)
	gui.eCate = guiCreateComboBox(margin+col1, margin+lineH2, w-margin*2-col1, lineH, currentCate or "Chat", false, gui.wNewStation)
	for i, cateName in ipairs(categories) do
		guiComboBoxAddItem(gui.eCate, cateName)
	end
	exports.global:guiComboBoxAdjustHeight(gui.eCate, 5)

	lineH2 = lineH2 + lineH

	gui.l6 = guiCreateLabel(margin, margin+lineH2, col1, lineH, "Permission:", false, gui.wNewStation)
	guiSetFont(gui.l6, "default-bold-small")
	guiLabelSetVerticalAlign(gui.l6, "center", true)
	gui.ePerm = guiCreateComboBox(margin+col1, margin+lineH2, w-margin*2-col1, lineH, perm or "Player", false, gui.wNewStation)
	local count = 0
	for i, permName in pairs(perms) do
		guiComboBoxAddItem(gui.ePerm, permName)
		count = count + 1
	end
	exports.global:guiComboBoxAdjustHeight(gui.ePerm, 5)

	lineH2 = lineH2 + lineH

	gui.l2 = guiCreateLabel(margin, margin+lineH2, col1, lineH, "Command Name:", false, gui.wNewStation)
	guiSetFont(gui.l2, "default-bold-small")
	guiLabelSetVerticalAlign(gui.l2, "center", true)
	gui.eName = guiCreateEdit(margin+col1, margin+lineH2, w-margin*2-col1, lineH, cmd or "", false, gui.wNewStation)

	lineH2 = lineH2 + lineH

	gui.l3 = guiCreateLabel(margin, margin+lineH2, col1, lineH, "Hotkey (if any):", false, gui.wNewStation)
	guiSetFont(gui.l3, "default-bold-small")
	guiLabelSetVerticalAlign(gui.l3, "center", true)
	gui.eKey = guiCreateEdit(margin+col1, margin+lineH2, w-margin*2-col1, lineH, key or "", false, gui.wNewStation)

	lineH2 = lineH2 + lineH

	gui.l4 = guiCreateLabel(margin, margin+lineH2, col1, lineH, "Explanation:", false, gui.wNewStation)
	guiSetFont(gui.l4, "default-bold-small")
	guiLabelSetVerticalAlign(gui.l4, "center", true)
	gui.eEx = guiCreateEdit(margin+col1, margin+lineH2, w-margin*2-col1, lineH, ex or "", false, gui.wNewStation)

	lineH2 = lineH2 + lineH



	local buttons = 3
	local buttonW = (w-margin*2)/buttons
	gui.bOk = guiCreateButton(margin, margin+lineH/2+lineH2, buttonW , lineH, id and "Save" or "Create",false,gui.wNewStation)
	guiSetFont(gui.bOk, buyNew and "default-small" or "default-bold-small")
	addEventHandler("onClientGUIClick", gui.bOk, function()
		if source == gui.bOk then
			exports.global:playSoundCreate()
			local cate1 = guiComboBoxGetItemText(gui.eCate, guiComboBoxGetSelected ( gui.eCate )) or currentCate or "Chat"
			cate1 = getCateIDFromName(cate1)
			local perm1 = guiComboBoxGetItemText(gui.ePerm, guiComboBoxGetSelected ( gui.ePerm )) or perm or "Player"
			perm1 = getPermIDFromName(perm1)
			local cmd1 = guiGetText(gui.eName)
			local key1 = guiGetText(gui.eKey)
			local ex1 = guiGetText(gui.eEx)
			triggerServerEvent("saveCommand", localPlayer, {id, cate1, perm1, cmd1, key1, ex1})
			--loading = true
			closeNewCommand()
		end
	end)

	gui.bDel = guiCreateButton(margin+buttonW, margin+lineH/2+lineH2, buttonW , lineH, "Delete",false,gui.wNewStation)
	guiSetFont(gui.bDel, "default-bold-small")
	addEventHandler("onClientGUIClick", gui.bDel, function()
		if source == gui.bDel then
			triggerServerEvent("deleteCommand", localPlayer, id)
			--loading = true
			closeNewCommand()
		end
	end)
	if not id then
		guiSetEnabled(gui.bDel, false)
	end

	gui.bClose1 = guiCreateButton(margin+buttonW*2, margin+lineH/2+lineH2, buttonW , lineH, "Cancel",false,gui.wNewStation)
	guiSetFont(gui.bClose1, "default-bold-small")
	addEventHandler("onClientGUIClick", gui.bClose1, function()
		if source == gui.bClose1 then
			closeNewCommand()
		end
	end)

	showCursor(true)
	guiSetInputEnabled(true)
end


function closeNewCommand()
	if gui.wNewStation and isElement(gui.wNewStation) then
		destroyElement(gui.wNewStation)
		gui.wNewStation = nil
		togF1Menu(true)
		--showCursor(true)
		guiSetInputEnabled(false)
	end
end

function tabSwitch(theTab)
	for i, cateName in ipairs(categories) do
		if theTab == tab[i] then
			currentCate = cateName
			break
		end
	end
end

function canEditCmds()
	return exports.integration:isPlayerTrialAdmin(localPlayer) or exports.integration:isPlayerSupporter(localPlayer)
end
