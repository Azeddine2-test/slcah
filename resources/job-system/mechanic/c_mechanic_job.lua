
-- Nando 08/03/2023

-- Main Mechanic window
local wMechanic

-- Confirm action window
local wConfirm

-- Tyre change window
local wTyre

-- Paint window
local wPaint
local currentColor
local savedPaintColors = {}

-- Confirmation window
local wOwnerConf

local currentVehicle = nil

local SW, SH = guiGetScreenSize()

local dgs = exports["dgs"]

function displayMechanicJob(notext)
	if not notext then
		exports.hud:sendBottomNotification(localPlayer, "Mécanicien", "Faites clic droit sur un véhicule pour accéder au menu de mécano.")
	end
end

local function showOwnerConfirmation(mechName, vehName, actionName)
	if isElement(wOwnerConf) then return end

	local WW, WH = 700, 240
	wOwnerConf = dgs:dgsCreateWindow((SW-WW)/2, (SH-WH)/2, WW, WH, "Confirmation", false)
	dgs:dgsWindowSetSizable(wOwnerConf, false)
	dgs:dgsWindowSetCloseButtonEnabled(wOwnerConf, false)

	local y = 15
	local lMechName = dgs:dgsCreateLabel(15, y, WW-30, 22, "Mécanicien: "..mechName, false, wOwnerConf)
	dgs:dgsSetFont(lMechName, "default-bold")
	dgs:dgsLabelSetHorizontalAlign(lMechName, "center")
	y = y + 22 + 5

	local lVehicle = dgs:dgsCreateLabel(15, y, WW-30, 22, vehName, false, wOwnerConf)
	dgs:dgsSetFont(lVehicle, "default-bold")
	dgs:dgsLabelSetHorizontalAlign(lVehicle, "center")
	y = y + 22 + 5

	local lActionName = dgs:dgsCreateLabel(15, y, WW-30, 22, "Action: "..actionName, false, wOwnerConf)
	dgs:dgsSetFont(lActionName, "default-bold")
	dgs:dgsLabelSetHorizontalAlign(lActionName, "center")
	y = y + 22 + 5

	local lQuestion = dgs:dgsCreateLabel(15, y, WW-30, 22, "Confirmez-vous cette action sur votre véhicule ?", false, wOwnerConf)
	dgs:dgsLabelSetHorizontalAlign(lQuestion, "center")
	y = y + 22 + 15

	local function closeWin()
		destroyElement(wOwnerConf)
		wOwnerConf = nil
	end

	local bConfirm = dgs:dgsCreateButton(15, y, WW-30, 30, "Confirmer", false, wOwnerConf)
	addEventHandler("onDgsMouseClickUp", bConfirm, function()
		closeWin()
		triggerServerEvent("mechanic:ownerConfirmAction", resourceRoot)
	end, false)
	dgs:dgsSetProperty(bConfirm, "textColor", tocolor(50, 255, 50))
	y = y + 30 + 5

	local bCancel = dgs:dgsCreateButton(15, y, WW-30, 30, "Refuser", false, wOwnerConf)
	addEventHandler("onDgsMouseClickUp", bCancel, function()
		closeWin()
		triggerServerEvent("mechanic:ownerDeclineConfirmAction", resourceRoot)
	end, false)
	dgs:dgsSetProperty(bCancel, "textColor", tocolor(255, 50, 50))
end
addEvent("mechanic:showOwnerConfirmation", true)
addEventHandler("mechanic:showOwnerConfirmation", localPlayer, showOwnerConfirmation, false)

function openConfirmWindow(actionName, action, additional)
	if isElement(wConfirm) then
		return
	end
	if not isElement(currentVehicle) then
		exports["srp_notifs"]:add("Le véhicule n'existe plus.", "error")
		closeMechanicWindow()
		return
	end
	
	if action == "WINDOW_TYRES" then
		dgs:dgsSetVisible(wMechanic, false)
		return tyreWindow()
	elseif action == "WINDOW_REPAINT" then
		dgs:dgsSetVisible(wMechanic, false)
		return paintWindow()
	elseif action == "WINDOW_LIGHTCOLOR" then
		dgs:dgsSetVisible(wMechanic, false)
		
		if exports.colorblender:isPickerOpened("paintjob") then
			exports["srp_notifs"]:addNotification("Vous êtes déjà en train de modifier une autre couleur.", "error")
			return
		end

		local r, g, b = getVehicleHeadLightColor( currentVehicle )
		exports.colorblender:openPicker("headlights", string.format("#%02X%02X%02X", r, g, b), "Choisissez une couleur pour les phares")
		return
	end

	destroyElement(wMechanic)
	wMechanic = nil

	-- Window variables
	local Width = 400
	local Height = 300
	local X = (SW - Width)/2
	local Y = (SH - Height)/2

	wConfirm = dgs:dgsCreateWindow(X, Y, Width, Height, "Confirmation", false )
	dgs:dgsWindowSetSizable(wConfirm, false)
	dgs:dgsWindowSetCloseButtonEnabled(wConfirm, false)

	local y = 15
	local lVehicleName = dgs:dgsCreateLabel( 15, y, Width - 30, 22, (exports["global"]:getVehicleName(currentVehicle)), false, wConfirm )
	dgs:dgsSetFont(lVehicleName, "default-bold")
	dgs:dgsLabelSetHorizontalAlign(lVehicleName, "center")
	y = y + 22 + 5

	local lActionName = dgs:dgsCreateLabel( 15, y, Width - 30, 22, actionName, false, wConfirm )
	dgs:dgsLabelSetHorizontalAlign(lActionName, "center")
	y = y + 22 + 5

	local lCost = dgs:dgsCreateLabel( 15, y, Width - 30, 22, "Coût: $"..(exports["global"]:formatMoney(getActionCost(action))), false, wConfirm )
	dgs:dgsLabelSetHorizontalAlign(lCost, "center")
	y = y + 22 + 5

	local payText = "Payer (Virement bancaire)"
	if isInMechanicFaction(localPlayer) then
		payText = "Payer (Entreprise)"
	end

	local bConfirm = dgs:dgsCreateButton( 15, y, Width - 30, 30, payText, false, wConfirm )
	addEventHandler( "onDgsMouseClickUp", bConfirm, function()
		closeConfirmWindow()
		clickMechanicAction(action, additional)
	end, false)
	dgs:dgsSetProperty(bConfirm, "textColor", tocolor(50, 255, 50))
	y = y + 30 + 5

	local bCancel = dgs:dgsCreateButton( 15, y, Width - 30, 30, "Annuler", false, wConfirm )
	addEventHandler( "onDgsMouseClickUp", bCancel, function()
		closeConfirmWindow()
		mechanicWindow(currentVehicle)
	end, false)
	dgs:dgsSetProperty(bCancel, "textColor", tocolor(255, 50, 50))
	y = y + 30 + 5

	Height = y + 40
	dgs:dgsSetSize(wConfirm, Width, Height, false)
end

function closeConfirmWindow()
	if isElement(wConfirm) then
		destroyElement(wConfirm)
		wConfirm = nil
	end
end

function clickMechanicAction(action, additional)
	if not isElement(currentVehicle) then
		exports["srp_notifs"]:add("Le véhicule n'existe plus.", "error")
		closeMechanicWindow()
		return
	end
	
	triggerServerEvent("mechanic:action", resourceRoot, currentVehicle, action, additional)
	closeMechanicWindow()
end

function mechanicWindow(vehicle)
	if not isElement(vehicle) then return end

	-- if true then
	-- 	return outputChatBox("Nando est en train de développer le menu mécano, veuillez patienter.", 255,0,0)
	-- end
	
	if not canMechanicJob(localPlayer) then
		return
	end

	if isElement(wMechanic) then
		return
	end
	currentVehicle = vehicle

	-- Window variables
	local Width = 200
	local Height = 800--ignored

	wMechanic = dgs:dgsCreateWindow((SW-Width)/2, (SH-Height)/2, Width, Height, "Menu Mécano", false )
	dgs:dgsWindowSetSizable(wMechanic, false)
	
	local ACTIONS = {
		{"Réparer Carrosserie", "REPAIR_BODYWORK"},
		{"Réparer Moteur", "REPAIR_ENGINE"},
		{"Repeindre", "WINDOW_REPAINT"},
		{"Couleur Phares", "WINDOW_LIGHTCOLOR"},
		-- {"Polir (Brillant)", "POLISH_PAINT"}, -- Disabled by Nando 22/04/2023
		{"Changer Serrure", "CHANGE_LOCK"},
		{"Dupliquer Clé", "DUPLICATE_KEY"},
	}
	local VEHS_NO_TYRES = { Boat = true, Helicopter = true, Plane = true, Train = true }
	if not VEHS_NO_TYRES[exports.global:getVehicleType(vehicle)] then
		ACTIONS[#ACTIONS+1] = {"Changer Pneu", "WINDOW_TYRES"}
	end
	if getElementData(vehicle, "tinted") then
		ACTIONS[#ACTIONS+1] = {"Retirer Teinte", "TOGGLE_TINT"}
	else
		ACTIONS[#ACTIONS+1] = {"Installer Teinte", "TOGGLE_TINT"}
	end

	local y = 15
	local BHEIGHT = 30

	for _, v in ipairs(ACTIONS) do
		local bOptions = dgs:dgsCreateButton( 15, y, Width - 30, BHEIGHT, v[1], false, wMechanic )
		addEventHandler( "onDgsMouseClickUp", bOptions, function()
			openConfirmWindow(v[1], v[2])
		end, false)
		y = y + BHEIGHT
	end

	addEventHandler("onDgsWindowClose", wMechanic, function()
		setTimer(closeMechanicWindow, 50, 1)
	end, false)

	Height = y + 40
	dgs:dgsSetSize(wMechanic, Width, Height, false)
	dgs:dgsSetPosition(wMechanic, (SW-Width)/2, (SH-Height)/2, false)
end
addEvent("openMechanicFixWindow")
addEventHandler("openMechanicFixWindow", localPlayer, mechanicWindow, false)

function tyreWindow()

	if isElement(wTyre) then
		return
	end

	-- Window variables
	local Width = exports.global:getVehicleType(currentVehicle) == "Bike" and 100 or 200
	local Height = 300
	local X = (SW - Width)/2
	local Y = (SH - Height)/2

	-- Create the window
	wTyre = dgs:dgsCreateWindow(X+100, Y, Width, Height, "Sélectionnez un pneu à changer.", false )
	dgs:dgsWindowSetCloseButtonEnabled(wTyre, false)
	dgs:dgsWindowSetSizable(wTyre, false)

	local actionName = "Changer Pneu"
	local action = "CHANGE_TYRE"

	if exports.global:getVehicleType(currentVehicle) ~= "Bike" then
		-- Front left
		local bTyreOne = dgs:dgsCreateButton( 0.05, 0.05, 0.45, 0.35, "Avant Gauche", true, wTyre )
		addEventHandler( "onDgsMouseClickUp", bTyreOne, function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(wTyre)
				wTyre = nil
				openConfirmWindow(actionName, action, 1)
			end
		end, false)

		-- Back left
		local bTyreTwo = dgs:dgsCreateButton( 0.05, 0.4, 0.45, 0.35, "Arrière Gauche", true, wTyre )
		addEventHandler( "onDgsMouseClickUp", bTyreTwo, function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(wTyre)
				wTyre = nil
				openConfirmWindow(actionName, action, 2)
			end
		end, false)

		-- front right
		local bTyreThree = dgs:dgsCreateButton( 0.5, 0.05, 0.45, 0.35, "Avant Droit", true, wTyre )
		addEventHandler( "onDgsMouseClickUp", bTyreThree, function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(wTyre)
				wTyre = nil
				openConfirmWindow(actionName, action, 3)
			end
		end, false)

		-- back right
		local bTyreFour = dgs:dgsCreateButton( 0.5, 0.4, 0.45, 0.35, "Arrière Droit", true, wTyre )
		addEventHandler( "onDgsMouseClickUp", bTyreFour, function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(wTyre)
				wTyre = nil
				openConfirmWindow(actionName, action, 4)
			end
		end, false)
		dgs:dgsSetProperty(bTyreOne, "textColor", tocolor(255, 255, 255))
		dgs:dgsSetProperty(bTyreTwo, "textColor", tocolor(255, 255, 255))
		dgs:dgsSetProperty(bTyreThree, "textColor", tocolor(255, 255, 255))
		dgs:dgsSetProperty(bTyreFour, "textColor", tocolor(255, 255, 255))
	else
		-- Front
		local bTyreOne = dgs:dgsCreateButton( 0.05, 0.05, 0.9, 0.35, "Avant", true, wTyre )
		addEventHandler( "onDgsMouseClickUp", bTyreOne, function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(wTyre)
				wTyre = nil
				openConfirmWindow(actionName, action, 1)
			end
		end, false)

		-- back right
		local bTyreThree = dgs:dgsCreateButton( 0.05, 0.4, 0.9, 0.35, "Arrière", true, wTyre )
		addEventHandler( "onDgsMouseClickUp", bTyreThree, function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(wTyre)
				wTyre = nil
				openConfirmWindow(actionName, action, 2)
			end
		end, false)
		dgs:dgsSetProperty(bTyreOne, "textColor", tocolor(255, 255, 255))
		dgs:dgsSetProperty(bTyreThree, "textColor", tocolor(255, 255, 255))
	end

	-- Close
	local bTyreClose = dgs:dgsCreateButton( 0.05, 0.8, 0.9, 0.1, "Annuler", true, wTyre )
	dgs:dgsSetProperty(bTyreClose, "textColor", tocolor(255, 50, 50))
	addEventHandler( "onDgsMouseClickUp", bTyreClose,  function(button, state)
		if(button == "left" and state == "up") then

			destroyElement(wTyre)
			wTyre = nil

			if isElement(wMechanic) then
				dgs:dgsSetVisible(wMechanic, true)
			end
		end
	end, false)
end

function paintColor( colorIndex )
	if exports.colorblender:isPickerOpened("paintjob") then
		return
	end
	if not isElement(wPaint) then
		return
	end
	dgs:dgsSetVisible(wPaint, false)

	local r, g, b = 0,0,0
	local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true )
	if colorIndex == 1 then
		r = r1
		g = g1
		b = b1
	elseif colorIndex == 2 then
		r = r2
		g = g2
		b = b2
	elseif colorIndex == 3 then
		r = r3
		g = g3
		b = b3
	elseif colorIndex == 4 then
		r = r4
		g = g4
		b = b4
	end
	currentColor = colorIndex
	exports.colorblender:openPicker("paintjob", string.format("#%02X%02X%02X", r, g, b), "Choisissez une couleur")
end

addEventHandler("onColorPickerChange", root,
 function(element, hex, r, g, b)
	if element == "paintjob" and currentColor then

		local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true)
		if currentColor == 1 then
			r1 = r
			g1 = g
			b1 = b
		elseif currentColor == 2 then
			r2 = r
			g2 = g
			b2 = b
		elseif currentColor == 3 then
			r3 = r
			g3 = g
			b3 = b
		elseif currentColor == 4 then
			r4 = r
			g4 = g
			b4 = b
		end

		triggerServerEvent( "colorPreview", localPlayer, currentVehicle, {r1, g1, b1}, {r2, g2, b2}, {r3, g3, b3}, {r4, g4, b4})

	elseif element == "headlights" then
		triggerServerEvent( "headlightPreview", localPlayer, currentVehicle, r, g, b)
	end
end)

--

addEventHandler("onColorPickerOK", root,
	function(id, hex, r, g, b)
		if id == 'paintjob' and currentColor then
			savedPaintColors[currentColor] = {r, g, b}
			triggerServerEvent( "colorPreview", localPlayer, currentVehicle, unpack(savedPaintColors))

			if isElement(wPaint) and not dgs:dgsGetVisible(wPaint) then
				dgs:dgsSetVisible(wPaint, true)
			end

		elseif id == 'headlights' then
			triggerServerEvent( "headlightEndPreview", localPlayer, currentVehicle)

			local actionName = "Changer Phares"
			local action = "HEADLIGHTS_COLOR"

			openConfirmWindow(actionName, action, {r, g, b})
		end
	end)

--

addEventHandler("onColorPickerCancel", root,
	function(id, hex, r, g, b)
		if id == 'paintjob' then
			triggerServerEvent( "colorPreview", localPlayer, currentVehicle, unpack(savedPaintColors))

			if isElement(wPaint) and not dgs:dgsGetVisible(wPaint) then
				dgs:dgsSetVisible(wPaint, true)
			end
		elseif id == 'headlights' then
			triggerServerEvent( "headlightEndPreview", localPlayer, currentVehicle)

			if isElement(wMechanic) and not dgs:dgsGetVisible(wMechanic) then
				dgs:dgsSetVisible(wMechanic, true)
			end
		end
	end)

--

function paintWindow()

	if isElement(wPaint) then
		return
	end

	local windowWidth = 400
	local windowHeight = 300
	local screenWidth, screenHeight = dgs:dgsGetScreenSize()
	local windowX = (screenWidth - windowWidth)/2
	local windowY = (screenHeight - windowHeight)/2

	local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true)
	savedPaintColors = { { r1, g1, b1 }, { r2, g2, b2 }, { r3, g3, b3 }, { r4, g4, b4 } }

	wPaint = dgs:dgsCreateWindow(windowX, windowY, windowWidth, windowHeight, "Vehicle Paint", false )
	dgs:dgsWindowSetSizable(wPaint, false)
	dgs:dgsWindowSetCloseButtonEnabled(wPaint, false)

	bPaintColor1 = dgs:dgsCreateButton( 0.05, 0.05, 0.45, 0.2, "Couleur 1", true, wPaint )
	addEventHandler( "onDgsMouseClickUp", bPaintColor1,  function(button, state)
		if(button == "left" and state == "up") then
			paintColor( 1 )
		end
	end, false)
	bPaintColor2 = dgs:dgsCreateButton( 0.5, 0.05, 0.45, 0.2, "Couleur 2", true, wPaint )
	addEventHandler( "onDgsMouseClickUp", bPaintColor2,  function(button, state)
		if(button == "left" and state == "up") then
			paintColor( 2 )
		end
	end, false)
	bPaintColor3 = dgs:dgsCreateButton( 0.05, 0.35, 0.45, 0.2, "Couleur 3", true, wPaint )
	addEventHandler( "onDgsMouseClickUp", bPaintColor3,  function(button, state)
		if(button == "left" and state == "up") then
			paintColor( 3 )
		end
	end, false)
	bPaintColor4 = dgs:dgsCreateButton( 0.5, 0.35, 0.45, 0.2, "Couleur 4", true, wPaint )
	addEventHandler( "onDgsMouseClickUp", bPaintColor4,  function(button, state)
		if(button == "left" and state == "up") then
			paintColor( 4 )
		end
	end, false)

	bPaintSubmit = dgs:dgsCreateButton( 0.05, 0.63, 0.90, 0.1, "Continuer", true, wPaint )
	addEventHandler( "onDgsMouseClickUp", bPaintSubmit,  function(button, state)
		if(button == "left" and state == "up") then
			local r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4 = getVehicleColor( currentVehicle, true)
			triggerServerEvent( "colorEndPreview", localPlayer, currentVehicle)
			exports.colorblender:closePicker("paintjob")

			destroyElement(wPaint)
			wPaint = nil

			local actionName = "Repeindre"
			local action = "REPAINT"

			openConfirmWindow(actionName, action, {{r1, g1, b1}, {r2, g2, b2}, {r3, g3, b3}, {r4, g4, b4}})
		end
	end, false)
	dgs:dgsSetProperty(bPaintSubmit, "textColor", tocolor(0, 255, 0))

	bPaintClose = dgs:dgsCreateButton( 0.05, 0.76, 0.90, 0.1, "Annuler", true, wPaint )
	dgs:dgsSetProperty(bPaintClose, "textColor", tocolor(255, 50, 50))
	addEventHandler( "onDgsMouseClickUp", bPaintClose,  function(button, state)
		if(button == "left" and state == "up") then
			destroyElement(wPaint)
			wPaint = nil
			triggerServerEvent( "colorEndPreview", localPlayer, currentVehicle)
			exports.colorblender:closePicker("paintjob")

			if isElement(wMechanic) then
				dgs:dgsSetVisible(wMechanic, true)
			end
		end
	end, false)
end

function closeMechanicWindow()
	if exports.colorblender:closePicker("headlights") then
		triggerServerEvent( "headlightEndPreview", localPlayer, currentVehicle)
	end

	if isElement(wTyre) then
		destroyElement(wTyre)
	end
	wTyre = nil

	if isElement(wPaint) then
		destroyElement(wPaint)
		triggerServerEvent( "colorEndPreview", localPlayer, currentVehicle)
	end
	wPaint = nil
	currentColor = nil
	savedPaintColors = {}

	if isElement(wMechanic) then
		destroyElement(wMechanic)
	end
	wMechanic = nil

	currentVehicle = nil
	exports.colorblender:closePicker("paintjob")

	triggerEvent("cursorHide", localPlayer) -- Forces toggleable cursor off
end
addEventHandler("onClientChangeChar", localPlayer, closeMechanicWindow, false)